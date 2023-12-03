import { PrismaClient } from '@prisma/client';
import xlsx from 'node-xlsx';
import * as dateFns from 'date-fns';
import pino from "pino"

const prisma = new PrismaClient();
const logger = pino()

async function importPlayers(row: Record<string, any>) {
  const alreadyUserExists = await prisma.player.findFirst({
    where: {
      id: row[8]
    }
  })

  if(alreadyUserExists) {
    console.log(`User ${row[8]} already exists`)
    return;
  }

  await prisma.player.create({
    data: {
      id: row[8],
      name: row[9],
      country: row[10],
      allTimeScore: parseInt(row[11], 10) ?? 0,
    }
  })

  logger.info(`User ${row[8]} created`)
}

async function importCards(row: Record<string, any>) {
  const alreadyCardExists = await prisma.card.findFirst({
    where: {
      id: row[0]
    }
  })

  if(alreadyCardExists) {
    logger.info(`Card ${row[0]} already exists`)
    return;
  }

  const mapperType = {
    'Trainer': 'TRAINER',
    'Pokémon': 'POKEMON'
  }

  await prisma.card.create({
    data: {
      id: row[0],
      name: row[1],
      price: row[3] === 'None' ? 0 : parseFloat(row[3]),
      energy: row[4] === "None" ? null : row[4],
      type: mapperType[row[5]],
    }
  })

  logger.info(`Card ${row[0]} created`)
}

async function importRotations(row: Record<string, any>) {
  const alreadyRotationExists = await prisma.rotation.findFirst({
    where: {
      name: row[22]
    }
  })

  if(alreadyRotationExists) {
    logger.info(`Rotation ${row[22]} already exists`)
    return;
  }

  let rotationDate = new Date()
  rotationDate = dateFns.setYear(rotationDate, row[23]);
  rotationDate = dateFns.setMonth(rotationDate, row[24]);
  rotationDate = dateFns.setDate(rotationDate, row[25]);

  await prisma.rotation.create({
    data: {
      name: row[22],
      initialDate: rotationDate,
      validRotationAtTournament: row[21] === "None" ? null : row[21]
    }
  })

  logger.info(`Rotation ${row[0]} created`)
}

async function importTournaments(row: Record<string, any>) {
  if(!row[13]) return;

  const alreadyTournamentExists = await prisma.tournament.findFirst({
    where: {
      id: parseInt(row[13])
    }
  })

  if(alreadyTournamentExists) {
    logger.info(`Tournament ${row[0]} already exists`)
    return;
  }

  const rotation = await prisma.rotation.findFirst({
    where: {
      name: row[22]
    }
  })

  const tournamentCategoryMapper = {
    'worlds': 'WORLD',
    'international': 'INTERNATIONAL',
    'regional': 'REGIONAL',
    'national': 'NATIONAL',
    'others': 'OTHER'
  }

  let tournamentDate = new Date()
  tournamentDate = dateFns.setYear(tournamentDate, row[18]);
  tournamentDate = dateFns.setMonth(tournamentDate, row[19]);
  tournamentDate = dateFns.setDate(tournamentDate, row[20]);

  await prisma.tournament.create({
    data: {
      id: parseInt(row[13], 10),
      name: row[15],
      date: tournamentDate,
      category: tournamentCategoryMapper[row[14]],
      country: row[17],
      region: row[16],
      rotationId: rotation?.id ?? null 
    }
  })

  logger.info(`Tournament ${row[0]} created`)
}

async function importPlayersTournament(row: Record<string, any>) {
  const playerId = row[8];
  const tournamentId = row[13];
  const alreadyPlayerTournamentExists = await prisma.playerTournament.findFirst({
    where: {
      playerId: playerId,
      tournamentId: tournamentId
    }
  })

  if(alreadyPlayerTournamentExists) {
    logger.info(`Player ${playerId} already exists in tournament ${tournamentId}`)
    return;
  }

  await prisma.playerTournament.create({
    data: {
      playerId,
      tournamentId,
      score: parseInt(row[12], 10) ?? 0,
    }
  })
}

async function importDecks(row: Record<string, any>) {
  const deckId = row[6];
  const deckName = row[7];
  const playerId = row[8];

  if(deckId === 'None') return;

  const alreadyDeckExists = await prisma.deck.findFirst({
    where: {
      id: deckId
    }
  })
  if(alreadyDeckExists) {
    logger.info(`Deck ${deckId} already exists`)
    return;
  }

  await prisma.deck.create({
    data: {
      id: deckId,
      name: deckName,
      playerId: playerId
    }
  })
}

async function importDeckCards(row: Record<string, any>) {
  const deckId = row[6];
  const cardId = row[0];

  if(deckId === 'None') return;

  const alreadyDeckCardExists = await prisma.deckCard.findFirst({
    where: {
      deckId: deckId,
      cardId: cardId
    }
  })

  if(alreadyDeckCardExists) {
    logger.info(`Deck ${deckId} already has card ${cardId}`)
    return;
  }

  await prisma.deckCard.create({
    data: {
      deckId: deckId,
      cardId: cardId,
      count: parseInt(row[2], 10) ?? 0,
    }
  })
}

async function main(){
  const workSheetsFromFile = xlsx.parse(`${__dirname}/database.xlsx`);
  const tournament = workSheetsFromFile.find(sheet => sheet.name === 'Tournaments');
  if(!tournament) throw new Error('Tournaments sheet not found');

  let index = 0;
  const total = tournament.data.length - 1;
  for(const row of tournament.data){
    if(index === 0) {
      index++;
      continue;
    }
    
    await importPlayers(row);
    await importCards(row);
    await importRotations(row);
    await importTournaments(row);
    await importPlayersTournament(row);
    await importDecks(row);
    await importDeckCards(row);

    logger.info(`Progress: ${index}/${total}`)
    index++;
  }
}
main();