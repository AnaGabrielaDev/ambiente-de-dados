select MAX(c.price) as card_most_value from cards c
inner join deck_cards dc on dc.card_id = c.id
inner join decks d on d.id = dc.deck_id = d.id
inner join players p on p.id = d.player_id
inner join players_tournaments pt on pt.player_id = p.id
inner join tournaments t on t.id = pt.tournament_id
where t.country = "Brazil"
