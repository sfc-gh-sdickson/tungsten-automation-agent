/*=============================================================================
  Tungsten Automation Intelligence Agent
  02_create_tables.sql
  
  Creates: 11 tables in RAW schema, 8 tables in REFERENCE schema
=============================================================================*/

USE DATABASE TA_INTELLIGENCE;
USE SCHEMA RAW;

-- =============================================================================
-- DIMENSION TABLES (RAW schema)
-- =============================================================================

CREATE OR REPLACE TABLE PRODUCT_DIM (
    PRODUCT_ID          VARCHAR(20)     NOT NULL,
    PRODUCT_NAME        VARCHAR(100)    NOT NULL,
    PRODUCT_FAMILY      VARCHAR(50)     NOT NULL,
    DEPLOYMENT_MODEL    VARCHAR(20)     NOT NULL,
    COMMENT             VARCHAR(500),
    PRIMARY KEY (PRODUCT_ID)
)
COMMENT = 'Product dimension: Tungsten Automation product portfolio';

CREATE OR REPLACE TABLE CUSTOMER_DIM (
    CUSTOMER_ID         VARCHAR(20)     NOT NULL,
    CUSTOMER_NAME       VARCHAR(200)    NOT NULL,
    INDUSTRY            VARCHAR(50)     NOT NULL,
    COUNTRY             VARCHAR(50)     NOT NULL,
    SEGMENT             VARCHAR(20)     NOT NULL,
    ACCOUNT_MANAGER     VARCHAR(100),
    CREATED_DATE        DATE            NOT NULL,
    PRIMARY KEY (CUSTOMER_ID)
)
COMMENT = 'Customer dimension: enterprise customers across industries and segments';

-- =============================================================================
-- FACT TABLES (RAW schema)
-- =============================================================================

CREATE OR REPLACE TABLE DOCUMENT_PROCESSING_JOBS (
    JOB_ID              VARCHAR(36)     NOT NULL,
    DOCUMENT_TYPE       VARCHAR(50)     NOT NULL,
    PRODUCT_ID          VARCHAR(20)     NOT NULL,
    CUSTOMER_ID         VARCHAR(20)     NOT NULL,
    RECEIVED_TS         TIMESTAMP_NTZ   NOT NULL,
    COMPLETED_TS        TIMESTAMP_NTZ,
    PAGE_COUNT          INTEGER         NOT NULL,
    STATUS              VARCHAR(20)     NOT NULL,
    REGION              VARCHAR(20)     NOT NULL,
    PRIMARY KEY (JOB_ID)
)
COMMENT = 'Document processing jobs across all IDP products (TotalAgility, OmniPage, AP Agility)';

CREATE OR REPLACE TABLE EXTRACTION_RESULTS (
    EXTRACTION_ID       VARCHAR(36)     NOT NULL,
    JOB_ID              VARCHAR(36)     NOT NULL,
    FIELD_NAME          VARCHAR(100)    NOT NULL,
    EXTRACTED_VALUE     VARCHAR(500),
    CONFIDENCE_SCORE    FLOAT           NOT NULL,
    VALIDATION_STATUS   VARCHAR(20)     NOT NULL,
    MANUAL_CORRECTION   BOOLEAN         NOT NULL DEFAULT FALSE,
    PRIMARY KEY (EXTRACTION_ID)
)
COMMENT = 'Field-level extraction results with confidence scores and correction flags';

CREATE OR REPLACE TABLE CLASSIFICATION_EVENTS (
    EVENT_ID            VARCHAR(36)     NOT NULL,
    JOB_ID              VARCHAR(36)     NOT NULL,
    PREDICTED_CLASS     VARCHAR(50)     NOT NULL,
    CONFIDENCE_SCORE    FLOAT           NOT NULL,
    ACTUAL_CLASS        VARCHAR(50),
    MODEL_VERSION       VARCHAR(20)     NOT NULL,
    CLASSIFIED_TS       TIMESTAMP_NTZ   NOT NULL,
    PRIMARY KEY (EVENT_ID)
)
COMMENT = 'Document classification decisions with predicted vs actual class for accuracy tracking';

CREATE OR REPLACE TABLE WORKFLOW_INSTANCES (
    INSTANCE_ID         VARCHAR(36)     NOT NULL,
    WORKFLOW_NAME       VARCHAR(100)    NOT NULL,
    PRODUCT_ID          VARCHAR(20)     NOT NULL,
    CUSTOMER_ID         VARCHAR(20)     NOT NULL,
    START_TS            TIMESTAMP_NTZ   NOT NULL,
    END_TS              TIMESTAMP_NTZ,
    STATUS              VARCHAR(20)     NOT NULL,
    STEPS_COMPLETED     INTEGER         NOT NULL,
    STEPS_TOTAL         INTEGER         NOT NULL,
    APQC_PROCESS_ID     VARCHAR(20),
    PRIMARY KEY (INSTANCE_ID)
)
COMMENT = 'Workflow execution instances across TotalAgility and RPA processes';

