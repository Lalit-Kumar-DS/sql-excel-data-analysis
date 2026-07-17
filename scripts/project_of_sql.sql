--creating table, for cleaning and formate correction keep all file formate in text


CREATE TABLE apple_pricing_staging (
    order_date TEXT,
    year TEXT,
    month TEXT,
    days TEXT,
    platform TEXT,
    product_category TEXT,
    model_name TEXT,
    condition TEXT,
    launch_price_usd TEXT,
    launch_price_inr TEXT,
    current_price_usd TEXT,
    current_price_inr TEXT,
    profit TEXT,
    profit_per TEXT,
    discount_pct TEXT,
    sale_event TEXT,
    stock_status TEXT,
    rating TEXT,
    rating_status TEXT,
    reviews_count TEXT
);

-- importing data in database
COPY apple_pricing_staging
FROM 'C:\sql\apple_products_pricing_2020_2026.csv'
DELIMITER ','
CSV HEADER;





--altering the table 

ALTER TABLE apple_pricing
ALTER COLUMN discount_pct TYPE NUMERIC(6,2) USING discount_pct::NUMERIC;


ALTER TABLE apple_pricing
ALTER COLUMN discount_pct TYPE NUMERIC(6,2) USING discount_pct::NUMERIC,
ALTER COLUMN rating TYPE NUMERIC(3,1) USING rating::NUMERIC,
ALTER COLUMN profit_per TYPE NUMERIC(6,2) USING profit_per::NUMERIC;

--for convinent
DROP TABLE IF EXISTS apple_pricing;

-- creating again for real table for further work
CREATE TABLE apple_pricing (
    order_date DATE,
    year INT,
    month VARCHAR(50),
    days VARCHAR(50),
    platform VARCHAR(50),
    product_category VARCHAR(50),
    model_name VARCHAR(50),
    condition VARCHAR(50),
    launch_price_usd NUMERIC(10,2),
    launch_price_inr NUMERIC(12,2),
    current_price_usd NUMERIC(10,2),
    current_price_inr NUMERIC(12,2),
    profit NUMERIC(12,2),          -- keep NUMERIC if profit can be decimal
    profit_per NUMERIC(5,2),       -- percentages with decimals
    discount_pct NUMERIC(5,2),              -- whole numbers only
    sale_event VARCHAR(50),
    stock_status VARCHAR(50),
    rating NUMERIC(5,2),
    rating_status VARCHAR(50),
    reviews_count INT
);



INSERT INTO apple_pricing (
    order_date,
    year,
    month,
    days,
    platform,
    product_category,
    model_name,
    condition,
    launch_price_usd,
    launch_price_inr,
    current_price_usd,
    current_price_inr,
    profit,
    profit_per,
    discount_pct,
    sale_event,
    stock_status,
    rating,
    rating_status,
    reviews_count
)
SELECT
    order_date::DATE,
    year::INT,
    month,
    days,
    platform,
    product_category,
    model_name,
    condition,
    REPLACE(launch_price_usd, '$', '')::NUMERIC(10,2),
    REPLACE(launch_price_inr, ',', '')::NUMERIC(12,2),
    REPLACE(current_price_usd, '$', '')::NUMERIC(10,2),
    REPLACE(current_price_inr, ',', '')::NUMERIC(12,2),
    profit::NUMERIC(12,2),
    REPLACE(profit_per, '%', '')::NUMERIC(6,2),
    discount_pct::NUMERIC(6,2),
    sale_event,
    stock_status,
    rating::NUMERIC(3,1),
    rating_status,
    reviews_count::INT
FROM apple_pricing_staging;



--checking the table of content
select * from apple_pricing;

-- by index checking 
SELECT order_date, model_name, launch_price_usd, current_price_usd, profit_per, discount_pct, rating, reviews_count
FROM apple_pricing
LIMIT 10;

select * from apple_pricing;

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
