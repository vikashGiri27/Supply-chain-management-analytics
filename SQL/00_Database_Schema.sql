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

Alter table Fact_Inventory
Add primary key (Inventory_Date,Product_ID,Warehouse_ID);
