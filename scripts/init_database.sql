/*====================================================================================================
  SCRIPT PURPOSE
  ----------------------------------------------------------------------------------------------------
  This script performs a full initialization of the DataWareHouse database environment. It ensures
  a clean deployment by removing any existing DataWareHouse database, recreating it, and establishing
  the core schemas (bronze, silver, gold) used in a layered data warehousing architecture.

  EXECUTION WARNINGS
  ----------------------------------------------------------------------------------------------------
  - This script must be executed sequentially and in full.
  - Running statements out of order may cause:
      * Database context errors
      * Schema creation failures
      * Objects being created in the wrong database
  - Skipping the USE Master statement may prevent the database from being dropped.
  - Omitting GO batch separators can cause CREATE DATABASE or CREATE SCHEMA statements to fail.
  - Executing this script will permanently delete the existing DataWareHouse database and all data.
====================================================================================================*/

-- Purpose: Ensure the session is connected to the system database to allow safe drop/recreate
-- Example result: Changed database context to 'master'.
USE Master

-- Purpose: Check for an existing DataWareHouse database and remove it to guarantee a clean rebuild
-- Example result: Command(s) completed successfully.
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWareHouse')
BEGIN
    ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWareHouse;
END;

-- Purpose: Create a fresh DataWareHouse database after cleanup
-- Example result: Command(s) completed successfully.
GO
CREATE DATABASE DataWareHouse;

-- Purpose: Switch execution context to the newly created DataWareHouse database
-- Example result: Changed database context to 'DataWareHouse'.
GO
USE DataWareHouse;

-- Purpose: Create the bronze schema to store raw, ingested source data
-- Example result: Command(s) completed successfully.
GO
CREATE SCHEMA bronze;

-- Purpose: Create the silver schema to store cleansed and transformed data
-- Example result: Command(s) completed successfully.
GO
CREATE SCHEMA silver;

-- Purpose: Create the gold schema to store curated, analytics-ready data
-- Example result: Command(s) completed successfully.
GO
CREATE SCHEMA gold;
