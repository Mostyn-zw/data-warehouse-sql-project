/*
===========================================================
 Script Purpose:
 ----------------------------------------------------------
 This script prepares the Silver layer of the data warehouse
 by creating six staging tables for cleaned and transformed 
 data from the Bronze Layer:

   - silver.crm_cust_info       → Customer information (CRM)
   - silver.crm_prd_info        → Product information (CRM)
   - silver.crm_sales_details   → Sales transactions (CRM)
   - silver.erp_cust_az12       → Customer records (ERP)
   - silver.erp_loc_a101        → Location data (ERP)
   - silver.erp_px_cat_g1v2     → Product category data (ERP)

 These tables form the foundation of the Medallion Architecture:
   - Bronze: Raw ingested data from CRM/ERP CSV files
   - Silver: Cleaned and transformed data (to be built later)
   - Gold: Curated, analytics-ready data for reporting

 ⚠️ Warnings:
 ----------------------------------------------------------
 - Each table is dropped if it already exists, then recreated.
 - Running this script will permanently delete any existing 
   data in these tables.
 - Safe for development and testing environments only.
 - Do NOT run in production without backups.
 - Use with caution: this operation is destructive.

 Author: Mostyn
 Date:   2026-06-21
===========================================================
*/


IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info(
	cst_id				INT,
	cst_key				NVARCHAR(50),
	cst_firstname		NVARCHAR(50),
	cst_lastname		NVARCHAR(50),
	cst_marital_status	NVARCHAR(50),
	cst_gndr			NVARCHAR(50),
	cst_create_date		DATE,
	dhw_create_date		DATETIME2 DEFAULT GETDATE() --metadata column to track when records are inserted into Silver layer
);
GO

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
GO
CREATE TABLE silver.crm_prd_info(
	prd_id			INT,
	cat_id			NVARCHAR(50),
	prd_key			NVARCHAR(50),
	prd_nm			NVARCHAR(50),
	prd_cost		INT,
	prd_line		NVARCHAR(50),
	prd_start_dt	DATE,
	prd_end_dt		DATE,
	dhw_create_date	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
GO
CREATE TABLE silver.crm_sales_details(
	sls_ord_num		NVARCHAR(50),
	sls_prd_key		NVARCHAR(50),
	sls_cust_id		INT,
	sls_order_dt	INT,
	sls_ship_dt		INT,
	sls_due_dt		INT,
	sls_sales		INT,
	sls_quantity	INT,
	sls_price		INT,
	dhw_create_date	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
GO
CREATE TABLE silver.erp_cust_az12(
	cid				NVARCHAR(50),
	bdate			DATE,
	gen				NVARCHAR(50),
	dhw_create_date	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;
GO
CREATE TABLE silver.erp_loc_a101(
	cid				NVARCHAR(50),
	cntry			NVARCHAR(50),
	dhw_create_date	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
GO
CREATE TABLE silver.erp_px_cat_g1v2(
	id				NVARCHAR(50),
	cat				NVARCHAR(50),
	subcat			NVARCHAR(50),
	maintenance		NVARCHAR(50),
	dhw_create_date	DATETIME2 DEFAULT GETDATE()
);
GO
