# dbt Analytics Project

**dbt Core · PostgreSQL · Staging/Marts Architecture · Data Quality Tests**

A complete analytics engineering project built with dbt Core demonstrating 
production-grade data modeling patterns used by modern data teams.

## Lineage DAG
![dbt Lineage DAG](screenshots/dbt_lineage_dag.png)

## Project structure
| Layer | Models | Description |
|-------|--------|-------------|
| Sources | `healthcare.departments`, `healthcare.projects` | Raw PostgreSQL source tables |
| Staging | `stg_departments`, `stg_projects` | Cleaned, renamed, standardized |
| Marts | `mart_project_summary`, `mart_dept_health` | Business-ready analytics tables |

## Key concepts demonstrated
| Concept | Description |
|---------|-------------|
| Staging layer | Raw source cleaning and standardization |
| Marts layer | Business logic, joins, and aggregations |
| `{{ ref() }}` | dbt model dependencies and DAG lineage |
| `{{ source() }}` | Source freshness and documentation |
| dbt tests | `unique` and `not_null` across all models |
| Materialization | Views for staging, tables for marts |

## Test results
