-- QUESTION 1: Do wages increase over the years in all industries, or do some decline?

-- START of the SQL block for Q1

-- CTE to clean and join payroll data with descriptive information
-- Filtering out NULL values in the payroll column to reduce unnecessary calculations.
WITH tmp_payroll AS (
	SELECT 
		cp.payroll_quarter,
		cp.payroll_year, 
		cp.industry_branch_code, 
		COALESCE(cpib.name, 'Unknown') AS industry_branch, -- Handle NULL values
		cp.calculation_code, 
		cpc.name AS calculation,
		cp.unit_code, 
		cpu.name AS units,
		cp.value_type_code, 
		cpvt.name AS value_type,
		cp.value AS payroll
	FROM czechia_payroll cp 
		LEFT JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code 
		LEFT JOIN czechia_payroll_calculation cpc ON cp.calculation_code = cpc.code
		LEFT JOIN czechia_payroll_unit cpu ON cp.unit_code = cpu.code
		LEFT JOIN czechia_payroll_value_type cpvt ON cp.value_type_code = cpvt.code 
	WHERE cp.value IS NOT NULL  -- Exclude rows where payroll value is NULL
	ORDER BY industry_branch
),

-- CTE to compute the average annual payroll for each industry
tmp_avg_payroll AS (
	SELECT 
		pay.industry_branch,
		pay.payroll_year,
		ROUND(AVG(pay.payroll), 0) AS avg_payroll,
		pay.units
	FROM tmp_payroll pay
	WHERE pay.value_type = 'Průměrná hrubá mzda na zaměstnance'  -- Ensure correct string quoting
	GROUP BY pay.industry_branch, pay.units, pay.payroll_year
	ORDER BY pay.industry_branch, pay.payroll_year
),

-- CTE to calculate year-over-year absolute payroll changes for each industry
tmp_payroll_yoy_change AS (
	SELECT 
		industry_branch,
		payroll_year,
		avg_payroll,
		ROUND(avg_payroll - LAG(avg_payroll) OVER (PARTITION BY industry_branch ORDER BY payroll_year), 2) AS payroll_abs_yoy_change
	FROM tmp_avg_payroll
),

-- CTE to compute the average absolute YoY payroll change for each industry
tmp_avg_payroll_yoy_change AS (
	SELECT 
		industry_branch,
		payroll_year,
		avg_payroll,
		payroll_abs_yoy_change,
		ROUND(AVG(payroll_abs_yoy_change) OVER (PARTITION BY industry_branch), 0) AS avg_payroll_abs_yoy_change
	FROM tmp_payroll_yoy_change
)

-- The final SELECT identifies industries where payroll decreased in specific years
SELECT 
	industry_branch,
	payroll_year,
	avg_payroll,  -- Average annual payroll
	payroll_abs_yoy_change,  -- YoY absolute change in payroll
	avg_payroll_abs_yoy_change AS avg_industry_branch_yoy_abs_change,  -- Average YoY payroll change over all years
	CASE  
		WHEN payroll_abs_yoy_change < 0 THEN 'decrease'
		ELSE 'increase' 
	END AS yoy_change_id  -- Identify years with a payroll decrease
FROM tmp_avg_payroll_yoy_change
WHERE payroll_abs_yoy_change < 0 AND industry_branch <> 'Unknown'  -- Exclude missing industry values
ORDER BY industry_branch, payroll_year, payroll_abs_yoy_change ASC;
-- END of the SQL BLOCK for the Q1