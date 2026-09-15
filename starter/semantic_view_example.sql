-- Cortex Code Adoption Template
-- Semantic View Starter File
-- 
-- Instructions:
-- 1. Replace <DATABASE>, <SCHEMA>, <TABLE> with actual fully-qualified names
-- 2. Update DIMENSIONS to match actual column names (use business names)
-- 3. Add METRICS for the KPIs you want to expose
-- 4. Add at least one AI_VERIFIED_QUERY for the most common question
-- 5. Run this file to CREATE the semantic view
--
-- Reference: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view

CREATE OR REPLACE SEMANTIC VIEW <DATABASE>.<SCHEMA>.sv_example
TABLES (
  -- Primary fact table
  main_table PRIMARY KEY (id)
    COMMENT 'Main operational data table. Grain: one row per <describe grain>.'
    AS SELECT * FROM <DATABASE>.<SCHEMA>.<TABLE>,

  -- Optional: join in a dimension table
  -- dim_table PRIMARY KEY (id)
  --   COMMENT 'Lookup table for <dimension>.'
  --   AS SELECT * FROM <DATABASE>.<SCHEMA>.<DIM_TABLE>
)

-- Uncomment and edit if you have multiple tables
-- RELATIONSHIPS (
--   main_table (dim_id) REFERENCES dim_table (id) AS r_example
-- )

DIMENSIONS (
  -- Categorical columns users will group or filter by
  -- Use business names, not column names
  main_table.status
    SYNONYMS ('state', 'current status')
    COMMENT 'Current status of the record.',

  main_table.category
    SYNONYMS ('type', 'kind')
    SAMPLE_VALUES ('active', 'pending', 'closed')
    IS_ENUM = TRUE
    COMMENT 'Category of the record.',

  main_table.created_date
    COMMENT 'Date the record was created.'

  -- Add more dimensions here
)

METRICS (
  -- Calculated KPIs users will aggregate and compare
  total_count AS COUNT(main_table.id)
    SYNONYMS ('count', 'number of records', 'total')
    COMMENT 'Total number of records.',

  -- Example with a filter
  -- active_count AS COUNT(main_table.id) FILTER (WHERE main_table.status = 'active')
  --   SYNONYMS ('active records', 'open items')
  --   COMMENT 'Count of records in active status.'
)

COMMENT = 'Semantic view for <describe what this covers>. Grain: one row per <grain>. Source: <DATABASE>.<SCHEMA>.<TABLE>.'

AI_SQL_GENERATION INSTRUCTIONS
$$
- Always filter to the current fiscal year by default unless the user specifies a different time range.
- Round dollar amounts to two decimal places.
- When the user asks about "this month", use the current calendar month.
$$

AI_QUESTION_CATEGORIZATION INSTRUCTIONS
$$
- If a question is not answerable from this data, respond: "I can only answer questions about <describe scope>. Try rephrasing or ask about a specific metric."
$$

AI_VERIFIED_QUERIES (
  -- Add the most common question phrased exactly as users ask it
  -- This is the strongest accuracy lever
  VERIFIED_QUERY 'example question'
    QUESTION 'How many <records> do we have this month?'
    SQL 'SELECT COUNT(*) AS record_count FROM <DATABASE>.<SCHEMA>.<TABLE> WHERE MONTH(created_date) = MONTH(CURRENT_DATE) AND YEAR(created_date) = YEAR(CURRENT_DATE)'
    VERIFIED = TRUE

  -- Add more verified queries for other common questions
)
;
