# Snowflake Intelligence Agent Project Template

## Purpose
Intelligent Document Processing & Workflow Automation Operations Intelligence at Tungsten Automation

Tungsten Automation (formerly Kofax) is the global leader in AI-powered intelligent document processing (IDP) and workflow automation, serving 25,000+ enterprise customers across banking, insurance, healthcare, government, and supply chain verticals. Its product portfolio spans the full document lifecycle — capture, classification, extraction, validation, workflow orchestration, and delivery — powered by industry-leading OCR (OmniPage), low-code process design (TotalAgility), AP automation (InvoiceAgility, AP Agility), a global e-Invoice Network, RPA, print management (ControlSuite/Printix), and PDF editing (Power PDF). The business runs on massive document volumes flowing through heterogeneous enterprise systems: invoices from thousands of suppliers in dozens of formats, claims in insurance, patient records in healthcare, citizen forms in government — each requiring classification, data extraction, validation, and routing. Today, operational analytics across this platform ecosystem are fragmented across product telemetry, customer usage databases, support systems, and finance tools. This project builds a natural-language intelligence agent that consolidates platform operations, customer engagement, document processing performance, and revenue analytics so internal teams can ask questions of their business directly — replacing siloed dashboards with governed, AI-driven analytics.

## Customer details
About Tungsten Automation
Tungsten Automation (renamed from Kofax in January 2024) is the trusted choice in workflow automation with a 40-year legacy of innovation. Recognized as a Leader in the 2025 Gartner Magic Quadrant for Intelligent Document Processing, the company serves enterprises across regulated industries worldwide.

Product portfolio
Tungsten Automation's product suite addresses three core domains:

1. **Workflow Automation** — TotalAgility: a low-code intelligent automation platform combining IDP, process modeling, workflow orchestration, case management, AI, RPA, business rules, e-signature, and analytics. Used across banking, insurance, healthcare, supply chain, and government.

2. **Invoice & Financial Process Automation** — InvoiceAgility, AP Agility, e-Invoice Network, Process Director: end-to-end AP/AR automation from invoice capture through three-way matching, approval, and payment posting. The Tungsten e-Invoice Network connects businesses, suppliers, and financial institutions globally for compliant electronic invoice exchange.

3. **Document Automation & Security** — OmniPage (market-leading OCR/document processing SDK), ControlSuite (serverless print/capture), Printix (cloud print management), Power PDF (enterprise PDF editing), PaperPort (document management).

Industries served
- Banking & Financial Services (KYC, loan origination, account opening, compliance)
- Insurance (claims processing, underwriting, policy administration)
- Healthcare (patient registration, claims, prior authorization)
- Government & Public Sector (citizen services, digitization of archives, benefits processing)
- Supply Chain & Manufacturing (purchase orders, shipping documents, supplier onboarding)

The data reality
- Platform telemetry scattered across TotalAgility process analytics, InvoiceAgility dashboards, e-Invoice Network monitoring, and separate product databases.
- No single consolidated view of cross-product document processing volumes, accuracy rates, and customer health.
- Customer engagement data (support tickets, NPS, usage metrics) lives in separate CRM/support systems.
- Revenue and subscription data in ERP/billing systems disconnected from product usage.
- The ideal end state: unified operational intelligence enabling product, customer success, and finance teams to query cross-platform metrics in natural language.

Strategic direction
Tungsten Automation is accelerating its AI-first strategy with the Tungsten Automation Platform (TAP), embedding purposeful AI throughout the product portfolio. This agent demonstrates how Snowflake Intelligence can unify operational data across the product ecosystem to drive data-informed decisions on product investment, customer health, and operational efficiency.

---

## Customer Configuration

**To create a new project, replace these variables throughout:**

| Variable | Description | Example (Tungsten Automation) |
|----------|-------------|-------------------|
| `{CUSTOMER_NAME}` | Customer name | Tungsten Automation |
| `{CUSTOMER_NAME_UPPER}` | Uppercase for SQL objects | TUNGSTEN_AUTOMATION |
| `{DATABASE_NAME}` | Main database name | TA_INTELLIGENCE |
| `{WAREHOUSE_NAME}` | Warehouse name | TUNGSTEN_AUTOMATION_WH |
| `{AGENT_NAME}` | Agent identifier | TUNGSTEN_AUTOMATION_AGENT |
| `{BUSINESS_DOMAIN}` | Customer's business focus | Intelligent Document Processing, Workflow Automation & Enterprise Platform Operations |
| `{WEB_PRESENCE}` | Web Address | https://www.tungstenautomation.com/ |

---

## Project Instructions

