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