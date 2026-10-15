/*======================================================
    ORDER FULFILLMENT & DELIVERY PERFORMANCE ANALYSIS
=======================================================*/

/*-----------------------------------------------------------
BQ01: What percentage of customer orders are fully fulfilled?
------------------------------------------------------------*/
select
count(distinct Order_ID) as total_orders,
count(*) as total_order_lines,
sum(Ordered_Quantity) as total_ordered_quantity,
sum(Fulfilled_Quantity) as total_fulfilled_quantity,
round(sum(Fulfilled_Quantity) / nullif(sum(Ordered_Quantity), 0) * 100,
2 ) as order_fulfillment_rate_pct,
sum(Ordered_Quantity is null) as missing_ordered_quantity_lines,
sum(Fulfilled_Quantity is null) as missing_fulfilled_quantity_lines
from Fact_Customer_Order;


/*-----------------------------------------------------------
BQ02: What percentage of completed deliveries are on time?
------------------------------------------------------------*/

select
count(*) as total_completed_deliveries,
sum(case when Actual_Delivery_Date <= Expected_Delivery_Date then 1 else 0 end) as on_time_deliveries,
round( sum(case when Actual_Delivery_Date <= Expected_Delivery_Date then 1 else 0 end) / nullif(count(*), 0) * 100,
2 ) as on_time_delivery_rate_pct
from Fact_Delivery
where Delivery_Status = 'Delivered'
and Expected_Delivery_Date is not null
and Actual_Delivery_Date is not null;


/*-----------------------------------------------------------
BQ03: Which warehouses have the highest fulfillment issues?
-----------------------------------------------------------*/

select
Warehouse_ID,
count(distinct Order_ID) as total_orders,
count(*) as total_order_lines,
sum(Ordered_Quantity) as total_ordered_quantity,
sum(Fulfilled_Quantity) as total_fulfilled_quantity,
round(sum(Fulfilled_Quantity) / nullif(sum(Ordered_Quantity), 0) * 100,2) as order_fulfillment_rate_pct,
sum(case when Ordered_Quantity > Fulfilled_Quantity then 1 else 0 end) as shortfall_order_lines,
sum(case when Ordered_Quantity > Fulfilled_Quantity then Ordered_Quantity - Fulfilled_Quantity
else 0 end) as fulfillment_shortfall_quantity,
sum(Ordered_Quantity is null) as missing_ordered_quantity_lines,
sum(Fulfilled_Quantity is null) as missing_fulfilled_quantity_lines
from Fact_Customer_Order
group by Warehouse_ID
order by fulfillment_shortfall_quantity desc;


/*-----------------------------------------------------------
BQ04: Which regions have the highest delivery delays?*
------------------------------------------------------------*/
select
Delivery_Region,
count(*) as Total_Completed_Deliveries,
sum(case when Actual_Delivery_Date > Expected_Delivery_Date then 1 else 0 end) as Late_Deliveries,
round(sum(case when Actual_Delivery_Date > Expected_Delivery_Date then 1 else 0 end) / nullif(count(*), 0) * 100,2) as Late_Delivery_Rate_Pct,
round( avg(case when Actual_Delivery_Date > Expected_Delivery_Date
then datediff(Actual_Delivery_Date, Expected_Delivery_Date)else null end),2 ) as Average_Delivery_Delay_Days
from Fact_Delivery
where Delivery_Status = 'Delivered'
and Expected_Delivery_Date is not null
and Actual_Delivery_Date is not null
group by Delivery_Region
order by Late_Delivery_Rate_Pct desc;


