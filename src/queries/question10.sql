select count(distinct t.id) as number_of_tournaments, t.country from tournaments t
group by t.country
order by count(distinct t.id) DESC
limit 1