CREATE OR REPLACE TABLE INVOICE_NETWORK_TRANSACTIONS (
    TRANSACTION_ID      VARCHAR(36)     NOT NULL,
    SENDER_ID           VARCHAR(20)     NOT NULL,
    RECEIVER_ID         VARCHAR(20)     NOT NULL,
    INVOICE_NUMBER      VARCHAR(50)     NOT NULL,
    AMOUNT              FLOAT           NOT NULL,
    CURRENCY            VARCHAR(3)      NOT NULL,
    COUNTRY_CODE        VARCHAR(3)      NOT NULL,
    COMPLIANCE_STANDARD VARCHAR(50)     NOT NULL,
    STATUS              VARCHAR(20)     NOT NULL,
    SUBMITTED_TS        TIMESTAMP_NTZ   NOT NULL,
    DELIVERED_TS        TIMESTAMP_NTZ,
    REJECTION_REASON    VARCHAR(200),
    PRIMARY KEY (TRANSACTION_ID)
)
COMMENT = 'e-Invoice Network transactions: electronic invoices exchanged between businesses globally';

CREATE OR REPLACE TABLE CUSTOMER_SUBSCRIPTIONS (
    SUBSCRIPTION_ID     VARCHAR(36)     NOT NULL,
    CUSTOMER_ID         VARCHAR(20)     NOT NULL,
    PRODUCT_ID          VARCHAR(20)     NOT NULL,
    TIER                VARCHAR(20)     NOT NULL,
    START_DATE          DATE            NOT NULL,
    RENEWAL_DATE        DATE            NOT NULL,
    ARR_USD             FLOAT           NOT NULL,
    DOCUMENT_VOLUME_LIMIT INTEGER      NOT NULL,
    STATUS              VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    PRIMARY KEY (SUBSCRIPTION_ID)
)
COMMENT = 'Customer subscription records with ARR and volume limits per product';

CREATE OR REPLACE TABLE CUSTOMER_USAGE_METRICS (
    CUSTOMER_ID         VARCHAR(20)     NOT NULL,
    PRODUCT_ID          VARCHAR(20)     NOT NULL,
    USAGE_DATE          DATE            NOT NULL,
    DOCUMENTS_PROCESSED INTEGER         NOT NULL,
    PAGES_PROCESSED     INTEGER         NOT NULL,
    API_CALLS           INTEGER         NOT NULL,
    ACTIVE_USERS        INTEGER         NOT NULL,
    PRIMARY KEY (CUSTOMER_ID, PRODUCT_ID, USAGE_DATE)
)
COMMENT = 'Daily customer usage metrics by product';

CREATE OR REPLACE TABLE SUPPORT_TICKETS (
    TICKET_ID           VARCHAR(36)     NOT NULL,
    CUSTOMER_ID         VARCHAR(20)     NOT NULL,
    PRODUCT_ID          VARCHAR(20)     NOT NULL,
    SEVERITY            VARCHAR(10)     NOT NULL,
    CATEGORY            VARCHAR(50)     NOT NULL,
    OPENED_TS           TIMESTAMP_NTZ   NOT NULL,
    RESOLVED_TS         TIMESTAMP_NTZ,
    RESOLUTION_TYPE     VARCHAR(30),
    CSAT_SCORE          FLOAT,
    PRIMARY KEY (TICKET_ID)
)
COMMENT = 'Customer support tickets with severity, resolution, and satisfaction scores';

CREATE OR REPLACE TABLE PLATFORM_HEALTH_METRICS (
    PRODUCT_ID          VARCHAR(20)     NOT NULL,
    REGION              VARCHAR(20)     NOT NULL,
    METRIC_HOUR         TIMESTAMP_NTZ   NOT NULL,
    AVAILABILITY_PCT    FLOAT           NOT NULL,
    AVG_RESPONSE_MS     FLOAT           NOT NULL,
    ERROR_RATE_PCT      FLOAT           NOT NULL,
    QUEUE_DEPTH         INTEGER         NOT NULL,
    PRIMARY KEY (PRODUCT_ID, REGION, METRIC_HOUR)
)
COMMENT = 'Hourly platform health metrics by product and region';

-- =============================================================================
-- REFERENCE / ONTOLOGY TABLES (REFERENCE schema)
-- =============================================================================

USE SCHEMA REFERENCE;

CREATE OR REPLACE TABLE APQC_PROCESS_TAXONOMY (
    PROCESS_ID          VARCHAR(20)     NOT NULL,
    PROCESS_NAME        VARCHAR(200)    NOT NULL,
    LEVEL               INTEGER         NOT NULL,
    PARENT_ID           VARCHAR(20),
    CATEGORY_CODE       VARCHAR(10)     NOT NULL,
    DESCRIPTION         VARCHAR(1000),
    PRIMARY KEY (PROCESS_ID)
)
COMMENT = 'APQC Process Classification Framework v7.4 - business process taxonomy';

