USE BikeStores
SELECT	ord.order_id, ord.order_date, pob.brand_name, pod.product_name, poc.category_name, 
		pod.model_year, pod.product_id, odt.quantity, odt.list_price, SUM (odt.list_price * odt.quantity) AS Revenue,
		 odt.discount, CONCAT (cus.First_name,' ' ,cus.Last_name) AS Customer_name, 
		cus.city,cus.state, sto.store_name, CONCAT (sta.First_name,' ' ,sta.Last_name) AS Staff_name
FROM sales.customers cus
JOIN sales.orders ord
ON cus.customer_id = ord.customer_id
JOIN sales.order_items odt
ON ord.order_id = odt.order_id
JOIN sales.stores sto
ON ord.store_id = sto.store_id
JOIN sales.staffs sta
ON ord.staff_id = sta.staff_id
JOIN Production.products pod
ON odt.product_id = pod.product_id
JOIN production.brands pob
ON pod.brand_id = pob.brand_id
JOIN production.categories poc
ON pod.category_id = poc.category_id

GROUP BY  CONCAT (cus.First_name,' ' ,cus.Last_name), 
		cus.city,cus.state, sto.store_name, CONCAT (sta.First_name,' ' ,sta.Last_name),ord.order_id, 
		ord.order_date, pob.brand_name, pod.product_name, poc.category_name, 
		pod.model_year, pod.product_id, odt.quantity, odt.list_price, odt.discount



----------------------------------------------------------------------------------------------------------------------------------------
--Total Revenue, Quantity Ordered and Discount 

SELECT SUM (list_price * quantity) AS Total_revenue, 
		SUM (quantity) AS Total_quantity_ordered,
		SUM (discount) AS Total_discount
			    
FROM sales.order_items
-- A total of 7,078 bikes were sold, total revenue generated is $8,578,988.88 and total discount given is 497.57 within the period of 2016 - 2018

----------------------------------------------------------------------------------------------------------------------------------------------
--Number of Orders

SELECT COUNT (order_id) AS Total_orders
FROM sales.orders

--The total number of orders reeceived is 1,615

--------------------------------------------------------------------------------------------------------------------------------------------------
--Number of Customers

SELECT DISTINCT COUNT (CONCAT (cus.First_name,' ' ,cus.Last_name)) AS Number_of_customers
FROM sales.customers cus

--A total of 1,445 customers patronized the business between 2016 - 2018

-------------------------------------------------------------------------------------------------------------------------------------------------
--Revenue by Year

SELECT YEAR (ord.order_date) AS Year, SUM (odt.list_price * odt.quantity) AS Total_revenue, SUM (odt.quantity) AS Quantity_Ordered
FROM sales.orders ord
JOIN sales.order_items odt
ON ord.order_id = odt.order_id
GROUP BY YEAR (ord.order_date)
ORDER BY 2 DESC

--Revenue peaked in 2017 with a total of $3,845,515.02 from $2,709,484.47 of 2016 but dropped significantly to $2,023,989.39 in 2018. 
--There's also a significant drop in the number of bikes sold from 3,099 in 2017 to 1,316 in 2018. 
--Further investigation is required to understand the reason for the drop in sales.
-----------------------------------------------------------------------------------------------------------------------------------------------------
--Revenue by State

SELECT cus.state, SUM (odt.list_price * odt.quantity) AS Total_revenue, SUM (odt.quantity) AS Quantity_Ordered
FROM sales.customers cus
JOIN sales.orders ord
ON cus.customer_id = ord.customer_id
JOIN sales.order_items odt
ON ord.order_id = odt.order_id
GROUP BY cus.state
ORDER BY 2 DESC

--NewYork recorded the highest sales with a total revenue of $5,826,242.21 and total of 4,779 bikes sold. While the lowest sales came from Texas with a total of 783 bikes sold.
----------------------------------------------------------------------------------------------------------------------------------------------------------
--Revenue by Stores

SELECT sto.store_name, SUM (odt.list_price * odt.quantity) AS Total_revenue, SUM (odt.quantity) AS Quantity_Ordered
FROM sales.stores sto
JOIN sales.orders ord
ON sto.store_id = ord.store_id
JOIN sales.order_items odt
ON ord.order_id = odt.order_id
GROUP BY sto.store_name
ORDER BY 2 DESC

--The top performing store is Baldwin Bikes with a total revenue of $5,826,242.21 and total of 4,779 bikes sold

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--Revenue by Category

SELECT poc.category_name, SUM (odt.list_price * odt.quantity) AS Total_revenue, SUM (odt.quantity) AS Quantity_Ordered
FROM production.products pod
JOIN production.categories poc
ON pod.category_id = poc.category_id
JOIN sales.order_items odt
ON pod.product_id = odt.product_id
GROUP BY poc.category_name
ORDER BY 2 DESC

--Mountain Bikes sold the highest and generated a total of $3,030,775.71 with 1,755 bikes sold
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Revenue by Sales Rep

SELECT CONCAT (sta.First_name,' ' ,sta.Last_name) AS Staff_name, SUM (odt.list_price * odt.quantity) AS Total_revenue, 
	   SUM (odt.quantity) AS Quantity_sold
FROM sales.staffs sta
JOIN sales.orders ord
ON sta.staff_id = ord.staff_id
JOIN sales.order_items odt
ON ord.order_id = odt.order_id
GROUP BY CONCAT (sta.First_name,' ' ,sta.Last_name) 
ORDER BY 2 DESC

--The sales champion for the period in consideration (2016 - 2017) is Marcelene Boyer with a toal of $2,938,888.73 revenue generated and 2,419 bikes sold.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Top 5 Products by Revenue

SELECT TOP 5 pod.product_name, SUM (odt.list_price * odt.quantity) AS Total_revenue, 
		     SUM (odt.quantity) AS Quantity_Ordered
FROM production.products pod
JOIN sales.order_items odt
ON pod.product_id = odt.product_id
GROUP BY pod.product_name
ORDER BY 2 DESC

--The product the customers like the most is Trek Slash 8 27.5 - 2016, a total of 154 orders were placed for it and this generated a total revenue of $615,998.46 making it the top performing product.

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Top 5 Cities by Revenue 

SELECT TOP 5 cus.city, SUM (odt.list_price * odt.quantity) AS Total_revenue, 
		     SUM (odt.quantity) AS Quantity_Ordered
FROM sales.customers cus
JOIN sales.orders ord
ON cus.customer_id = ord.customer_id
JOIN sales.order_items odt
ON ord.order_id = odt.order_id
GROUP BY cus.city
ORDER BY 2 DESC

--The top performing city is Mount Vernon with a total revenue of $117,010.21 and total of 84 bikes sold

--------------------------------------------------------------------------------------------------------------------
--Top 5 Customers by Revenue

SELECT TOP 5  CONCAT (cus.First_name,' ' ,cus.Last_name) AS Customer_name, SUM (odt.list_price * odt.quantity) AS Total_revenue,
			  SUM (odt.quantity) AS Quantity_Ordered
FROM sales.customers cus
JOIN sales.orders ord
ON cus.customer_id = ord.customer_id
JOIN sales.order_items odt
ON ord.order_id = odt.order_id
GROUP BY CONCAT (cus.First_name,' ' ,cus.Last_name)
ORDER BY 2 DESC

--The top customer in terms of revenue generation is Pamelia Newman with a total revenue of $37,801.84 generated between 2016 - 2018

-----------------------------------------------------------------------------------------------------------------------------------------------





