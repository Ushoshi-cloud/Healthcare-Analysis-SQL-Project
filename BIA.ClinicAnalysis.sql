CREATE DATABASE clinic_analytics;
USE clinic_analytics;
-- patients table
CREATE TABLE patients (
  patient_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  gender ENUM('M','F','O'),
  dob DATE,
  city VARCHAR(100)
);

-- visits table
CREATE TABLE visits (
  visit_id INT PRIMARY KEY,
  patient_id INT,
  visit_date DATE,
  department VARCHAR(50),
  diagnosis VARCHAR(255),
  doctor_id INT,
  total_bill DECIMAL(10,2),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- lab_results table
CREATE TABLE lab_results (
  result_id INT PRIMARY KEY,
  visit_id INT,
  test_name VARCHAR(100),
  result_value VARCHAR(100),
  normal_low VARCHAR(50),
  normal_high VARCHAR(50),
  unit VARCHAR(30),
  FOREIGN KEY (visit_id) REFERENCES visits(visit_id)
);

-- verifying data loading
SELECT * FROM patients LIMIT 5;
SELECT * FROM visits LIMIT 5;
SELECT * FROM lab_results LIMIT 5;
SELECT COUNT(*) FROM lab_results;
SELECT * FROM lab_results LIMIT 5;

-- BEGGINER QUERIES 
-- 1. Show the names and ages of all patients who are above 50 years old 
SELECT 
    first_name, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age
FROM
    patients
WHERE
    TIMESTAMPDIFF(YEAR, dob, CURDATE()) > 40;

-- 2. Find all lab results where the test name is “Glucose”.
SELECT 
    *
FROM
    lab_results
WHERE
    test_name = 'HbA1c';

-- 3. Show all visits that occurred after January 1, 2023 
SELECT 
    *
FROM
    visits;
SELECT 
    *
FROM
    visits
WHERE
    visit_date > '2023-01-01';

-- 4. List all distinct diagnoses recorded in the visits table.
SELECT DISTINCT
    diagnosis
FROM
    visits;

-- 5. Find all test results where the result value is higher than the normal high limit
SELECT 
    *
FROM
    lab_results
WHERE
    result_value > normal_high; 

-- 6. Count how many tests of each type have been conducted.
SELECT 
    test_name, COUNT(*) AS total_tests
FROM
    lab_results
GROUP BY test_name
ORDER BY total_tests;

-- INTERMEDIATE QUERIES 
-- 1. Find the total number of visits for each patient
SELECT 
    p.patient_id,
    p.first_name,
    COUNT(v.visit_id) AS total_visits
FROM
    patients p
        JOIN
    visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id , p.first_name
ORDER BY total_visits DESC;

-- 2. List all patients who have taken a “Glucose” test
SELECT DISTINCT
    p.patient_id, p.first_name
FROM
    patients p
        JOIN
    visits v ON p.patient_id = v.patient_id
        JOIN
    lab_results l ON v.visit_id = l.visit_id
WHERE
    test_name = 'CBC_Hb';

-- 3. Find the average result value for each test type
SELECT 
    test_name, AVG(result_value) AS results
FROM
    lab_results
GROUP BY test_name
ORDER BY results DESC;

-- 4. a)round nearest 10's 
SELECT 
    test_name, ROUND(AVG(result_value), - 1) AS avg_result_value
FROM
    lab_results
GROUP BY test_name
ORDER BY avg_result_value DESC;

-- b)round nearest 100's 
SELECT 
    test_name, ROUND(AVG(result_value), - 2) AS avg_result_value
FROM
    lab_results
GROUP BY test_name
ORDER BY avg_result_value DESC;

-- c)round nearest 1000's 
SELECT 
    test_name, ROUND(AVG(result_value), - 3) AS avg_result_value
FROM
    lab_results
GROUP BY test_name
ORDER BY avg_result_value DESC;

-- 5. Identify visits where any lab test result was above the normal range
SELECT 
    v.visit_id,
    p.first_name,
    l.test_name,
    l.result_value,
    l.normal_high
FROM
    lab_results l
        JOIN
    visits v ON l.visit_id = v.visit_id
        JOIN
    patients p ON v.patient_id = p.patient_id
WHERE
    l.result_value > l.normal_high
ORDER BY p.first_name DESC;

-- 6. Find the latest visit date for each patient
SELECT 
    p.first_name, MAX(v.visit_date) AS last_visit_date
FROM
    patients p
        JOIN
    visits v ON p.patient_id = v.patient_id
GROUP BY p.first_name
ORDER BY last_visit_date DESC;

-- 7. Show test names that were conducted more than 1 time 
SELECT 
    test_name, COUNT(*) AS total_tests
FROM
    lab_results
GROUP BY test_name
HAVING COUNT(*) > 1
ORDER BY total_tests; 

-- Advanced Queries 
-- 1. Find patients who have test results above normal in more than 1 visits
SELECT 
    p.first_name, COUNT(DISTINCT v.visit_id) AS abnormal_visits
FROM
    patients p
        JOIN
    visits v ON p.patient_id = v.patient_id
        JOIN
    lab_results l ON v.visit_id = l.visit_id
WHERE
    l.result_value > l.normal_high
GROUP BY p.first_name
HAVING COUNT(DISTINCT v.visit_id) > 1
ORDER BY abnormal_visits DESC;

-- 2. Find the top 3 most frequently performed tests
SELECT 
    test_name, COUNT(*) AS total_tests
FROM
    lab_results
GROUP BY test_name
ORDER BY total_tests DESC
LIMIT 3;

-- 3. Find the highest test result for each test name, and display the patient who got that result.
SELECT 
    p.first_name,
    l.test_name,
    l.result_value,
    l.unit,
    l.rn
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY test_name ORDER BY result_value DESC) AS rn
    FROM lab_results
) l
JOIN visits v ON l.visit_id = v.visit_id
JOIN patients p ON v.patient_id = p.patient_id;

-- 4. Find all patients who had more than one lab test during their visits.
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







