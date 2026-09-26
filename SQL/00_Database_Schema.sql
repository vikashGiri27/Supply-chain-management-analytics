create database supply_chain_analytics;
use supply_chain_analytics;

/*-----------------------------------------------------------------------------
										 Dim_Product Setup
-------------------------------------------------------------------------------*/
create table Dim_Product(
Product_ID varchar(10) Primary key,
Product_Name varchar(250),
Product_Category varchar(100),
Unit_Cost decimal(12,2),
Selling_Price decimal(12,2),
Product_Status varchar(20));

# Import Dim_Product data :

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Dim_Product.csv'
INTO TABLE Dim_Product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/*-----------------------------------------------------------------------------
										 Dim_Warehouse Setup
-------------------------------------------------------------------------------*/

create table Dim_Warehouse
(Warehouse_ID varchar(10) primary key,
Warehouse_Name varchar(30),
Warehouse_Location varchar(40),
Warehouse_Capacity int);

# Import Dim_Warehouse data :

Load Data Infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Dim_Warehouse.csv'
Into Table Dim_Warehouse
Fields Terminated By ','
Enclosed by '"'
lines terminated by  '\n'
Ignore 1 rows;

/*-----------------------------------------------------------------------------
										 Dim_Supplier Setup
------------------------------------------------------------------------------*/
create table Dim_Supplier(	
Supplier_ID varchar(10) primary key,
Supplier_Name varchar(40),
Supplier_Location varchar(20),
Supplier_Category varchar(40),
Supplier_Status varchar(30));

# import Dim_Supplier data :

Load Data Infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Dim_Supplier.csv'
Into Table Dim_Supplier
Fields terminated by ','
Enclosed by '"'
Lines terminated by '\n'
Ignore 1 rows;

/*-----------------------------------------------------------------------------
										 Dim_Customer Setup
-------------------------------------------------------------------------------*/
create table Dim_Customer(
Customer_ID	varchar(10) primary key,
Customer_Name varchar(50),
Customer_Segment varchar(40),
Customer_Location varchar(30));

# import Dim_Customer data

Load Data Infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Dim_Customer.csv'
Into Table Dim_Customer
Fields terminated by ','
Enclosed by '"'
Lines terminated by '\n'
Ignore 1 rows;

/*-----------------------------------------------------------------------------
										 Dim_Date Setup
-------------------------------------------------------------------------------*/
Create table Dim_Date(Date date primary key,
Year int,
Quarter	varchar(10),
Month int,
Month_Name varchar(20),
Day int,
Week_Of_Year int,
Day_Name varchar(20),
Is_Weekend varchar(10));

# Import Dim_Date data

Load Data Infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Dim_Date.csv'
Into Table Dim_Date
Fields terminated by ','
Enclosed by '"'
Lines terminated by '\n'
Ignore 1 rows
(@Date, Year, Quarter, Month, Month_Name, Day, Week_Of_Year, Day_Name, Is_Weekend)
set Date=str_to_date(@Date,'%d-%m-%Y');

/*-----------------------------------------------------------------------------
									  Fact_Inventory Setup
------------------------------------------------------------------------------*/

CREATE TABLE Fact_Inventory(
Inventory_Date DATE,
Product_ID VARCHAR(10),
Warehouse_ID VARCHAR(10),
Opening_Stock INT,
Received_Quantity INT,
Issued_or_Sold_Quantity INT,
Closing_Stock INT,
Reorder_Level INT
);

# Import Fact_Inventory data

Load Data Infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Fact_Inventory.csv'
Into Table Fact_Inventory
Fields terminated by ','
Enclosed by '"'
Lines terminated by '\n'
Ignore 1 rows
(@Inventory_Date,
Product_ID,
Warehouse_ID,
Opening_Stock,
@Received_Quantity,
Issued_or_Sold_Quantity,
Closing_Stock,Reorder_Level)
Set Inventory_Date=str_to_date(@Inventory_Date,'%d-%m-%Y'),
Received_Quantity=nullif(@Received_Quantity, '');

#Add Composite Primary Key :

Alter table Fact_Inventory
Add primary key (Inventory_Date,Product_ID,Warehouse_ID);

		
/*-----------------------------------------------------------------------------
								  Fact_Purchase_Order Setup
------------------------------------------------------------------------------*/

CREATE TABLE Fact_Purchase_Order(
PO_ID VARCHAR(20),
PO_Line_ID VARCHAR(20) PRIMARY KEY,
Supplier_ID VARCHAR(10),
Product_ID VARCHAR(10),
Order_Date DATE,
Expected_Delivery_Date DATE,
Actual_Delivery_Date DATE,
Ordered_Quantity INT,
Received_Quantity INT,
Planned_Unit_Cost DECIMAL(10,2),
Actual_Unit_Cost DECIMAL(10,2),
PO_Status VARCHAR(30)
);

# Import Fact_Purchase_Order data

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Fact_Purchase_Order.csv'
INTO TABLE Fact_Purchase_Order
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
PO_ID,
PO_Line_ID,
Supplier_ID,
Product_ID,
@Order_Date,
@Expected_Delivery_Date,
@Actual_Delivery_Date,
Ordered_Quantity,
Received_Quantity,
Planned_Unit_Cost,
@Actual_Unit_Cost,
PO_Status
)
SET
Order_Date = STR_TO_DATE(NULLIF(@Order_Date, ''), '%d-%m-%Y'),
Expected_Delivery_Date = STR_TO_DATE(NULLIF(@Expected_Delivery_Date, ''), '%d-%m-%Y'),
Actual_Delivery_Date = STR_TO_DATE(NULLIF(@Actual_Delivery_Date, ''), '%d-%m-%Y'),
Actual_Unit_Cost = NULLIF(@Actual_Unit_Cost, '');


