-- ==========================================
-- SALES PERFORMANCE ANALYTICS (SNOWFLAKE SQL)
-- Project: Retail Sales End-to-End Case Study
-- Stakeholder: Executive Leadership Team
-- Prepared by: Cephas Masimba
-- ==========================================

/*
  OBJECTIVES:
  1. Calculate key performance metrics (Revenue, GP, Margins).
  2. Identify and analyze promotional performance (Specials vs. Regular).
  3. Provide a data-driven recommendation on promotional strategy.
*/

-- ---------------------------------------------------------
-- 1. DATA EXPLORATION AND KPI CALCULATION
-- ---------------------------------------------------------

SELECT 
    DATE,
    -- Core Volume Metrics
    SUM(QUANTITY_SOLD) AS total_units_sold,
    
    -- Financial Metrics
    SUM(SALES) AS daily_revenue,
    SUM(COST_OF_SALES) AS daily_cost,
    SUM(SALES - COST_OF_SALES) AS daily_gross_profit,
    
    -- Unit Metrics
    ROUND(SUM(SALES) / NULLIF(SUM(QUANTITY_SOLD), 0), 2) AS avg_unit_selling_price,
    ROUND(SUM(SALES - COST_OF_SALES) / NULLIF(SUM(QUANTITY_SOLD), 0), 2) AS gross_profit_per_unit,
    
    -- Efficiency Metrics
    ROUND(
        (SUM(SALES) - SUM(COST_OF_SALES)) / NULLIF(SUM(SALES), 0) * 100, 
        2
    ) AS gross_profit_margin_pct,

    -- 2. PROMOTIONAL DAY CLASSIFICATION
    -- Classifying days based on quantity sold volume to identify historical promotion periods
    CASE
        WHEN QUANTITY_SOLD >= 9000 THEN '01. High Impact promotion'
        WHEN QUANTITY_SOLD >= 5000 THEN '02. Mid Tier promotion'
        WHEN QUANTITY_SOLD >= 2000 THEN '03. Light promotion'
        ELSE '04. Regular Price'
    END AS promotional_tier

FROM products
GROUP BY 
    DATE, 
    promotional_tier
ORDER BY 
    DATE DESC;

-- ---------------------------------------------------------
-- 3. POST-MORTEM ANALYSIS (Draft Methodology)
-- ---------------------------------------------------------

/*
  Next steps for Analytics Engineer:
  - Join this aggregated view with a "Promotions Calendar" dimension table.
  - Calculate "Lift" (Sales volume increase vs. Margin erosion).
  - Determine "Break-even" points for future promotional pricing.
*/