/*---------------------------------------------------------------
BQ05: Which products experience recurring fulfillment shortages?
----------------------------------------------------------------*/
select
Product_ID,
sum(Ordered_Quantity) as Total_Ordered_Quantity,
sum(Fulfilled_Quantity) as Total_Fulfilled_Quantity,
Round(sum(fulfilled_Quantity)*100.0/nullif(sum(Ordered_Quantity),0),2) as Product_Fulfillment_Rate,
sum(case When Ordered_Quantity>Fulfilled_Quantity then 1 else 0 end) as Shortage_Order_Lines,
sum(case when Ordered_Quantity=Fulfilled_Quantity then 1 else 0 end) as Fully_Filled_orders_line,
sum(case When Fulfilled_Quantity>Ordered_Quantity then 1 else 0 end) as over_fulfilled_orders_line,
sum(case when Ordered_Quantity>Fulfilled_Quantity then Ordered_Quantity-Fulfilled_Quantity else 0 end) as Total_Shortage_Quantity 
from fact_customer_order
where Ordered_Quantity is not null
and Fulfilled_Quantity is not null 
group by Product_ID
order by Shortage_Order_Lines desc,Total_Shortage_Quantity desc;

/*-------------------------------------------------------
BQ06 — What is the average order-to-delivery cycle time?
--------------------------------------------------------*/
with Order_Level as
( select
fo.Order_ID,
min(fo.Order_Date) as Order_Date,
max(fd.Actual_Delivery_Date) as Actual_Delivery_Date
from Fact_Customer_Order as fo
inner join Fact_Delivery as fd
on fo.Order_ID = fd.Order_ID
where fo.Order_Date is not null
and fd.Actual_Delivery_Date is not null
group by fo.Order_ID),
Order_Cycle_Time as
(select 	Order_ID,
Order_Date,
Actual_Delivery_Date,
datediff(Actual_Delivery_Date, Order_Date) as Order_to_Delivery_Days
from Order_Level)
select
count(*) as Total_Orders_Analyzed,
round(avg(Order_to_Delivery_Days), 2) as Average_Order_to_Delivery_Days,
min(Order_to_Delivery_Days) as Minimum_Cycle_Time_Days,
max(Order_to_Delivery_Days) as Maximum_Cycle_Time_Days
from Order_Cycle_Time
where Order_to_Delivery_Days >= 0;


/*-----------------------------------------------------
BQ07 — How does delivery performance change over time?
------------------------------------------------------*/
with Distinct_Deliveries as
( select distinct
Delivery_ID,
Order_ID,
Shipment_Date,
Expected_Delivery_Date,
Actual_Delivery_Date,
Delivery_Status,
Delivery_Region
from Fact_Delivery ),
Monthly_Delivery_Performance as
(select
year(Actual_Delivery_Date) as Delivery_Year,
month(Actual_Delivery_Date) as Delivery_Month,
count(*) as Total_Eligible_Deliveries,
sum(case when Actual_Delivery_Date <= Expected_Delivery_Date then 1 else 0 end) as On_Time_Deliveries,
sum(case when Actual_Delivery_Date > Expected_Delivery_Date then 1 else 0 end) as Late_Deliveries
from Distinct_Deliveries
where Delivery_Status = 'Delivered'
and Actual_Delivery_Date is not null
and Expected_Delivery_Date is not null
group by year(Actual_Delivery_Date),
month(Actual_Delivery_Date))
select Delivery_Year,
Delivery_Month,
Total_Eligible_Deliveries,
On_Time_Deliveries,
Late_Deliveries,
round(On_Time_Deliveries * 100.0 / nullif(Total_Eligible_Deliveries, 0),2) as On_Time_Delivery_Rate,
round(Late_Deliveries * 100.0 / nullif(Total_Eligible_Deliveries, 0),2) as Late_Delivery_Rate
from Monthly_Delivery_Performance
order by
Delivery_Year,
Delivery_Month;

/*------------------------------------------------------------------------------------
BQ08. Are inventory shortages associated with incomplete customer order fulfillment?
-------------------------------------------------------------------------------------*/

