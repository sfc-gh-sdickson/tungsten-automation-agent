/*=============================================================================
  Tungsten Automation Intelligence Agent
  05_create_semantic_views.sql
  
  Creates: 6 domain-specific semantic views in ANALYTICS schema
  1. TA_DOCUMENT_PROCESSING_SV
  2. TA_WORKFLOW_AUTOMATION_SV
  3. TA_INVOICE_NETWORK_SV
  4. TA_CUSTOMER_HEALTH_SV
  5. TA_PLATFORM_OPERATIONS_SV
  6. TA_REVENUE_BUSINESS_SV
=============================================================================*/

USE DATABASE TA_INTELLIGENCE;
USE WAREHOUSE TUNGSTEN_AUTOMATION_WH;
USE SCHEMA ANALYTICS;

-- =============================================================================
-- 1. TA_DOCUMENT_PROCESSING_SV
-- IDP operations: volumes, accuracy, classification, OCR model performance
-- =============================================================================
CREATE OR REPLACE SEMANTIC VIEW TA_DOCUMENT_PROCESSING_SV

  TABLES (
    doc_jobs AS TA_INTELLIGENCE.ANALYTICS.V_DOCUMENT_PROCESSING
      PRIMARY KEY (JOB_ID)
      WITH SYNONYMS ('document processing', 'IDP jobs', 'document jobs')
      COMMENT = 'Document processing jobs across all IDP products',
    extractions AS TA_INTELLIGENCE.ANALYTICS.V_EXTRACTION_PERFORMANCE
      PRIMARY KEY (EXTRACTION_ID)
      WITH SYNONYMS ('extraction results', 'field extraction', 'data extraction')
      COMMENT = 'Field-level extraction results with accuracy metrics'
  )

  RELATIONSHIPS (
    extractions_to_jobs AS
      extractions (JOB_ID) REFERENCES doc_jobs (JOB_ID)
  )

  DIMENSIONS (
    doc_jobs.document_type AS DOCUMENT_TYPE
      WITH SYNONYMS = ('doc type', 'document class')
      COMMENT = 'Type of document processed (Invoice, Claim, Application, etc.)'
      SAMPLE_VALUES ('Invoice', 'Purchase Order', 'Claim Form', 'Application', 'Contract', 'Receipt', 'Tax Document', 'Shipping Document', 'Medical Record', 'Government Form')
      IS_ENUM,
    doc_jobs.product_name AS PRODUCT_NAME
      WITH SYNONYMS = ('product', 'platform')
      COMMENT = 'Tungsten Automation product used for processing'
      SAMPLE_VALUES ('TotalAgility', 'InvoiceAgility', 'AP Agility', 'OmniPage', 'ControlSuite', 'Printix')
      IS_ENUM,
    doc_jobs.product_family AS PRODUCT_FAMILY
      WITH SYNONYMS = ('product line', 'product group')
      COMMENT = 'Product family grouping'
      SAMPLE_VALUES ('Workflow Automation', 'Invoice Automation', 'Document Automation')
      IS_ENUM,
    doc_jobs.customer_name AS CUSTOMER_NAME
      WITH SYNONYMS = ('customer', 'client', 'account')
      COMMENT = 'Customer name',
    doc_jobs.industry AS INDUSTRY
      WITH SYNONYMS = ('vertical', 'sector')
      COMMENT = 'Customer industry vertical'
      SAMPLE_VALUES ('Banking & Financial Services', 'Insurance', 'Healthcare', 'Government & Public Sector', 'Supply Chain & Manufacturing')
      IS_ENUM,
    doc_jobs.segment AS CUSTOMER_SEGMENT
      WITH SYNONYMS = ('tier', 'customer size')
      COMMENT = 'Customer segment (enterprise, mid-market, SMB)'
      SAMPLE_VALUES ('enterprise', 'mid-market', 'SMB')
      IS_ENUM,
    doc_jobs.status AS JOB_STATUS
      WITH SYNONYMS = ('processing status', 'job state')
      COMMENT = 'Job completion status'
      SAMPLE_VALUES ('COMPLETED', 'PROCESSING', 'FAILED', 'QUEUED')
      IS_ENUM,
    doc_jobs.region AS PROCESSING_REGION
      WITH SYNONYMS = ('region', 'data center')
      COMMENT = 'Processing region'
      SAMPLE_VALUES ('us-east', 'us-west', 'eu-west', 'eu-central', 'ap-southeast')
      IS_ENUM,
    doc_jobs.processing_date AS PROCESSING_DATE
      COMMENT = 'Date the document was received for processing',
    doc_jobs.processing_month AS PROCESSING_MONTH
      COMMENT = 'Month the document was processed',
    extractions.field_name AS FIELD_NAME
      WITH SYNONYMS = ('extracted field', 'data field')
      COMMENT = 'Name of the extracted field',
    extractions.validation_status AS VALIDATION_STATUS
      WITH SYNONYMS = ('validation result')
      COMMENT = 'Extraction validation outcome'
      SAMPLE_VALUES ('VALIDATED', 'NEEDS_REVIEW', 'REJECTED')
      IS_ENUM,
    extractions.model_version AS MODEL_VERSION
      WITH SYNONYMS = ('OCR model version', 'model')
      COMMENT = 'OCR/extraction model version used'
  )

  METRICS (
    doc_jobs.total_documents_processed AS COUNT(JOB_ID)
      WITH SYNONYMS = ('document count', 'job count', 'volume')
      COMMENT = 'Total number of documents processed',
    doc_jobs.total_pages_processed AS SUM(PAGE_COUNT)
      WITH SYNONYMS = ('page count', 'pages')
      COMMENT = 'Total pages processed across all documents',
    doc_jobs.avg_processing_time_sec AS AVG(PROCESSING_TIME_SEC)
      WITH SYNONYMS = ('processing time', 'turnaround time')
      COMMENT = 'Average document processing time in seconds',
    extractions.avg_confidence_score AS AVG(CONFIDENCE_SCORE)
      WITH SYNONYMS = ('extraction accuracy', 'confidence', 'accuracy')
      COMMENT = 'Average extraction confidence score (0-1)',
    extractions.manual_correction_rate AS AVG(CASE WHEN MANUAL_CORRECTION THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('correction rate', 'human review rate')
      COMMENT = 'Percentage of extractions requiring manual correction',
    extractions.classification_accuracy AS AVG(CLASSIFICATION_CORRECT)
      WITH SYNONYMS = ('classification accuracy', 'classifier performance')
      COMMENT = 'Document classification accuracy rate'
  )

  COMMENT = 'Intelligent Document Processing operations: volumes, extraction accuracy, classification performance, and OCR model analytics';

-- =============================================================================
-- 2. TA_WORKFLOW_AUTOMATION_SV
-- TotalAgility/RPA workflow analytics
-- =============================================================================
CREATE OR REPLACE SEMANTIC VIEW TA_WORKFLOW_AUTOMATION_SV

  TABLES (
    workflows AS TA_INTELLIGENCE.ANALYTICS.V_WORKFLOW_PERFORMANCE
      PRIMARY KEY (INSTANCE_ID)
      WITH SYNONYMS ('workflow', 'process', 'automation', 'TotalAgility')
      COMMENT = 'Workflow execution instances across TotalAgility and RPA'
  )

  DIMENSIONS (
    workflows.workflow_name AS WORKFLOW_NAME
      WITH SYNONYMS = ('workflow type', 'process name')
      COMMENT = 'Name of the workflow being executed'
      SAMPLE_VALUES ('Invoice Approval', 'Customer Onboarding', 'KYC Verification', 'Claims Processing', 'Purchase Order Matching'),
    workflows.product_name AS PRODUCT_NAME
      COMMENT = 'Product executing the workflow'
      SAMPLE_VALUES ('TotalAgility', 'InvoiceAgility')
      IS_ENUM,
    workflows.customer_name AS CUSTOMER_NAME
      WITH SYNONYMS = ('customer', 'client')
      COMMENT = 'Customer running the workflow',
    workflows.industry AS INDUSTRY
      WITH SYNONYMS = ('vertical', 'sector')
      COMMENT = 'Customer industry'
      SAMPLE_VALUES ('Banking & Financial Services', 'Insurance', 'Healthcare', 'Government & Public Sector', 'Supply Chain & Manufacturing')
      IS_ENUM,
    workflows.segment AS CUSTOMER_SEGMENT
      COMMENT = 'Customer segment'
      SAMPLE_VALUES ('enterprise', 'mid-market', 'SMB')
      IS_ENUM,
    workflows.status AS WORKFLOW_STATUS
      WITH SYNONYMS = ('status', 'state')
      COMMENT = 'Workflow execution status'
      SAMPLE_VALUES ('COMPLETED', 'IN_PROGRESS', 'FAILED', 'CANCELLED')
      IS_ENUM,
    workflows.apqc_process_name AS APQC_PROCESS
      WITH SYNONYMS = ('business process', 'APQC category', 'process classification')
      COMMENT = 'APQC Process Classification Framework process name',
    workflows.apqc_category AS APQC_CATEGORY_CODE
      WITH SYNONYMS = ('APQC code', 'process code')
      COMMENT = 'APQC category code (e.g., 9.3.2 for AP processing)',
    workflows.workflow_date AS WORKFLOW_DATE
      COMMENT = 'Date the workflow was started',
    workflows.workflow_month AS WORKFLOW_MONTH
      COMMENT = 'Month the workflow was started'
  )

  METRICS (
    workflows.total_workflows AS COUNT(INSTANCE_ID)
      WITH SYNONYMS = ('workflow count', 'executions')
      COMMENT = 'Total number of workflow instances',
    workflows.avg_duration_sec AS AVG(DURATION_SEC)
      WITH SYNONYMS = ('completion time', 'duration', 'cycle time')
      COMMENT = 'Average workflow duration in seconds',
    workflows.avg_completion_rate AS AVG(COMPLETION_RATE)
      WITH SYNONYMS = ('step completion rate', 'progress rate')
      COMMENT = 'Average ratio of steps completed to total steps',
    workflows.failure_rate AS AVG(CASE WHEN STATUS = 'FAILED' THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('error rate', 'fail rate')
      COMMENT = 'Percentage of workflows that failed'
  )

  COMMENT = 'Workflow automation analytics: TotalAgility and RPA execution metrics with APQC process classification';

-- =============================================================================
-- 3. TA_INVOICE_NETWORK_SV
-- e-Invoice Network analytics
-- =============================================================================
CREATE OR REPLACE SEMANTIC VIEW TA_INVOICE_NETWORK_SV

  TABLES (
    invoices AS TA_INTELLIGENCE.ANALYTICS.V_INVOICE_NETWORK
      PRIMARY KEY (TRANSACTION_ID)
      WITH SYNONYMS ('e-invoice', 'invoice transaction', 'Tungsten Network', 'electronic invoice')
      COMMENT = 'e-Invoice Network transactions: electronic invoices exchanged globally'
  )

  DIMENSIONS (
    invoices.country_code AS COUNTRY_CODE
      WITH SYNONYMS = ('country', 'jurisdiction')
      COMMENT = 'Country where the invoice was submitted',
    invoices.compliance_standard AS COMPLIANCE_STANDARD
      WITH SYNONYMS = ('standard', 'format', 'protocol')
      COMMENT = 'e-Invoicing compliance standard used'
      SAMPLE_VALUES ('Peppol BIS 3.0', 'UBL 2.1', 'CII', 'SDI FatturaPA', 'GST e-Invoice', 'ZATCA FATOORA')
      IS_ENUM,
    invoices.currency AS CURRENCY
      WITH SYNONYMS = ('invoice currency')
      COMMENT = 'Invoice currency code (ISO 4217)'
      SAMPLE_VALUES ('USD', 'EUR', 'GBP', 'AUD', 'JPY')
      IS_ENUM,
    invoices.status AS TRANSACTION_STATUS
      WITH SYNONYMS = ('delivery status', 'invoice status')
      COMMENT = 'Invoice delivery status'
      SAMPLE_VALUES ('DELIVERED', 'PENDING', 'REJECTED', 'FAILED')
      IS_ENUM,
    invoices.clearance_model AS CLEARANCE_MODEL
      WITH SYNONYMS = ('clearance type', 'validation model')
      COMMENT = 'Regulatory clearance model'
      SAMPLE_VALUES ('Pre-clearance', 'Post-audit')
      IS_ENUM,
    invoices.rejection_reason AS REJECTION_REASON
      WITH SYNONYMS = ('failure reason', 'error')
      COMMENT = 'Reason for invoice rejection if applicable',
    invoices.sender_name AS SENDER_NAME
      WITH SYNONYMS = ('sender', 'supplier')
      COMMENT = 'Invoice sender/supplier name',
    invoices.sender_industry AS SENDER_INDUSTRY
      COMMENT = 'Industry of the sending customer',
    invoices.transaction_date AS TRANSACTION_DATE
      COMMENT = 'Date the invoice was submitted',
    invoices.transaction_month AS TRANSACTION_MONTH
      COMMENT = 'Month the invoice was submitted'
  )

  METRICS (
    invoices.total_invoices AS COUNT(TRANSACTION_ID)
      WITH SYNONYMS = ('invoice count', 'transaction volume')
      COMMENT = 'Total number of e-invoices processed',
    invoices.total_amount AS SUM(AMOUNT)
      WITH SYNONYMS = ('invoice value', 'total value', 'GMV')
      COMMENT = 'Total invoice amount processed',
    invoices.avg_delivery_time_sec AS AVG(DELIVERY_TIME_SEC)
      WITH SYNONYMS = ('delivery time', 'processing time')
      COMMENT = 'Average time to deliver an invoice in seconds',
    invoices.rejection_rate AS AVG(CASE WHEN STATUS = 'REJECTED' THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('reject rate', 'failure rate')
      COMMENT = 'Percentage of invoices rejected'
  )

  COMMENT = 'e-Invoice Network analytics: transaction volumes, compliance rates, delivery metrics, and rejection analysis';

-- =============================================================================
-- 4. TA_CUSTOMER_HEALTH_SV
-- Customer engagement, support, usage, churn signals
-- =============================================================================
CREATE OR REPLACE SEMANTIC VIEW TA_CUSTOMER_HEALTH_SV

  TABLES (
    usage AS TA_INTELLIGENCE.ANALYTICS.V_CUSTOMER_HEALTH
      PRIMARY KEY (CUSTOMER_ID, PRODUCT_ID, USAGE_DATE)
      WITH SYNONYMS ('customer usage', 'usage metrics', 'engagement')
      COMMENT = 'Daily customer usage metrics by product',
    tickets AS TA_INTELLIGENCE.ANALYTICS.V_SUPPORT_METRICS
      PRIMARY KEY (TICKET_ID)
      WITH SYNONYMS ('support tickets', 'cases', 'support')
      COMMENT = 'Customer support ticket analytics'
  )

  DIMENSIONS (
    usage.customer_name AS CUSTOMER_NAME
      WITH SYNONYMS = ('customer', 'client', 'account')
      COMMENT = 'Customer name',
    usage.industry AS INDUSTRY
      WITH SYNONYMS = ('vertical', 'sector')
      COMMENT = 'Customer industry'
      SAMPLE_VALUES ('Banking & Financial Services', 'Insurance', 'Healthcare', 'Government & Public Sector', 'Supply Chain & Manufacturing')
      IS_ENUM,
    usage.country AS COUNTRY
      COMMENT = 'Customer country',
    usage.segment AS CUSTOMER_SEGMENT
      WITH SYNONYMS = ('tier', 'size')
      COMMENT = 'Customer segment'
      SAMPLE_VALUES ('enterprise', 'mid-market', 'SMB')
      IS_ENUM,
    usage.product_name AS PRODUCT_NAME
      COMMENT = 'Product being used',
    usage.product_family AS PRODUCT_FAMILY
      COMMENT = 'Product family',
    usage.tier AS SUBSCRIPTION_TIER
      WITH SYNONYMS = ('plan', 'tier')
      COMMENT = 'Subscription tier level'
      SAMPLE_VALUES ('Enterprise', 'Professional', 'Standard')
      IS_ENUM,
    usage.usage_date AS USAGE_DATE
      COMMENT = 'Date of usage measurement',
    usage.account_manager AS ACCOUNT_MANAGER
      COMMENT = 'Assigned account manager',
    tickets.severity AS TICKET_SEVERITY
      WITH SYNONYMS = ('priority', 'urgency')
      COMMENT = 'Support ticket severity level'
      SAMPLE_VALUES ('P1', 'P2', 'P3', 'P4')
      IS_ENUM,
    tickets.category AS TICKET_CATEGORY
      WITH SYNONYMS = ('issue type', 'problem area')
      COMMENT = 'Support ticket category'
      SAMPLE_VALUES ('Extraction Accuracy', 'Workflow Failure', 'Performance Issue', 'Integration Error', 'Configuration Help', 'Feature Request', 'Invoice Rejection', 'Login/Access Issue')
      IS_ENUM,
    tickets.ticket_month AS TICKET_MONTH
      COMMENT = 'Month the ticket was opened'
  )

  METRICS (
    usage.avg_documents_per_day AS AVG(DOCUMENTS_PROCESSED)
      WITH SYNONYMS = ('daily document volume', 'daily usage')
      COMMENT = 'Average documents processed per day',
    usage.avg_active_users AS AVG(ACTIVE_USERS)
      WITH SYNONYMS = ('active users', 'user count')
      COMMENT = 'Average daily active users',
    usage.avg_utilization_pct AS AVG(DAILY_UTILIZATION_PCT)
      WITH SYNONYMS = ('utilization', 'capacity usage')
      COMMENT = 'Average daily utilization as percentage of volume limit',
    tickets.total_tickets AS COUNT(TICKET_ID)
      WITH SYNONYMS = ('ticket count', 'cases opened')
      COMMENT = 'Total support tickets',
    tickets.avg_csat AS AVG(CSAT_SCORE)
      WITH SYNONYMS = ('customer satisfaction', 'CSAT', 'satisfaction score')
      COMMENT = 'Average customer satisfaction score (1-5)',
    tickets.avg_resolution_hours AS AVG(RESOLUTION_HOURS)
      WITH SYNONYMS = ('resolution time', 'time to resolve', 'MTTR')
      COMMENT = 'Average ticket resolution time in hours'
  )

  COMMENT = 'Customer health analytics: usage trends, support engagement, satisfaction scores, and churn signals';

-- =============================================================================
-- 5. TA_PLATFORM_OPERATIONS_SV
-- SaaS platform health, availability, performance
-- =============================================================================
CREATE OR REPLACE SEMANTIC VIEW TA_PLATFORM_OPERATIONS_SV

  TABLES (
    platform AS TA_INTELLIGENCE.ANALYTICS.V_PLATFORM_HEALTH
      PRIMARY KEY (PRODUCT_ID, REGION, METRIC_HOUR)
      WITH SYNONYMS ('platform health', 'system performance', 'SaaS metrics', 'infrastructure')
      COMMENT = 'Hourly platform health metrics by product and region'
  )

  DIMENSIONS (
    platform.product_name AS PRODUCT_NAME
      WITH SYNONYMS = ('product', 'service')
      COMMENT = 'Tungsten Automation product'
      SAMPLE_VALUES ('TotalAgility', 'InvoiceAgility', 'AP Agility', 'OmniPage', 'ControlSuite', 'Printix')
      IS_ENUM,
    platform.product_family AS PRODUCT_FAMILY
      COMMENT = 'Product family grouping'
      SAMPLE_VALUES ('Workflow Automation', 'Invoice Automation', 'Document Automation')
      IS_ENUM,
    platform.deployment_model AS DEPLOYMENT_MODEL
      WITH SYNONYMS = ('deployment type', 'hosting')
      COMMENT = 'Product deployment model'
      SAMPLE_VALUES ('cloud', 'on-prem', 'hybrid')
      IS_ENUM,
    platform.region AS REGION
      WITH SYNONYMS = ('data center', 'processing region')
      COMMENT = 'Infrastructure region'
      SAMPLE_VALUES ('us-east', 'us-west', 'eu-west', 'eu-central', 'ap-southeast')
      IS_ENUM,
    platform.metric_date AS METRIC_DATE
      COMMENT = 'Date of the metric measurement',
    platform.metric_week AS METRIC_WEEK
      COMMENT = 'Week of the metric measurement',
    platform.time_category AS TIME_CATEGORY
      WITH SYNONYMS = ('business hours', 'time of day')
      COMMENT = 'Business Hours vs Off Hours classification'
      SAMPLE_VALUES ('Business Hours', 'Off Hours')
      IS_ENUM
  )

  METRICS (
    platform.avg_availability AS AVG(AVAILABILITY_PCT)
      WITH SYNONYMS = ('uptime', 'availability', 'SLA')
      COMMENT = 'Average platform availability percentage',
    platform.avg_response_ms AS AVG(AVG_RESPONSE_MS)
      WITH SYNONYMS = ('response time', 'latency', 'performance')
      COMMENT = 'Average response time in milliseconds',
    platform.avg_error_rate AS AVG(ERROR_RATE_PCT)
      WITH SYNONYMS = ('error rate', 'failure rate', 'errors')
      COMMENT = 'Average error rate percentage',
    platform.avg_queue_depth AS AVG(QUEUE_DEPTH)
      WITH SYNONYMS = ('queue size', 'backlog', 'pending items')
      COMMENT = 'Average queue depth (items waiting for processing)',
    platform.max_queue_depth AS MAX(QUEUE_DEPTH)
      WITH SYNONYMS = ('peak queue', 'max backlog')
      COMMENT = 'Maximum queue depth observed'
  )

  COMMENT = 'Platform operations analytics: availability, response times, error rates, and capacity metrics with ITIL service management context';

-- =============================================================================
-- 6. TA_REVENUE_BUSINESS_SV
-- ARR, retention, subscription growth
-- =============================================================================
CREATE OR REPLACE SEMANTIC VIEW TA_REVENUE_BUSINESS_SV

  TABLES (
    subscriptions AS TA_INTELLIGENCE.ANALYTICS.V_REVENUE_METRICS
      PRIMARY KEY (SUBSCRIPTION_ID)
      WITH SYNONYMS ('subscriptions', 'revenue', 'ARR', 'contracts', 'bookings')
      COMMENT = 'Customer subscription and revenue analytics'
  )

  DIMENSIONS (
    subscriptions.customer_name AS CUSTOMER_NAME
      WITH SYNONYMS = ('customer', 'client', 'account')
      COMMENT = 'Customer name',
    subscriptions.industry AS INDUSTRY
      WITH SYNONYMS = ('vertical', 'sector')
      COMMENT = 'Customer industry'
      SAMPLE_VALUES ('Banking & Financial Services', 'Insurance', 'Healthcare', 'Government & Public Sector', 'Supply Chain & Manufacturing')
      IS_ENUM,
    subscriptions.country AS COUNTRY
      COMMENT = 'Customer country',
    subscriptions.segment AS CUSTOMER_SEGMENT
      WITH SYNONYMS = ('tier', 'size', 'segment')
      COMMENT = 'Customer segment'
      SAMPLE_VALUES ('enterprise', 'mid-market', 'SMB')
      IS_ENUM,
    subscriptions.product_name AS PRODUCT_NAME
      WITH SYNONYMS = ('product')
      COMMENT = 'Subscribed product',
    subscriptions.product_family AS PRODUCT_FAMILY
      WITH SYNONYMS = ('product line')
      COMMENT = 'Product family grouping',
    subscriptions.tier AS SUBSCRIPTION_TIER
      WITH SYNONYMS = ('plan', 'pricing tier')
      COMMENT = 'Subscription tier'
      SAMPLE_VALUES ('Enterprise', 'Professional', 'Standard')
      IS_ENUM,
    subscriptions.status AS SUBSCRIPTION_STATUS
      COMMENT = 'Subscription status'
      SAMPLE_VALUES ('ACTIVE')
      IS_ENUM,
    subscriptions.start_date AS START_DATE
      COMMENT = 'Subscription start date',
    subscriptions.renewal_date AS RENEWAL_DATE
      WITH SYNONYMS = ('renewal', 'contract end')
      COMMENT = 'Next renewal date'
  )

  FACTS (
    subscriptions.days_to_renewal AS DAYS_TO_RENEWAL
      WITH SYNONYMS = ('days until renewal', 'time to renew')
      COMMENT = 'Number of days until subscription renewal'
  )

  METRICS (
    subscriptions.total_arr AS SUM(ARR_USD)
      WITH SYNONYMS = ('ARR', 'annual recurring revenue', 'revenue', 'total revenue')
      COMMENT = 'Total Annual Recurring Revenue in USD',
    subscriptions.avg_arr_per_customer AS AVG(ARR_USD)
      WITH SYNONYMS = ('average deal size', 'avg ARR', 'ARPA')
      COMMENT = 'Average ARR per customer subscription',
    subscriptions.total_customers AS COUNT(SUBSCRIPTION_ID)
      WITH SYNONYMS = ('customer count', 'subscription count')
      COMMENT = 'Total number of active subscriptions',
    subscriptions.total_volume_limit AS SUM(DOCUMENT_VOLUME_LIMIT)
      WITH SYNONYMS = ('total capacity', 'contracted volume')
      COMMENT = 'Total contracted document volume limit'
  )

  COMMENT = 'Revenue and business analytics: ARR, subscription metrics, customer segmentation, and renewal tracking';
