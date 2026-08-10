<img src="Snowflake_Logo.svg" width="200">

# Agent Setup Guide — Tungsten Automation Intelligence Agent

## Prerequisites

1. Snowflake account with ACCOUNTADMIN role (or custom role with CREATE DATABASE, CREATE WAREHOUSE, CREATE CORTEX SEARCH SERVICE, CREATE AGENT privileges)
2. Cortex AI features enabled in your region
3. A warehouse for processing (X-SMALL is sufficient)

## Step-by-Step Deployment

### Step 1: Database and Schema Setup

```sql
-- Execute: sql/setup/01_database_and_schema.sql
-- Creates: TA_INTELLIGENCE database, RAW/ANALYTICS/REFERENCE schemas, TUNGSTEN_AUTOMATION_WH warehouse
```

Verify:
```sql
SHOW SCHEMAS IN DATABASE TA_INTELLIGENCE;
-- Should show: RAW, ANALYTICS, REFERENCE, INFORMATION_SCHEMA, PUBLIC
```

### Step 2: Create Tables

```sql
-- Execute: sql/setup/02_create_tables.sql
-- Creates: 11 tables in RAW schema, 8 tables in REFERENCE schema
```

Verify:
```sql
SELECT TABLE_SCHEMA, COUNT(*) as TABLE_COUNT
FROM TA_INTELLIGENCE.INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
GROUP BY TABLE_SCHEMA;
-- RAW: 11, REFERENCE: 8
```

### Step 3: Generate Synthetic Data

```sql
-- Execute: sql/data/03_generate_synthetic_data.sql
-- Generates: ~500K document processing jobs, 100 customers, 12 months of correlated data
-- Runtime: ~3-5 minutes on X-SMALL warehouse
```

Verify:
```sql
SELECT 'DOCUMENT_PROCESSING_JOBS' as tbl, COUNT(*) as rows FROM TA_INTELLIGENCE.RAW.DOCUMENT_PROCESSING_JOBS
UNION ALL SELECT 'CUSTOMER_DIM', COUNT(*) FROM TA_INTELLIGENCE.RAW.CUSTOMER_DIM
UNION ALL SELECT 'INVOICE_NETWORK_TRANSACTIONS', COUNT(*) FROM TA_INTELLIGENCE.RAW.INVOICE_NETWORK_TRANSACTIONS;
```

### Step 4: Seed Industry Standards

```sql
-- Execute: sql/data/03b_seed_industry_standards.sql
-- Seeds: APQC PCF, Dublin Core, UBL, ITIL, e-Invoice mandates, NAICS, GDPR categories
```

Verify:
```sql
SELECT TABLE_NAME, ROW_COUNT
FROM TA_INTELLIGENCE.INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'REFERENCE';
```

### Step 5: Create Analytical Views

```sql
-- Execute: sql/views/04_create_views.sql
-- Creates: Analytical views joining RAW + REFERENCE data per domain
```

### Step 6: Create Semantic Views

```sql
-- Execute: sql/views/05_create_semantic_views.sql
-- Creates: 6 domain-specific semantic views for Cortex Analyst
```

Verify:
```sql
SHOW SEMANTIC VIEWS IN SCHEMA TA_INTELLIGENCE.ANALYTICS;
-- Should show 6 semantic views
```

### Step 7: Create Cortex Search Services

```sql
-- Execute: sql/search/06_create_cortex_search.sql
-- Creates: 2 Cortex Search services (product docs + standards/compliance)
```

Verify:
```sql
SHOW CORTEX SEARCH SERVICES IN SCHEMA TA_INTELLIGENCE.ANALYTICS;
```

### Step 8: Train ML Models

Upload `notebooks/07_ml_models.ipynb` to Snowsight Notebooks and execute all cells. This trains 4 models and registers them in the Snowflake Model Registry.

Verify:
```sql
SHOW MODELS IN SCHEMA TA_INTELLIGENCE.ANALYTICS;
-- Should show: CHURN_RISK_MODEL, EXTRACTION_ACCURACY_MODEL, INVOICE_ANOMALY_MODEL, CAPACITY_FORECAST_MODEL
```

### Step 9: Create ML Model UDFs

```sql
-- Execute: sql/models/08_ml_model_functions.sql
-- Creates: 4 UDFs that call registered ML models
```

### Step 10: Create the Agent

```sql
-- Execute: sql/agent/09_create_agent.sql
-- Creates: TUNGSTEN_AUTOMATION_AGENT with all tools wired
```

Verify:
```sql
SHOW AGENTS IN SCHEMA TA_INTELLIGENCE.ANALYTICS;
-- Test the agent:
-- Navigate to Snowflake Intelligence in Snowsight and select the agent
```

## Testing the Agent

Try these questions to validate each domain:

1. **Document Processing:** "What is the average extraction accuracy by product this month?"
2. **Workflow Automation:** "Which workflows have the highest failure rates?"
3. **Invoice Network:** "How many e-invoices were processed by country this quarter?"
4. **Customer Health:** "Which customers have declining usage month over month?"
5. **Platform Operations:** "Show platform availability by region for the last week."
6. **Revenue:** "What is total ARR by product family?"
7. **ML Prediction:** "Which customers are at highest churn risk?"
8. **Standards Search:** "Which APQC processes relate to accounts payable?"

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Agent creation fails | Ensure Cortex Agent is enabled in your region |
| Semantic view errors | Check that all analytical views exist first |
| Search service timeout | Increase warehouse size temporarily |
| ML model not found | Re-run notebook; check Model Registry |
