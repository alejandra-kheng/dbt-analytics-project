-- ============================================================
-- Staging Model: stg_projects
-- Description: Cleans and standardizes the projects source
--              table. Calculates completion percentage and
--              adds performance tier classification.
-- ============================================================

WITH source AS (
    SELECT * FROM {{ source('healthcare', 'projects') }}
),

renamed AS (
    SELECT
        project_id                             AS project_id,
        TRIM(project_name)                     AS project_name,
        department_id                          AS dept_id,
        completed_tasks,
        total_tasks,
        due_date,
        ROUND(
            CAST(completed_tasks AS NUMERIC)
            / NULLIF(total_tasks, 0) * 100, 1
        )                                      AS completion_pct,
        CURRENT_TIMESTAMP                      AS loaded_at
    FROM source
)

SELECT * FROM renamed
