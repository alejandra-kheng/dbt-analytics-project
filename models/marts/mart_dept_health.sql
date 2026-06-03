-- ============================================================
-- Mart Model: mart_dept_health
-- Description: Department-level health scorecard aggregating
--              project performance into executive summary.
-- ============================================================

WITH project_summary AS (
    SELECT * FROM {{ ref('mart_project_summary') }}
),

final AS (
    SELECT
        department_name,
        COUNT(project_id)                           AS total_projects,
        ROUND(AVG(completion_pct), 1)               AS avg_completion_pct,
        MAX(completion_pct)                         AS highest_pct,
        MIN(completion_pct)                         AS lowest_pct,
        COUNT(CASE WHEN performance_tier = 'High'
              THEN 1 END)                           AS high_count,
        COUNT(CASE WHEN performance_tier = 'On Track'
              THEN 1 END)                           AS on_track_count,
        COUNT(CASE WHEN performance_tier = 'At Risk'
              THEN 1 END)                           AS at_risk_count,
        CASE
            WHEN AVG(completion_pct) >= 90
             AND COUNT(CASE WHEN performance_tier = 'At Risk'
                 THEN 1 END) = 0        THEN 'Excellent'
            WHEN AVG(completion_pct) >= 75 THEN 'Good'
            WHEN AVG(completion_pct) >= 60 THEN 'Needs Attention'
            ELSE                             'Critical'
        END                                         AS dept_health_status
    FROM project_summary
    GROUP BY department_name
)

SELECT * FROM final
ORDER BY avg_completion_pct DESC
