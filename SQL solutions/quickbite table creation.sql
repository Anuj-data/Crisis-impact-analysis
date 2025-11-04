CREATE TABLE dim_delivery_partner (
    delivery_partner_id VARCHAR(20) PRIMARY KEY,
    partner_name VARCHAR(100),
    city VARCHAR(100),
    vehicle_type VARCHAR(50),
    employment_type VARCHAR(50),
    avg_rating DECIMAL(3,2),
    is_active CHAR(1)
);


CREATE TABLE dim_restaurant (
    restaurant_id VARCHAR(20) PRIMARY KEY,
    restaurant_name VARCHAR(150),
    city VARCHAR(100),
    cuisine_type VARCHAR(100),
    partner_type VARCHAR(50),
    avg_prep_time_min VARCHAR(20),
    is_active CHAR(1)
);


CREATE TABLE dim_menu_item (
    menu_item_id VARCHAR(30) PRIMARY KEY,
    restaurant_id VARCHAR(20) REFERENCES dim_restaurant(restaurant_id),
    item_name VARCHAR(150),
    category VARCHAR(50),
    is_veg CHAR(1),
    price DECIMAL(10,2)
);

DROP TABLE IF EXISTS fact_order_items CASCADE;

CREATE TABLE fact_order_items (
    order_id VARCHAR(20),
    item_id VARCHAR(20),
    menu_item_id VARCHAR(30),
    restaurant_id VARCHAR(20),
    quantity INT,
    unit_price DECIMAL(10,2),
    item_discount DECIMAL(10,2),
    line_total DECIMAL(10,2)
);



CREATE TABLE fact_order_items (
    item_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) REFERENCES fact_orders(order_id),
    menu_item_id VARCHAR(30) REFERENCES dim_menu_item(menu_item_id),
    restaurant_id VARCHAR(20) REFERENCES dim_restaurant(restaurant_id),
    quantity INT,
    unit_price DECIMAL(10,2),
    item_discount DECIMAL(10,2),
    line_total DECIMAL(10,2)
);


CREATE TABLE fact_delivery_performance (
    order_id VARCHAR(20) REFERENCES fact_orders(order_id),
    actual_delivery_time_mins INT,
    expected_delivery_time_mins INT,
    distance_km DECIMAL(5,2)
);


DROP TABLE IF EXISTS staging_fact_ratings;
CREATE TABLE staging_fact_ratings (
  order_id TEXT,
  customer_id TEXT,
  restaurant_id TEXT,
  rating_text TEXT,
  review_text TEXT,
  review_timestamp_text TEXT,
  sentiment_score_text TEXT
);


DROP TABLE IF EXISTS fact_ratings;


ALTER TABLE staging_fact_ratings
RENAME TO fact_ratings;

ALTER TABLE fact_ratings
RENAME COLUMN "rating_text" TO rating;

ALTER TABLE fact_ratings
RENAME COLUMN "review_timestamp_text" TO review_timestamp;

ALTER TABLE fact_ratings
RENAME COLUMN "sentiment_score_text" TO sentiment_score;

