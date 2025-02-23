-- QUESTION 1: Do the salaries increase over the years in all industries, or do some decline?

-- CTE to clean and join payroll data with descriptive information
-- Filtering out NULL values in the payroll column to reduce unnecessary calculations.

WITH tmp_payroll AS (
	SELECT 
		year,
		category,
		avg_value AS avg_payroll,
		units,
		avg_value - LAG(avg_value) OVER (PARTITION BY category ORDER BY year) AS payroll_abs_yoy_change

	FROM t_tomas_pakosta_project_SQL_primary_final
	WHERE value_type = 'Mzdy'  -- Ensure correct string quoting
	ORDER BY category, year
),

-- CTE to compute the average annual payroll for each industry
tmp_avg_change AS (
	SELECT
		year,
		category,
		avg_payroll,
		units,
		payroll_abs_yoy_change,
		ROUND(AVG(payroll_abs_yoy_change) OVER (PARTITION BY category), 0) AS avg_payroll_abs_change  -- Average YoY payroll change over all years

	FROM tmp_payroll
)

-- The final SELECT identifies industries where payroll decreased in specific years
SELECT 
	category,
	year,
	ROUND(avg_payroll,  0) AS avg_payroll,  -- Average annual payroll
	ROUND(payroll_abs_yoy_change, 0) AS payroll_abs_YoY_change,  -- YoY absolute change in payroll
	CASE  
		WHEN payroll_abs_yoy_change < 0 THEN 'decrease'
		ELSE 'increase' 
	END AS yoy_change_id,  -- Identify years with a payroll decrease
	avg_payroll_abs_change AS category_payroll_avg_change
FROM tmp_avg_change
WHERE 1=1
	AND payroll_abs_yoy_change < 0 
	AND category <> 'Unknown'  -- Exclude missing industry values
ORDER BY category, year, payroll_abs_yoy_change ASC

-- THE RESULT: The table shows only the years for each industry branch that recorded a decrease in salary within the given year compared to previous year. 
-- There is also information about the overall avg. growth/decline over the years for each industry branch. 
-- This shows that all industry branches have growth in average but also specific years with a decrease in avg. salary.

