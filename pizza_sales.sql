--GETTING THE DATA
 

--REQUIRE KPI--
--1. TOTAL REVENUE GENERATED

Select SUM(total_price) As Total_Revenue from PizzaDB..pizza_sales

--2. AVERAGE ORDER VALUE
Select SUM(total_price)/COUNT(DISTINCT(order_id)) as AvR_Order_Value from PizzaDB..pizza_sales

--3. TOTAL PIZZA SOLD
Select SUM(quantity) As TotalPizzaSold from PizzaDB..pizza_sales
--4. TOTAL ORDER
Select COUNT(DISTINCT(order_id)) as TotalOrder from PizzaDB..pizza_sales
--5. AVERAGE PIZZAS SOLD PER ORDER
Select (cast(SUM(quantity) as decimal(10,1))/cast(COUNT(DISTINCT(order_id)) as decimal(10,1))) as AvRPizzaPerOrder from PizzaDB..pizza_sales

/*CHART REQUIREMENT*/
--1. HOURLYTREND OF TOTAL ORDER
Select DATEPART(HOUR, order_time) as HourOrd,COUNT(DISTINCT(order_id)) as TotalOrders 
from PizzaDB..pizza_sales
Group by DATEPART(HOUR, order_time)
order by HourOrd Asc

--2. WEEKLY TREND OF TOTAL ORDER
Select DATEPART(ISO_WEEK, order_date) as WeekOrd,Year(order_date) as OrdYear,
COUNT(DISTINCT(order_id)) as TotalOrders 
from PizzaDB..pizza_sales
Group by DATEPART(ISO_WEEK, order_date), Year(order_date)
order by WeekOrd Asc

--3. PERCENTAGE OF SALES BY PIZZA CATEGORY
select pizza_category, cast(Sum(total_price)/(Select Sum(total_price)from PizzaDB..pizza_sales)*100 as decimal(10,2)) as PercentSold from PizzaDB..pizza_sales
Group by pizza_category
Order by PercentSold Asc

--4. PERCENTAGE OF SALES BY PIZZA SIZE
select pizza_size, cast(Sum(total_price)/(Select Sum(total_price)from PizzaDB..pizza_sales)*100 as decimal(10,2)) as PercentSold from PizzaDB..pizza_sales
Group by pizza_size
Order by PercentSold Asc

--5. TOTAL PIZZA SOLD BY CATEGORY
select pizza_category, Sum(quantity) as Total_Sold from PizzaDB..pizza_sales
Group by pizza_category
Order by Total_Sold Asc

--6. TOP 5 BEST SELER BY REVENUE, TOTAL QUANTITY AND TOTAL ORDERS
	--	a.TOP 5 BEST SELER BY REVENUE
select top 5 pizza_name, Sum(total_price) as Total_Revenue from PizzaDB..pizza_sales
Group by pizza_name
Order by Total_Revenue desc
	--b.TOP 5 BEST SELER BY TOTAL QUALITY
select top 5 pizza_name, Sum(quantity) as Total_Quantity from PizzaDB..pizza_sales
Group by pizza_name
Order by Total_Quantity desc
	--c.TOP 5 BEST SELER BY TOTAL ORDER
select top 5 pizza_name, COUNT(DISTINCT(order_id)) as Total_Order from PizzaDB..pizza_sales
Group by pizza_name
Order by Total_Order desc

--7. BOTTOM 5 BEST SELER BY REVENUE, TOTAL QUANTITY AND TOTAL ORDERS
	--	a.TOP 5 BEST SELER BY REVENUE
select top 5 pizza_name, Sum(total_price) as Total_Revenue from PizzaDB..pizza_sales
Group by pizza_name
Order by Total_Revenue asc
	--b.TOP 5 BEST SELER BY TOTAL QUALITY
select top 5 pizza_name, Sum(quantity) as Total_Quantity from PizzaDB..pizza_sales
Group by pizza_name
Order by Total_Quantity asc
	--c.TOP 5 BEST SELER BY TOTAL ORDER
select top 5 pizza_name, COUNT(DISTINCT(order_id)) as Total_Order from PizzaDB..pizza_sales
Group by pizza_name
Order by Total_Order asc
