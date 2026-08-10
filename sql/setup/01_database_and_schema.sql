/*=============================================================================
  Tungsten Automation Intelligence Agent
  01_database_and_schema.sql
  
  Creates: TA_INTELLIGENCE database, RAW/ANALYTICS/REFERENCE schemas, warehouse
=============================================================================*/

-- Create database
CREATE DATABASE IF NOT EXISTS TA_INTELLIGENCE
    COMMENT = 'Tungsten Automation Platform Operations Intelligence';

USE DATABASE TA_INTELLIGENCE;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS RAW
    COMMENT = 'Raw operational data from platform telemetry, CRM, and billing systems';

CREATE SCHEMA IF NOT EXISTS ANALYTICS
    COMMENT = 'Analytical views, semantic views, search services, and agent objects';

CREATE SCHEMA IF NOT EXISTS REFERENCE
    COMMENT = 'Industry standards, ontologies, and compliance reference data (APQC, Dublin Core, UBL, ITIL, GDPR)';

-- Create warehouse
CREATE OR REPLACE WAREHOUSE TUNGSTEN_AUTOMATION_WH WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Tungsten Automation Intelligence Agent';

USE WAREHOUSE TUNGSTEN_AUTOMATION_WH;
USE SCHEMA RAW;
