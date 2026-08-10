/*=============================================================================
  Tungsten Automation Intelligence Agent
  03b_seed_industry_standards.sql
  
  Seeds: REFERENCE schema with industry ontologies and standards
  - APQC Process Classification Framework v7.4 (relevant processes)
  - Dublin Core document type taxonomy (ISO 15836)
  - UBL 2.1 invoice elements + Peppol BIS 3.0 subset
  - Global e-invoicing mandate registry
  - ITIL 4 service management KPIs
  - NAICS industry classification
  - GDPR/CCPA/HIPAA data categories
  - OCR model version registry
=============================================================================*/

USE DATABASE TA_INTELLIGENCE;
USE WAREHOUSE TUNGSTEN_AUTOMATION_WH;
USE SCHEMA REFERENCE;

-- =============================================================================
-- APQC_PROCESS_TAXONOMY (representative subset of PCF v7.4)
-- =============================================================================
INSERT INTO APQC_PROCESS_TAXONOMY (PROCESS_ID, PROCESS_NAME, LEVEL, PARENT_ID, CATEGORY_CODE, DESCRIPTION)
VALUES
    -- Level 1 Categories
    ('APQC_3',     'Market and Sell Products and Services',        1, NULL,       '3.0',   'Processes related to understanding markets, managing customers, and selling'),
    ('APQC_4',     'Deliver Products and Services',                1, NULL,       '4.0',   'Processes for planning, procuring, producing, and delivering'),
    ('APQC_6',     'Manage Business Rules and Knowledge',          1, NULL,       '6.0',   'Processes for managing organizational knowledge and business rules'),
    ('APQC_8',     'Manage Information Technology',                1, NULL,       '8.0',   'IT service delivery, support, and infrastructure management'),
    ('APQC_9',     'Manage Financial Resources',                   1, NULL,       '9.0',   'Financial planning, accounting, AP/AR, treasury, and tax'),
    ('APQC_11',    'Manage Enterprise Risk and Compliance',        1, NULL,       '11.0',  'Risk management, compliance, and remediation processes'),
    -- Level 2 (selected)
    ('APQC_3.5',   'Manage Customer Service',                      2, 'APQC_3',  '3.5',   'Customer onboarding, service requests, and relationship management'),
    ('APQC_4.2',   'Procure Materials and Services',               2, 'APQC_4',  '4.2',   'Supplier management, procurement, and purchasing'),
    ('APQC_4.3',   'Produce/Manufacture/Deliver Products',         2, 'APQC_4',  '4.3',   'Production, logistics, and delivery operations'),
    ('APQC_6.1',   'Manage Business Rules',                        2, 'APQC_6',  '6.1',   'Define, maintain, and enforce business rules and workflows'),
    ('APQC_6.3',   'Manage Contract Lifecycle',                    2, 'APQC_6',  '6.3',   'Contract creation, review, approval, and management'),
    ('APQC_8.4',   'Manage Information',                           2, 'APQC_8',  '8.4',   'Data governance, content management, and document management'),
    ('APQC_9.2',   'Perform Revenue Accounting',                   2, 'APQC_9',  '9.2',   'Revenue recognition, billing, and collections'),
    ('APQC_9.3',   'Perform General Accounting and Reporting',     2, 'APQC_9',  '9.3',   'AP/AR processing, general ledger, and financial reporting'),
    ('APQC_9.4',   'Manage Treasury Operations',                   2, 'APQC_9',  '9.4',   'Cash management, payments, and banking relationships'),
    ('APQC_9.5',   'Manage Taxes',                                 2, 'APQC_9',  '9.5',   'Tax planning, compliance, filing, and reporting'),
    ('APQC_11.1',  'Manage Enterprise Risk',                       2, 'APQC_11', '11.1',  'Risk identification, assessment, mitigation, and monitoring'),
    ('APQC_11.2',  'Manage Compliance',                            2, 'APQC_11', '11.2',  'Regulatory compliance, audit, and reporting'),
    -- Level 3 (specific processes mapped to Tungsten products)
    ('APQC_3.5.1', 'Manage Customer Onboarding',                   3, 'APQC_3.5','3.5.1', 'New customer registration, KYC verification, account setup. Maps to TotalAgility KYC workflows.'),
    ('APQC_3.5.2', 'Perform KYC Verification',                     3, 'APQC_3.5','3.5.2', 'Know Your Customer identity verification and compliance checks.'),
    ('APQC_3.5.3', 'Register Patient/Applicant',                   3, 'APQC_3.5','3.5.3', 'Patient registration, benefits enrollment, application intake.'),
    ('APQC_3.5.4', 'Open Customer Account',                        3, 'APQC_3.5','3.5.4', 'Bank account opening, insurance policy setup, service activation.'),
    ('APQC_4.2.1', 'Onboard Suppliers',                            3, 'APQC_4.2','4.2.1', 'Supplier registration, qualification, and master data setup.'),
    ('APQC_4.3.2', 'Process Shipping Documents',                   3, 'APQC_4.3','4.3.2', 'Bill of lading, packing list, customs documentation processing.'),
    ('APQC_6.1.2', 'Manage Enrollment Workflows',                  3, 'APQC_6.1','6.1.2', 'Benefits enrollment, policy renewal, and membership processing.'),
    ('APQC_6.3.1', 'Review and Approve Contracts',                 3, 'APQC_6.3','6.3.1', 'Contract review, clause extraction, approval routing.'),
    ('APQC_8.4.1', 'Classify and Index Documents',                 3, 'APQC_8.4','8.4.1', 'Document classification, metadata extraction, indexing. Maps to OmniPage/TotalAgility IDP.'),
    ('APQC_8.4.2', 'Manage Digital Mail Room',                     3, 'APQC_8.4','8.4.2', 'Inbound mail digitization, sorting, and routing. Maps to ControlSuite.'),
    ('APQC_9.2.1', 'Process Loan Applications',                    3, 'APQC_9.2','9.2.1', 'Loan origination, document collection, credit assessment.'),
    ('APQC_9.3.1', 'Match Purchase Orders to Invoices',            3, 'APQC_9.3','9.3.1', 'Three-way matching of PO, receipt, and invoice. Maps to AP Agility.'),
    ('APQC_9.3.2', 'Process Accounts Payable',                     3, 'APQC_9.3','9.3.2', 'Invoice capture, validation, approval, and payment. Maps to InvoiceAgility.'),
    ('APQC_9.3.3', 'Process Expense Reports',                      3, 'APQC_9.3','9.3.3', 'Expense submission, receipt validation, approval, and reimbursement.'),
    ('APQC_9.4.1', 'Process Payments',                             3, 'APQC_9.4','9.4.1', 'Payment execution, bank reconciliation, cash application.'),
    ('APQC_9.5.1', 'Process Tax Forms',                            3, 'APQC_9.5','9.5.1', 'Tax form classification, data extraction, compliance filing.'),
    ('APQC_11.1.1','Perform Compliance Audit',                     3, 'APQC_11.1','11.1.1','Internal audit documentation, evidence collection, report generation.'),
    ('APQC_11.1.3','Process Insurance Claims',                     3, 'APQC_11.1','11.1.3','Claims intake, document validation, assessment, and settlement.'),
    ('APQC_11.2.1','Underwrite Policies',                          3, 'APQC_11.2','11.2.1','Insurance underwriting, risk assessment, policy issuance.'),
    ('APQC_11.2.2','Process Insurance Renewals',                   3, 'APQC_11.2','11.2.2','Policy renewal processing, document verification, re-underwriting.');

