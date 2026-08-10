/*=============================================================================
  Tungsten Automation Intelligence Agent
  08_ml_model_functions.sql
  
  Creates: 4 UDFs that call ML models registered in the Model Registry
  These are called by the agent's generic tools.
  
  PREREQUISITE: Run notebooks/07_ml_models.ipynb first to train and register
  the models in the Snowflake Model Registry.
  
  Models expected:
  - TA_INTELLIGENCE.ANALYTICS.CHURN_RISK_MODEL (V1)
  - TA_INTELLIGENCE.ANALYTICS.EXTRACTION_ACCURACY_MODEL (V1)
  - TA_INTELLIGENCE.ANALYTICS.INVOICE_ANOMALY_MODEL (V1)
  - TA_INTELLIGENCE.ANALYTICS.CAPACITY_FORECAST_MODEL (V1)
=============================================================================*/

USE DATABASE TA_INTELLIGENCE;
USE WAREHOUSE TUNGSTEN_AUTOMATION_WH;
USE SCHEMA ANALYTICS;

-- =============================================================================
-- 1. AGENT_PREDICT_CHURN_RISK
-- Returns top customers by churn risk with key risk factors
-- =============================================================================
CREATE OR REPLACE FUNCTION AGENT_PREDICT_CHURN_RISK()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'customer_id', CUSTOMER_ID,
    'customer_name', CUSTOMER_NAME,
    'industry', INDUSTRY,
    'segment', SEGMENT,
    'churn_probability', CHURN_PROBABILITY,
    'risk_factors', RISK_FACTORS,
    'arr_usd', ARR_USD,
    'days_to_renewal', DAYS_TO_RENEWAL
)) FROM (
    SELECT
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.INDUSTRY,
        c.SEGMENT,
        MODEL(TA_INTELLIGENCE.ANALYTICS.CHURN_RISK_MODEL, V1)!PREDICT(
            u.AVG_DOCS,
            u.USAGE_TREND,
            t.TICKET_COUNT,
            t.AVG_CSAT,
            s.DAYS_TO_RENEWAL
        ):output_feature_0::FLOAT AS CHURN_PROBABILITY,
        CASE
            WHEN u.USAGE_TREND < -0.2 THEN 'Declining usage (-' || ROUND(ABS(u.USAGE_TREND) * 100) || '%)'
            WHEN t.AVG_CSAT < 3.0 THEN 'Low CSAT (' || ROUND(t.AVG_CSAT, 1) || ')'
            WHEN t.TICKET_COUNT > 10 THEN 'High support volume (' || t.TICKET_COUNT || ' tickets)'
            WHEN s.DAYS_TO_RENEWAL < 30 THEN 'Renewal in ' || s.DAYS_TO_RENEWAL || ' days'
            ELSE 'Multiple signals'
        END AS RISK_FACTORS,
        s.ARR_USD,
        s.DAYS_TO_RENEWAL
    FROM RAW.CUSTOMER_DIM c
    JOIN (
        SELECT CUSTOMER_ID,
               AVG(DOCUMENTS_PROCESSED) AS AVG_DOCS,
               (AVG(CASE WHEN USAGE_DATE > DATEADD('day', -30, CURRENT_DATE()) THEN DOCUMENTS_PROCESSED END) -
                AVG(CASE WHEN USAGE_DATE BETWEEN DATEADD('day', -60, CURRENT_DATE()) AND DATEADD('day', -30, CURRENT_DATE()) THEN DOCUMENTS_PROCESSED END)) /
               NULLIF(AVG(CASE WHEN USAGE_DATE BETWEEN DATEADD('day', -60, CURRENT_DATE()) AND DATEADD('day', -30, CURRENT_DATE()) THEN DOCUMENTS_PROCESSED END), 0) AS USAGE_TREND
        FROM RAW.CUSTOMER_USAGE_METRICS
        WHERE USAGE_DATE > DATEADD('day', -90, CURRENT_DATE())
        GROUP BY CUSTOMER_ID
    ) u ON c.CUSTOMER_ID = u.CUSTOMER_ID
    LEFT JOIN (
        SELECT CUSTOMER_ID,
               COUNT(*) AS TICKET_COUNT,
               AVG(CSAT_SCORE) AS AVG_CSAT
        FROM RAW.SUPPORT_TICKETS
        WHERE OPENED_TS > DATEADD('day', -90, CURRENT_DATE())
        GROUP BY CUSTOMER_ID
    ) t ON c.CUSTOMER_ID = t.CUSTOMER_ID
    LEFT JOIN (
        SELECT CUSTOMER_ID,
               SUM(ARR_USD) AS ARR_USD,
               MIN(DATEDIFF('day', CURRENT_DATE(), RENEWAL_DATE)) AS DAYS_TO_RENEWAL
        FROM RAW.CUSTOMER_SUBSCRIPTIONS
        WHERE STATUS = 'ACTIVE'
        GROUP BY CUSTOMER_ID
    ) s ON c.CUSTOMER_ID = s.CUSTOMER_ID
    ORDER BY CHURN_PROBABILITY DESC
    LIMIT 20
)
$$;

