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












