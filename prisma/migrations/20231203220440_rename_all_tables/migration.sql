/*
  Warnings:

  - You are about to drop the `Card` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Deck` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `DeckCard` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Player` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `PlayerTournament` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Rotation` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Tournament` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `Deck` DROP FOREIGN KEY `Deck_player_id_fkey`;

-- DropForeignKey
ALTER TABLE `DeckCard` DROP FOREIGN KEY `DeckCard_card_id_fkey`;

-- DropForeignKey
ALTER TABLE `DeckCard` DROP FOREIGN KEY `DeckCard_deck_id_fkey`;

-- DropForeignKey
ALTER TABLE `PlayerTournament` DROP FOREIGN KEY `PlayerTournament_player_id_fkey`;

-- DropForeignKey
ALTER TABLE `PlayerTournament` DROP FOREIGN KEY `PlayerTournament_tournament_id_fkey`;

-- DropForeignKey
ALTER TABLE `Tournament` DROP FOREIGN KEY `Tournament_rotation_id_fkey`;

-- DropTable
DROP TABLE `Card`;

-- DropTable
DROP TABLE `Deck`;

-- DropTable
DROP TABLE `DeckCard`;

-- DropTable
DROP TABLE `Player`;

-- DropTable
DROP TABLE `PlayerTournament`;

-- DropTable
DROP TABLE `Rotation`;

-- DropTable
DROP TABLE `Tournament`;

-- CreateTable
CREATE TABLE `cards` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `type` ENUM('POKEMON', 'TRAINER') NOT NULL,
    `energy` VARCHAR(191) NULL,
    `price` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `players` (
    `id` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `country` VARCHAR(191) NOT NULL,
    `all_time_score` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `decks` (
    `id` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `player_id` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `deck_cards` (
    `deck_id` INTEGER NOT NULL,
    `card_id` VARCHAR(191) NOT NULL,
    `count` INTEGER NOT NULL,

    PRIMARY KEY (`deck_id`, `card_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `players_tournaments` (
    `player_id` INTEGER NOT NULL,
    `tournament_id` INTEGER NOT NULL,
    `score` INTEGER NOT NULL,

    PRIMARY KEY (`player_id`, `tournament_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tournaments` (
    `id` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `region` VARCHAR(191) NOT NULL,
    `country` VARCHAR(191) NOT NULL,
    `category` VARCHAR(191) NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `rotation_id` INTEGER NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `rotations` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `valid_rotation_at_tournament` VARCHAR(191) NULL,
    `initial_date` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `decks` ADD CONSTRAINT `decks_player_id_fkey` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `deck_cards` ADD CONSTRAINT `deck_cards_deck_id_fkey` FOREIGN KEY (`deck_id`) REFERENCES `decks`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `deck_cards` ADD CONSTRAINT `deck_cards_card_id_fkey` FOREIGN KEY (`card_id`) REFERENCES `cards`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `players_tournaments` ADD CONSTRAINT `players_tournaments_player_id_fkey` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `players_tournaments` ADD CONSTRAINT `players_tournaments_tournament_id_fkey` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tournaments` ADD CONSTRAINT `tournaments_rotation_id_fkey` FOREIGN KEY (`rotation_id`) REFERENCES `rotations`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
