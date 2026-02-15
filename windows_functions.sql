-- Window functions performs calcualtion (eg. aggreagation) on a specific subset of data, without leaving the level of detail.
select 
	category,
	sum(sale) revn
from orders
group by category;

select * from orders;

-- Types of windows functions
-- 01. Aggreagation functions(count,sum,avg,min,max)
-- 02. Rank functions (Row_number,rank,dense_rank,cume_dist,percent_rank,ntile(n)
-- 03. Value Functions(lead,lag, first_value, last_value)


-- 01. Aggregation functions
Select
	*,
    sum(sale) over() Revenue,
    count(orderid) over() totalRecords,
    avg(sale) over() avgSale,
    min(sale) over() minimumSale,
    max(sale) over() maxSale
from orders;

-- in regular queries we use 'group by' but in windows funciton we use 'partition by' instead


select
	category,
    sale,
    format(sum(sale) over(partition by category order by sale),2) rvnByCategory,
    format(avg(sale) over(partition by  category),2) avgSaleByCtrg,
    min(sale) over(partition by category) minSaleByCtrg,
    max(sale) over(partition by category) maxSaleByCtrg
from orders;
-- with aggregation function you can use 'order by' its optional


-- 02. Rank Function
-- With rank function order by is requried

-- intege ranking
select
	*,
    row_number() over(order by sale) row_rank, -- Assign the unique number to each row, however does not handles ties
    rank() over(order by sale) order_rank, -- it handles ties but leaves gap in ranking
    dense_rank() over(order by sale) denseRank, -- it handles everything carefully
    ntile(2) over(order by sale) bucketData -- bucket size = no. of rows / no. of buckets
from orders;


-- percentage ranking
select
	*,
    concat(round(cume_dist() over(order by sale desc)*100,2),'%') cume_ranking,
    -- Ties Rule - The position no. of occurence of the same value
    concat(round(percent_rank() over(order by sale desc)*100,2),'%')perct_rnk
    -- Ties Rule - The position of the first occurene of the same value
from orders;




-- 03. Value functions
select 
	orderdate,
    category,
    sale,
    lead(sale) over(order by orderdate) leadValue,
    lag(sale) over(order by orderdate) lagValue,
    lag(sale) over(order by orderdate) / sale saleGrowth
from orders;



-- first values & last value
select
	category,
    orderdate,
    sale,
    first_value(sale) over(partition by category order by orderdate ) firstSale,
    last_value(sale) over(partition by category order by orderdate
    rows between unbounded preceding and unbounded following) lastSale
from orders;