-- =============================================================================
-- DUBLIN_CORE_DOCUMENT_TYPES (document type taxonomy using DC metadata)
-- =============================================================================
INSERT INTO DUBLIN_CORE_DOCUMENT_TYPES (DC_TYPE_ID, DC_TYPE_LABEL, DC_FORMAT, DC_SUBJECT_CATEGORY, PARENT_TYPE, INDUSTRY_APPLICABILITY)
VALUES
    ('DC_001', 'Invoice',              'application/pdf',  'Financial',         NULL,      'Banking, Insurance, Healthcare, Government, Supply Chain'),
    ('DC_002', 'Purchase Order',       'application/pdf',  'Procurement',       NULL,      'Supply Chain, Manufacturing, Government'),
    ('DC_003', 'Claim Form',           'application/pdf',  'Insurance',         NULL,      'Insurance, Healthcare'),
    ('DC_004', 'Application Form',     'application/pdf',  'Onboarding',        NULL,      'Banking, Insurance, Government'),
    ('DC_005', 'Contract',             'application/pdf',  'Legal',             NULL,      'Banking, Insurance, Healthcare, Government, Supply Chain'),
    ('DC_006', 'Receipt',              'image/jpeg',       'Financial',         'DC_001',  'Banking, Supply Chain'),
    ('DC_007', 'Tax Document',         'application/pdf',  'Taxation',          NULL,      'Banking, Government'),
    ('DC_008', 'Shipping Document',    'application/pdf',  'Logistics',         NULL,      'Supply Chain, Manufacturing'),
    ('DC_009', 'Medical Record',       'application/pdf',  'Healthcare',        NULL,      'Healthcare'),
    ('DC_010', 'Government Form',      'application/pdf',  'Civic',             NULL,      'Government'),
    ('DC_011', 'Bank Statement',       'application/pdf',  'Financial',         NULL,      'Banking'),
    ('DC_012', 'Insurance Policy',     'application/pdf',  'Insurance',         NULL,      'Insurance'),
    ('DC_013', 'Prescription',         'image/jpeg',       'Healthcare',        'DC_009',  'Healthcare'),
    ('DC_014', 'Customs Declaration',  'application/xml',  'Trade',             'DC_008',  'Supply Chain'),
    ('DC_015', 'Identity Document',    'image/jpeg',       'Identification',    NULL,      'Banking, Insurance, Government'),
    ('DC_016', 'Utility Bill',         'application/pdf',  'Financial',         NULL,      'Banking, Government'),
    ('DC_017', 'Payslip',              'application/pdf',  'Employment',        NULL,      'Banking, Government'),
    ('DC_018', 'Remittance Advice',    'application/xml',  'Financial',         'DC_001',  'Banking, Supply Chain'),
    ('DC_019', 'Bill of Lading',       'application/pdf',  'Logistics',         'DC_008',  'Supply Chain'),
    ('DC_020', 'Credit Note',          'application/pdf',  'Financial',         'DC_001',  'Banking, Supply Chain');

