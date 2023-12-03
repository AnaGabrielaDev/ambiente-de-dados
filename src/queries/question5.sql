select t.name, count(distinct pt.player_id) as participants from tournaments t
inner join players_tournaments pt on t.id = pt.tournament_id
group by t.id
order by count(pt.player_id) DESC
