CREATE DATABASE retail_sales;
USE retail_sales;
SELECT*FROM sales;
ALTER TABLE sales MODIFY COLUMN transaction_date date;
ALTER TABLE sales MODIFY COLUMN transaction_time time;
Desc sales;

-- Sales Performance Analysis
-- What are the total sales revenue and average unit price across all stores?
SELECT 
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_sales,
    ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM
    sales;

-- Which store location generates the highest revenue?
SELECT 
    store_location,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM
    sales
GROUP BY store_location
ORDER BY total_revenue DESC
;

-- Which product category has the highest sales volume?
SELECT 
    product_category, SUM(transaction_qty) AS total_quantity
FROM
    sales
GROUP BY product_category
ORDER BY total_quantity DESC
LIMIT 1;

-- Customer Buying Patterns
-- Which products are frequently purchased together?
SELECT 
    LEAST(a.product_type, b.product_type) AS product_1, 
    GREATEST(a.product_type, b.product_type) AS product_2, 
    COUNT(*) AS frequency
FROM sales a
JOIN sales b 
    ON a.transaction_id = b.transaction_id AND a.product_type <> b.product_type
GROUP BY product_1, product_2
ORDER BY frequency DESC
LIMIT 5;

-- Are there seasonal trends in sales based on transaction dates?
SELECT 
    MONTH(transaction_date) AS month,
    SUM(transaction_qty) AS total_sales
FROM
    sales
GROUP BY month
ORDER BY total_sales DESC;

-- Pricing and Revenue Optimization
-- How does the unit price affect the quantity sold?
SELECT 
    unit_price, 
    SUM(transaction_qty) AS total_quantity_sold
FROM sales
GROUP BY unit_price
ORDER BY unit_price;

-- Which products contribute the most to revenue, and should their pricing be adjusted?
SELECT 
    product_type, 
    ROUND(SUM(transaction_qty * unit_price),2) AS total_revenue
FROM sales
GROUP BY product_type
ORDER BY total_revenue DESC
LIMIT 5;

-- Inventory and Stock Management
-- Which store locations need better stock management based on sales trends?
SELECT 
    store_location, 
    SUM(transaction_qty) AS total_items_sold
FROM sales
GROUP BY store_location
ORDER BY total_items_sold ASC LIMIT 3;

-- Are certain product types overstocked or understocked?
SELECT 
    product_type, 
    SUM(transaction_qty) AS total_sold
FROM sales
GROUP BY product_type
ORDER BY total_sold ASC
;
