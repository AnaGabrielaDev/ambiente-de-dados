select * from players p
inner join players_tournaments pt on pt.player_id = p.id
inner join tournaments t on t.id = pt.tournament_id
order by t.name DESC