-- =============================================================================
-- 2. AGENT_PREDICT_EXTRACTION_ACCURACY
-- Returns predicted accuracy by document type and model version
-- =============================================================================
CREATE OR REPLACE FUNCTION AGENT_PREDICT_EXTRACTION_ACCURACY()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'document_type', DOCUMENT_TYPE,
    'model_version', MODEL_VERSION,
    'predicted_accuracy', PREDICTED_ACCURACY,
    'current_accuracy', CURRENT_ACCURACY,
    'sample_count', SAMPLE_COUNT,
    'recommendation', RECOMMENDATION
)) FROM (
    SELECT
        j.DOCUMENT_TYPE,
        cl.MODEL_VERSION,
        MODEL(TA_INTELLIGENCE.ANALYTICS.EXTRACTION_ACCURACY_MODEL, V1)!PREDICT(
            SAMPLE_COUNT,
            AVG_PAGES,
            CURRENT_ACCURACY
        ):output_feature_0::FLOAT AS PREDICTED_ACCURACY,
        CURRENT_ACCURACY,
        SAMPLE_COUNT,
        CASE
            WHEN CURRENT_ACCURACY < 0.85 THEN 'Retrain immediately - below 85% threshold'
            WHEN CURRENT_ACCURACY < 0.90 THEN 'Schedule retraining - below 90% target'
            WHEN CURRENT_ACCURACY < 0.95 THEN 'Monitor - approaching target'
            ELSE 'Healthy - above 95% target'
        END AS RECOMMENDATION
    FROM (
        SELECT
            j.DOCUMENT_TYPE,
            cl.MODEL_VERSION,
            COUNT(*) AS SAMPLE_COUNT,
            AVG(j.PAGE_COUNT) AS AVG_PAGES,
            AVG(CASE WHEN cl.PREDICTED_CLASS = cl.ACTUAL_CLASS THEN 1.0 ELSE 0.0 END) AS CURRENT_ACCURACY
        FROM RAW.DOCUMENT_PROCESSING_JOBS j
        JOIN RAW.CLASSIFICATION_EVENTS cl ON j.JOB_ID = cl.JOB_ID
        WHERE j.RECEIVED_TS > DATEADD('month', -3, CURRENT_TIMESTAMP())
        GROUP BY j.DOCUMENT_TYPE, cl.MODEL_VERSION
        HAVING COUNT(*) > 100
    ) sub
    JOIN RAW.DOCUMENT_PROCESSING_JOBS j ON 1=0
    JOIN RAW.CLASSIFICATION_EVENTS cl ON 1=0
    ORDER BY CURRENT_ACCURACY ASC
    LIMIT 30
)
$$;

