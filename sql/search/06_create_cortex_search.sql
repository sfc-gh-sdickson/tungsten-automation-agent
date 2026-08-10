/*=============================================================================
  Tungsten Automation Intelligence Agent
  06_create_cortex_search.sql
  
  Creates: 2 Cortex Search services in ANALYTICS schema
  1. TA_PRODUCT_DOCS_SEARCH - Product documentation and knowledge base
  2. TA_STANDARDS_COMPLIANCE_SEARCH - Industry standards and regulatory text
=============================================================================*/

USE DATABASE TA_INTELLIGENCE;
USE WAREHOUSE TUNGSTEN_AUTOMATION_WH;
USE SCHEMA ANALYTICS;

-- =============================================================================
-- Source table for product documentation search
-- =============================================================================
CREATE OR REPLACE TABLE TA_INTELLIGENCE.ANALYTICS.PRODUCT_DOCS_CORPUS (
    DOC_ID          VARCHAR(36)     NOT NULL,
    PRODUCT_NAME    VARCHAR(100)    NOT NULL,
    CATEGORY        VARCHAR(50)     NOT NULL,
    TITLE           VARCHAR(300)    NOT NULL,
    CONTENT         VARCHAR(5000)   NOT NULL,
    PRIMARY KEY (DOC_ID)
);

