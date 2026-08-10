<img src="Snowflake_Logo.svg" width="200">

# Deployment Summary — Tungsten Automation Intelligence Agent

## Deployment Status

| Component | File | Status | Notes |
|-----------|------|--------|-------|
| Database & Schemas | `01_database_and_schema.sql` | Not Deployed | TA_INTELLIGENCE, RAW/ANALYTICS/REFERENCE |
| Table Definitions | `02_create_tables.sql` | Not Deployed | 19 tables (11 RAW + 8 REFERENCE) |
| Synthetic Data | `03_generate_synthetic_data.sql` | Not Deployed | ~500K doc jobs, 100 customers, 12 months |
| Reference Data | `03b_seed_industry_standards.sql` | Not Deployed | APQC, Dublin Core, UBL, ITIL, NAICS, GDPR |
| Analytical Views | `04_create_views.sql` | Not Deployed | Domain-specific analytical views |
| Semantic Views | `05_create_semantic_views.sql` | Not Deployed | 6 domain-specific semantic views |
| Cortex Search | `06_create_cortex_search.sql` | Not Deployed | 2 search services |
| ML Models | `07_ml_models.ipynb` | Not Deployed | 4 models (churn, accuracy, anomaly, capacity) |
| ML UDFs | `08_ml_model_functions.sql` | Not Deployed | 4 UDFs calling registered models |
| Agent | `09_create_agent.sql` | Not Deployed | 12 tools (6 Analyst + 2 Search + 4 UDF) |

## Environment Details

| Property | Value |
|----------|-------|
| Database | `TA_INTELLIGENCE` |
| Warehouse | `TUNGSTEN_AUTOMATION_WH` |
| Warehouse Size | X-SMALL |
| Agent Name | `TUNGSTEN_AUTOMATION_AGENT` |
| Target Account | AWS161 |

## Semantic Views

| View Name | Domain | Tables Covered |
|-----------|--------|----------------|
| `TA_DOCUMENT_PROCESSING_SV` | IDP Operations | Jobs, Extraction, Classification, Dublin Core |
| `TA_WORKFLOW_AUTOMATION_SV` | Workflow/RPA | Workflow Instances, APQC Taxonomy |
| `TA_INVOICE_NETWORK_SV` | e-Invoice Network | Transactions, UBL Elements, Mandates |
| `TA_CUSTOMER_HEALTH_SV` | Customer Engagement | Subscriptions, Usage, Support Tickets |
| `TA_PLATFORM_OPERATIONS_SV` | Platform Health | Health Metrics, ITIL KPIs |
| `TA_REVENUE_BUSINESS_SV` | Revenue/Finance | Subscriptions, Usage, Industry |

## ML Models

| Model | Type | Target |
|-------|------|--------|
| `CHURN_RISK_MODEL` | Binary Classification | Customer churn in 90 days |
| `EXTRACTION_ACCURACY_MODEL` | Regression | Expected extraction accuracy % |
| `INVOICE_ANOMALY_MODEL` | Anomaly Detection | Unusual invoice patterns |
| `CAPACITY_FORECAST_MODEL` | Time-Series Regression | Queue depth forecast by region |

## Data Volumes (Expected)

| Table | Estimated Rows |
|-------|---------------|
| DOCUMENT_PROCESSING_JOBS | ~500,000 |
| EXTRACTION_RESULTS | ~2,000,000 |
| CLASSIFICATION_EVENTS | ~500,000 |
| WORKFLOW_INSTANCES | ~150,000 |
| INVOICE_NETWORK_TRANSACTIONS | ~800,000 |
| CUSTOMER_SUBSCRIPTIONS | 100 |
| CUSTOMER_USAGE_METRICS | ~36,500 |
| SUPPORT_TICKETS | ~5,000 |
| PLATFORM_HEALTH_METRICS | ~52,000 |
| CUSTOMER_DIM | 100 |
| PRODUCT_DIM | 6 |