```Build a complete Snowflake Intelligence architecture and implementation plan for Tungsten Automation.

The proposed architecture is a modern, consolidated analytics platform that unifies fragmented platform operations data (document processing volumes, extraction accuracy, workflow throughput, invoice network transactions, customer health metrics, and revenue/subscription analytics) into a single governed source of truth. Data currently spread across TotalAgility analytics, InvoiceAgility monitoring, e-Invoice Network telemetry, OmniPage processing logs, support/CRM systems, and billing/ERP is landed in Snowflake so that product managers, customer success teams, and executives can ask questions of their operations with Natural Language Queries — spanning the full document lifecycle from capture to delivery and out to customer outcomes.

(Note: All project images should be SVG graphics)
 This Project should encompass all aspects of the details identified on their website. The Agent Project Structure directories should be created in the root github repo directory.

## Agent Project Structure

```
/
├── README.md                           # Project overview and setup instructions
├── docs/
│   ├── AGENT_SETUP.md                 # Step-by-step agent configuration guide
│   ├── DEPLOYMENT_SUMMARY.md          # Current deployment status
│   ├── questions.md                   # 30+ complex test questions
│   └── images/
│       ├── architecture.svg           # System architecture diagram
│       ├── deployment_flow.svg        # Deployment workflow diagram
│       └── ml_models.svg              # ML pipeline visualization
├── notebooks/
│   └── 07_ml_models.ipynb      # ML model training (optional)
└── sql/
    ├── setup/
    │   ├── 01_database_and_schema.sql # Database, schemas (RAW, ANALYTICS, REFERENCE), warehouse
    │   └── 02_create_tables.sql       # All table definitions (incl. REFERENCE ontology/regulatory tables)
    ├── data/
    │   ├── 03_generate_synthetic_data.sql # Test data generation
    │   └── 03b_seed_industry_standards.sql # Seed APQC PCF, Dublin Core, UBL/Peppol, ITIL reference data
    ├── views/
    │   ├── 04_create_views.sql        # Analytical views
    │   └── 05_create_semantic_views.sql # Semantic views for Cortex Analyst
    ├── search/
    │   └── 06_create_cortex_search.sql # Cortex Search services (product docs + compliance text)
    ├── models/
    │   └── 08_ml_model_functions.sql  # ML prediction views and agent functions
    └── agent/
        └── 09_create_agent.sql        # Agent creation script