INSERT INTO TA_INTELLIGENCE.ANALYTICS.PRODUCT_DOCS_CORPUS VALUES
    (UUID_STRING(), 'TotalAgility', 'Getting Started', 'TotalAgility Platform Overview', 'TotalAgility is a low-code intelligent automation platform that combines intelligent document processing (IDP), process modeling, workflow orchestration, case management, AI, RPA, business rules, e-signature, and analytics. It enables organizations to automate content-intensive workflows across banking, insurance, healthcare, supply chain, and government.'),
    (UUID_STRING(), 'TotalAgility', 'Configuration', 'Configuring Document Classification', 'To configure document classification in TotalAgility, navigate to the Classification module and define document classes. Each class maps to a document type (Invoice, Claim, Application, etc.). Training requires a minimum of 20 sample documents per class. The classifier uses AI-powered models with confidence thresholds that determine automatic vs manual routing.'),
    (UUID_STRING(), 'TotalAgility', 'Troubleshooting', 'Workflow Failure Recovery', 'When a workflow fails in TotalAgility, check the execution log for error details. Common causes include: timeout on external service calls, invalid document format, missing required fields, and permission errors. Use the retry mechanism for transient failures. For persistent issues, route to exception handling workflows.'),
    (UUID_STRING(), 'InvoiceAgility', 'Getting Started', 'InvoiceAgility Overview', 'InvoiceAgility combines the global scale of the Tungsten e-Invoice Network with intelligent invoice capture via AP Essentials. It processes invoices in any format from any supplier, including countries with e-invoice mandates. Key capabilities: touchless invoice processing, automated compliance, AI-driven data extraction, and three-way matching.'),
    (UUID_STRING(), 'InvoiceAgility', 'Configuration', 'Setting Up Three-Way Matching', 'Three-way matching in InvoiceAgility compares the invoice against the purchase order and goods receipt. Configure matching tolerances for amount variance (default 2%), quantity variance (default 5%), and price variance (default 3%). Invoices within tolerance are auto-approved; those outside tolerance route to exception queues for review.'),
    (UUID_STRING(), 'InvoiceAgility', 'Best Practices', 'Optimizing Extraction Accuracy', 'To improve invoice extraction accuracy: 1) Ensure supplier invoices are high-resolution (300+ DPI), 2) Configure supplier-specific templates for top vendors, 3) Enable the AI learning loop that improves from manual corrections, 4) Use structured data validation against master data (vendor IDs, PO numbers). Target >95% straight-through processing rate.'),
    (UUID_STRING(), 'AP Agility', 'Getting Started', 'AP Agility for SAP Integration', 'AP Agility (Process Director) standardizes how invoices enter, flow through, and are approved in SAP. It eliminates fragmented invoice handling across email, paper, and disconnected tools. Key benefits: reduced bottlenecks, increased data accuracy, real-time visibility into liabilities and process status.'),
    (UUID_STRING(), 'OmniPage', 'Getting Started', 'OmniPage OCR SDK Overview', 'OmniPage is the market-leading OCR and document processing SDK powering intelligent document capture across the Tungsten portfolio. It provides: text recognition (200+ languages), table extraction, barcode reading, form recognition, and document conversion. Available for Windows and Linux (OmniPage Capture SDK 2025.3).'),
    (UUID_STRING(), 'OmniPage', 'Configuration', 'Configuring Multi-Language OCR', 'OmniPage supports 200+ recognition languages. Configure primary and secondary languages per document type for optimal accuracy. Enable automatic language detection for mixed-language documents. For Asian languages (CJK), enable the specialized recognition module. Performance tip: limit active languages to those expected in the document stream.'),
    (UUID_STRING(), 'ControlSuite', 'Getting Started', 'ControlSuite Print and Capture', 'ControlSuite is a serverless print and capture platform integrating cloud-native Printix with zonal OCR and document classification. It supports capture from email, mobile, scan, and web print queues. Hybrid Cloud Print enables remote print management for distributed workforces.'),
    (UUID_STRING(), 'Printix', 'Getting Started', 'Printix Cloud Print Management', 'Printix is cloud-native print management providing secure printing, cost tracking, and environmental reporting. Features: pull printing (release-at-device), cloud OCR via OmniPage integration, S3-compatible object storage, VPN-less print workflows, and integration with ERP systems.'),
    (UUID_STRING(), 'Platform', 'Security', 'Data Privacy and Compliance', 'Tungsten Automation products comply with GDPR, CCPA, HIPAA, SOX, and ISO 27001/SOC 2 Type II. Document data extracted by IDP can contain PII/PHI. Configure data retention policies per document type. Enable automatic PII redaction for sensitive fields. All data-in-transit uses TLS 1.3; data-at-rest uses AES-256 encryption.'),
    (UUID_STRING(), 'Platform', 'Integration', 'API and Webhook Configuration', 'All Tungsten products expose REST APIs for integration. Configure webhooks for real-time event notifications (job completed, workflow failed, invoice delivered). API authentication supports OAuth 2.0, API keys, and client certificates. Rate limits: 1000 requests/minute per customer (enterprise tier: 5000/min).'),
    (UUID_STRING(), 'Platform', 'Performance', 'Scaling and Capacity Planning', 'Platform auto-scales based on queue depth and processing latency. Monitor queue_depth and avg_response_ms metrics. Capacity thresholds: queue_depth > 1000 triggers scale-up; response_ms > 500ms (p95) triggers investigation. Regional failover available for enterprise tier customers.');

-- =============================================================================
-- Source table for standards and compliance search
-- =============================================================================
CREATE OR REPLACE TABLE TA_INTELLIGENCE.ANALYTICS.STANDARDS_COMPLIANCE_CORPUS (
    DOC_ID          VARCHAR(36)     NOT NULL,
    STANDARD_NAME   VARCHAR(100)    NOT NULL,
    CATEGORY        VARCHAR(50)     NOT NULL,
    TITLE           VARCHAR(300)    NOT NULL,
    CONTENT         VARCHAR(5000)   NOT NULL,
    PRIMARY KEY (DOC_ID)
);

