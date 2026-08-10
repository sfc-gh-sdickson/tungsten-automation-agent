/*=============================================================================
  Tungsten Automation Intelligence Agent
  03_generate_synthetic_data.sql
  
  Generates: 12 months of synthetic operational data
  - 100 customers across 5 industries, 3 segments
  - ~500K document processing jobs
  - ~2M extraction results
  - ~500K classification events
  - ~150K workflow instances
  - ~800K e-invoice transactions
  - ~36,500 daily usage records
  - ~5K support tickets
  - ~52K platform health records
  
  Runtime: ~5-10 minutes on X-SMALL warehouse
=============================================================================*/

USE DATABASE TA_INTELLIGENCE;
USE WAREHOUSE TUNGSTEN_AUTOMATION_WH;
USE SCHEMA RAW;

-- =============================================================================
-- PRODUCT_DIM (6 products)
-- =============================================================================
INSERT INTO PRODUCT_DIM (PRODUCT_ID, PRODUCT_NAME, PRODUCT_FAMILY, DEPLOYMENT_MODEL, COMMENT)
VALUES
    ('PROD_TA',   'TotalAgility',      'Workflow Automation',        'cloud',  'Low-code intelligent automation platform'),
    ('PROD_IA',   'InvoiceAgility',    'Invoice Automation',         'cloud',  'Integrated invoice capture and e-invoicing'),
    ('PROD_AP',   'AP Agility',        'Invoice Automation',         'hybrid', 'Accounts payable automation solution'),
    ('PROD_OP',   'OmniPage',          'Document Automation',        'on-prem','Market-leading OCR and document processing SDK'),
    ('PROD_CS',   'ControlSuite',      'Document Automation',        'hybrid', 'Serverless print and capture platform'),
    ('PROD_PX',   'Printix',           'Document Automation',        'cloud',  'Cloud-native print management');

-- =============================================================================
-- CUSTOMER_DIM (100 customers)
-- =============================================================================
INSERT INTO CUSTOMER_DIM (CUSTOMER_ID, CUSTOMER_NAME, INDUSTRY, COUNTRY, SEGMENT, ACCOUNT_MANAGER, CREATED_DATE)
SELECT
    'CUST_' || LPAD(SEQ4()::VARCHAR, 4, '0') AS CUSTOMER_ID,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'Global Finance Corp'
        WHEN 1 THEN 'Pacific Insurance Group'
        WHEN 2 THEN 'Northern Healthcare Systems'
        WHEN 3 THEN 'Federal Services Agency'
        WHEN 4 THEN 'Atlas Manufacturing Co'
        WHEN 5 THEN 'Meridian Bank Holdings'
        WHEN 6 THEN 'Sentinel Insurance Ltd'
        WHEN 7 THEN 'MedTech Solutions Inc'
        WHEN 8 THEN 'State Revenue Authority'
        WHEN 9 THEN 'Precision Logistics GmbH'
        WHEN 10 THEN 'Continental Credit Union'
        WHEN 11 THEN 'Shield Underwriters'
        WHEN 12 THEN 'HealthFirst Network'
        WHEN 13 THEN 'Municipal Digitization Office'
        WHEN 14 THEN 'Summit Supply Chain'
        WHEN 15 THEN 'Apex Financial Services'
        WHEN 16 THEN 'Guardian Life Insurance'
        WHEN 17 THEN 'Regional Medical Center'
        WHEN 18 THEN 'National Tax Authority'
        WHEN 19 THEN 'TransGlobal Shipping'
    END || ' ' || LPAD(SEQ4()::VARCHAR, 2, '0') AS CUSTOMER_NAME,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Banking & Financial Services'
        WHEN 1 THEN 'Insurance'
        WHEN 2 THEN 'Healthcare'
        WHEN 3 THEN 'Government & Public Sector'
        WHEN 4 THEN 'Supply Chain & Manufacturing'
    END AS INDUSTRY,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'United States'
        WHEN 1 THEN 'United Kingdom'
        WHEN 2 THEN 'Germany'
        WHEN 3 THEN 'France'
        WHEN 4 THEN 'Australia'
        WHEN 5 THEN 'Canada'
        WHEN 6 THEN 'Netherlands'
        WHEN 7 THEN 'Japan'
        WHEN 8 THEN 'Singapore'
        WHEN 9 THEN 'Brazil'
    END AS COUNTRY,
    CASE 
        WHEN MOD(SEQ4(), 10) < 3 THEN 'enterprise'
        WHEN MOD(SEQ4(), 10) < 7 THEN 'mid-market'
        ELSE 'SMB'
    END AS SEGMENT,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Sarah Mitchell'
        WHEN 1 THEN 'James Rodriguez'
        WHEN 2 THEN 'Anna Kowalski'
        WHEN 3 THEN 'David Chen'
        WHEN 4 THEN 'Maria Santos'
    END AS ACCOUNT_MANAGER,
    DATEADD('day', -UNIFORM(365, 1825, RANDOM()), CURRENT_DATE()) AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 100));