-- =============================================================================
-- 3. AGENT_DETECT_INVOICE_ANOMALY
-- Returns anomalous invoice transactions
-- =============================================================================
CREATE OR REPLACE FUNCTION AGENT_DETECT_INVOICE_ANOMALY()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'transaction_id', TRANSACTION_ID,
    'sender_id', SENDER_ID,
    'country_code', COUNTRY_CODE,
    'amount', AMOUNT,
    'anomaly_score', ANOMALY_SCORE,
    'anomaly_type', ANOMALY_TYPE,
    'submitted_ts', SUBMITTED_TS::VARCHAR
)) FROM (
    SELECT
        t.TRANSACTION_ID,
        t.SENDER_ID,
        t.COUNTRY_CODE,
        t.AMOUNT,
        MODEL(TA_INTELLIGENCE.ANALYTICS.INVOICE_ANOMALY_MODEL, V1)!PREDICT(
            t.AMOUNT,
            DATEDIFF('second', t.SUBMITTED_TS, t.DELIVERED_TS),
            HOUR(t.SUBMITTED_TS)
        ):output_feature_0::FLOAT AS ANOMALY_SCORE,
        CASE
            WHEN t.AMOUNT > 100000 AND HOUR(t.SUBMITTED_TS) NOT BETWEEN 6 AND 20 THEN 'High-value off-hours transaction'
            WHEN t.STATUS = 'REJECTED' AND t.AMOUNT > 50000 THEN 'High-value rejection'
            WHEN DATEDIFF('second', t.SUBMITTED_TS, t.DELIVERED_TS) < 5 THEN 'Suspiciously fast delivery'
            ELSE 'Statistical outlier'
        END AS ANOMALY_TYPE,
        t.SUBMITTED_TS
    FROM RAW.INVOICE_NETWORK_TRANSACTIONS t
    WHERE t.SUBMITTED_TS > DATEADD('day', -30, CURRENT_TIMESTAMP())
    ORDER BY ANOMALY_SCORE DESC
    LIMIT 20
)
$$;

-- =============================================================================
-- 4. AGENT_FORECAST_CAPACITY
-- Returns capacity forecast by region for next quarter
-- =============================================================================
CREATE OR REPLACE FUNCTION AGENT_FORECAST_CAPACITY()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'product_name', PRODUCT_NAME,
    'region', REGION,
    'current_avg_queue_depth', CURRENT_AVG_QUEUE,
    'forecasted_queue_depth', FORECASTED_QUEUE,
    'growth_rate_pct', GROWTH_RATE_PCT,
    'capacity_risk', CAPACITY_RISK,
    'recommendation', RECOMMENDATION
)) FROM (
    SELECT
        p.PRODUCT_NAME,
        h.REGION,
        ROUND(AVG(h.QUEUE_DEPTH)) AS CURRENT_AVG_QUEUE,
        MODEL(TA_INTELLIGENCE.ANALYTICS.CAPACITY_FORECAST_MODEL, V1)!PREDICT(
            AVG(h.QUEUE_DEPTH),
            STDDEV(h.QUEUE_DEPTH),
            MAX(h.QUEUE_DEPTH)
        ):output_feature_0::FLOAT AS FORECASTED_QUEUE,
        ROUND((AVG(CASE WHEN h.METRIC_HOUR > DATEADD('day', -30, CURRENT_TIMESTAMP()) THEN h.QUEUE_DEPTH END) -
               AVG(CASE WHEN h.METRIC_HOUR BETWEEN DATEADD('day', -60, CURRENT_TIMESTAMP()) AND DATEADD('day', -30, CURRENT_TIMESTAMP()) THEN h.QUEUE_DEPTH END)) /
              NULLIF(AVG(CASE WHEN h.METRIC_HOUR BETWEEN DATEADD('day', -60, CURRENT_TIMESTAMP()) AND DATEADD('day', -30, CURRENT_TIMESTAMP()) THEN h.QUEUE_DEPTH END), 0) * 100, 1) AS GROWTH_RATE_PCT,
        CASE
            WHEN AVG(h.QUEUE_DEPTH) > 1500 THEN 'HIGH'
            WHEN AVG(h.QUEUE_DEPTH) > 800 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS CAPACITY_RISK,
        CASE
            WHEN AVG(h.QUEUE_DEPTH) > 1500 THEN 'Scale up immediately - approaching capacity limits'
            WHEN AVG(h.QUEUE_DEPTH) > 800 THEN 'Plan scaling for next quarter'
            ELSE 'No action needed - within normal range'
        END AS RECOMMENDATION
    FROM RAW.PLATFORM_HEALTH_METRICS h
    JOIN RAW.PRODUCT_DIM p ON h.PRODUCT_ID = p.PRODUCT_ID
    WHERE h.METRIC_HOUR > DATEADD('day', -60, CURRENT_TIMESTAMP())
    GROUP BY p.PRODUCT_NAME, h.REGION
    ORDER BY CURRENT_AVG_QUEUE DESC
)
$$;
