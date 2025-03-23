-- Amazon Sales Analysis SQL Queries
-- This script includes queries to analyze sales trends, product performance, fulfillment efficiency, customer segmentation, and geographical sales distribution.

--CREATION OF TABLE--

CREATE TABLE amazon_sales (
    order_id VARCHAR(50),
    order_date DATE,
    status VARCHAR(50),
    fulfilment VARCHAR(50),
    sales_channel VARCHAR(50),
    ship_service_level VARCHAR(100),
    category VARCHAR(100),
    size VARCHAR(50),
    courier_status VARCHAR(50),
    quantity INT,
    currency VARCHAR(10),
    amount DECIMAL(10,2),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(50),
    b2b BOOLEAN,
    fulfilled_by VARCHAR(50)
);

SELECT * FROM amazon_sales;

--PERFORMING DATA ANALYSIS & QUERIES--

--SALES OVERVIEW--
--Finding total revenue, total orders, and monthly sales trends.--

SELECT TO_CHAR(order_date, 'Month') AS month_name, 
       EXTRACT(MONTH FROM order_date) AS month_number, 
       SUM(amount) AS total_revenue, 
       COUNT(order_id) AS total_orders 
FROM amazon_sales 
GROUP BY month_name, month_number 
ORDER BY month_number;


--TOP-SELLING-PRODUCT--
--Identifying the most sold products.--

SELECT category, 
       size, 
       SUM(quantity) AS total_units_sold, 
       SUM(amount) AS total_revenue 
FROM amazon_sales 
GROUP BY category, size 
ORDER BY total_units_sold DESC;

--Most Popular Product Sizes--

SELECT size, 
       COUNT(*) AS total_orders, 
       SUM(quantity) AS total_units_sold 
FROM amazon_sales 
WHERE size IS NOT NULL
GROUP BY size 
ORDER BY total_units_sold DESC;

--Revenue Contribution by Product Category--

SELECT category, 
       ROUND(SUM(amount), 2) AS total_revenue, 
       ROUND(SUM(amount) * 100 / (SELECT SUM(amount) FROM amazon_sales), 2) AS revenue_percentage 
FROM amazon_sales 
GROUP BY category 
ORDER BY total_revenue DESC;


--FULFILLMENT ANALYSIS--

--This query shows the total number of orders and revenue for each fulfillment type.--

SELECT fulfilment AS fulfillment_method,
	   COUNT(order_id) AS total_orders,
	   SUM(amount) AS total_revenue
FROM amazon_sales
GROUP BY fulfilment
ORDER BY total_orders DESC;


--This query shows order status, breakdown by fulfillment method--

SELECT fulfilment AS fulfillment_method, 
       status, 
       COUNT(order_id) AS total_orders 
FROM amazon_sales 
GROUP BY fulfilment, status 
ORDER BY fulfillment_method, total_orders DESC;


--This query shows geographical fulfillment analysis--

SELECT fulfilment AS fulfillment_method, 
       ship_state, 
       COUNT(order_id) AS total_orders 
FROM amazon_sales 
GROUP BY fulfilment, ship_state 
ORDER BY fulfillment_method, total_orders DESC;


--CUSTOMER SEGMENTATION--

--This query Identifies customers who have spent the most money.

SELECT ship_city AS customer_location,
	   SUM(amount) AS total_spent,
	   COUNT(order_id) AS total_orders,
	   ROUND(AVG(amount), 2) AS avg_order_value
FROM amazon_sales
GROUP BY ship_city
ORDER BY total_spent DESC;

--This query Identifies customers based on their order frequency.--

SELECT ship_postal_code AS customer_id,
	   COUNT(order_id) AS total_orders,
	   ROUND(AVG(amount), 2) AS avg_order_value,
	   SUM(amount) AS total_spent
FROM amazon_sales
GROUP BY ship_postal_code
ORDER BY total_orders DESC;

--This query classifies customers based on how many times they have ordered.--

SELECT ship_postal_code AS customer_id,
	   CASE
	   		WHEN COUNT(order_id) = 1 THEN 'New Customer'
			WHEN COUNT(order_id) BETWEEN 2 AND 5 THEN 'Regular Customer'
			ELSE 'Loyal Customer'
	   END AS customer_type,
	   COUNT(order_id) AS total_orders,
	   SUM(amount) AS total_spent
FROM amazon_sales
GROUP BY ship_postal_code
ORDER BY total_spent DESC;


--GEOGRAPHICAL ANALYSIS--

--This query shows Total Orders & Revenue by State--
SELECT ship_state,
		COUNT(order_id) AS total_orders,
		SUM(amount) AS total_revenue
FROM amazon_sales
GROUP BY ship_state
ORDER BY total_revenue DESC;

--This query shows Total Orders & Revenue by City--
SELECT ship_city,
		COUNT(order_id) AS total_orders,
		SUM(amount) AS total_revenue
FROM amazon_sales
GROUP BY ship_city
ORDER BY total_revenue DESC;

--This query shows Sales Growth Trend by State (Monthly)--
SELECT ship_state,
		TO_CHAR(order_date, 'Month') AS month_name, 
		SUM(amount) AS total_revenue
FROM amazon_sales
GROUP BY ship_state, month_name
ORDER BY ship_state, month_name;