```

---

## File Execution Order

**MUST be executed in this exact order:**

These are examples of what is required. You may need to add more project defined project. The documentation should have an SVG image showing the project flow.

1. `sql/setup/01_database_and_schema.sql`
2. `sql/setup/02_create_tables.sql`
3. `sql/data/03_generate_synthetic_data.sql`
3b. `sql/data/03b_seed_industry_standards.sql`
4. `sql/views/04_create_views.sql`
5. `sql/views/05_create_semantic_views.sql`
6. `sql/search/06_create_cortex_search.sql`
7. `notebooks/07_ml_models.ipynb`
8. `sql/models/08_ml_model_functions.sql`
9. `sql/agent/09_create_agent.sql`

---

## Suggested Data Model (Intelligent Document Processing & Platform Operations)

The synthetic data should model the Tungsten Automation platform ecosystem end to end. Suggested core tables (in a RAW schema, surfaced through ANALYTICS views):

| Table | Grain | Key fields |
|-------|-------|-----------|
| `DOCUMENT_PROCESSING_JOBS` | one row per document processed | job_id, document_type, product (TotalAgility/OmniPage/AP Agility), customer_id, received_ts, completed_ts, page_count, status |
| `EXTRACTION_RESULTS` | job × field extracted | job_id, field_name, extracted_value, confidence_score, validation_status, manual_correction_flag |
| `CLASSIFICATION_EVENTS` | one row per classification decision | event_id, job_id, predicted_class, confidence_score, actual_class, model_version |
| `WORKFLOW_INSTANCES` | one row per workflow execution | instance_id, workflow_name, product, customer_id, start_ts, end_ts, status, steps_completed, steps_total |
| `INVOICE_NETWORK_TRANSACTIONS` | one row per e-invoice exchanged | transaction_id, sender_id, receiver_id, invoice_number, amount, currency, country_code, compliance_standard, status, submitted_ts, delivered_ts |
| `CUSTOMER_SUBSCRIPTIONS` | one row per customer × product | subscription_id, customer_id, product, tier, start_date, renewal_date, arr_usd, document_volume_limit |
| `CUSTOMER_USAGE_METRICS` | customer × product × day | customer_id, product, usage_date, documents_processed, pages_processed, api_calls, active_users |
| `SUPPORT_TICKETS` | one row per support case | ticket_id, customer_id, product, severity, category, opened_ts, resolved_ts, resolution_type, csat_score |
| `PLATFORM_HEALTH_METRICS` | product × region × hour | product, region, metric_hour, availability_pct, avg_response_ms, error_rate, queue_depth |
| `CUSTOMER_DIM` | one row per customer | customer_id, customer_name, industry, country, segment (enterprise/mid-market/SMB), account_manager |
| `PRODUCT_DIM` | one row per product | product_id, product_name, product_family, deployment_model (cloud/on-prem/hybrid) |

This lets the agent answer both operational questions (document processing volumes, accuracy, throughput, platform health) and business questions (customer health, ARR, churn risk, usage trends), and connect platform performance to customer outcomes — the exact capability gap in fragmented product analytics.

### Reference / Ontology & Standards tables (REFERENCE schema)

These tables hold controlled vocabularies, industry ontologies, and compliance reference data. They are seeded (not synthetically generated) in `03b_seed_industry_standards.sql` and joined to the operational tables above so the agent reasons in standardized, industry-recognized terms.

| Table | Grain | Key fields | Source standard |
|-------|-------|-----------|-----------------|
| `APQC_PROCESS_TAXONOMY` | one row per APQC PCF process element | process_id, process_name, level (1-5), parent_id, category_code, description | APQC Process Classification Framework v7.4 |
| `DUBLIN_CORE_DOCUMENT_TYPES` | one row per document type class | dc_type_id, dc_type_label, dc_format, dc_subject_category, parent_type, industry_applicability | Dublin Core Metadata Element Set (ISO 15836) |
| `UBL_INVOICE_ELEMENTS` | one row per canonical invoice data element | element_id, element_name, ubl_path, data_type, cardinality, description, peppol_subset_flag | OASIS UBL 2.1 / Peppol BIS 3.0 |
| `EINVOICE_MANDATE_REGISTRY` | one row per country e-invoicing mandate | mandate_id, country_code, standard_name, format (UBL/CII/local), effective_date, mandatory_flag, clearance_model | Global e-invoicing mandates (EU ViDA, Italy SDI, India GST, Brazil NFe, Saudi ZATCA) |
| `ITIL_SERVICE_METRICS` | one row per ITIL 4 KPI definition | metric_id, metric_name, itil_practice, measurement_formula, target_threshold, unit | ITIL 4 Service Value System |
| `INDUSTRY_CLASSIFICATION` | one row per industry vertical | industry_id, industry_name, naics_code, apqc_process_focus, typical_document_types, regulatory_body | NAICS + APQC mapping |
| `GDPR_DATA_CATEGORIES` | one row per PII/sensitive data category | category_id, category_name, sensitivity_level, retention_days, applicable_regulations, extraction_flag | GDPR Art. 9 / CCPA / HIPAA |
| `OCR_MODEL_REGISTRY` | one row per ML model version | model_id, model_name, version, trained_date, accuracy_score, document_types_supported | Internal model management |

**How the ontologies connect:**
- `APQC_PROCESS_TAXONOMY` classifies *what business processes* Tungsten's products automate (e.g., "9.3.2 — Process Accounts Payable" maps to InvoiceAgility; "3.5.1 — Manage Customer Onboarding" maps to TotalAgility KYC workflows).
- `DUBLIN_CORE_DOCUMENT_TYPES` classifies *what documents* flow through the IDP pipeline using Dublin Core metadata semantics (Type, Format, Subject), enabling the agent to reason about document classes consistently across products.
- `UBL_INVOICE_ELEMENTS` defines *what fields* exist in a canonical invoice per OASIS UBL 2.1, so the agent can map extracted invoice fields to their standard definitions and identify extraction coverage gaps.
- `EINVOICE_MANDATE_REGISTRY` maps the compliance landscape — which countries mandate which formats by when — so the agent can answer which customers/regions face upcoming regulatory deadlines.
- `ITIL_SERVICE_METRICS` provides standardized KPI definitions (availability, MTTR, incident rate, SLA compliance) for the platform health layer, ensuring the agent uses industry-standard service management vocabulary.

---

## Industry Ontology & Standards Layer

**Why include this:** Tungsten Automation operates at the intersection of document intelligence, business process automation, and global compliance. Layering industry-standard ontologies gives the agent a shared vocabulary across products and customers — enabling it to reason about *what processes* are being automated (APQC), *what documents* are being processed (Dublin Core), *what data elements* are being extracted (UBL), *how the platform is performing* (ITIL), and *what regulations apply* (e-invoicing mandates, GDPR).

**Regulatory framing (important):** Tungsten's products operate under multiple regulatory regimes simultaneously:
- **E-invoicing mandates** vary by country (EU ViDA/Peppol, Italy SDI, India GST e-invoicing, Brazil NFe, Saudi Arabia ZATCA, Malaysia MyInvois) — the e-Invoice Network must comply with all of them.
- **Data privacy** (GDPR, CCPA, HIPAA for healthcare documents) governs how extracted PII is handled.
- **Industry-specific compliance** (SOX for financial documents, HIPAA for healthcare, KYC/AML for banking) determines processing and retention requirements.

### Standards incorporated

1. **APQC Process Classification Framework (PCF) v7.4** — The de-facto cross-industry taxonomy of business processes (~1,500 process elements across 12 top-level categories). Provides the vocabulary for *what* Tungsten's products automate. Key categories:
   - 8.0 — Manage Information Technology (document management, service delivery)
   - 9.0 — Manage Financial Resources (AP, AR, invoicing → InvoiceAgility/AP Agility)
   - 3.0 — Market and Sell Products and Services (customer onboarding, KYC → TotalAgility)
   - 6.0 — Manage Business Rules (workflow orchestration → TotalAgility/RPA)
   - 11.0 — Manage Enterprise Risk, Compliance, Remediation & Resiliency

2. **Dublin Core Metadata Element Set (ISO 15836)** — Standard vocabulary for describing documents (Type, Format, Subject, Creator, Date). Used to classify the documents flowing through Tungsten's IDP pipeline in product-agnostic terms. Enables cross-product document analytics ("how many `Type:Invoice` vs `Type:Claim` vs `Type:Application` documents processed this month?").

3. **OASIS UBL 2.1 / Peppol BIS 3.0 / EN 16931** — Canonical data models for electronic invoices and business documents. UBL defines ~650 data elements for invoices; Peppol BIS is the EU interoperability subset. Maps directly to what InvoiceAgility extracts and validates — the agent can compare extraction coverage against the standard.

4. **ITIL 4 Service Value System** — Industry-standard framework for IT service management KPIs. Provides controlled vocabulary for platform operations metrics: Availability, Mean Time to Restore (MTTR), Incident Rate, SLA Compliance, Change Success Rate, Problem Resolution Time. Used in `PLATFORM_HEALTH_METRICS` and `SUPPORT_TICKETS`.

5. **NAICS + APQC Industry Mapping** — North American Industry Classification for customer segmentation, cross-referenced with APQC's industry-specific PCF variants to identify which processes are most automated per vertical.

6. **GDPR / CCPA / HIPAA** — Privacy and compliance frameworks governing how extracted document data (PII, PHI) is handled, retained, and purged. `GDPR_DATA_CATEGORIES` maps which extraction fields contain sensitive data categories.

7. **ISO 27001 / SOC 2 Type II** — Information security standards relevant to platform operations and customer trust.

### How it plugs into the architecture

- **Process automation backbone:** join `APQC_PROCESS_TAXONOMY` to `WORKFLOW_INSTANCES` so the agent can answer "which APQC Level 3 processes have the highest automation rate?" or "what percentage of our customers' AP processes (APQC 9.3) are fully touchless?"
- **Document classification layer:** join `DUBLIN_CORE_DOCUMENT_TYPES` to `DOCUMENT_PROCESSING_JOBS` and `CLASSIFICATION_EVENTS` so the agent reasons about document types using standard Dublin Core vocabulary rather than product-specific labels.
- **Invoice element coverage:** join `UBL_INVOICE_ELEMENTS` to `EXTRACTION_RESULTS` to measure extraction coverage — "what percentage of UBL mandatory fields are we successfully extracting at >95% confidence?"
- **Compliance landscape:** join `EINVOICE_MANDATE_REGISTRY` to `INVOICE_NETWORK_TRANSACTIONS` and `CUSTOMER_DIM` to identify which customers are in countries with upcoming mandate deadlines.
- **Platform health vocabulary:** join `ITIL_SERVICE_METRICS` to `PLATFORM_HEALTH_METRICS` so the agent uses standardized ITIL metric definitions and thresholds when reporting on service performance.
- **Regulatory Cortex Search service:** a Cortex Search service over ontology/compliance text (APQC process descriptions, e-invoicing mandate details, GDPR articles, ITIL practice descriptions) so the agent can answer open-ended questions like "what ITIL practices apply to our incident management?" or "which APQC processes relate to customer onboarding?"
- **Agent tooling:** the standards search is exposed as a `cortex_search` tool alongside the operational Cortex Analyst tool; a scalar UDF can classify a customer's regulatory exposure based on their industry, geography, and products used.

*Reference: APQC PCF (apqc.org), Dublin Core (dublincore.org / ISO 15836), UBL 2.1 (OASIS), Peppol BIS 3.0 (OpenPeppol), ITIL 4 (PeopleCert/Axelos), NAICS (US Census Bureau), GDPR (EU), HIPAA (US HHS). These are external public standards — seed representative reference data; do not fabricate regulatory text as fact.*

---

## Critical Syntax Reference

### Snowflake Agent YAML Specification (VERIFIED WORKING)

```yaml
CREATE OR REPLACE AGENT {AGENT_NAME}
  COMMENT = '{Customer} intelligence agent'
  PROFILE = '{"display_name": "{Customer} Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 60
      tokens: 32000

  instructions:
    response: "Response instructions..."
    orchestration: "Tool routing instructions..."
    system: "System role description..."
    sample_questions:
      - question: "Sample question?"
        answer: "How the agent should respond."

  tools:
    # Cortex Analyst (text-to-SQL)
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "ToolName"
        description: "Description of what this tool does"

    # Cortex Search
    - tool_spec:
        type: "cortex_search"
        name: "SearchName"
        description: "Description of search capability"

    # Custom Function (generic)
    - tool_spec:
        type: "generic"
        name: "FunctionName"
        description: "Description of function output"

  tool_resources:
    # Cortex Analyst resource
    ToolName:
      semantic_view: "{DATABASE}.{SCHEMA}.{SEMANTIC_VIEW_NAME}"

    # Cortex Search resource
    SearchName:
      name: "{DATABASE}.{SCHEMA}.{SEARCH_SERVICE_NAME}"
      max_results: "10"
      title_column: "column_name"
      id_column: "id_column"

    # Custom Function resource
    FunctionName:
      type: "function"
      identifier: "{DATABASE}.{SCHEMA}.{FUNCTION_NAME}"
      execution_environment:
        type: "warehouse"
        warehouse: "{WAREHOUSE_NAME}"
  $$;
