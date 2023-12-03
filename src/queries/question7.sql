select count(c.id) as number_of_cards_by_type from cards c 
group by c.type