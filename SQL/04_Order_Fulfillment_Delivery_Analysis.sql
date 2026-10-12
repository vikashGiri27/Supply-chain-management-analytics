/*======================================================
    ORDER FULFILLMENT & DELIVERY PERFORMANCE ANALYSIS
=======================================================*/

/*------------------------------------------------------
What percentage of customer orders are fully fulfilled?
------------------------------------------------------*/
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