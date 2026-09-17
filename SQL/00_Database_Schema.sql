create database supply_chain_analytics;
use supply_chain_analytics;

/*-----------------------------------------------------------------------------
                                     Dim_Product Setup
-------------------------------------------------------------------------------*/
create table Dim_Product(
Product_Id varchar(10) Primary key,
Product_Name varchar(250),
Product_Category varchar(100),
Unit_Cost decimal(12,2),
Selling_Price decimal(12,2),
Product_Status varchar(20));

