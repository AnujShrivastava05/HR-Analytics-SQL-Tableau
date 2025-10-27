
## CREATING DATABASE ##
CREATE DATABASE hr_database;
-------------------------------------------------------------------------------------
## CREATING TABLES ##
CREATE TABLE hrdata (
	emp_no  INT8 PRIMARY KEY,
	gender VARCHAR(50) NOT NULL,
	marital_status VARCHAR(50),
	age_band VARCHAR(50),
	age INT8,
	department VARCHAR(50),
	education VARCHAR(50),
	education_field VARCHAR(50),
	job_role VARCHAR(50),
	business_travel VARCHAR(50),
	employee_count INT8,
	attrition VARCHAR(50),
	attrition_label VARCHAR(50),
	job_satisfaction INT8,
	active_employee INT8
);
-------------------------------------------------------------------------------------

## Employee Count ##
SELECT sum(employee_count) AS Employee_Count FROM hrdata 
-- WHERE education = 'High School'
-- WHERE department = 'Sales' ;
-- WHERE department = 'R&D';
WHERE education_field = 'Medical';

--------------------------------------------------------------------------------------

## Attrition Count ##
SELECT count(attrition) FROM hrdata 
WHERE attrition='Yes' 
AND education = 'Doctoral Degree' 
AND department = 'R&D' 
AND education_field = 'Medical';

---------------------------------------------------------------------------------------

## Attrition Rate ##
SELECT 
round (((SELECT count(attrition) FROM hrdata WHERE attrition='Yes')/ 
sum(employee_count)) * 100,2) FROM hrdata
WHERE department = 'Sales';

---------------------------------------------------------------------------------------

## Active Employee ##
SELECT sum(employee_count) - (SELECT count(attrition) FROM hrdata  
WHERE attrition='Yes') FROM hrdata
WHERE gender = 'Male';

---------------------------------------------------------------------------------------

## Average Age ##
SELECT round(AVG(age),0) AS Avg_age FROM hrdata;

---------------------------------------------------------------------------------------

## Attrition by Gender ## 
SELECT gender, count(attrition) AS attrition_count FROM hrdata
WHERE attrition='Yes'
GROUP BY gender
ORDER BY count(attrition) DESC;

---------------------------------------------------------------------------------------

## Department wise Attrition ## 
SELECT 
    department,
    COUNT(*) AS total_attritions,
    ROUND(
        (SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) /
         (SELECT COUNT(*) FROM hrdata WHERE attrition = 'Yes')) * 100,
        2
    ) AS female_attrition_pct_of_total
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY department
ORDER BY total_attritions DESC;

---------------------------------------------------------------------------------------

## No of Employee by Age Group ##
SELECT age,  sum(employee_count) AS employee_count FROM hrdata
GROUP BY age
ORDER BY age;

---------------------------------------------------------------------------------------

## Education Field wise Attrition ##
SELECT education_field, count(attrition) AS attrition_count FROM hrdata
WHERE attrition='Yes'
GROUP BY education_field
ORDER BY count(attrition) DESC;

---------------------------------------------------------------------------------------

## Attrition Rate by Gender for different Age Group ##
  SELECT age_band, gender,
  COUNT(*) AS attrition,
  ROUND(
    (CAST(COUNT(*) AS DECIMAL(10,4)) /
     (SELECT COUNT(*) FROM hrdata WHERE attrition = 'Yes')) * 100, 2) AS pct
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY age_band, gender
ORDER BY age_band, gender DESC;

---------------------------------------------------------------------------------------

## Job Satisfaction Rating ##
SELECT
  job_role AS 'Job Role',
  SUM(CASE WHEN job_satisfaction = 1 THEN employee_count ELSE 0 END) AS 'Rating 1',
  SUM(CASE WHEN job_satisfaction = 2 THEN employee_count ELSE 0 END) AS 'Rating 2',
  SUM(CASE WHEN job_satisfaction = 3 THEN employee_count ELSE 0 END) AS 'Rating 3',
  SUM(CASE WHEN job_satisfaction = 4 THEN employee_count ELSE 0 END) AS 'Rating 4'
FROM hrdata
GROUP BY job_role
ORDER BY job_role;

---------------------------------------------------------------------------------------