-- =============================================================================
-- UBL_INVOICE_ELEMENTS (key elements from OASIS UBL 2.1 Invoice)
-- =============================================================================
INSERT INTO UBL_INVOICE_ELEMENTS (ELEMENT_ID, ELEMENT_NAME, UBL_PATH, DATA_TYPE, CARDINALITY, DESCRIPTION, PEPPOL_SUBSET_FLAG)
VALUES
    ('UBL_001', 'InvoiceNumber',           '/Invoice/ID',                                    'Identifier', '1..1', 'Unique invoice identifier assigned by the seller',                    TRUE),
    ('UBL_002', 'IssueDate',              '/Invoice/IssueDate',                              'Date',       '1..1', 'Date when the invoice was issued',                                    TRUE),
    ('UBL_003', 'DueDate',                '/Invoice/DueDate',                                'Date',       '0..1', 'Date by which payment is due',                                        TRUE),
    ('UBL_004', 'InvoiceTypeCode',        '/Invoice/InvoiceTypeCode',                        'Code',       '1..1', 'Code specifying the type of invoice (380=commercial, 381=credit)',     TRUE),
    ('UBL_005', 'DocumentCurrencyCode',   '/Invoice/DocumentCurrencyCode',                   'Code',       '1..1', 'Currency code for the invoice (ISO 4217)',                             TRUE),
    ('UBL_006', 'BuyerReference',         '/Invoice/BuyerReference',                         'Text',       '0..1', 'Reference assigned by the buyer (e.g., PO number)',                   TRUE),
    ('UBL_007', 'SupplierPartyName',      '/Invoice/AccountingSupplierParty/Party/PartyName','Text',       '1..1', 'Legal name of the supplier/seller',                                   TRUE),
    ('UBL_008', 'SupplierTaxID',          '/Invoice/AccountingSupplierParty/Party/PartyTaxScheme/CompanyID','Identifier','0..1','Tax identification number of the supplier', TRUE),
    ('UBL_009', 'CustomerPartyName',      '/Invoice/AccountingCustomerParty/Party/PartyName','Text',       '1..1', 'Legal name of the customer/buyer',                                    TRUE),
    ('UBL_010', 'CustomerTaxID',          '/Invoice/AccountingCustomerParty/Party/PartyTaxScheme/CompanyID','Identifier','0..1','Tax identification number of the customer', TRUE),
    ('UBL_011', 'TaxableAmount',          '/Invoice/TaxTotal/TaxSubtotal/TaxableAmount',     'Amount',     '1..n', 'Net amount subject to tax',                                           TRUE),
    ('UBL_012', 'TaxAmount',              '/Invoice/TaxTotal/TaxAmount',                     'Amount',     '1..1', 'Total tax amount for the invoice',                                    TRUE),
    ('UBL_013', 'TaxCategoryCode',        '/Invoice/TaxTotal/TaxSubtotal/TaxCategory/ID',    'Code',       '1..n', 'Tax category code (S=standard, Z=zero, E=exempt)',                    TRUE),
    ('UBL_014', 'PayableAmount',          '/Invoice/LegalMonetaryTotal/PayableAmount',       'Amount',     '1..1', 'Total amount to be paid including tax',                               TRUE),
    ('UBL_015', 'LineExtensionAmount',    '/Invoice/LegalMonetaryTotal/LineExtensionAmount', 'Amount',     '1..1', 'Sum of all invoice line net amounts',                                 TRUE),
    ('UBL_016', 'InvoiceLineID',          '/Invoice/InvoiceLine/ID',                         'Identifier', '1..n', 'Unique identifier for each invoice line',                             TRUE),
    ('UBL_017', 'LineQuantity',           '/Invoice/InvoiceLine/InvoicedQuantity',           'Quantity',   '1..1', 'Quantity of items on the line',                                        TRUE),
    ('UBL_018', 'LineItemName',           '/Invoice/InvoiceLine/Item/Name',                  'Text',       '1..1', 'Name/description of the invoiced item',                               TRUE),
    ('UBL_019', 'LinePriceAmount',        '/Invoice/InvoiceLine/Price/PriceAmount',          'Amount',     '1..1', 'Unit price of the item',                                              TRUE),
    ('UBL_020', 'PaymentMeansCode',       '/Invoice/PaymentMeans/PaymentMeansCode',          'Code',       '0..1', 'Code for payment method (30=bank transfer, 48=card, 58=SEPA)',         TRUE),
    ('UBL_021', 'PaymentTermsNote',       '/Invoice/PaymentTerms/Note',                      'Text',       '0..1', 'Free-text description of payment terms',                              FALSE),
    ('UBL_022', 'OrderReference',         '/Invoice/OrderReference/ID',                      'Identifier', '0..1', 'Reference to the purchase order',                                     TRUE),
    ('UBL_023', 'DeliveryDate',           '/Invoice/Delivery/ActualDeliveryDate',            'Date',       '0..1', 'Actual date of delivery of goods/services',                           FALSE),
    ('UBL_024', 'AllowanceChargeAmount',  '/Invoice/AllowanceCharge/Amount',                 'Amount',     '0..n', 'Document-level allowance or charge amount',                           TRUE),
    ('UBL_025', 'PrepaidAmount',          '/Invoice/LegalMonetaryTotal/PrepaidAmount',       'Amount',     '0..1', 'Amount already paid (advance payments)',                               FALSE);