-- =============================================================================
-- CUSTOMER_SUBSCRIPTIONS (one per customer, primary product)
-- =============================================================================
INSERT INTO CUSTOMER_SUBSCRIPTIONS (SUBSCRIPTION_ID, CUSTOMER_ID, PRODUCT_ID, TIER, START_DATE, RENEWAL_DATE, ARR_USD, DOCUMENT_VOLUME_LIMIT, STATUS)
SELECT
    UUID_STRING() AS SUBSCRIPTION_ID,
    C.CUSTOMER_ID,
    CASE MOD(ROW_NUMBER() OVER (ORDER BY C.CUSTOMER_ID), 6)
        WHEN 0 THEN 'PROD_TA'
        WHEN 1 THEN 'PROD_IA'
        WHEN 2 THEN 'PROD_AP'
        WHEN 3 THEN 'PROD_OP'
        WHEN 4 THEN 'PROD_CS'
        WHEN 5 THEN 'PROD_PX'
    END AS PRODUCT_ID,
    CASE C.SEGMENT
        WHEN 'enterprise' THEN 'Enterprise'
        WHEN 'mid-market' THEN 'Professional'
        ELSE 'Standard'
    END AS TIER,
    DATEADD('month', -UNIFORM(1, 24, RANDOM()), CURRENT_DATE()) AS START_DATE,
    DATEADD('month', UNIFORM(1, 12, RANDOM()), CURRENT_DATE()) AS RENEWAL_DATE,
    CASE C.SEGMENT
        WHEN 'enterprise' THEN UNIFORM(500000, 5000000, RANDOM())
        WHEN 'mid-market' THEN UNIFORM(100000, 500000, RANDOM())
        ELSE UNIFORM(50000, 150000, RANDOM())
    END AS ARR_USD,
    CASE C.SEGMENT
        WHEN 'enterprise' THEN UNIFORM(500000, 5000000, RANDOM())
        WHEN 'mid-market' THEN UNIFORM(100000, 500000, RANDOM())
        ELSE UNIFORM(10000, 100000, RANDOM())
    END AS DOCUMENT_VOLUME_LIMIT,
    'ACTIVE' AS STATUS
FROM CUSTOMER_DIM C;

