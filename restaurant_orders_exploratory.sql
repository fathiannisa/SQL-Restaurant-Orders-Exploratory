-- This project explores transactional and menu data from a fictional restaurant, Taste of the World Café, to uncover customer preferences and business insights following the launch of a new menu.

-- OBJECTIVE 1 - Explore the menu_items table to get an idea of what’s on the new menu

-- a. View all menu items
SELECT * FROM menu_items;

-- b. Count total number of menu items
SELECT COUNT(*) FROM menu_items;

-- c. Least expensive menu item (Sorting using ORDER BY)
SELECT * FROM menu_items
ORDER BY price
LIMIT 1;

-- d. Most expensive menu item (Sorting using ORDER BY)
SELECT * FROM menu_items
ORDER BY price DESC
LIMIT 1;

-- e. Count of Italian dishes (Filtering using WHERE) 
SELECT COUNT(*) FROM menu_items
WHERE category = 'Italian';

-- f. Least expensive Italian dish (Filtering and Sorting) 
SELECT * FROM menu_items
WHERE category = 'Italian'
ORDER BY price
LIMIT 1;

-- g. Most expensive Italian dish (Filtering and Sorting) 
SELECT * FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC
LIMIT 1;

-- h. Number of dishes per category
SELECT category, COUNT(menu_item_id) AS num_dishes
FROM menu_items
GROUP BY category;
-- whatever we put in a GROUP BY, has to also be in a SELECT statement

-- Average dish price per category (Aggregate, Grouping by GROUP BY)
SELECT category, AVG(price) AS avg_price
FROM menu_items
GROUP BY category;


-- OBJECTIVE 2 - Explore the order_details table to get an idea of the data that’s been collected

-- a. View order details
SELECT * FROM order_details;

-- b. Order date range
-- Checking all range
SELECT * FROM order_details
ORDER BY order_date;

-- Checking date range
SELECT MIN(order_date) AS start_date, MAX(order_date) AS end_date
FROM order_details;

-- c. Total orders made
SELECT COUNT(DISTINCT order_id) FROM order_details;

-- d. Total items ordered
SELECT COUNT(*) FROM order_details;

-- e. Orders with the most items
SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC
LIMIT 1;

-- f. Orders with more than 12 items
SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
HAVING num_items > 12;

-- g. Count of orders with more than 12 items
SELECT COUNT(*) FROM 
  (SELECT order_id, COUNT(item_id) AS num_items
  FROM order_details
  GROUP BY order_id
  HAVING num_items > 12) AS large_orders;


-- OBJECTIVE 3 - Use both tables to understand how customers are reacting to the new menu

-- a. Combine the menu_items and order_details tables into a single table
-- Start with the transaction table first, then the details about menu item
SELECT * 
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id;

-- b. Most and least ordered items
SELECT item_name, COUNT(order_details_id) AS num_purchases
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name
ORDER BY num_purchases DESC;

-- c. Most and least ordered items with categories (Adding category)
SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases DESC;

-- d. What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;

-- e. View the details of the highest spend order. What insight can you gather from the results?
-- The highest spend -> order_id = 440
SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category;
-- Insights: The highest spend order is Italian items, eventho not popular in the menu (Most popular: American)

-- 5.	View the details of the top 5 highest spend orders. What insights can you gather from the results?
SELECT category, COUNT(item_id) as num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE oder_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category;

-- Check each order_id’s category
SELECT order_id, category, COUNT(item_id) as num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE oder_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category;
-- Insights: Most highest spend order_id (4 out of 5) is ordered Italian food, insight: we should keep this expensive Italian food on the menu because people seems to be ordering that a lot, especially our highest spend customers