-- =============================================================================
-- EINVOICE_MANDATE_REGISTRY (global e-invoicing mandates)
-- =============================================================================
INSERT INTO EINVOICE_MANDATE_REGISTRY (MANDATE_ID, COUNTRY_CODE, STANDARD_NAME, FORMAT, EFFECTIVE_DATE, MANDATORY_FLAG, CLEARANCE_MODEL, DESCRIPTION)
VALUES
    ('EM_001', 'IT', 'SDI FatturaPA',           'FatturaPA',    '2019-01-01', TRUE,  'Pre-clearance', 'Italy Sistema di Interscambio: all B2B/B2G invoices must route through SDI'),
    ('EM_002', 'IN', 'GST e-Invoice',           'JSON/IRN',     '2022-10-01', TRUE,  'Pre-clearance', 'India GST: mandatory e-invoicing for businesses above turnover threshold via IRP'),
    ('EM_003', 'BR', 'NFe/NFSe',                'XML',          '2006-04-01', TRUE,  'Pre-clearance', 'Brazil Nota Fiscal Eletronica: all goods/services invoices via SEFAZ'),
    ('EM_004', 'SA', 'ZATCA FATOORA',           'UBL 2.1',     '2024-01-01', TRUE,  'Pre-clearance', 'Saudi Arabia Zakat Tax Authority: phased e-invoicing with clearance model'),
    ('EM_005', 'EU', 'Peppol BIS Billing 3.0',  'UBL 2.1',     '2024-04-01', TRUE,  'Post-audit',    'EU B2G mandate via Peppol network; EN 16931 core invoice model'),
    ('EM_006', 'EU', 'ViDA (VAT in Digital Age)','UBL/CII',     '2028-07-01', TRUE,  'Pre-clearance', 'EU ViDA: mandatory B2B e-invoicing and digital reporting across all member states'),
    ('EM_007', 'DE', 'XRechnung',               'UBL 2.1/CII', '2020-11-27', TRUE,  'Post-audit',    'Germany: mandatory e-invoicing for B2G; B2B mandate phasing in 2025-2028'),
    ('EM_008', 'FR', 'Factur-X / Chorus Pro',   'CII/UBL',     '2026-09-01', TRUE,  'Pre-clearance', 'France: mandatory B2B e-invoicing and e-reporting via PPF/PDP platforms'),
    ('EM_009', 'PL', 'KSeF',                    'XML',          '2026-02-01', TRUE,  'Pre-clearance', 'Poland National e-Invoice System: centralized clearance for all B2B invoices'),
    ('EM_010', 'MY', 'MyInvois',                'UBL 2.1',     '2024-08-01', TRUE,  'Pre-clearance', 'Malaysia LHDN: phased mandatory e-invoicing via MyInvois platform'),
    ('EM_011', 'MX', 'CFDI 4.0',               'XML',          '2022-01-01', TRUE,  'Pre-clearance', 'Mexico: Comprobante Fiscal Digital por Internet via SAT'),
    ('EM_012', 'TR', 'e-Fatura',                'UBL-TR',       '2014-04-01', TRUE,  'Pre-clearance', 'Turkey: mandatory e-invoicing for registered taxpayers via GIB'),
    ('EM_013', 'AU', 'Peppol AU-NZ',            'UBL 2.1',     '2022-07-01', FALSE, 'Post-audit',    'Australia/NZ: voluntary Peppol adoption for B2G; B2B encouraged'),
    ('EM_014', 'SG', 'InvoiceNow',             'UBL 2.1',     '2024-11-01', FALSE, 'Post-audit',    'Singapore: Peppol-based InvoiceNow; voluntary but government-promoted'),
    ('EM_015', 'NO', 'EHF / Peppol',           'UBL 2.1',     '2019-04-01', TRUE,  'Post-audit',    'Norway: mandatory e-invoicing for B2G via Peppol/EHF format'),
    ('EM_016', 'SE', 'Peppol SE',              'UBL 2.1',     '2019-04-01', TRUE,  'Post-audit',    'Sweden: mandatory e-invoicing for B2G via Peppol network'),
    ('EM_017', 'CO', 'Facturacion Electronica', 'UBL 2.1',     '2019-01-01', TRUE,  'Pre-clearance', 'Colombia: mandatory e-invoicing validated by DIAN'),
    ('EM_018', 'CL', 'DTE',                    'XML',          '2014-11-01', TRUE,  'Pre-clearance', 'Chile: Documento Tributario Electronico via SII'),
    ('EM_019', 'JP', 'Qualified Invoice System','Local',        '2023-10-01', TRUE,  'Post-audit',    'Japan: qualified invoice preservation system for consumption tax'),
    ('EM_020', 'KR', 'e-Tax Invoice',          'XML',          '2011-01-01', TRUE,  'Pre-clearance', 'South Korea: mandatory e-tax invoice issuance via NTS HomeTax');

