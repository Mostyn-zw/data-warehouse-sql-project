/*
===========================================================
 Stored Procedure Purpose:
 ----------------------------------------------------------
 This procedure loads raw data into the Bronze layer of the 
 data warehouse by truncating existing staging tables and 
 bulk inserting fresh data from CSV source files.

 Workflow:
   - CRM Tables:
       * bronze.crm_cust_info       → Customer information
       * bronze.crm_prd_info        → Product details
       * bronze.crm_sales_details   → Sales transactions
   - ERP Tables:
       * bronze.erp_cust_az12       → Customer records
       * bronze.erp_loc_a101        → Location data
       * bronze.erp_px_cat_g1v2     → Product categories

 Key Features:
   - Uses BULK INSERT to load CSV files from source folders.
   - Tracks load duration for each table and overall batch.
   - Provides console output for progress monitoring.
   - Includes TRY/CATCH for error handling and diagnostics.

 ⚠️ Warnings:
 ----------------------------------------------------------
 - Each table is truncated before loading, permanently 
   deleting any existing data.
 - Running this procedure will overwrite Bronze layer data 
   with the latest CSV extracts.
 - Safe for development and testing environments only.
 - Do NOT run in production without backups or validation.
 - Ensure file paths are correct and accessible to SQL Server.

 Author: Mostyn
 Date:   2026-06-16
===========================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';
		SET @batch_start_time = GETDATE();
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>>Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\DWH Project\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>>Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\DWH Project\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>>Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\DWH Project\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>>Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\DWH Project\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>>Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\DWH Project\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>>Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\DWH Project\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		SET @batch_end_time = GETDATE();
		PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------';

		PRINT '===============================================================';
		PRINT 'Loading Bronze Layer is completed';
		PRINT '  -Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '===============================================================';
	END TRY
	BEGIN CATCH
		PRINT '===============================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '===============================================================';
	END CATCH
END
