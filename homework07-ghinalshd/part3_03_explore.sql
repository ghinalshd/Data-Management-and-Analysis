-- 1. Determine whether all rows in the table have unique id's or not
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT report_id) AS unique_report_IDs
FROM staging_caers_event_product;

-- total_rows | unique_report_ids 
--------------+-------------------
--     206606 |            130178
--(1 row)

-- 2. Identify which symptoms most often lead to death
SELECT DISTINCT TRIM(lower(terms)) AS symptoms, COUNT(*)
FROM staging_caers_event_product
WHERE outcomes ILIKE '%death%' AND terms NOT ILIKE '%death%'
GROUP BY TRIM(lower(terms))
ORDER BY COUNT(*) DESC
LIMIT 5;

--                  symptoms                   | count 
-----------------------------------------------+-------
-- ovarian cancer                              |   118
-- injury                                      |    28
-- ovarian cancer stage iii                    |     7
-- chest pain, circulatory collapse            |     4
-- ovarian cancer stage iv                     |     3
--(5 rows)

-- 3. Common ages that are most hospitalized in each sex
SELECT DISTINCT sex, ROUND(AVG(patient_age),2) 
AS avg_age, COUNT(*)
FROM staging_caers_event_product
WHERE sex IS NOT NULL 
AND outcomes ILIKE '%hospital%' 
AND age_units ILIKE '%year%'
GROUP BY sex;

--   sex   | average_age | count 
-----------+-------------+-------
-- Female  |       54.97 | 21086
-- Male    |       53.66 |  7814
-- Unknown |       43.40 |     3
--(3 rows)

-- 4. Frequency of specific outcomes by age groups
SELECT CASE 
WHEN patient_age <= 18 THEN '0-18'
WHEN patient_age BETWEEN 19 AND 30 THEN '19-30'
WHEN patient_age BETWEEN 31 AND 45 THEN '31-45'
WHEN patient_age BETWEEN 46 AND 60 THEN '46-60'
WHEN patient_age BETWEEN 61 AND 75 THEN '61-75'
ELSE 'Above 75'
END AS age_group,
COUNT(*) AS case_count
FROM staging_caers_event_product
WHERE patient_age IS NOT NULL
GROUP BY age_group
ORDER BY age_group;

--   age_group   | case_count 
-----------------+------------
-- 0-18          |       9385
-- 19-30         |      12858 
-- 31-45         |      26630
-- 46-60         |      38609
-- 61-75         |      34349
-- Above 75      |      16898
--(6 rows)

-- 5. Frequency of specicific outcomes by date in descending order
SELECT created_date, outcomes, COUNT(*) AS outcome_count
FROM staging_caers_event_product
WHERE created_date IS NOT NULL AND outcomes IS NOT NULL
GROUP BY created_date, outcomes
ORDER BY outcome_count DESC
LIMIT 10;

--   created_date   |                 outcomes                 | outcome_count 
--------------------+------------------------------------------+---------------
-- 2017-06-28       | Other Serious or Important Medical Event |          2590
-- 2017-06-12       | Other Serious or Important Medical Event |          1369
-- 2017-06-02       | Other Serious or Important Medical Event |           806
-- 2017-06-28       | Other Serious or Important Medical Event |           712
-- 2017-05-23       | Other Serious or Important Medical Event |           678
-- 2022-05-23       | Other Serious or Important Medical Event |           673
-- 2017-01-09       | Other Serious or Important Medical Event |           550
-- 2021-07-06       | Other Serious or Important Medical Event |           318
-- 2017-03-20       | Other Serious or Important Medical Event |           307
-- 2013-06-14       | Other Serious or Important Medical Event |           303
--(10 rows)