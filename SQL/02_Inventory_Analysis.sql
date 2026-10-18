/*=================================================================
                    INVENTORY ANALYSIS
==================================================================*/

/*----------------------------------------------------------------
BQ1. Which products experience the highest number of stockouts?
------------------------------------------------------------------*/
Select i.Product_ID,
p.Product_Name,
p.Product_Category,
COUNT(*) as Stockout_Count
From Fact_Inventory i
Inner Join Dim_Product p
on i.Product_ID = p.Product_ID
Where i.Closing_Stock = 0
Group by i.Product_ID,
p.Product_Name,
p.Product_Category
order by Stockout_Count desc;

/*---------------------------------------------------------------------
BQ2. Which products and warehouses hold the highest inventory quantity?
-----------------------------------------------------------------------*/
select
i.Product_ID,
p.Product_Name,
i.Warehouse_ID,
w.Warehouse_Name,
i.Closing_Stock as Inventory_Quantity
from Fact_Inventory i
left join Dim_Product p
on i.Product_ID = p.Product_ID
inner join Dim_Warehouse w
on i.Warehouse_ID = w.Warehouse_ID
where i.Inventory_Date = (
select max(Inventory_Date)
from Fact_Inventory)
order by Inventory_Quantity desc;

/*-----------------------------------------
 BQ3. How does inventory change over time?
-------------------------------------------*/

With inventory_movement_base as
(select
Product_ID,
Warehouse_ID,
Inventory_Date,
Closing_Stock,
lag(Closing_Stock) over (
partition by Product_ID, Warehouse_ID
order by Inventory_Date ) as Previous_Closing_Stock From Fact_Inventory)
Select
Product_ID,
Warehouse_ID,
Inventory_Date,
Closing_Stock,
Previous_Closing_Stock,
Closing_Stock - Previous_Closing_Stock as Inventory_Change
from Inventory_Movement_Base
order by Product_ID, Warehouse_ID, Inventory_Date;

/*----------------------------------------------------
BQ4. How does inventory vary across warehouses?
------------------------------------------------------*/

select
w.Warehouse_ID,
w.Warehouse_Name,
w.Warehouse_Location,
sum(i.Closing_Stock) as Warehouse_Inventory_Quantity
from Fact_Inventory i
inner join Dim_Warehouse w
on i.Warehouse_ID = w.Warehouse_ID
where i.Inventory_Date = (
select max(Inventory_Date)
from Fact_Inventory 
)
group by
w.Warehouse_ID,
w.Warehouse_Name,
w.Warehouse_Location
order by Warehouse_Inventory_Quantity desc;

/*--------------------------------------------------------------------------------
BQ5: Analyze monthly inventory movement and stock held by product and warehouse.
----------------------------------------------------------------------------------*/

With Monthly_Inventory as (
select
Product_ID,
Warehouse_ID,
Inventory_Date,
Opening_Stock,
Issued_or_Sold_Quantity,
Closing_Stock,
date_format(Inventory_Date, '%Y-%m') as Inventory_Month,
row_number() over (partition by Product_ID, Warehouse_ID, date_format(Inventory_Date, '%Y-%m')
order by Inventory_Date) as First_Row,
row_number() over(partition by Product_ID, Warehouse_ID,date_format(Inventory_Date, '%Y-%m')
order by Inventory_Date desc) as Last_Row from Fact_Inventory)
select 
Product_ID,
Warehouse_ID,
Inventory_Month,
max(case when First_Row = 1 then Opening_Stock end) as Month_Opening_Stock,
sum(Issued_or_Sold_Quantity) as Total_Issued_Sold,
avg(Closing_Stock) as Average_Closing_Stock,
max(case when Last_Row = 1 then Closing_Stock end) as Month_End_Closing_Stock
from Monthly_Inventory
group by
Product_ID,
Warehouse_ID,
Inventory_Month
order by
Product_ID,
Warehouse_ID,
Inventory_Month;


/*----------------------------------------------------------
BQ6:Identify warehouses with the highest stockout frequency.
----------------------------------------------------------*/

select
i.Warehouse_ID,
w.Warehouse_Name,
w.Warehouse_Location,
count(i.Closing_Stock) as Stockout_Count
From Fact_Inventory i
inner join Dim_Warehouse w
on i.Warehouse_ID = w.Warehouse_ID
where i.Closing_Stock = 0
group by
i.Warehouse_ID,
w.Warehouse_Name,
w.Warehouse_Location
order by Stockout_Count desc;


/*------------------------------------------------------
BQ7: Compare product availability across warehouses.
--------------------------------------------------------*/
select
i.Product_ID,
p.Product_Name,
i.Warehouse_ID,
w.Warehouse_Name,
i.Inventory_Date,
i.Closing_Stock,
case
when i.Closing_Stock = 0 then 'Out of Stock' else 'Stock Available' end as Stock_Status
from Fact_Inventory i
inner join Dim_Product p
on i.Product_ID = p.Product_ID
inner join Dim_Warehouse w
on i.Warehouse_ID = w.Warehouse_ID
where i.Inventory_Date = (
select max(Inventory_Date)
FROM Fact_Inventory)
and exists(select 1
from Fact_Inventory other
where other.Product_ID = i.Product_ID
and other.Inventory_Date = i.Inventory_Date
and other.Warehouse_ID <> i.Warehouse_ID
and ((i.Closing_Stock = 0 and other.Closing_Stock > 0)or
(i.Closing_Stock > 0 and other.Closing_Stock = 0)))
order by
i.Product_ID,
i.Closing_Stock desc,
i.Warehouse_ID;


/*-------------------------------------------------------
BQ8 — Inventory Availability vs Customer Order Demand
-------------------------------------------------------*/

select
i.Product_ID as Inventory_Product_ID,
i.Warehouse_ID as Inventory_Warehouse_ID,
i.Inventory_Date,
i.Closing_Stock,
c.Product_ID as Order_Product_ID,
c.Warehouse_ID as Order_Warehouse_ID,
c.Order_Date,
c.Ordered_Quantity
from Fact_Inventory i
inner join Fact_Customer_Order c
on i.Product_ID = c.Product_ID
and i.Warehouse_ID = c.Warehouse_ID
and i.Inventory_Date = c.Order_Date
order by
i.Product_ID,
i.Warehouse_ID,
i.Inventory_Date;