INSERT INTO TA_INTELLIGENCE.ANALYTICS.STANDARDS_COMPLIANCE_CORPUS VALUES
    (UUID_STRING(), 'APQC PCF', 'Process Taxonomy', 'APQC 9.3 - Perform General Accounting and Reporting', 'APQC Process 9.3 covers accounts payable processing, accounts receivable, general ledger, and financial reporting. Sub-process 9.3.1 (Match POs to Invoices) involves three-way matching of purchase orders, goods receipts, and supplier invoices. Sub-process 9.3.2 (Process Accounts Payable) covers the end-to-end invoice lifecycle from receipt through payment. These processes are the primary automation targets for InvoiceAgility and AP Agility.'),
    (UUID_STRING(), 'APQC PCF', 'Process Taxonomy', 'APQC 3.5 - Manage Customer Service', 'APQC Process 3.5 covers customer onboarding, KYC verification, account opening, and service requests. Sub-process 3.5.1 (Customer Onboarding) and 3.5.2 (KYC Verification) are primary automation targets for TotalAgility in banking and insurance. Document-intensive onboarding processes benefit from IDP-powered identity verification, form extraction, and automated compliance checks.'),
    (UUID_STRING(), 'APQC PCF', 'Process Taxonomy', 'APQC 8.4 - Manage Information', 'APQC Process 8.4 covers data governance, content management, and document management. Sub-process 8.4.1 (Classify and Index Documents) maps directly to Tungsten IDP capabilities — automated document classification, metadata extraction, and indexing. Sub-process 8.4.2 (Digital Mail Room) maps to ControlSuite inbound mail digitization and routing.'),
    (UUID_STRING(), 'APQC PCF', 'Process Taxonomy', 'APQC 11.1 - Manage Enterprise Risk', 'APQC Process 11.1 covers risk identification, assessment, mitigation, and monitoring. Sub-process 11.1.3 (Process Insurance Claims) is a major automation target for TotalAgility in the insurance vertical — claims intake, document validation, assessment workflow, and settlement processing. High-volume document processing with strict SLA requirements.'),
    (UUID_STRING(), 'UBL 2.1', 'Invoice Standard', 'UBL Invoice Mandatory Fields (Peppol BIS 3.0)', 'Peppol BIS Billing 3.0 mandates the following UBL invoice fields: InvoiceNumber (ID), IssueDate, InvoiceTypeCode, DocumentCurrencyCode, AccountingSupplierParty (name, tax ID), AccountingCustomerParty (name, tax ID), TaxTotal/TaxAmount, LegalMonetaryTotal/PayableAmount, and at least one InvoiceLine with ID, quantity, item name, and price. Optional but recommended: BuyerReference, OrderReference, DeliveryDate, PaymentMeans.'),
    (UUID_STRING(), 'UBL 2.1', 'Invoice Standard', 'UBL Tax Category Codes', 'UBL tax categories used in Peppol invoices: S (Standard rate), Z (Zero rated), E (Exempt), AE (VAT Reverse Charge), K (Intra-community supply), G (Export outside EU), O (Outside scope of VAT), L (Canary Islands), M (Ceuta and Melilla). Each InvoiceLine and the document-level TaxSubtotal must reference a valid tax category.'),
    (UUID_STRING(), 'ITIL 4', 'Service Management', 'ITIL Service Level Management KPIs', 'Key ITIL 4 KPIs for platform operations: Service Availability (target: 99.9%), Mean Time to Restore/MTTR (target: <60 min), SLA Compliance Rate (target: 95%), Incident Rate (target: <5/day), First Contact Resolution (target: 70%), Change Success Rate (target: 95%). These metrics should be monitored hourly for SaaS platforms and reported weekly to stakeholders.'),
    (UUID_STRING(), 'ITIL 4', 'Service Management', 'ITIL Incident Management Practice', 'ITIL Incident Management restores normal service operation as quickly as possible. Key metrics: MTTR (Mean Time to Restore), Incident Rate, and SLA breach percentage. Severity classification: P1 (critical business impact, target <1hr), P2 (major impact, target <4hr), P3 (moderate impact, target <24hr), P4 (minor impact, target <72hr). Escalation paths should be defined for each severity.'),
    (UUID_STRING(), 'GDPR', 'Data Privacy', 'GDPR Article 9 - Special Category Data', 'GDPR Article 9 prohibits processing of special category data unless specific conditions apply. Special categories include: racial/ethnic origin, political opinions, religious beliefs, trade union membership, genetic data, biometric data for identification, health data, and sex life/orientation data. Document extraction systems must identify and flag special category PII. Retention must be minimized and purpose-limited.'),
    (UUID_STRING(), 'GDPR', 'Data Privacy', 'GDPR Data Minimization for Document Processing', 'Under GDPR Article 5(1)(c), personal data must be adequate, relevant, and limited to what is necessary. For IDP systems: extract only fields required for the business process, redact unnecessary PII before storage, implement automatic purging after retention period, maintain processing records per Article 30. Healthcare documents (HIPAA intersection) require additional safeguards for PHI.'),
    (UUID_STRING(), 'e-Invoicing', 'Mandates', 'EU ViDA - VAT in the Digital Age', 'The EU VAT in the Digital Age (ViDA) regulation mandates B2B e-invoicing across all EU member states by July 2028. Key requirements: structured e-invoices in EN 16931 format (UBL 2.1 or CII), real-time digital reporting of cross-border transactions, and pre-clearance model for domestic B2B transactions in participating states. Businesses must issue e-invoices within 10 days of the chargeable event.'),
    (UUID_STRING(), 'e-Invoicing', 'Mandates', 'France Factur-X Mandate (September 2026)', 'France mandates B2B e-invoicing from September 2026 via Partner Dematerialization Platforms (PDPs) or the Public Billing Portal (PPF). Requirements: Factur-X format (CII-based hybrid PDF with embedded XML), e-reporting of B2C transactions, real-time transmission to the tax authority. Large enterprises comply first; SMEs follow in phases through 2027.'),
    (UUID_STRING(), 'e-Invoicing', 'Mandates', 'Saudi Arabia ZATCA FATOORA', 'Saudi Arabia ZATCA e-invoicing (FATOORA) requires all B2B and B2C invoices to be issued electronically in UBL 2.1 format. Phase 2 (Integration Phase) requires real-time clearance through the ZATCA platform before invoice delivery. Invoices must be cryptographically stamped with a QR code. Non-compliance results in fines starting at 5,000 SAR per invoice.'),
    (UUID_STRING(), 'Dublin Core', 'Document Metadata', 'Dublin Core Type Vocabulary for IDP', 'Dublin Core metadata elements for document classification in IDP systems: Type (document class - Invoice, Contract, Claim), Format (MIME type - application/pdf, image/jpeg), Subject (domain category - Financial, Insurance, Healthcare), Creator (originating entity), Date (document creation date). Using DC vocabulary enables cross-product document analytics and industry-standard reporting.');