-- =============================================================================
-- DOCUMENT_PROCESSING_JOBS (~500K rows, 12 months)
-- =============================================================================
CREATE OR REPLACE TEMPORARY TABLE TMP_DATE_SPINE AS
SELECT DATEADD('hour', SEQ4(), DATEADD('month', -12, CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ AS TS
FROM TABLE(GENERATOR(ROWCOUNT => 8760));

INSERT INTO DOCUMENT_PROCESSING_JOBS (JOB_ID, DOCUMENT_TYPE, PRODUCT_ID, CUSTOMER_ID, RECEIVED_TS, COMPLETED_TS, PAGE_COUNT, STATUS, REGION)
SELECT
    UUID_STRING() AS JOB_ID,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Invoice'
        WHEN 2 THEN 'Purchase Order'
        WHEN 3 THEN 'Claim Form'
        WHEN 4 THEN 'Application'
        WHEN 5 THEN 'Contract'
        WHEN 6 THEN 'Receipt'
        WHEN 7 THEN 'Tax Document'
        WHEN 8 THEN 'Shipping Document'
        WHEN 9 THEN 'Medical Record'
        WHEN 10 THEN 'Government Form'
    END AS DOCUMENT_TYPE,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'PROD_TA'
        WHEN 2 THEN 'PROD_IA'
        WHEN 3 THEN 'PROD_AP'
        WHEN 4 THEN 'PROD_OP'
        WHEN 5 THEN 'PROD_CS'
        WHEN 6 THEN 'PROD_PX'
    END AS PRODUCT_ID,
    'CUST_' || LPAD(UNIFORM(0, 99, RANDOM())::VARCHAR, 4, '0') AS CUSTOMER_ID,
    DATEADD('second', UNIFORM(0, 3599, RANDOM()), D.TS) AS RECEIVED_TS,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 95
        THEN DATEADD('second', UNIFORM(5, 300, RANDOM()), DATEADD('second', UNIFORM(0, 3599, RANDOM()), D.TS))
        ELSE NULL
    END AS COMPLETED_TS,
    UNIFORM(1, 25, RANDOM()) AS PAGE_COUNT,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'COMPLETED'
        WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'PROCESSING'
        WHEN UNIFORM(1, 100, RANDOM()) <= 98 THEN 'FAILED'
        ELSE 'QUEUED'
    END AS STATUS,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'us-east'
        WHEN 2 THEN 'us-west'
        WHEN 3 THEN 'eu-west'
        WHEN 4 THEN 'eu-central'
        WHEN 5 THEN 'ap-southeast'
    END AS REGION
FROM TMP_DATE_SPINE D,
     TABLE(GENERATOR(ROWCOUNT => 57)) G
WHERE UNIFORM(1, 100, RANDOM()) <= 100;

-- =============================================================================
-- EXTRACTION_RESULTS (~4 fields per job, for completed jobs)
-- =============================================================================
INSERT INTO EXTRACTION_RESULTS (EXTRACTION_ID, JOB_ID, FIELD_NAME, EXTRACTED_VALUE, CONFIDENCE_SCORE, VALIDATION_STATUS, MANUAL_CORRECTION)
SELECT
    UUID_STRING() AS EXTRACTION_ID,
    J.JOB_ID,
    F.FIELD_NAME,
    'extracted_value_' || UNIFORM(1000, 9999, RANDOM())::VARCHAR AS EXTRACTED_VALUE,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN UNIFORM(92, 99, RANDOM()) / 100.0
        WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN UNIFORM(80, 92, RANDOM()) / 100.0
        ELSE UNIFORM(50, 80, RANDOM()) / 100.0
    END AS CONFIDENCE_SCORE,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'VALIDATED'
        WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'NEEDS_REVIEW'
        ELSE 'REJECTED'
    END AS VALIDATION_STATUS,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 8 THEN TRUE ELSE FALSE END AS MANUAL_CORRECTION
FROM DOCUMENT_PROCESSING_JOBS J,
     (SELECT 'invoice_number' AS FIELD_NAME UNION ALL
      SELECT 'date' UNION ALL
      SELECT 'amount' UNION ALL
      SELECT 'vendor_name') F
WHERE J.STATUS = 'COMPLETED'
  AND UNIFORM(1, 100, RANDOM()) <= 25;

-- =============================================================================
-- CLASSIFICATION_EVENTS (one per job)
-- =============================================================================
INSERT INTO CLASSIFICATION_EVENTS (EVENT_ID, JOB_ID, PREDICTED_CLASS, CONFIDENCE_SCORE, ACTUAL_CLASS, MODEL_VERSION, CLASSIFIED_TS)
SELECT
    UUID_STRING() AS EVENT_ID,
    J.JOB_ID,
    J.DOCUMENT_TYPE AS PREDICTED_CLASS,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 88 THEN UNIFORM(90, 99, RANDOM()) / 100.0
        ELSE UNIFORM(60, 90, RANDOM()) / 100.0
    END AS CONFIDENCE_SCORE,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 92 THEN J.DOCUMENT_TYPE
        ELSE CASE UNIFORM(1, 3, RANDOM())
            WHEN 1 THEN 'Invoice'
            WHEN 2 THEN 'Receipt'
            WHEN 3 THEN 'Contract'
        END
    END AS ACTUAL_CLASS,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'v3.2.1'
        WHEN 2 THEN 'v3.3.0'
        WHEN 3 THEN 'v3.4.0'
        WHEN 4 THEN 'v4.0.0-beta'
    END AS MODEL_VERSION,
    J.RECEIVED_TS AS CLASSIFIED_TS
FROM DOCUMENT_PROCESSING_JOBS J
WHERE UNIFORM(1, 100, RANDOM()) <= 25;

-- =============================================================================
-- WORKFLOW_INSTANCES (~150K rows)
-- =============================================================================
INSERT INTO WORKFLOW_INSTANCES (INSTANCE_ID, WORKFLOW_NAME, PRODUCT_ID, CUSTOMER_ID, START_TS, END_TS, STATUS, STEPS_COMPLETED, STEPS_TOTAL, APQC_PROCESS_ID)
SELECT
    UUID_STRING() AS INSTANCE_ID,
    WF.WORKFLOW_NAME,
    CASE WHEN UNIFORM(1, 10, RANDOM()) <= 7 THEN 'PROD_TA' ELSE 'PROD_IA' END AS PRODUCT_ID,
    'CUST_' || LPAD(UNIFORM(0, 99, RANDOM())::VARCHAR, 4, '0') AS CUSTOMER_ID,
    DATEADD('second', UNIFORM(0, 86399, RANDOM()), 
            DATEADD('day', -UNIFORM(0, 364, RANDOM()), CURRENT_DATE()))::TIMESTAMP_NTZ AS START_TS,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 88
        THEN DATEADD('second', UNIFORM(60, 7200, RANDOM()),
                     DATEADD('second', UNIFORM(0, 86399, RANDOM()), 
                             DATEADD('day', -UNIFORM(0, 364, RANDOM()), CURRENT_DATE())))::TIMESTAMP_NTZ
        ELSE NULL
    END AS END_TS,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 82 THEN 'COMPLETED'
        WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'IN_PROGRESS'
        WHEN UNIFORM(1, 100, RANDOM()) <= 96 THEN 'FAILED'
        ELSE 'CANCELLED'
    END AS STATUS,
    UNIFORM(1, WF.STEPS, RANDOM()) AS STEPS_COMPLETED,
    WF.STEPS AS STEPS_TOTAL,
    WF.APQC_ID AS APQC_PROCESS_ID
FROM (
    SELECT 'Invoice Approval' AS WORKFLOW_NAME, 5 AS STEPS, 'APQC_9.3.2' AS APQC_ID UNION ALL
    SELECT 'Customer Onboarding', 8, 'APQC_3.5.1' UNION ALL
    SELECT 'KYC Verification', 6, 'APQC_3.5.2' UNION ALL
    SELECT 'Claims Processing', 7, 'APQC_11.1.3' UNION ALL
    SELECT 'Document Classification', 3, 'APQC_8.4.1' UNION ALL
    SELECT 'Purchase Order Matching', 4, 'APQC_9.3.1' UNION ALL
    SELECT 'Policy Underwriting', 9, 'APQC_11.2.1' UNION ALL
    SELECT 'Patient Registration', 5, 'APQC_3.5.3' UNION ALL
    SELECT 'Benefits Enrollment', 6, 'APQC_6.1.2' UNION ALL
    SELECT 'Supplier Onboarding', 7, 'APQC_4.2.1' UNION ALL
    SELECT 'Tax Form Processing', 4, 'APQC_9.5.1' UNION ALL
    SELECT 'Loan Origination', 10, 'APQC_9.2.1' UNION ALL
    SELECT 'Contract Review', 6, 'APQC_6.3.1' UNION ALL
    SELECT 'Expense Approval', 4, 'APQC_9.3.3' UNION ALL
    SELECT 'Compliance Audit', 8, 'APQC_11.1.1' UNION ALL
    SELECT 'Mail Room Digitization', 3, 'APQC_8.4.2' UNION ALL
    SELECT 'Shipping Document Processing', 5, 'APQC_4.3.2' UNION ALL
    SELECT 'Insurance Renewal', 6, 'APQC_11.2.2' UNION ALL
    SELECT 'Account Opening', 7, 'APQC_3.5.4' UNION ALL
    SELECT 'Payment Processing', 4, 'APQC_9.4.1'
) WF,
TABLE(GENERATOR(ROWCOUNT => 7500));

-- =============================================================================
-- INVOICE_NETWORK_TRANSACTIONS (~800K rows)
-- =============================================================================
INSERT INTO INVOICE_NETWORK_TRANSACTIONS (TRANSACTION_ID, SENDER_ID, RECEIVER_ID, INVOICE_NUMBER, AMOUNT, CURRENCY, COUNTRY_CODE, COMPLIANCE_STANDARD, STATUS, SUBMITTED_TS, DELIVERED_TS, REJECTION_REASON)
SELECT
    UUID_STRING() AS TRANSACTION_ID,
    'CUST_' || LPAD(UNIFORM(0, 99, RANDOM())::VARCHAR, 4, '0') AS SENDER_ID,
    'CUST_' || LPAD(UNIFORM(0, 99, RANDOM())::VARCHAR, 4, '0') AS RECEIVER_ID,
    'INV-' || UNIFORM(100000, 999999, RANDOM())::VARCHAR AS INVOICE_NUMBER,
    UNIFORM(100, 500000, RANDOM()) + UNIFORM(0, 99, RANDOM()) / 100.0 AS AMOUNT,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'USD'
        WHEN 2 THEN 'EUR'
        WHEN 3 THEN 'GBP'
        WHEN 4 THEN 'AUD'
        WHEN 5 THEN 'JPY'
    END AS CURRENCY,
    CASE UNIFORM(1, 20, RANDOM())
        WHEN 1 THEN 'US'
        WHEN 2 THEN 'GB'
        WHEN 3 THEN 'DE'
        WHEN 4 THEN 'FR'
        WHEN 5 THEN 'IT'
        WHEN 6 THEN 'AU'
        WHEN 7 THEN 'CA'
        WHEN 8 THEN 'NL'
        WHEN 9 THEN 'JP'
        WHEN 10 THEN 'BR'
        WHEN 11 THEN 'IN'
        WHEN 12 THEN 'SA'
        WHEN 13 THEN 'SG'
        WHEN 14 THEN 'SE'
        WHEN 15 THEN 'NO'
        WHEN 16 THEN 'DK'
        WHEN 17 THEN 'ES'
        WHEN 18 THEN 'PT'
        WHEN 19 THEN 'MY'
        WHEN 20 THEN 'MX'
    END AS COUNTRY_CODE,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'Peppol BIS 3.0'
        WHEN 2 THEN 'UBL 2.1'
        WHEN 3 THEN 'CII'
        WHEN 4 THEN 'SDI FatturaPA'
        WHEN 5 THEN 'GST e-Invoice'
        WHEN 6 THEN 'ZATCA FATOORA'
    END AS COMPLIANCE_STANDARD,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 92 THEN 'DELIVERED'
        WHEN UNIFORM(1, 100, RANDOM()) <= 96 THEN 'PENDING'
        WHEN UNIFORM(1, 100, RANDOM()) <= 99 THEN 'REJECTED'
        ELSE 'FAILED'
    END AS STATUS,
    DATEADD('second', UNIFORM(0, 86399, RANDOM()),
            DATEADD('day', -UNIFORM(0, 364, RANDOM()), CURRENT_DATE()))::TIMESTAMP_NTZ AS SUBMITTED_TS,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 92
        THEN DATEADD('second', UNIFORM(30, 3600, RANDOM()),
                     DATEADD('second', UNIFORM(0, 86399, RANDOM()),
                             DATEADD('day', -UNIFORM(0, 364, RANDOM()), CURRENT_DATE())))::TIMESTAMP_NTZ
        ELSE NULL
    END AS DELIVERED_TS,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) > 92 AND UNIFORM(1, 100, RANDOM()) <= 50 THEN 'Schema validation failed'
        WHEN UNIFORM(1, 100, RANDOM()) > 92 AND UNIFORM(1, 100, RANDOM()) <= 75 THEN 'Missing mandatory field'
        WHEN UNIFORM(1, 100, RANDOM()) > 92 THEN 'Receiver not registered'
        ELSE NULL
    END AS REJECTION_REASON
FROM TABLE(GENERATOR(ROWCOUNT => 800000));

-- =============================================================================
-- CUSTOMER_USAGE_METRICS (100 customers x 365 days)
-- =============================================================================
INSERT INTO CUSTOMER_USAGE_METRICS (CUSTOMER_ID, PRODUCT_ID, USAGE_DATE, DOCUMENTS_PROCESSED, PAGES_PROCESSED, API_CALLS, ACTIVE_USERS)
SELECT
    C.CUSTOMER_ID,
    S.PRODUCT_ID,
    D.DT AS USAGE_DATE,
    GREATEST(0, 
        CASE C.SEGMENT
            WHEN 'enterprise' THEN UNIFORM(800, 3000, RANDOM())
            WHEN 'mid-market' THEN UNIFORM(200, 800, RANDOM())
            ELSE UNIFORM(20, 200, RANDOM())
        END
        + CASE WHEN DAYOFWEEK(D.DT) IN (0, 6) THEN -UNIFORM(100, 500, RANDOM()) ELSE 0 END
        + CASE WHEN MONTH(D.DT) = 12 THEN -UNIFORM(50, 200, RANDOM()) ELSE 0 END
    ) AS DOCUMENTS_PROCESSED,
    GREATEST(0,
        CASE C.SEGMENT
            WHEN 'enterprise' THEN UNIFORM(2000, 10000, RANDOM())
            WHEN 'mid-market' THEN UNIFORM(500, 3000, RANDOM())
            ELSE UNIFORM(50, 500, RANDOM())
        END
    ) AS PAGES_PROCESSED,
    CASE C.SEGMENT
        WHEN 'enterprise' THEN UNIFORM(5000, 20000, RANDOM())
        WHEN 'mid-market' THEN UNIFORM(1000, 5000, RANDOM())
        ELSE UNIFORM(100, 1000, RANDOM())
    END AS API_CALLS,
    CASE C.SEGMENT
        WHEN 'enterprise' THEN UNIFORM(20, 150, RANDOM())
        WHEN 'mid-market' THEN UNIFORM(5, 30, RANDOM())
        ELSE UNIFORM(1, 8, RANDOM())
    END AS ACTIVE_USERS
FROM CUSTOMER_DIM C
JOIN CUSTOMER_SUBSCRIPTIONS S ON C.CUSTOMER_ID = S.CUSTOMER_ID
CROSS JOIN (
    SELECT DATEADD('day', SEQ4(), DATEADD('month', -12, CURRENT_DATE())) AS DT
    FROM TABLE(GENERATOR(ROWCOUNT => 365))
) D;

-- =============================================================================
-- SUPPORT_TICKETS (~5K rows)
-- =============================================================================
INSERT INTO SUPPORT_TICKETS (TICKET_ID, CUSTOMER_ID, PRODUCT_ID, SEVERITY, CATEGORY, OPENED_TS, RESOLVED_TS, RESOLUTION_TYPE, CSAT_SCORE)
SELECT
    UUID_STRING() AS TICKET_ID,
    'CUST_' || LPAD(UNIFORM(0, 99, RANDOM())::VARCHAR, 4, '0') AS CUSTOMER_ID,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'PROD_TA'
        WHEN 2 THEN 'PROD_IA'
        WHEN 3 THEN 'PROD_AP'
        WHEN 4 THEN 'PROD_OP'
        WHEN 5 THEN 'PROD_CS'
        WHEN 6 THEN 'PROD_PX'
    END AS PRODUCT_ID,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'P1'
        WHEN 2 THEN 'P2'
        WHEN 3 THEN 'P2'
        WHEN 4 THEN 'P3'
        WHEN 5 THEN 'P3'
        WHEN 6 THEN 'P3'
        WHEN 7 THEN 'P4'
        WHEN 8 THEN 'P4'
        WHEN 9 THEN 'P4'
        WHEN 10 THEN 'P4'
    END AS SEVERITY,
    CASE UNIFORM(1, 8, RANDOM())
        WHEN 1 THEN 'Extraction Accuracy'
        WHEN 2 THEN 'Workflow Failure'
        WHEN 3 THEN 'Performance Issue'
        WHEN 4 THEN 'Integration Error'
        WHEN 5 THEN 'Configuration Help'
        WHEN 6 THEN 'Feature Request'
        WHEN 7 THEN 'Invoice Rejection'
        WHEN 8 THEN 'Login/Access Issue'
    END AS CATEGORY,
    DATEADD('second', UNIFORM(0, 86399, RANDOM()),
            DATEADD('day', -UNIFORM(0, 364, RANDOM()), CURRENT_DATE()))::TIMESTAMP_NTZ AS OPENED_TS,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85
        THEN DATEADD('hour', UNIFORM(1, 168, RANDOM()),
                     DATEADD('second', UNIFORM(0, 86399, RANDOM()),
                             DATEADD('day', -UNIFORM(0, 364, RANDOM()), CURRENT_DATE())))::TIMESTAMP_NTZ
        ELSE NULL
    END AS RESOLVED_TS,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85
        THEN CASE UNIFORM(1, 4, RANDOM())
            WHEN 1 THEN 'Resolved'
            WHEN 2 THEN 'Workaround Provided'
            WHEN 3 THEN 'Configuration Change'
            WHEN 4 THEN 'Bug Fix Deployed'
        END
        ELSE NULL
    END AS RESOLUTION_TYPE,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 75
        THEN UNIFORM(1, 5, RANDOM()) + UNIFORM(0, 9, RANDOM()) / 10.0
        ELSE NULL
    END AS CSAT_SCORE
FROM TABLE(GENERATOR(ROWCOUNT => 5000));

-- =============================================================================
-- PLATFORM_HEALTH_METRICS (~52K rows: 6 products x 5 regions x 24 hrs x ~72 days sampled)
-- =============================================================================
INSERT INTO PLATFORM_HEALTH_METRICS (PRODUCT_ID, REGION, METRIC_HOUR, AVAILABILITY_PCT, AVG_RESPONSE_MS, ERROR_RATE_PCT, QUEUE_DEPTH)
SELECT
    P.PRODUCT_ID,
    R.REGION,
    DATEADD('hour', H.HR, DATEADD('day', -D.DAY_OFFSET, CURRENT_DATE()))::TIMESTAMP_NTZ AS METRIC_HOUR,
    CASE 
        WHEN UNIFORM(1, 1000, RANDOM()) <= 5 THEN UNIFORM(95.0, 98.0, RANDOM())
        WHEN UNIFORM(1, 1000, RANDOM()) <= 50 THEN UNIFORM(99.0, 99.5, RANDOM())
        ELSE UNIFORM(99.5, 100.0, RANDOM())
    END AS AVAILABILITY_PCT,
    CASE P.PRODUCT_ID
        WHEN 'PROD_TA' THEN UNIFORM(50, 300, RANDOM())
        WHEN 'PROD_IA' THEN UNIFORM(80, 400, RANDOM())
        WHEN 'PROD_AP' THEN UNIFORM(60, 250, RANDOM())
        WHEN 'PROD_OP' THEN UNIFORM(100, 500, RANDOM())
        WHEN 'PROD_CS' THEN UNIFORM(30, 150, RANDOM())
        WHEN 'PROD_PX' THEN UNIFORM(20, 100, RANDOM())
    END + CASE WHEN H.HR BETWEEN 9 AND 17 THEN UNIFORM(20, 100, RANDOM()) ELSE 0 END AS AVG_RESPONSE_MS,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN UNIFORM(0, 50, RANDOM()) / 100.0
        WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN UNIFORM(50, 200, RANDOM()) / 100.0
        ELSE UNIFORM(200, 500, RANDOM()) / 100.0
    END AS ERROR_RATE_PCT,
    CASE P.PRODUCT_ID
        WHEN 'PROD_TA' THEN UNIFORM(10, 500, RANDOM())
        WHEN 'PROD_IA' THEN UNIFORM(50, 1000, RANDOM())
        WHEN 'PROD_AP' THEN UNIFORM(20, 300, RANDOM())
        WHEN 'PROD_OP' THEN UNIFORM(100, 2000, RANDOM())
        WHEN 'PROD_CS' THEN UNIFORM(5, 100, RANDOM())
        WHEN 'PROD_PX' THEN UNIFORM(5, 50, RANDOM())
    END + CASE WHEN H.HR BETWEEN 9 AND 17 THEN UNIFORM(50, 200, RANDOM()) ELSE 0 END AS QUEUE_DEPTH
FROM (SELECT 'PROD_TA' AS PRODUCT_ID UNION ALL SELECT 'PROD_IA' UNION ALL SELECT 'PROD_AP' UNION ALL SELECT 'PROD_OP' UNION ALL SELECT 'PROD_CS' UNION ALL SELECT 'PROD_PX') P
CROSS JOIN (SELECT 'us-east' AS REGION UNION ALL SELECT 'us-west' UNION ALL SELECT 'eu-west' UNION ALL SELECT 'eu-central' UNION ALL SELECT 'ap-southeast') R
CROSS JOIN (SELECT SEQ4() AS HR FROM TABLE(GENERATOR(ROWCOUNT => 24))) H
CROSS JOIN (SELECT SEQ4() * 5 AS DAY_OFFSET FROM TABLE(GENERATOR(ROWCOUNT => 73))) D;

-- =============================================================================
-- Verify row counts
-- =============================================================================
SELECT 'PRODUCT_DIM' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM PRODUCT_DIM
UNION ALL SELECT 'CUSTOMER_DIM', COUNT(*) FROM CUSTOMER_DIM
UNION ALL SELECT 'CUSTOMER_SUBSCRIPTIONS', COUNT(*) FROM CUSTOMER_SUBSCRIPTIONS
UNION ALL SELECT 'DOCUMENT_PROCESSING_JOBS', COUNT(*) FROM DOCUMENT_PROCESSING_JOBS
UNION ALL SELECT 'EXTRACTION_RESULTS', COUNT(*) FROM EXTRACTION_RESULTS
UNION ALL SELECT 'CLASSIFICATION_EVENTS', COUNT(*) FROM CLASSIFICATION_EVENTS
UNION ALL SELECT 'WORKFLOW_INSTANCES', COUNT(*) FROM WORKFLOW_INSTANCES
UNION ALL SELECT 'INVOICE_NETWORK_TRANSACTIONS', COUNT(*) FROM INVOICE_NETWORK_TRANSACTIONS
UNION ALL SELECT 'CUSTOMER_USAGE_METRICS', COUNT(*) FROM CUSTOMER_USAGE_METRICS
UNION ALL SELECT 'SUPPORT_TICKETS', COUNT(*) FROM SUPPORT_TICKETS
UNION ALL SELECT 'PLATFORM_HEALTH_METRICS', COUNT(*) FROM PLATFORM_HEALTH_METRICS
ORDER BY TABLE_NAME;
