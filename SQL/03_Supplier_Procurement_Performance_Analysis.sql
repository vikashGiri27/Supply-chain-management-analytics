/*=================================================================
                 SUPPLIER & PROCUREMENT PERFORMANCE ANALYSIS
==================================================================*/

/*-----------------------------------------------------------
BQ10. Which suppliers have the lowest on-time delivery performance?
-------------------------------------------------------------*/
select
s.Supplier_ID,
s.Supplier_Name,
count(*) as Total_PO_Lines,
sum(case when p.Actual_Delivery_Date <= p.Expected_Delivery_Date then 1 else 0 end) as On_Time_PO_Lines,
round(sum(case when p.Actual_Delivery_Date <= p.Expected_Delivery_Date then 1 else 0 end) * 100.0 / count(*), 2) as On_Time_Delivery_Rate
from Fact_Purchase_Order p
inner join Dim_Supplier s
on p.Supplier_ID = s.Supplier_ID
where p.PO_Status= 'Completed'
and p.Actual_Delivery_Date is not null
and p.Expected_Delivery_Date is not null
group by s.Supplier_ID,
s.Supplier_Name
order by On_Time_Delivery_Rate asc;

/*----------------------------------------------------------------------------------
#BQ11. Which suppliers generate the highest number of delayed purchase orders?
---------------------------------------------------------------------------------*/
Select
s.Supplier_ID,
s.Supplier_Name,
count(distinct p.PO_ID) as Delayed_PO_Count
from Dim_Supplier s
inner join Fact_Purchase_Order p
on s.Supplier_ID = p.Supplier_ID
where p.PO_Status= 'Completed'
and p.actual_Delivery_Date is not null
and p.Expected_Delivery_Date is not null
and p.Actual_delivery_Date > p.Expected_Delivery_Date
group by s.Supplier_ID,s.Supplier_Name
order by Delayed_PO_Count desc;

/*-----------------------------------------------------
BQ12. What is the average procurement lead time?
------------------------------------------------------*/
Select
round(avg(datediff(Actual_Delivery_Date, Order_Date)),2)
AS Average_Procurement_Lead_Time_Days
from Fact_Purchase_Order
where PO_Status = 'Completed'
and Actual_Delivery_Date is not null
and Order_Date is not null
and Actual_Delivery_Date >= Order_Date;

/*-----------------------------------------------------------
BQ13. Which products have the longest procurement lead time?
-------------------------------------------------------------*/

select
p.Product_ID,
p.Product_Name,
round(avg(datediff(po.Actual_Delivery_Date, po.Order_Date)), 2) as Average_Procurement_Lead_Time_Days
from Dim_Product as p
inner join Fact_Purchase_Order as po
on p.Product_ID = po.Product_ID
where po.PO_Status = 'Completed'
and po.Order_Date is not null
and po.Actual_Delivery_Date is not null
and po.Actual_Delivery_Date >= po.Order_Date
group by p.Product_ID,p.Product_Name
order by Average_Procurement_Lead_Time_Days desc;


/*-------------------------------------------------------------------
BQ14: Which suppliers frequently deliver less quantity than ordered?
---------------------------------------------------------------------*/

select
s.Supplier_ID,
s.Supplier_Name,
count(*) as Short_Delivery_Count
from Dim_Supplier s
inner join Fact_Purchase_Order po
on s.Supplier_ID = po.Supplier_ID
where po.Received_Quantity < po.Ordered_Quantity
and po.PO_Status = 'Completed'
group by
s.Supplier_ID,
s.Supplier_Name
order by Short_Delivery_Count desc;

/*-------------------------------------------------------------------
BQ15. What is the purchase order fulfillment rate by supplier?
---------------------------------------------------------------------*/
select
s.Supplier_ID,
s.Supplier_Name,
round( sum(po.Received_Quantity) * 100.0 / nullif(sum(po.Ordered_Quantity), 0),2) as Fulfillment_Rate
from Fact_Purchase_Order po
inner join Dim_Supplier s
on po.Supplier_ID = s.Supplier_ID
where po.PO_Status = 'Completed'
and po.Ordered_Quantity is not null
and po.Ordered_Quantity > 0
and po.Received_Quantity is not null
and po.Received_Quantity >= 0
group by s.Supplier_ID,
s.Supplier_Name
order by Fulfillment_Rate desc;


/*-----------------------------------------------------
BQ16. How has supplier performance changed over time?
------------------------------------------------------*/
select
Supplier_ID,
year(Order_Date) as Order_Year,
month(Order_Date) as Order_Month,
count(*) as Total_PO_Lines,
sum(case when Actual_Delivery_Date <= Expected_Delivery_Date then 1 else 0 end) as On_Time_PO_Line_Count,
sum(case when Actual_Delivery_Date > Expected_Delivery_Date then 1 else 0 end) as Late_PO_Line_Count,
round(sum(case when Actual_Delivery_Date <= Expected_Delivery_Date then 1 else 0 end) * 100.0 / count(*), 2) as On_Time_Delivery_Rate,
round(sum(case when Actual_Delivery_Date > Expected_Delivery_Date then 1 else 0 end) * 100.0 / count(*), 2) as Late_Delivery_Rate
from Fact_Purchase_Order
where PO_Status = 'Completed'
and Order_Date is not null
and Actual_Delivery_Date is not null
and Expected_Delivery_Date is not null
group by Supplier_ID,
year(Order_Date),
month(Order_Date)
order by
Order_Year,
Order_Month,
Supplier_ID;

/*------------------------------------------------
 BQ17: Supplier Delays vs Inventory Shortages 
--------------------------------------------------*/

with monthly_events as (
select
Product_ID,
year(Expected_Delivery_Date) as Analysis_Year,
month(Expected_Delivery_Date) as Analysis_Month,
count(distinct PO_ID) as Late_PO_Count,
0 as Stockout_Frequency
from Fact_Purchase_Order
where PO_Status = 'Completed'
and Expected_Delivery_Date is not null
and Actual_Delivery_Date is not null
and Actual_Delivery_Date > Expected_Delivery_Date
group by Product_ID, year(Expected_Delivery_Date), month(Expected_Delivery_Date)
union all
select Product_ID,
year(Inventory_Date) as Analysis_Year,
month(Inventory_Date) as Analysis_Month,
0 as Late_PO_Count,
count(*) as Stockout_Frequency
from Fact_Inventory
where Inventory_Date is not null
and Closing_Stock = 0
group by Product_ID, year(Inventory_Date), month(Inventory_Date))
select Product_ID,
Analysis_Year,
Analysis_Month,
sum(Late_PO_Count) as Late_PO_Count,
sum(Stockout_Frequency) as Stockout_Frequency
from monthly_events
group by Product_ID, Analysis_Year, Analysis_Month
order by Analysis_Year, Analysis_Month, Product_ID;
