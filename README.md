Healthcare Analysis SQL Project
Project Overview

This project focuses on analyzing healthcare data using SQL. The objective is to identify key patterns in patient visits, lab test results, and overall hospital performance. The analysis helps in understanding patient trends and improving decision-making in healthcare management.

Dataset Description

The dataset includes the following tables:

Patients: Contains patient demographic information.

Visits: Records each patient’s hospital visits and dates.

Lab_Results: Includes details about lab tests conducted for each visit.

SQL Concepts Used

Data cleaning and filtering using WHERE, IS NULL, and DISTINCT.

Data aggregation using GROUP BY, HAVING, and COUNT().

Advanced joins to combine multiple tables.

Window functions such as RANK(), DENSE_RANK(), and ROW_NUMBER().

Common Table Expressions (CTEs) for modular and readable queries.

Example Query
WITH test_counts AS (
    SELECT visit_id, COUNT(*) AS total_tests
    FROM lab_results
    GROUP BY visit_id
)
SELECT v.visit_id, v.visit_date, p.first_name, p.last_name, t.total_tests
FROM test_counts t
JOIN visits v ON t.visit_id = v.visit_id
JOIN patients p ON v.patient_id = p.patient_id
WHERE t.total_tests > 1
ORDER BY t.total_tests DESC;

Insights

Identified patients with multiple lab tests per visit.

Analyzed visit frequency and test distribution.

Derived insights to optimize healthcare resource allocation.

Tools Used

MySQL for data analysis.

Excel for preliminary data review.

GitHub for version control and project sharing.

Author

Ushoshi Bose
