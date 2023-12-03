select t.name, YEAR(t.date) as year from tournaments t
inner join players_tournaments pt on t.id = pt.tournament_id
group by t.id
order by count(pt.player_id) DESC
limit 1