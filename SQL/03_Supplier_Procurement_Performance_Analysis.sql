/*=================================================================
                 SUPPLIER & PROCUREMENT PERFORMANCE ANALYSIS
==================================================================*/

/*-----------------------------------------------------------
BQ10. Which suppliers have the lowest on-time delivery performance?
-------------------------------------------------------------*/
select
s.Supplier_ID,
s.Supplier_Name,
count(*) as Total_Orders,
sum(case when p.Actual_Delivery_Date <= p.Expected_Delivery_Date then 1 else 0 end) as On_Time_Orders,
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
and Order_Date in not null
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