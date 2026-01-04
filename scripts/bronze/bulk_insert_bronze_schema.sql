/**********************************************************************************************
-- Script: bronze.load_bronze
-- Purpose:
--   This stored procedure loads the Bronze layer of the data warehouse by ingesting CRM and 
--   ERP source data (customers, products, sales, demographics, locations, and product categories)
--   into staging tables in the 'bronze' schema. Each table is truncated before loading to ensure
--   fresh data is loaded every time.
--
-- Warning:
--   - This script must be executed in its entirety. Running partial steps or skipping tables
--     may result in inconsistent or incomplete Bronze layer data.
--   - Ensure source CSV files exist and are accessible, otherwise the BULK INSERT operations
--     will fail.
--   - Running this procedure concurrently with other processes modifying the same tables may
--     cause locking or data corruption issues.
**********************************************************************************************/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    -------------------------------------------------------------------------------
    -- Declare variables to track the start and end times of each loading step and the overall batch
    -- @start_time: Records the time just before a load begins
    -- @end_time: Records the time immediately after a load completes
    -- @batch_start_time: Records the time just before the batch begins
    -- @batch_end_time: Records the time immediately after the batch completes
    -- Usage: The difference between @end_time and @start_time (in seconds) gives
    --        the duration of each data load step, which is printed for monitoring
    -------------------------------------------------------------------------------
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        PRINT 'Starting Bronze layer load process...';

        -------------------------------------------------------------------------------
        -- Load CRM customer data
        -- Purpose: Populate bronze.crm_cust_info with fresh CRM customer data
        -- Example output: "0 rows affected" if table truncated successfully, then bulk insert message
        -------------------------------------------------------------------------------
        SET @batch_start_time = GETDATE();  -- Record batch start time
        SET @start_time = GETDATE();  -- Record start time
        PRINT 'Loading CRM customer data...';
        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Public\Documents\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();  -- Record end time
        PRINT 'Step duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------------------------
        -- Load CRM product data
        -- Purpose: Populate bronze.crm_prd_info with fresh CRM product information
        -- Example output: "Bulk load successfully completed."
        -------------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT 'Loading CRM product data...';
        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Public\Documents\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Step duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------------------------
        -- Load CRM sales transaction data
        -- Purpose: Populate bronze.crm_sales_details with recent sales transactions
        -- Example output: "1000 rows affected" (depends on CSV size)
        -------------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT 'Loading CRM sales transaction data...';
        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Public\Documents\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Step duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------------------------
        -- Load ERP customer demographic data
        -- Purpose: Populate bronze.erp_cust_az12 with ERP customer demographic info
        -- Example output: "Bulk load successfully completed."
        -------------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT 'Loading ERP customer demographic data...';
        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\Public\Documents\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Step duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------------------------
        -- Load ERP customer location data
        -- Purpose: Populate bronze.erp_loc_a101 with ERP customer location information
        -- Example output: "Bulk load successfully completed."
        -------------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT 'Loading ERP customer location data...';
        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\Public\Documents\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Step duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------------------------
        -- Load ERP product category data
        -- Purpose: Populate bronze.erp_px_cat_g1v2 with ERP product category information
        -- Example output: "Bulk load successfully completed."
        -------------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT 'Loading ERP product category data...';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\Public\Documents\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Step duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        SET @batch_end_time = GETDATE();  -- Record batch end time
        PRINT 'Batch duration = ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';


        PRINT 'Bronze layer load process completed successfully.';

    END TRY
    BEGIN CATCH
        PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOADING';
        PRINT 'Error message: ' + CAST(ERROR_MESSAGE() AS NVARCHAR);
        PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error state: ' + CAST(ERROR_STATE() AS NVARCHAR);
    END CATCH
END;
