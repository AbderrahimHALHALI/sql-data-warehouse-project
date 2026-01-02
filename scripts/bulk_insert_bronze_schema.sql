/*====================================================================================================
  SCRIPT PURPOSE
  ----------------------------------------------------------------------------------------------------
  This script loads raw source data from CRM and ERP CSV files into bronze-layer tables using
  BULK INSERT operations. After each load, basic validation queries are executed to verify
  column alignment and row counts against the source files.

  EXECUTION WARNINGS
  ----------------------------------------------------------------------------------------------------
  - This script must be executed in sequence and in full.
  - Target bronze tables must exist prior to execution, or BULK INSERT will fail.
  - Incorrect file paths, missing files, or insufficient file system permissions will cause
    load failures.
  - Skipping validation queries may result in undetected data quality or mapping issues.
  - Running BULK INSERT out of order may lead to partial or inconsistent bronze-layer loads.
====================================================================================================*/

-- Purpose: Load raw CRM customer data from CSV into the bronze customer table
-- Example result: (1000 rows affected)
BULK INSERT bronze.crm_cust_info
FROM '<CRM_SOURCE_PATH>\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Purpose: Perform a visual validation to confirm column order and data alignment
-- Example result: cst_id | cst_key | cst_firstname | cst_lastname | ...
SELECT *
FROM bronze.crm_cust_info;

-- Purpose: Validate record count against the source file
-- Example result: 1000
SELECT COUNT(*)
FROM bronze.crm_cust_info;

-- Purpose: Load raw CRM product data into the bronze product table
-- Example result: (250 rows affected)
BULK INSERT bronze.crm_prd_info
FROM '<CRM_SOURCE_PATH>\prd_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Purpose: Verify product data structure and column ordering
-- Example result: prd_id | prd_key | prd_nm | prd_cost | ...
SELECT *
FROM bronze.crm_prd_info;

-- Purpose: Confirm number of loaded product records
-- Example result: 250
SELECT COUNT(*)
FROM bronze.crm_prd_info;

-- Purpose: Load raw CRM sales transaction data into the bronze sales table
-- Example result: (15000 rows affected)
BULK INSERT bronze.crm_sales_details
FROM '<CRM_SOURCE_PATH>\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Purpose: Validate sales data alignment and detect obvious mapping issues
-- Example result: sls_ord_num | sls_prd_key | sls_cust_id | ...
SELECT *
FROM bronze.crm_sales_details;

-- Purpose: Validate total number of sales transactions loaded
-- Example result: 15000
SELECT COUNT(*)
FROM bronze.crm_sales_details;

-- Purpose: Load raw ERP customer demographic data into the bronze ERP customer table
-- Example result: (800 rows affected)
BULK INSERT bronze.erp_cust_az12
FROM '<ERP_SOURCE_PATH>\cust_az12.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Purpose: Validate ERP customer data structure and contents
-- Example result: CID | BDATE | GEN
SELECT *
FROM bronze.erp_cust_az12;

-- Purpose: Confirm record count for ERP customer data
-- Example result: 800
SELECT COUNT(*)
FROM bronze.erp_cust_az12;

-- Purpose: Load raw ERP customer location data into the bronze location table
-- Example result: (800 rows affected)
BULK INSERT bronze.erp_loc_a101
FROM '<ERP_SOURCE_PATH>\loc_a101.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Purpose: Validate customer location mappings and column order
-- Example result: CID | CNTRY
SELECT *
FROM bronze.erp_loc_a101;

-- Purpose: Validate row count consistency for location data
-- Example result: 800
SELECT COUNT(*)
FROM bronze.erp_loc_a101;

-- Purpose: Load raw ERP product category reference data into the bronze category table
-- Example result: (120 rows affected)
BULK INSERT bronze.erp_px_cat_g1v2
FROM '<ERP_SOURCE_PATH>\px_cat_g1v2.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Purpose: Verify product category hierarchy and column alignment
-- Example result: ID | CAT | SUBCAT | MAINTENANCE
SELECT *
FROM bronze.erp_px_cat_g1v2;

-- Purpose: Confirm number of loaded product category records
-- Example result: 120
SELECT COUNT(*)
FROM bronze.erp_px_cat_g1v2;
