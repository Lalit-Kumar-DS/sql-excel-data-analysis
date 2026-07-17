-- analysis start here

--which model generated the highest profit in USD/INR?

select Model_name, product_category, sum(profit) as total_profit from apple_pricing
group by Model_name, product_category
order by total_profit desc
limit 5;

--what is the average profit percentage per product category?

select model_name, product_category, avg(profit_per) as avg_profit from apple_pricing
group by model_name, product_category
order by avg_profit desc;

-- which sales event had the highest average discount percentage?
select product_category, Sale_Event, avg(discount_pct) as avg_discount from apple_pricing
group by sale_event, product_category
order by avg_discount desc;

--do higher discounts correlated with higher review_count?

select discount_pct, avg(reviews_count) as avg_review, count(*) as product_count
from apple_pricing 
group by discount_pct
order by discount_pct desc
limit 20;

--we want to know year over year sales trend?

select year, sum(current_price_usd) as total_sales_usd
group by year
order by year;

_--renaming the column 
alter table apple_pricing
rename column year to years;

SELECT years, SUM(current_price_usd) AS total_sales_usd
FROM apple_pricing
GROUP BY years
ORDER BY years;

--checking by category of product and trend?

select Years as years, product_category, sum(current_price_usd) as total_price_usd from apple_pricing
group by years, product_category
order by total_price_usd;


-- checking by effect of discount by year
SELECT years, AVG(discount_pct) AS avg_discount, SUM(current_price_usd) AS total_sales_usd
FROM apple_pricing
GROUP BY years
ORDER BY years;