-- =============================================================================
-- ITIL_SERVICE_METRICS (ITIL 4 KPI definitions)
-- =============================================================================
INSERT INTO ITIL_SERVICE_METRICS (METRIC_ID, METRIC_NAME, ITIL_PRACTICE, MEASUREMENT_FORMULA, TARGET_THRESHOLD, UNIT, DESCRIPTION)
VALUES
    ('ITIL_001', 'Service Availability',         'Service Level Management',    'uptime_minutes / total_minutes * 100',          99.9,   'percent',  'Percentage of time service is available and functional'),
    ('ITIL_002', 'Mean Time to Restore (MTTR)',  'Incident Management',         'SUM(restore_time) / COUNT(incidents)',           60,     'minutes',  'Average time to restore service after an incident'),
    ('ITIL_003', 'Mean Time Between Failures',   'Problem Management',          'total_uptime / COUNT(failures)',                 720,    'hours',    'Average time between service failures'),
    ('ITIL_004', 'Incident Rate',                'Incident Management',         'COUNT(incidents) / time_period',                 5,      'per_day',  'Number of incidents per time period'),
    ('ITIL_005', 'SLA Compliance Rate',          'Service Level Management',    'COUNT(met_SLAs) / COUNT(total_SLAs) * 100',     95,     'percent',  'Percentage of SLA targets met'),
    ('ITIL_006', 'First Contact Resolution',     'Service Desk',                'COUNT(resolved_first) / COUNT(total) * 100',    70,     'percent',  'Percentage of issues resolved on first contact'),
    ('ITIL_007', 'Change Success Rate',          'Change Enablement',           'COUNT(successful_changes) / COUNT(total) * 100',95,     'percent',  'Percentage of changes implemented without incident'),
    ('ITIL_008', 'Problem Resolution Time',      'Problem Management',          'AVG(resolution_time)',                           48,     'hours',    'Average time to resolve identified problems'),
    ('ITIL_009', 'Customer Satisfaction',         'Service Level Management',    'AVG(CSAT_score)',                                4.0,    'score_1_5','Average customer satisfaction score (1-5 scale)'),
    ('ITIL_010', 'Throughput Rate',              'Service Design',              'COUNT(processed_items) / time_period',           1000,   'per_hour', 'Processing throughput rate per time period'),
    ('ITIL_011', 'Error Rate',                   'Incident Management',         'COUNT(errors) / COUNT(total_requests) * 100',   1.0,    'percent',  'Percentage of requests resulting in errors'),
    ('ITIL_012', 'Queue Depth',                  'Service Design',              'COUNT(items_in_queue)',                           500,    'items',    'Number of items waiting for processing'),
    ('ITIL_013', 'Response Time (P95)',          'Service Level Management',    'PERCENTILE(response_time, 0.95)',                500,    'ms',       '95th percentile response time'),
    ('ITIL_014', 'Deployment Frequency',         'Deployment Management',       'COUNT(deployments) / time_period',               2,      'per_week', 'Frequency of production deployments'),
    ('ITIL_015', 'Capacity Utilization',         'Capacity and Performance',    'current_load / max_capacity * 100',              80,     'percent',  'Percentage of total capacity currently in use');