-- =============================================================================
-- Cortex Search Service 1: Product Documentation
-- =============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE TA_PRODUCT_DOCS_SEARCH
  ON CONTENT
  ATTRIBUTES PRODUCT_NAME, CATEGORY, TITLE
  WAREHOUSE = TUNGSTEN_AUTOMATION_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Product documentation and knowledge base search for Tungsten Automation products'
AS
  SELECT
    DOC_ID,
    PRODUCT_NAME,
    CATEGORY,
    TITLE,
    CONTENT
  FROM TA_INTELLIGENCE.ANALYTICS.PRODUCT_DOCS_CORPUS;

-- =============================================================================
-- Cortex Search Service 2: Standards and Compliance
-- =============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE TA_STANDARDS_COMPLIANCE_SEARCH
  ON CONTENT
  ATTRIBUTES STANDARD_NAME, CATEGORY, TITLE
  WAREHOUSE = TUNGSTEN_AUTOMATION_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Industry standards and compliance search: APQC PCF, UBL, ITIL, GDPR, e-invoicing mandates'
AS
  SELECT
    DOC_ID,
    STANDARD_NAME,
    CATEGORY,
    TITLE,
    CONTENT
  FROM TA_INTELLIGENCE.ANALYTICS.STANDARDS_COMPLIANCE_CORPUS;
