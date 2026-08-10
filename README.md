<img src="Snowflake_Logo.svg" width="200">

# Tungsten Automation Intelligence Agent

A Snowflake Intelligence Agent that unifies platform operations data across Tungsten Automation's product ecosystem — enabling natural-language queries over document processing performance, workflow automation metrics, e-Invoice Network analytics, customer health, platform operations, and revenue insights.

## Architecture Overview

The agent consolidates data from 6 business domains into a governed analytics platform:

| Domain | Semantic View | Key Questions |
|--------|--------------|---------------|
| Document Processing | `TA_DOCUMENT_PROCESSING_SV` | Extraction accuracy, classification performance, OCR throughput |
| Workflow Automation | `TA_WORKFLOW_AUTOMATION_SV` | TotalAgility completion times, failure rates, process automation |
| Invoice Network | `TA_INVOICE_NETWORK_SV` | e-Invoice volumes, compliance rates, delivery metrics |
| Customer Health | `TA_CUSTOMER_HEALTH_SV` | Usage trends, support CSAT, churn signals |
| Platform Operations | `TA_PLATFORM_OPERATIONS_SV` | Availability, error rates, capacity metrics |
| Revenue & Business | `TA_REVENUE_BUSINESS_SV` | ARR, retention, subscription growth |

## Quick Start

Execute SQL files in order against your Snowflake account:

```bash
# 1. Database setup
snowsql -f sql/setup/01_database_and_schema.sql
snowsql -f sql/setup/02_create_tables.sql

# 2. Load data
snowsql -f sql/data/03_generate_synthetic_data.sql
snowsql -f sql/data/03b_seed_industry_standards.sql

# 3. Create views
snowsql -f sql/views/04_create_views.sql
snowsql -f sql/views/05_create_semantic_views.sql

# 4. Search services
snowsql -f sql/search/06_create_cortex_search.sql

# 5. ML models (run in Snowflake Notebook)
# Upload notebooks/07_ml_models.ipynb to Snowsight

# 6. ML UDFs and Agent
snowsql -f sql/models/08_ml_model_functions.sql
snowsql -f sql/agent/09_create_agent.sql
```

## Project Structure

```
/
├── README.md
├── Snowflake_Logo.svg
├── tungsten_automation_agent.md        # Project template/spec
├── docs/
│   ├── AGENT_SETUP.md
│   ├── DEPLOYMENT_SUMMARY.md
│   ├── questions.md
│   └── images/
│       ├── architecture.svg
│       ├── deployment_flow.svg
│       └── ml_models.svg
├── notebooks/
│   └── 07_ml_models.ipynb
└── sql/
    ├── setup/
    │   ├── 01_database_and_schema.sql
    │   └── 02_create_tables.sql
    ├── data/
    │   ├── 03_generate_synthetic_data.sql
    │   └── 03b_seed_industry_standards.sql
    ├── views/
    │   ├── 04_create_views.sql
    │   └── 05_create_semantic_views.sql
    ├── search/
    │   └── 06_create_cortex_search.sql
    ├── models/
    │   └── 08_ml_model_functions.sql
    └── agent/
        └── 09_create_agent.sql
```

## Agent Tools

| Tool | Type | Purpose |
|------|------|---------|
| DocumentProcessingAnalyst | cortex_analyst_text_to_sql | IDP operations queries |
| WorkflowAutomationAnalyst | cortex_analyst_text_to_sql | Workflow/RPA queries |
| InvoiceNetworkAnalyst | cortex_analyst_text_to_sql | e-Invoice analytics |
| CustomerHealthAnalyst | cortex_analyst_text_to_sql | Customer engagement queries |
| PlatformOperationsAnalyst | cortex_analyst_text_to_sql | Platform health queries |
| RevenueBusinessAnalyst | cortex_analyst_text_to_sql | Financial/ARR queries |
| ProductDocsSearch | cortex_search | Product knowledge base |
| StandardsComplianceSearch | cortex_search | APQC/UBL/ITIL/GDPR standards |
| PredictChurnRisk | generic (UDF) | Customer churn prediction |
| PredictExtractionAccuracy | generic (UDF) | Extraction accuracy forecast |
| DetectInvoiceAnomaly | generic (UDF) | Invoice anomaly detection |
| ForecastCapacity | generic (UDF) | Platform capacity planning |

## Industry Standards Integrated

- **APQC PCF v7.4** — Business process classification
- **Dublin Core (ISO 15836)** — Document type metadata
- **OASIS UBL 2.1 / Peppol BIS 3.0** — Invoice data elements
- **ITIL 4** — Service management KPIs
- **NAICS** — Industry classification
- **GDPR / CCPA / HIPAA** — Data privacy categories

## Prerequisites

- Snowflake account with ACCOUNTADMIN or equivalent privileges
- Warehouse (X-SMALL is sufficient for demo)
- Cortex AI features enabled (Agent, Analyst, Search)