-- =============================================================================
-- INDUSTRY_CLASSIFICATION (NAICS + APQC mapping)
-- =============================================================================
INSERT INTO INDUSTRY_CLASSIFICATION (INDUSTRY_ID, INDUSTRY_NAME, NAICS_CODE, APQC_PROCESS_FOCUS, TYPICAL_DOCUMENT_TYPES, REGULATORY_BODY)
VALUES
    ('IND_001', 'Banking & Financial Services', '522',   'AP/AR (9.3), KYC/Onboarding (3.5), Loan Origination (9.2)',    'Invoice, Application, Contract, Bank Statement, Identity Document, Tax Document',    'OCC, FDIC, SEC, FinCEN'),
    ('IND_002', 'Insurance',                    '524',   'Claims (11.1.3), Underwriting (11.2.1), Renewals (11.2.2)',     'Claim Form, Insurance Policy, Application, Medical Record, Identity Document',       'State Insurance Depts, NAIC, Lloyds'),
    ('IND_003', 'Healthcare',                   '621',   'Patient Registration (3.5.3), Claims (11.1.3), Prior Auth',    'Medical Record, Claim Form, Prescription, Application, Insurance Policy',            'CMS, HHS/OCR (HIPAA), State Health Depts'),
    ('IND_004', 'Government & Public Sector',   '921',   'Digital Mail (8.4.2), Tax Processing (9.5.1), Benefits (6.1.2)','Government Form, Tax Document, Identity Document, Application, Contract',            'GAO, OMB, State/Local Agencies'),
    ('IND_005', 'Supply Chain & Manufacturing', '336',   'PO Matching (9.3.1), Shipping (4.3.2), Supplier Onboard (4.2.1)','Invoice, Purchase Order, Shipping Document, Customs Declaration, Receipt',          'CBP, FDA, OSHA, ISO');