CREATE OR REPLACE TABLE DUBLIN_CORE_DOCUMENT_TYPES (
    DC_TYPE_ID          VARCHAR(20)     NOT NULL,
    DC_TYPE_LABEL       VARCHAR(100)    NOT NULL,
    DC_FORMAT           VARCHAR(50),
    DC_SUBJECT_CATEGORY VARCHAR(100),
    PARENT_TYPE         VARCHAR(20),
    INDUSTRY_APPLICABILITY VARCHAR(200),
    PRIMARY KEY (DC_TYPE_ID)
)
COMMENT = 'Dublin Core document type classification (ISO 15836) for IDP document taxonomy';

CREATE OR REPLACE TABLE UBL_INVOICE_ELEMENTS (
    ELEMENT_ID          VARCHAR(20)     NOT NULL,
    ELEMENT_NAME        VARCHAR(100)    NOT NULL,
    UBL_PATH            VARCHAR(300)    NOT NULL,
    DATA_TYPE           VARCHAR(50)     NOT NULL,
    CARDINALITY         VARCHAR(10)     NOT NULL,
    DESCRIPTION         VARCHAR(500),
    PEPPOL_SUBSET_FLAG  BOOLEAN         NOT NULL DEFAULT FALSE,
    PRIMARY KEY (ELEMENT_ID)
)
COMMENT = 'OASIS UBL 2.1 invoice data elements with Peppol BIS 3.0 subset flags';

CREATE OR REPLACE TABLE EINVOICE_MANDATE_REGISTRY (
    MANDATE_ID          VARCHAR(20)     NOT NULL,
    COUNTRY_CODE        VARCHAR(3)      NOT NULL,
    STANDARD_NAME       VARCHAR(100)    NOT NULL,
    FORMAT              VARCHAR(30)     NOT NULL,
    EFFECTIVE_DATE      DATE            NOT NULL,
    MANDATORY_FLAG      BOOLEAN         NOT NULL,
    CLEARANCE_MODEL     VARCHAR(30)     NOT NULL,
    DESCRIPTION         VARCHAR(500),
    PRIMARY KEY (MANDATE_ID)
)
COMMENT = 'Global e-invoicing mandate registry (EU ViDA, Italy SDI, India GST, Brazil NFe, Saudi ZATCA)';

CREATE OR REPLACE TABLE ITIL_SERVICE_METRICS (
    METRIC_ID           VARCHAR(20)     NOT NULL,
    METRIC_NAME         VARCHAR(100)    NOT NULL,
    ITIL_PRACTICE       VARCHAR(100)    NOT NULL,
    MEASUREMENT_FORMULA VARCHAR(300),
    TARGET_THRESHOLD    FLOAT,
    UNIT                VARCHAR(30)     NOT NULL,
    DESCRIPTION         VARCHAR(500),
    PRIMARY KEY (METRIC_ID)
)
COMMENT = 'ITIL 4 Service Value System KPI definitions for platform operations';

CREATE OR REPLACE TABLE INDUSTRY_CLASSIFICATION (
    INDUSTRY_ID         VARCHAR(20)     NOT NULL,
    INDUSTRY_NAME       VARCHAR(100)    NOT NULL,
    NAICS_CODE          VARCHAR(10),
    APQC_PROCESS_FOCUS  VARCHAR(200),
    TYPICAL_DOCUMENT_TYPES VARCHAR(300),
    REGULATORY_BODY     VARCHAR(200),
    PRIMARY KEY (INDUSTRY_ID)
)
COMMENT = 'NAICS industry classification with APQC process mapping and document type profiles';

CREATE OR REPLACE TABLE GDPR_DATA_CATEGORIES (
    CATEGORY_ID         VARCHAR(20)     NOT NULL,
    CATEGORY_NAME       VARCHAR(100)    NOT NULL,
    SENSITIVITY_LEVEL   VARCHAR(20)     NOT NULL,
    RETENTION_DAYS      INTEGER,
    APPLICABLE_REGULATIONS VARCHAR(200) NOT NULL,
    EXTRACTION_FLAG     BOOLEAN         NOT NULL DEFAULT FALSE,
    DESCRIPTION         VARCHAR(500),
    PRIMARY KEY (CATEGORY_ID)
)
COMMENT = 'GDPR/CCPA/HIPAA data categories for PII/PHI classification in document extraction';

CREATE OR REPLACE TABLE OCR_MODEL_REGISTRY (
    MODEL_ID            VARCHAR(20)     NOT NULL,
    MODEL_NAME          VARCHAR(100)    NOT NULL,
    VERSION             VARCHAR(20)     NOT NULL,
    TRAINED_DATE        DATE            NOT NULL,
    ACCURACY_SCORE      FLOAT           NOT NULL,
    DOCUMENT_TYPES_SUPPORTED VARCHAR(300),
    DESCRIPTION         VARCHAR(500),
    PRIMARY KEY (MODEL_ID)
)
COMMENT = 'Internal OCR/IDP model version registry for tracking model performance over time';
