git /*=================================================================
                 SUPPLIER & PROCUREMENT PERFORMANCE ANALYSIS
==================================================================*/

/*-----------------------------------------------------------
BQ1. Which suppliers have the lowest on-time delivery performance?
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
#BQ2. Which suppliers generate the highest number of delayed purchase orders?
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
BQ3. What is the average procurement lead time?
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
BQ4. Which products have the longest procurement lead time?
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
BQ5: Which suppliers frequently deliver less quantity than ordered?
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
group by s.Supplier_ID, s.Supplier_Name
order by Short_Delivery_Count desc;

/*-------------------------------------------------------------------
BQ6. What is the purchase order fulfillment rate by supplier?
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
BQ7. How has supplier performance changed over time?
------------------------------------------------------*/
select
Supplier_ID,
year(Order_Date) as Order_Year,
month(Order_Date) as Order_Month,
count(*) as Total_PO_Lines,
sum(Actual_Delivery_Date <= Expected_Delivery_Date) as On_Time_PO_Line_Count,
sum(Actual_Delivery_Date > Expected_Delivery_Date) as Late_PO_Line_Count,
round(avg(Actual_Delivery_Date <= Expected_Delivery_Date) * 100, 2) as On_Time_Delivery_Rate,
round(avg(Actual_Delivery_Date > Expected_Delivery_Date) * 100, 2) as Late_Delivery_Rate
from Fact_Purchase_Order
where PO_Status = 'Completed'
and Order_Date is not null
and Actual_Delivery_Date is not null
and Expected_Delivery_Date is not null
group by Supplier_ID, year(Order_Date), month(Order_Date)
order by Order_Year, Order_Month, Supplier_ID;

/*------------------------------------------------------------------------------
 BQ8:How do monthly supplier delays and inventory stockouts compare by product?
-------------------------------------------------------------------------------*/

with delays as (
select Product_ID, year(Expected_Delivery_Date) as yr, month(Expected_Delivery_Date) as mn,
count(distinct PO_ID) as Late_PO_Count
from Fact_Purchase_Order
where PO_Status = 'Completed'
and Actual_Delivery_Date > Expected_Delivery_Date
and Expected_Delivery_Date is not null
group by Product_ID, yr, mn),
stockouts as (select Product_ID, year(Inventory_Date) as yr, month(Inventory_Date) as mn,
count(*) as Stockout_Frequency
from Fact_Inventory
where Closing_Stock = 0
group by Product_ID, yr, mn)
select coalesce(d.Product_ID, i.Product_ID) as Product_ID,
coalesce(d.yr, i.yr) as Analysis_Year,
coalesce(d.mn, i.mn) as Analysis_Month,
coalesce(d.Late_PO_Count, 0) as Late_PO_Count,
coalesce(i.Stockout_Frequency, 0) as Stockout_Frequency
from delays d
left join stockouts i
on d.Product_ID = i.Product_ID
and d.yr = i.yr
and d.mn = i.mn
union
select i.Product_ID, i.yr, i.mn, 0, i.Stockout_Frequency
from stockouts i
left join delays d
on i.Product_ID = d.Product_ID
and i.yr = d.yr
and i.mn = d.mn
where d.Product_ID is null
order by Analysis_Year, Analysis_Month, Product_ID;