-- =============================================================================
-- GDPR_DATA_CATEGORIES (PII/PHI classification for extraction)
-- =============================================================================
INSERT INTO GDPR_DATA_CATEGORIES (CATEGORY_ID, CATEGORY_NAME, SENSITIVITY_LEVEL, RETENTION_DAYS, APPLICABLE_REGULATIONS, EXTRACTION_FLAG, DESCRIPTION)
VALUES
    ('GDPR_001', 'Full Name',                    'Standard',  1095, 'GDPR Art.6, CCPA',            TRUE,  'First and last name of natural persons'),
    ('GDPR_002', 'Email Address',                'Standard',  1095, 'GDPR Art.6, CCPA',            TRUE,  'Personal or business email addresses'),
    ('GDPR_003', 'Physical Address',             'Standard',  1095, 'GDPR Art.6, CCPA',            TRUE,  'Street address, city, postal code, country'),
    ('GDPR_004', 'Phone Number',                 'Standard',  1095, 'GDPR Art.6, CCPA',            TRUE,  'Personal or business telephone numbers'),
    ('GDPR_005', 'Date of Birth',                'Standard',  1095, 'GDPR Art.6, CCPA',            TRUE,  'Birth date used for identity verification'),
    ('GDPR_006', 'National ID / SSN',            'High',      365,  'GDPR Art.9, CCPA, HIPAA',     TRUE,  'Government-issued identification numbers'),
    ('GDPR_007', 'Tax ID / VAT Number',          'High',      2555, 'GDPR Art.6, Tax Regulations', TRUE,  'Tax identification or VAT registration numbers'),
    ('GDPR_008', 'Bank Account / IBAN',          'High',      1095, 'GDPR Art.6, PSD2',            TRUE,  'Bank account numbers and routing information'),
    ('GDPR_009', 'Credit Card Number',           'High',      90,   'GDPR Art.6, PCI-DSS',         TRUE,  'Payment card numbers (must be masked/tokenized)'),
    ('GDPR_010', 'Health/Medical Data',          'Special',   2555, 'GDPR Art.9, HIPAA',           TRUE,  'Diagnosis, treatment, medication, lab results'),
    ('GDPR_011', 'Biometric Data',               'Special',   365,  'GDPR Art.9, BIPA',            FALSE, 'Fingerprints, facial recognition, iris scans'),
    ('GDPR_012', 'Racial/Ethnic Origin',         'Special',   365,  'GDPR Art.9',                  FALSE, 'Data revealing racial or ethnic origin'),
    ('GDPR_013', 'Political Opinions',           'Special',   365,  'GDPR Art.9',                  FALSE, 'Data revealing political opinions or affiliations'),
    ('GDPR_014', 'Salary/Compensation',          'Standard',  1095, 'GDPR Art.6, Employment Law',  TRUE,  'Salary, wages, bonuses, compensation details'),
    ('GDPR_015', 'Signature',                    'Standard',  2555, 'GDPR Art.6, eIDAS',           TRUE,  'Handwritten or electronic signatures on documents');

