-- ============================================================
-- Staging Model: stg_departments
-- Description: Cleans and standardizes the departments source
--              table. Renames columns for consistency and
--              adds a loaded timestamp.
-- ============================================================

WITH source AS (
    SELECT * FROM {{ source('healthcare', 'departments') }}
),

renamed AS (
    SELECT
        department_id                          AS dept_id,
        TRIM(department_name)                  AS dept_name,
        CURRENT_TIMESTAMP                      AS loaded_at
    FROM source
)

SELECT * FROM renamed
