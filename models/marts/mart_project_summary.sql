-- ============================================================
-- Mart Model: mart_project_summary
-- Description: Business-ready project summary joining staging
--              models. Includes completion rates, variance
--              vs department average, and performance tiers.
--              This is the layer Power BI connects to.
-- ============================================================

WITH projects AS (
    SELECT * FROM {{ ref('stg_projects') }}
),

departments AS (
    SELECT * FROM {{ ref('stg_departments') }}
),

dept_avg AS (
    SELECT
        dept_id,
        ROUND(AVG(completion_pct), 1) AS dept_avg_pct,
        COUNT(project_id)             AS total_projects
    FROM projects
    GROUP BY dept_id
),

final AS (
    SELECT
        p.project_id,
        p.project_name,
        d.dept_name                                        AS department_name,
        p.completed_tasks,
        p.total_tasks,
        p.completion_pct,
        p.due_date,
        da.dept_avg_pct,
        da.total_projects                                  AS dept_total_projects,
        ROUND(p.completion_pct - da.dept_avg_pct, 1)      AS variance_vs_avg,
        CASE
            WHEN p.completion_pct >= 90 THEN 'High'
            WHEN p.completion_pct >= 60 THEN 'On Track'
            ELSE 'At Risk'
        END                                                AS performance_tier,
        CASE
            WHEN p.completion_pct >= da.dept_avg_pct + 10 THEN 'Outperforming'
            WHEN p.completion_pct <= da.dept_avg_pct - 10 THEN 'Underperforming'
            ELSE 'Within range'
        END                                                AS performance_vs_dept
    FROM projects p
    JOIN departments d ON p.dept_id = d.dept_id
    JOIN dept_avg da   ON p.dept_id = da.dept_id
)

SELECT * FROM final
ORDER BY department_name, completion_pct DESC
