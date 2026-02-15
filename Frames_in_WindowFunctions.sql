use views;

select 
	category,
	orderdate,
    sale,
    sum(sale) over(partition by category order by orderdate rows between unbounded preceding and current row) total
from orders;

