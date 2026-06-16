/*
===========================================================
 Script Purpose:
 ----------------------------------------------------------
 This script ensures a clean database environment by:
   - Dropping the database if it already exists.
   - Creating the database if it does not exist.
   - Adding three schemas: Bronze, Silver, and Gold.

 These schemas represent a layered architecture:
   - Bronze: Raw ingested data (from CRM/ERP CSV files).
   - Silver: Cleaned and transformed data.
   - Gold: Curated, analytics-ready data for reporting.

 ⚠️ Warnings:
 ----------------------------------------------------------
 - Running this script will permanently delete the existing 
   database and ALL of its data if the database is present.
 - Do NOT run this in production environments.
 - Always back up important data before executing.
 - Use with caution: this operation is destructive when 
   the database exists.

 Author: Mostyn
 Date:   2026-06-16
===========================================================
*/


USE master;
GO

--Drop and Recreate 'DataWarehouse' if it exists
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

--Create 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
