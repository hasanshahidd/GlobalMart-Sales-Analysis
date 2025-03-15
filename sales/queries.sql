SELECT tablename FROM pg_tables WHERE schemaname = 'public';

SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'dim_date';
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'orders';

SELECT country, SUM(staff_numbers) AS total_staff_numbers FROM dim_store WHERE country = 'UK' GROUP BY country;

SELECT SUM(o.product_quantity * dp.sale_price) AS Total_Revenue, dd.month_name AS Month 
FROM orders o 
INNER JOIN dim_product dp ON dp.product_code = o.product_code 
INNER JOIN dim_date dd ON dd.date = o.order_date 
WHERE dd.year = '2022' 
GROUP BY dd.month_name 
ORDER BY Total_Revenue DESC LIMIT 1;

SELECT SUM(o.product_quantity * dp.sale_price) AS Total_Revenue, ds.store_type AS Store_Type 
FROM orders o 
INNER JOIN dim_product dp ON dp.product_code = o.product_code 
INNER JOIN dim_store ds ON ds.store_code = o.store_code 
INNER JOIN dim_date dd ON dd.date = o.order_date 
WHERE dd.year = '2022' AND ds.country = 'Germany' 
GROUP BY Store_Type 
ORDER BY Total_Revenue DESC LIMIT 1;

CREATE VIEW Summary_Store_Data AS 
SELECT Store_Type, Revenue, Revenue / SUM(Revenue) OVER () AS Percentage_of_Total_Revenue, Count_of_Orders 
FROM (SELECT ds.store_type AS Store_Type, SUM(o.product_quantity * dp.sale_price) AS Revenue, COUNT(*) AS Count_of_Orders 
FROM orders o 
INNER JOIN dim_product dp ON dp.product_code = o.product_code 
INNER JOIN dim_store ds ON ds.store_code = o.store_code 
INNER JOIN dim_date dd ON dd.date = o.order_date 
GROUP BY Store_Type) AS info;

SELECT SUM(o.product_quantity * (dp.sale_price - dp.cost_price)) AS Profit, dp.category AS Product_Category 
FROM orders o 
INNER JOIN dim_product dp ON dp.product_code = o.product_code 
INNER JOIN dim_store ds ON ds.store_code = o.store_code 
INNER JOIN dim_date dd ON dd.date = o.order_date 
WHERE dd.year = '2021' AND ds.full_region = 'Wiltshire, UK' 
GROUP BY Product_Category 
ORDER BY Profit DESC LIMIT 1;

WITH count_products_cte AS (
    SELECT user_id, product_code, COUNT(product_code) AS product_count 
    FROM orders GROUP BY user_id, product_code ORDER BY user_id ASC),
product_rank_cte AS (
    SELECT user_id, product_code, DENSE_RANK() OVER(PARTITION BY user_id ORDER BY product_count DESC) AS rank 
    FROM count_products_cte)
SELECT c2.product_code, p.description, COUNT(c2.user_id) AS most_ordered_count 
FROM product_rank_cte c2 
INNER JOIN dim_product p ON c2.product_code = p.product_code 
WHERE rank = 1 
GROUP BY c2.product_code, p.description 
ORDER BY most_ordered_count DESC LIMIT 10;