-- =============================================================================
-- OCR_MODEL_REGISTRY (internal model versions)
-- =============================================================================
INSERT INTO OCR_MODEL_REGISTRY (MODEL_ID, MODEL_NAME, VERSION, TRAINED_DATE, ACCURACY_SCORE, DOCUMENT_TYPES_SUPPORTED, DESCRIPTION)
VALUES
    ('OCR_001', 'OmniPage Core OCR',            'v3.2.1',      '2024-03-15', 0.943, 'Invoice, Receipt, Purchase Order, Tax Document',              'Production baseline model for structured documents'),
    ('OCR_002', 'OmniPage Core OCR',            'v3.3.0',      '2024-07-22', 0.957, 'Invoice, Receipt, Purchase Order, Tax Document, Contract',    'Improved table extraction and multi-language support'),
    ('OCR_003', 'OmniPage Core OCR',            'v3.4.0',      '2025-01-10', 0.968, 'All document types',                                          'Major accuracy improvement with transformer-based extraction'),
    ('OCR_004', 'OmniPage Core OCR',            'v4.0.0-beta', '2025-06-01', 0.972, 'All document types',                                          'Next-gen model with generative AI enhancement (beta)'),
    ('OCR_005', 'TotalAgility Classifier',       'v2.1.0',      '2024-02-01', 0.912, 'Invoice, Claim Form, Application, Contract, Government Form','Multi-class document classifier for routing'),
    ('OCR_006', 'TotalAgility Classifier',       'v2.2.0',      '2024-08-15', 0.935, 'All 20 document types',                                      'Extended coverage with few-shot learning'),
    ('OCR_007', 'TotalAgility Classifier',       'v2.3.0',      '2025-03-01', 0.948, 'All 20 document types',                                      'Improved confidence calibration and edge-case handling'),
    ('OCR_008', 'InvoiceAgility Extractor',      'v1.5.0',      '2024-04-01', 0.961, 'Invoice, Credit Note, Remittance Advice',                    'Specialized invoice field extraction optimized for AP'),
    ('OCR_009', 'InvoiceAgility Extractor',      'v1.6.0',      '2024-11-01', 0.974, 'Invoice, Credit Note, Remittance Advice, Purchase Order',    'Added PO matching fields and multi-currency support'),
    ('OCR_010', 'InvoiceAgility Extractor',      'v1.7.0',      '2025-05-15', 0.981, 'Invoice, Credit Note, Remittance Advice, Purchase Order',    'Highest accuracy release with UBL field mapping');

-- =============================================================================
-- Verify reference data counts
-- =============================================================================
SELECT 'APQC_PROCESS_TAXONOMY' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM APQC_PROCESS_TAXONOMY
UNION ALL SELECT 'DUBLIN_CORE_DOCUMENT_TYPES', COUNT(*) FROM DUBLIN_CORE_DOCUMENT_TYPES
UNION ALL SELECT 'UBL_INVOICE_ELEMENTS', COUNT(*) FROM UBL_INVOICE_ELEMENTS
UNION ALL SELECT 'EINVOICE_MANDATE_REGISTRY', COUNT(*) FROM EINVOICE_MANDATE_REGISTRY
UNION ALL SELECT 'ITIL_SERVICE_METRICS', COUNT(*) FROM ITIL_SERVICE_METRICS
UNION ALL SELECT 'INDUSTRY_CLASSIFICATION', COUNT(*) FROM INDUSTRY_CLASSIFICATION
UNION ALL SELECT 'GDPR_DATA_CATEGORIES', COUNT(*) FROM GDPR_DATA_CATEGORIES
UNION ALL SELECT 'OCR_MODEL_REGISTRY', COUNT(*) FROM OCR_MODEL_REGISTRY
ORDER BY TABLE_NAME;
