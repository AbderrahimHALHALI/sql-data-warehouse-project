p/*====================================================================================================
  SCRIPT PURPOSE
  ----------------------------------------------------------------------------------------------------
  This script rebuilds a set of bronze-layer tables used to ingest raw data from CRM, ERP, and product
  source systems. Each table is dropped if it already exists and then recreated to ensure a clean,
  repeatable initialization of the bronze data structures.

  EXECUTION WARNINGS
  ----------------------------------------------------------------------------------------------------
  - This script must be executed sequentially and in full.
  - Skipping DROP TABLE statements may cause CREATE TABLE operations to fail due to existing objects.
  - Running the script out of order can result in missing or partially created tables.
  - The bronze schema must exist prior to execution, or table creation will fail.
  - Executing this script will permanently delete any existing data in the affected tables.
====================================================================================================*/

-- Purpose: Remove the existing CRM customer table to ensure a clean rebuild of raw customer data
-- Example result: Command(s) completed successfully.
DROP TABLE IF EXISTS bronze.crm_cust_info;
GO

-- Purpose: Create the CRM customer table to store raw customer master data from the source system
-- Example result: Command(s) completed successfully.
CREATE TABLE bronze.crm_cust_info (
    cst_id               INT,
    cst_key              NVARCHAR(50),
    cst_firstname        NVARCHAR(50),
    cst_lastname         NVARCHAR(50),
    cst_marital_status   NVARCHAR(50),
    cst_gndr             NVARCHAR(50),
    cst_create_date      DATE
);

-- Purpose: Remove the existing CRM product table to allow a full refresh of product reference data
-- Example result: Command(s) completed successfully.
DROP TABLE IF EXISTS bronze.crm_prd_info;
GO

-- Purpose: Create the CRM product table to store raw product attributes from the CRM system
-- Example result: Command(s) completed successfully.
CREATE TABLE bronze.crm_prd_info (
    prd_id        INT,
    prd_key       NVARCHAR(50),
    prd_nm        NVARCHAR(100),
    prd_cost      INT,
    prd_line      NVARCHAR(50),
    prd_start_dt  DATE,
    prd_end_dt    DATE
);

-- Purpose: Remove the existing CRM sales details table to prepare for a full transactional reload
-- Example result: Command(s) completed successfully.
DROP TABLE IF EXISTS bronze.crm_sales_details;
GO

-- Purpose: Create the CRM sales details table to store raw sales transaction records
-- Example result: Command(s) completed successfully.
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num   NVARCHAR(50),
    sls_prd_key   NVARCHAR(50),
    sls_cust_id   INT,
    sls_order_dt  INT,
    sls_ship_dt   INT,
    sls_due_dt    INT,
    sls_sales     INT,
    sls_quantity  INT,
    sls_price     INT
);

-- Purpose: Remove the existing ERP customer table to ensure consistency with the latest ERP extract
-- Example result: Command(s) completed successfully.
DROP TABLE IF EXISTS bronze.erp_cust_az12;
GO

-- Purpose: Create the ERP customer table to store raw demographic attributes from ERP sources
-- Example result: Command(s) completed successfully.
CREATE TABLE bronze.erp_cust_az12 (
    CID    NVARCHAR(50),
    BDATE  DATE,
    GEN    NVARCHAR(50)
);

-- Purpose: Remove the existing ERP location table to prevent conflicts with refreshed location data
-- Example result: Command(s) completed successfully.
DROP TABLE IF EXISTS bronze.erp_loc_a101;
GO

-- Purpose: Create the ERP location table to store raw customer country information
-- Example result: Command(s) completed successfully.
CREATE TABLE bronze.erp_loc_a101 (
    CID    NVARCHAR(50),
    CNTRY  NVARCHAR(50)
);

-- Purpose: Remove the existing product category table to allow alignment with source taxonomy updates
-- Example result: Command(s) completed successfully.
DROP TABLE IF EXISTS bronze.px_cat_g1v2;
GO

-- Purpose: Create the product category table to store raw product classification data
-- Example result: Command(s) completed successfully.
CREATE TABLE bronze.erp_px_cat_g1v2 (
    ID           NVARCHAR(50),
    CAT          NVARCHAR(50),
    SUBCAT       NVARCHAR(50),
    MAINTENANCE  NVARCHAR(50)
);