```

### SQL UDF Return Types (VERIFIED)

| Function Returns | Correct Return Type |
|------------------|---------------------|
| `ARRAY_AGG(...)` | `RETURNS ARRAY` |
| `OBJECT_CONSTRUCT(...)` | `RETURNS OBJECT` |
| Single scalar value | `RETURNS VARCHAR/NUMBER/etc` |

**DO NOT USE:**
- `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
- `LANGUAGE SQL` clause in SQL UDFs

### SQL UDF Syntax (VERIFIED)

```sql
-- Correct syntax for scalar UDF returning ARRAY
CREATE OR REPLACE FUNCTION AGENT_GET_DATA()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'key1', COLUMN1,
    'key2', COLUMN2
)) FROM (SELECT * FROM TABLE LIMIT 50)
$$;

-- Correct syntax for scalar UDF returning OBJECT
CREATE OR REPLACE FUNCTION AGENT_GET_SUMMARY()
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'metric1', (SELECT COUNT(*) FROM TABLE1),
    'metric2', (SELECT AVG(COLUMN) FROM TABLE2)
)
$$;
```

---

## Lessons Learned (CRITICAL)

### 1. ALWAYS VERIFY SNOWFLAKE SYNTAX BEFORE WRITING CODE

**What went wrong:** Multiple syntax errors because I guessed at syntax instead of verifying against Snowflake documentation.

