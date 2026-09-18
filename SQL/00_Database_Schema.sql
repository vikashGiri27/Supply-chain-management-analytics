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
                                     DDim_Warehouse Setup
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
-------------------------------------------------------------------------------*/
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