/*-----------------------------------------------------------------------------
							  Fact_Customer_Order Setup
------------------------------------------------------------------------------*/

CREATE TABLE Fact_Customer_Order(
Order_ID VARCHAR(20),
Order_Line_ID VARCHAR(20) PRIMARY KEY,
Customer_ID VARCHAR(10),
Product_ID VARCHAR(10),
Warehouse_ID VARCHAR(10),
Order_Date DATE,
Ordered_Quantity INT,
Fulfilled_Quantity INT,
Order_Status VARCHAR(30)
);

#Import Fact_Customer_Order data
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Fact_Customer_Order.csv'
INTO TABLE Fact_Customer_Order
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
Order_ID,
Order_Line_ID,
Customer_ID,
Product_ID,
Warehouse_ID,
@Order_Date,
@Ordered_Quantity,
Fulfilled_Quantity,
Order_Status
)
SET
Order_Date = STR_TO_DATE(NULLIF(@Order_Date, ''), '%d-%m-%Y'),
Ordered_Quantity = NULLIF(@Ordered_Quantity, '');
	   

/*-----------------------------------------------------------------------------
								  Fact_Delivery Setup
------------------------------------------------------------------------------*/
CREATE TABLE Fact_Delivery(
Delivery_ID VARCHAR(20) PRIMARY KEY,
Order_ID VARCHAR(20),
Shipment_Date DATE,
Expected_Delivery_Date DATE,
Actual_Delivery_Date DATE,
Delivery_Status VARCHAR(30),
Delivery_Region VARCHAR(50),
Delivery_Accuracy_Flag VARCHAR(5),
Damage_Flag VARCHAR(5),
Carrier_ID VARCHAR(20)
);

#Import Fact_Delivery data

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Fact_Delivery.csv'
INTO TABLE Fact_Delivery
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
Delivery_ID,
Order_ID,
@Shipment_Date,
@Expected_Delivery_Date,
@Actual_Delivery_Date,
Delivery_Status,
Delivery_Region,
Delivery_Accuracy_Flag,
Damage_Flag,
Carrier_ID
)
SET
Shipment_Date = STR_TO_DATE(NULLIF(@Shipment_Date, ''), '%d-%m-%Y'),
Expected_Delivery_Date = STR_TO_DATE(NULLIF(@Expected_Delivery_Date, ''), '%d-%m-%Y'),
Actual_Delivery_Date = STR_TO_DATE(NULLIF(@Actual_Delivery_Date, ''), '%d-%m-%Y');	


/*-----------------------------------------------------------------------------
								  Fact_Return Setup
------------------------------------------------------------------------------*/
CREATE TABLE Fact_Return(
Return_ID VARCHAR(20) PRIMARY KEY,
Order_ID VARCHAR(20),
Product_ID VARCHAR(10),
Return_Date DATE,
Returned_Quantity INT,
Return_Reason VARCHAR(100)
);

# Import Fact_Return data

Load Data Infile 
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Supply_Chain_Cleaned_Data/Fact_Return.csv'
Into table Fact_Return
Fields terminated by ','
Enclosed by '"'
Lines terminated by '\n'
Ignore 1 rows
(Return_ID,
Order_ID,
Product_ID,
@Return_Date,
Returned_Quantity,
Return_Reason)
Set Return_Date=str_to_date(@Return_Date,'%d-%m-%Y');


/*-------------------------------------------------------------------------------------------
								RELATIONSHIP SETUP — FOREIGN KEY CONSTRAINTS
---------------------------------------------------------------------------------------------*/

#-----Fact_Inventory → Dim_Warehouse

ALTER TABLE Fact_Inventory
ADD CONSTRAINT Fk_inventory_warehouse
FOREIGN KEY (Warehouse_ID)
REFERENCES Dim_Warehouse(Warehouse_ID);

#----- Fact_Inventory → Dim_Product
# Foreign key not created as a physical constraint.
# Reason: Fact_Inventory contains orphan Product_ID
# values that do not exist in Dim_Product.
# Logical relationship:
# Fact_Inventory.Product_ID → Dim_Product.Product_ID

#----- Fact_Purchase_order -> Dim_Supplier

Alter table Fact_Purchase_Order
Add constraint Fk_po_supplier
foreign key (supplier_ID)
References Dim_Supplier(Supplier_ID);

#------ Fact_Purchase_order -> Dim_Product

Alter Table Fact_Purchase_Order
Add Constraint Fk_po_product
Foreign Key (Product_ID)
References Dim_Product(Product_ID);

#------ Fact_Customer_Order ->Dim_Warehouse
Alter Table Fact_Customer_Order
Add Constraint Fk_customer_order_warehouse
Foreign Key (Warehouse_ID)
References Dim_Warehouse(Warehouse_ID);

#----- Fact_Customer_Order -> Dim_customer
Alter Table Fact_Customer_Order
Add Constraint Fk_customer_order_customer
Foreign Key (Customer_ID)
References Dim_Customer(Customer_ID);