**Correct approach:**
- Use `snowflake_product_docs` tool to look up syntax BEFORE writing any SQL
- Use `system_instructions` tool for Cortex Agent, Analyst, and other Snowflake products
- Reference working examples

**Specific errors made:**
- Used `RETURNS VARIANT` instead of `RETURNS ARRAY` for `ARRAY_AGG`
- Used `RETURNS VARIANT` instead of `RETURNS OBJECT` for `OBJECT_CONSTRUCT`
- Used `LANGUAGE SQL` clause which is invalid for SQL UDFs
- Used `type: "procedure"` instead of `type: "function"` for agent tools
- Used `search_service:` instead of `name:` for Cortex Search resources
- Used JSON format instead of YAML for agent specification

### 2. COMPLETE ALL FILES BEFORE STOPPING

**What went wrong:** Generated partial files and stopped without completing the project, leaving merge conflicts and incomplete code.

**Correct approach:**
- Review ALL files in the project at the start
- Create a TODO list for every file that needs to be created/modified
- Do not mark a task complete until the file is verified to compile/run
- Verify file completeness before moving to the next task

### 3. NEVER GUESS - ASK OR RESEARCH

**What went wrong:** Made assumptions about:
- Agent YAML syntax
- SQL UDF return types
- Function naming conventions
- Tool resource configuration

**Correct approach:**
- If unsure about syntax, use documentation tools first
- If documentation is unclear, ask the user for clarification
- Reference working examples from similar projects
- Test small pieces of code before combining them

### 4. ASK QUESTIONS WHEN UNCLEAR

