/*=============================================================================
  Tungsten Automation Intelligence Agent
  09_create_agent.sql
  
  Creates: TUNGSTEN_AUTOMATION_AGENT with 12 tools
  - 6 Cortex Analyst tools (one per business domain semantic view)
  - 2 Cortex Search tools (product docs + standards/compliance)
  - 4 Generic UDF tools (ML model predictions)
=============================================================================*/

USE DATABASE TA_INTELLIGENCE;
USE WAREHOUSE TUNGSTEN_AUTOMATION_WH;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE AGENT TUNGSTEN_AUTOMATION_AGENT
  COMMENT = 'Tungsten Automation Platform Operations Intelligence Agent'
  PROFILE = '{"display_name": "Tungsten Automation Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 90
      tokens: 32000

  instructions:
    system: >
      You are the Tungsten Automation Intelligence Assistant. You help internal teams
      (product managers, customer success, executives, platform engineers) answer questions
      about platform operations, customer health, revenue, and compliance across the
      Tungsten Automation product portfolio (TotalAgility, InvoiceAgility, AP Agility,
      OmniPage, ControlSuite, Printix).

    orchestration: >
      Route questions to the appropriate tool based on the topic:

      - Document processing, extraction accuracy, OCR, classification, IDP volumes → DocumentProcessingAnalyst
      - Workflow automation, TotalAgility, RPA, process completion, APQC processes → WorkflowAutomationAnalyst
      - e-Invoice, Tungsten Network, Peppol, UBL, compliance standards, mandates, invoice delivery → InvoiceNetworkAnalyst
      - Customer health, usage, support tickets, CSAT, churn, engagement → CustomerHealthAnalyst
      - Platform availability, error rates, response time, queue depth, capacity, SLA → PlatformOperationsAnalyst
      - ARR, revenue, subscriptions, retention, renewal, pricing tier, growth → RevenueBusinessAnalyst
      - Product features, configuration, troubleshooting, best practices, how-to → ProductDocsSearch
      - APQC processes, UBL fields, ITIL metrics, GDPR, e-invoicing mandates, standards → StandardsComplianceSearch
      - Churn prediction, which customers are at risk → PredictChurnRisk
      - Extraction accuracy prediction for document types → PredictExtractionAccuracy
      - Invoice fraud or anomaly detection → DetectInvoiceAnomaly
      - Platform capacity forecasting → ForecastCapacity

      When a question spans multiple domains, use multiple tools and combine results.
      Always provide specific numbers and context in responses.

    response: >
      Provide clear, data-driven answers with specific metrics. When presenting data:
      - Include relevant numbers, percentages, and trends
      - Note the time period covered
      - Highlight items that need attention (declining metrics, threshold breaches)
      - Suggest next steps when appropriate
      Format tables for readability. Use business language appropriate for executives and product managers.

    sample_questions:
      - question: "What is the average extraction accuracy by product this month?"
        answer: "I'll query the Document Processing domain to show extraction accuracy metrics broken down by product for the current month."
      - question: "Which customers are at highest churn risk?"
        answer: "I'll use the churn prediction model to identify customers with the highest risk scores based on usage patterns, support history, and engagement metrics."
      - question: "How many e-invoices were processed by country this quarter?"
        answer: "I'll query the Invoice Network domain for quarterly transaction volumes segmented by country code."
      - question: "Show platform availability by region for the last week."
        answer: "I'll query the Platform Operations domain for availability percentages by region over the past 7 days."

  tools:
    # === Cortex Analyst Tools (6 domain-specific) ===
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "DocumentProcessingAnalyst"
        description: "Query document processing operations data: IDP volumes, extraction accuracy, confidence scores, classification performance, OCR model metrics, manual correction rates, processing throughput by product, customer, document type, and region."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "WorkflowAutomationAnalyst"
        description: "Query workflow automation data: TotalAgility and RPA workflow execution metrics, completion times, failure rates, step completion, APQC business process classification, automation rates by workflow type, customer, and industry."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "InvoiceNetworkAnalyst"
        description: "Query e-Invoice Network data: electronic invoice transaction volumes, delivery times, rejection rates, compliance standard usage (Peppol, UBL, SDI, ZATCA), country-level analytics, and clearance model breakdown."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "CustomerHealthAnalyst"
        description: "Query customer health data: daily usage metrics, document volumes vs limits, active users, support tickets, CSAT scores, resolution times, utilization rates, and engagement trends by customer, product, industry, and segment."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "PlatformOperationsAnalyst"
        description: "Query platform health data: service availability percentage, response times, error rates, queue depth, capacity metrics by product, region, time of day, and deployment model. Aligned with ITIL 4 service management KPIs."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "RevenueBusinessAnalyst"
        description: "Query revenue and subscription data: ARR by product/segment/industry, subscription counts, average deal size, document volume limits, renewal dates, days to renewal, and customer segmentation analytics."

    # === Cortex Search Tools (2 knowledge bases) ===
    - tool_spec:
        type: "cortex_search"
        name: "ProductDocsSearch"
        description: "Search Tungsten Automation product documentation, configuration guides, troubleshooting steps, and best practices for TotalAgility, InvoiceAgility, AP Agility, OmniPage, ControlSuite, and Printix."

    - tool_spec:
        type: "cortex_search"
        name: "StandardsComplianceSearch"
        description: "Search industry standards and compliance information: APQC Process Classification Framework, UBL 2.1 invoice elements, ITIL 4 service metrics, GDPR data categories, and global e-invoicing mandates (Peppol, ViDA, ZATCA, Factur-X)."

    # === ML Prediction Tools (4 UDFs) ===
    - tool_spec:
        type: "generic"
        name: "PredictChurnRisk"
        description: "Predict customer churn risk for the next 90 days. Returns top customers ranked by churn probability with key risk factors (usage decline, support issues, low CSAT, approaching renewal)."

    - tool_spec:
        type: "generic"
        name: "PredictExtractionAccuracy"
        description: "Predict expected extraction accuracy for a document type and model version combination. Helps identify which document types need model retraining."

    - tool_spec:
        type: "generic"
        name: "DetectInvoiceAnomaly"
        description: "Detect anomalous invoice processing patterns that may indicate fraud, system issues, or unusual transaction behavior. Returns flagged transactions with anomaly scores."

    - tool_spec:
        type: "generic"
        name: "ForecastCapacity"
        description: "Forecast platform capacity needs by region for the next quarter based on historical growth trends. Returns predicted queue depth and recommended scaling actions."

  tool_resources:
    # === Cortex Analyst Resources ===
    DocumentProcessingAnalyst:
      semantic_view: "TA_INTELLIGENCE.ANALYTICS.TA_DOCUMENT_PROCESSING_SV"

    WorkflowAutomationAnalyst:
      semantic_view: "TA_INTELLIGENCE.ANALYTICS.TA_WORKFLOW_AUTOMATION_SV"

    InvoiceNetworkAnalyst:
      semantic_view: "TA_INTELLIGENCE.ANALYTICS.TA_INVOICE_NETWORK_SV"

    CustomerHealthAnalyst:
      semantic_view: "TA_INTELLIGENCE.ANALYTICS.TA_CUSTOMER_HEALTH_SV"

    PlatformOperationsAnalyst:
      semantic_view: "TA_INTELLIGENCE.ANALYTICS.TA_PLATFORM_OPERATIONS_SV"

    RevenueBusinessAnalyst:
      semantic_view: "TA_INTELLIGENCE.ANALYTICS.TA_REVENUE_BUSINESS_SV"

    # === Cortex Search Resources ===
    ProductDocsSearch:
      name: "TA_INTELLIGENCE.ANALYTICS.TA_PRODUCT_DOCS_SEARCH"
      max_results: "5"
      title_column: "TITLE"
      id_column: "DOC_ID"

    StandardsComplianceSearch:
      name: "TA_INTELLIGENCE.ANALYTICS.TA_STANDARDS_COMPLIANCE_SEARCH"
      max_results: "5"
      title_column: "TITLE"
      id_column: "DOC_ID"

    # === ML Model UDF Resources ===
    PredictChurnRisk:
      type: "function"
      identifier: "TA_INTELLIGENCE.ANALYTICS.AGENT_PREDICT_CHURN_RISK"
      execution_environment:
        type: "warehouse"
        warehouse: "TUNGSTEN_AUTOMATION_WH"

    PredictExtractionAccuracy:
      type: "function"
      identifier: "TA_INTELLIGENCE.ANALYTICS.AGENT_PREDICT_EXTRACTION_ACCURACY"
      execution_environment:
        type: "warehouse"
        warehouse: "TUNGSTEN_AUTOMATION_WH"

    DetectInvoiceAnomaly:
      type: "function"
      identifier: "TA_INTELLIGENCE.ANALYTICS.AGENT_DETECT_INVOICE_ANOMALY"
      execution_environment:
        type: "warehouse"
        warehouse: "TUNGSTEN_AUTOMATION_WH"

    ForecastCapacity:
      type: "function"
      identifier: "TA_INTELLIGENCE.ANALYTICS.AGENT_FORECAST_CAPACITY"
      execution_environment:
        type: "warehouse"
        warehouse: "TUNGSTEN_AUTOMATION_WH"
  $$;