select
i.Product_ID,
i.Warehouse_ID,
count(*) as Stockout_Order_Matches,
sum(o.Ordered_Quantity) as Total_Ordered_Quantity,
sum(o.Fulfilled_Quantity) as Total_Fulfilled_Quantity,
sum(o.Ordered_Quantity - o.Fulfilled_Quantity)
as Unfulfilled_Quantity
from Fact_Inventory as i
join Fact_Customer_Order as o
on i.Product_ID = o.Product_ID
and i.Warehouse_ID = o.Warehouse_ID
and i.Inventory_Date = o.Order_Date
where i.Closing_Stock = 0
and o.Order_Status <> 'Cancelled'
group by
i.Product_ID,
i.Warehouse_ID
having sum(o.Ordered_Quantity - o.Fulfilled_Quantity) > 0
order by Unfulfilled_Quantity desc;

/*-------------------------------------------------------------------------
BQ09: Are supplier delays associated with downstream delivery performance?
--------------------------------------------------------------------------*/
with s as (
select date_format(Expected_Delivery_Date,'%Y-%m') as Performance_Month,
count(*) as Completed_PO_Line_Count,
sum(Actual_Delivery_Date > Expected_Delivery_Date) as Late_PO_Count
from Fact_Purchase_Order
where PO_Status = 'Completed'
and Actual_Delivery_Date is not null
and Expected_Delivery_Date is not null
group by Performance_Month), d 
as (select date_format(Expected_Delivery_Date,'%Y-%m') as Performance_Month,
count(*) as Completed_Delivery_Count,
sum(Actual_Delivery_Date > Expected_Delivery_Date) as Late_Delivery_Count
from Fact_Delivery
where Delivery_Status = 'Delivered'
and Actual_Delivery_Date is not null
and Expected_Delivery_Date is not null
group by Performance_Month
)
select s.Performance_Month,
s.Completed_PO_Line_Count,
s.Late_PO_Count,
round(100.0 * s.Late_PO_Count / nullif(s.Completed_PO_Line_Count,0),2) as Late_PO_Rate_Percent,
d.Completed_Delivery_Count,
d.Late_Delivery_Count,
round(100.0 * d.Late_Delivery_Count / nullif(d.Completed_Delivery_Count,0),2) as Late_Delivery_Rate_Percent
from s join d using (Performance_Month)
order by s.Performance_Month;


/*-------------------------------------------------------------------------
BQ10:Which operational segments should be prioritized for improvement?
--------------------------------------------------------------------------*/

select 'warehouse' as segment_type, Warehouse_ID as segment_name,
count(*) as total_cases,
sum(case when Fulfilled_Quantity < Ordered_Quantity then 1 else 0 end) as issue_cases,
sum(Ordered_Quantity - Fulfilled_Quantity) as issue_qty,
round(100.0 * sum(Ordered_Quantity - Fulfilled_Quantity) / nullif(sum(Ordered_Quantity), 0), 2) as issue_pct
from Fact_Customer_Order
where Ordered_Quantity is not null and Fulfilled_Quantity is not null
group by Warehouse_ID
union all
select 'product', Product_ID, count(*),
sum(case when Fulfilled_Quantity < Ordered_Quantity then 1 else 0 end),
sum(Ordered_Quantity - Fulfilled_Quantity),
round(100.0 * sum(Ordered_Quantity - Fulfilled_Quantity) / nullif(sum(Ordered_Quantity), 0), 2)
from Fact_Customer_Order
where Ordered_Quantity is not null and Fulfilled_Quantity is not null
group by Product_ID
union all
select 'region', Delivery_Region, count(*),
sum(case when Actual_Delivery_Date > Expected_Delivery_Date then 1 else 0 end),
null,round(100.0 * sum(case when Actual_Delivery_Date > Expected_Delivery_Date then 1 else 0 end) / count(*), 2)
from Fact_Delivery
where Delivery_Status = 'Delivered'
and Actual_Delivery_Date is not null
and Expected_Delivery_Date is not null
group by Delivery_Region
order by segment_type, issue_pct desc;