**What went wrong:** Proceeded with assumptions instead of asking for clarification on requirements.

**Questions to ask upfront:**
- What business domain/industry is this for?
- What specific ML models or predictions are needed?
- What data sources exist or need to be created?
- What sample questions should the agent answer?
- Are there any existing working examples to reference?

### 5. SEMANTIC VIEWS USE TABLES/DIMENSIONS/METRICS — NOT SELECT...FROM

**What went wrong:** Used regular view syntax (`SELECT ... FROM`) for `CREATE SEMANTIC VIEW`, causing compilation errors (`unexpected 'COMMENT'`, `unexpected 'AS'`).

**Correct approach:**
- Semantic views use `TABLES (...)`, `DIMENSIONS (...)`, and `METRICS (...)` clauses
- They do NOT use `SELECT ... FROM` like regular views
- Each table is declared with `alias AS fully.qualified.table PRIMARY KEY (...)`
- Dimensions are categorical/descriptive columns: `alias.col AS COL_NAME`
- Metrics are numeric/aggregatable columns: `alias.col AS AGG_FUNC(COL_NAME)`
- Synonyms on columns use `WITH SYNONYMS = (...)` (with `=`), on tables use `WITH SYNONYMS (...)` (no `=`)
- ALWAYS use `snowflake_product_docs` to look up `CREATE SEMANTIC VIEW` syntax before writing

### 6. SNOWFLAKE NOTEBOOKS — SESSION AND SQL CELL RULES

**What went wrong:** Wrote Snowflake Notebooks using wrong session management and SQL patterns:
- Used `Session.builder.configs(...).create()` to create sessions (fails in Snowflake Notebooks)
- Used `session.sql("...").to_pandas()` for data queries instead of dedicated SQL cells

**Correct approach:**
- **Session:** ALWAYS use `get_active_session()` — NEVER use `Session.builder`:
  ```python
  from snowflake.snowpark.context import get_active_session
  session = get_active_session()
  ```
- **SQL queries:** ALWAYS use dedicated SQL cells (cell_type: "sql") with `result_variable_name` — NEVER use `session.sql()`
- SQL cell results are automatically available as pandas DataFrames in subsequent Python cells via the `result_variable_name`
- Do NOT call `.to_pandas()` on SQL cell results — they are already DataFrames
- Use `session` only when Snowpark DataFrame operations are genuinely needed (e.g., writing to tables, ML model registry)
- ALWAYS call `get_notebook_guide` before writing any notebook code

**Snowflake Notebook cell pattern:**
```
# SQL cell (cell_type: "sql", result_variable_name: "df_jobs")
SELECT * FROM TA_INTELLIGENCE.RAW.DOCUMENT_PROCESSING_JOBS

# Python cell — reference SQL result directly as pandas DataFrame
print(f'Rows: {len(df_jobs)}')
```

### 8. ML MODELS MUST BE REGISTERED IN MODEL REGISTRY AND CALLED BY UDFs — NO EXCEPTIONS

**What went wrong:** Trained ML models in the notebook but NEVER registered them in the Snowflake Model Registry. The SQL UDFs used hardcoded thresholds instead of calling the trained models. This made the ML models completely disconnected — they existed only in the notebook and were never used by the agent. This is unacceptable and defeats the entire purpose of training ML models.

For a platform operations agent, relevant models might include: document extraction accuracy prediction, customer churn risk classification, workflow completion time forecasting, invoice processing anomaly detection, and platform capacity prediction. Whatever is trained MUST be registered and called by a UDF.

**Correct approach — MANDATORY for every project:**
1. **Notebook MUST register models** using `snowflake.ml.registry.Registry`:
   ```python
   from snowflake.ml.registry import Registry
   registry = Registry(session=session, database_name="DB", schema_name="SCHEMA")
   mv = registry.log_model(
       trained_model,
       model_name="MODEL_NAME",
       version_name="V1",
       sample_input_data=X_train,
       conda_dependencies=["scikit-learn"],
       comment="Model description"
   )
   mv.set_metric("accuracy", score)
   ```

2. **SQL UDFs MUST call registered models** using `MODEL(name, version)!PREDICT(...)`:
   ```sql
   SELECT MODEL(DB.SCHEMA.MODEL_NAME, V1)!PREDICT(col1, col2, ...):output_feature_0::INT
   FROM table;
   ```

3. **NEVER use hardcoded thresholds** as a substitute for ML model predictions in UDFs. If a model was trained, it MUST be registered and called.

4. **Verify the full pipeline** before marking complete: Notebook trains → Notebook registers → UDFs call registered models → Agent invokes UDFs.

