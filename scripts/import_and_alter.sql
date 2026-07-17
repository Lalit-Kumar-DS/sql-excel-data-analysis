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