**Checklist (MUST complete for every ML model):**
- [ ] Model trained in notebook
- [ ] Model registered via `registry.log_model()`
- [ ] Metrics tracked via `mv.set_metric()`
- [ ] SQL UDF calls model via `MODEL(name, version)!PREDICT(...)`
- [ ] Agent tool references UDF
- [ ] End-to-end pipeline verified

### 7. VERIFY GIT MERGE CONFLICTS

**What went wrong:** Left merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in SQL files.

**Correct approach:**
- After any file operations, verify no merge conflicts exist
- Search for conflict markers before marking files complete
- Test SQL files compile before considering them done

---

## Component Templates

### Database Setup (01_database_and_schema.sql)

```sql
CREATE DATABASE IF NOT EXISTS {DATABASE_NAME};
USE DATABASE {DATABASE_NAME};

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;
CREATE SCHEMA IF NOT EXISTS REFERENCE;

CREATE OR REPLACE WAREHOUSE {WAREHOUSE_NAME} WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for {CUSTOMER_NAME} Intelligence Agent';

USE WAREHOUSE {WAREHOUSE_NAME};
```

### Cortex Search Service

```sql
CREATE OR REPLACE CORTEX SEARCH SERVICE {SEARCH_SERVICE_NAME}
  ON {text_column}
  ATTRIBUTES {attr1}, {attr2}, {attr3}
  WAREHOUSE = {WAREHOUSE_NAME}
  TARGET_LAG = '1 hour'
  COMMENT = 'Description of search service'
AS
  SELECT
    {columns}
  FROM {TABLE};
```

For Tungsten Automation, two Cortex Search services complement the structured Cortex Analyst tool:
1. **Product documentation search** — over product knowledge base articles, feature descriptions, and best practices for TotalAgility, InvoiceAgility, OmniPage, etc.
2. **Industry standards & compliance search** — over APQC process descriptions, UBL element definitions, e-invoicing mandate details, ITIL practice descriptions, GDPR/HIPAA requirements, and Dublin Core type definitions. Enables the agent to answer open-ended ontology questions like "which APQC processes relate to invoice handling?" or "what UBL fields are mandatory for cross-border invoices?"

### Semantic View

```sql
CREATE OR REPLACE SEMANTIC VIEW {SEMANTIC_VIEW_NAME}

  TABLES (
    {alias} AS {database}.{schema}.{table}
      PRIMARY KEY ({primary_key_column})
      WITH SYNONYMS ('{synonym1}', '{synonym2}')
      COMMENT = '{Table description}'
  )

  DIMENSIONS (
    {alias}.{column} AS {COLUMN_NAME}
      WITH SYNONYMS = ('{synonym1}', '{synonym2}')
      COMMENT = '{Column description}'
  )

  METRICS (
    {alias}.{column} AS {AGG_FUNC}({COLUMN_NAME})
      WITH SYNONYMS = ('{synonym1}', '{synonym2}')
      COMMENT = '{Metric description}'
  )

  COMMENT = '{Semantic view description}';
```

**IMPORTANT: Semantic views do NOT use SELECT...FROM syntax. They use TABLES, DIMENSIONS, and METRICS clauses.**

### Snowflake Notebook (07_ml_models.ipynb)

```python
# Cell 1 (Python): Session setup — ONLY way to get session in Snowflake Notebooks
from snowflake.snowpark.context import get_active_session
session = get_active_session()
```

```sql
-- Cell 2 (SQL, result_variable_name: "df_data"): Load data via SQL cell — NOT session.sql()
SELECT * FROM {DATABASE}.{SCHEMA}.{TABLE}
```

```python
# Cell 3 (Python): Use SQL cell result directly as pandas DataFrame
# df_data is already a pandas DataFrame — do NOT call .to_pandas()
print(f'Rows: {len(df_data)}')
```

**IMPORTANT: NEVER use `Session.builder` or `session.sql()` in Snowflake Notebooks. Use `get_active_session()` and dedicated SQL cells.**

---

## Sample Questions the Agent Should Answer (Platform Operations & Business Intelligence)

Document processing operations:
- What is the average extraction accuracy by document type across all products this month?
- Which customers have the highest volume of manual corrections on extracted fields?
- Show document processing throughput (jobs per hour) by product and region for the last 30 days.
- What is the classification accuracy trend by model version for invoice documents this quarter?
- Which document types have confidence scores consistently below 90%, indicating model retraining is needed?

Workflow & platform performance:
- What is the average workflow completion time by workflow type across TotalAgility instances?
- Which workflows have the highest failure/retry rates, and what are the common error categories?
- Show platform availability and error rates by product and region over the last week.
- What is the current queue depth across all processing regions, and which are approaching capacity?

Invoice network & compliance:
- How many e-invoices were processed through the Tungsten Network this quarter, by country and compliance standard?
- Which countries have upcoming e-invoicing mandate deadlines, and how many of our customers are affected?
- What is the average invoice delivery time by sender country, and which corridors have the highest rejection rates?
- Show the three-way matching success rate by customer segment for the last quarter.

Customer health & engagement:
- Which enterprise customers show declining document volumes month over month (potential churn signal)?
- What is the average CSAT score by product and severity level for support tickets this quarter?
- Show the top 10 customers by ARR who have utilization below 50% of their volume limit.
- Which customers are approaching their document volume limit and may need tier upgrades?

Revenue & business:
- What is the total ARR by product family and customer segment?
- Show net revenue retention by industry vertical for the trailing 12 months.
- Which products have the highest growth rate in new customer subscriptions this year?
- Connect document processing volume trends to subscription renewal outcomes — do high-usage customers renew at higher rates?

ML-driven predictions:
- Which customers are at highest risk of churning in the next 90 days based on usage patterns?
- Predict extraction accuracy for a new document type based on similar document characteristics.
- Forecast platform capacity needs by region for next quarter based on growth trends.
- Identify anomalous invoice processing patterns that may indicate fraud or system issues.

These map directly to the operational challenges of running a multi-product SaaS platform at scale: fragmented telemetry, disconnected customer health signals, and the need to connect product performance to business outcomes.

---

## Checklist for New Projects

### Before Starting
- [ ] Confirm customer name and business domain
- [ ] Identify data sources (existing tables or need synthetic data)
- [ ] Determine ML models needed (churn prediction, accuracy forecasting, anomaly detection, capacity planning, etc.)
- [ ] Collect sample questions the agent should answer
- [ ] Get working example project for reference

### During Development
- [ ] Verify ALL SQL syntax against Snowflake docs before writing
- [ ] Test each SQL file compiles before moving to next
- [ ] Check for merge conflicts after any file operations
- [ ] Complete TODO list for every component

### Before Delivery
- [ ] Run all SQL files in order (01-08)
- [ ] Test agent creation succeeds
- [ ] Verify agent responds to sample questions
- [ ] Update documentation with customer-specific details
- [ ] Remove any placeholder values

---

## Reference Links

- Snowflake Agent Docs: `snowflake_product_docs` → "Cortex Agent"
- SQL UDF Reference: `snowflake_product_docs` → "CREATE FUNCTION SQL"
- Cortex Search: `snowflake_product_docs` → "CREATE CORTEX SEARCH SERVICE"
- Semantic Views: `snowflake_product_docs` → "CREATE SEMANTIC VIEW"

---

## Version History

- **v1.0** - Tungsten Automation platform operations & business intelligence agent, adapted from Intelligence Agent project template
- **Created:** August 2026
- **Lessons Learned:** Carried forward from previous project issues

---

## DO NOT:
1. Guess at syntax - VERIFY FIRST
2. Use `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
3. Use `LANGUAGE SQL` in SQL UDFs
4. Use JSON format for Agent specification (use YAML)
5. Leave merge conflicts in files
6. Mark tasks complete before verifying they work
7. Assume you know Snowflake syntax without checking
8. Use text based graphics
9. Use `SELECT ... FROM` syntax in `CREATE SEMANTIC VIEW` — use `TABLES`, `DIMENSIONS`, `METRICS` instead
10. Use `Session.builder.configs(...).create()` in Snowflake Notebooks — use `get_active_session()` instead
11. Use `session.sql()` in Snowflake Notebooks for standard queries — use dedicated SQL cells instead
12. Call `.to_pandas()` on SQL cell results in notebooks — they are already pandas DataFrames
13. Train ML models without registering them in the Snowflake Model Registry
14. Use hardcoded thresholds in SQL UDFs when a trained ML model exists — ALWAYS use `MODEL(name, version)!PREDICT()`
15. Mark ML model tasks complete without verifying the full pipeline: train → register → UDF calls model → agent invokes UDF

## DO:
1. Use `snowflake_product_docs` before writing SQL
2. Use `system_instructions` for Cortex products
3. Reference working examples
4. Ask questions when requirements are unclear
5. Test each file compiles before moving on
6. Complete ALL files before stopping
7. Verify no merge conflicts exist
8. Always generate documentation
9. Always generate SVG images for the documentation.
10. Always generate all files and never placeholders
11. Always put this line of code at the top of all documentation files: <img src="Snowflake_Logo.svg" width="200">
12. In Snowflake Notebooks, ALWAYS use `get_active_session()` for session and dedicated SQL cells for queries
13. ALWAYS call `get_notebook_guide` before writing any notebook code
