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




-- QUESTION 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- START of the SQL block for Q1

-- Initital CTE to get all important information about food categories
WITH tmp_food AS (
	SELECT 
		cpr.id AS food_id,
		cprc.name AS food_category,
		cprc.price_value AS food_unit_volume,
		cprc.price_unit AS food_unit,
		COALESCE(cr.name, 'Unknown') AS region_name,
		YEAR(date_to) AS food_year_to,
		QUARTER(date_to) AS food_quarter_to,
		cpr.value AS food_volume
		
	FROM czechia_price cpr
		LEFT JOIN czechia_price_category cprc ON cpr.category_code = cprc.code
		LEFT JOIN czechia_region cr ON cpr.region_code = cr.code 
	WHERE cpr.value IS NOT NULL
),

-- CTE to get list of years that are available within food table
tmp_food_years AS (
	SELECT DISTINCT YEAR(date_to) AS food_year FROM czechia_price
),

-- CTE to get list of years that are available within payroll table
tmp_payroll_years AS (
	SELECT DISTINCT payroll_year FROM czechia_payroll
),

-- CTE to find years that exist in both food & payroll data
tmp_common_years AS (
    SELECT food_year FROM tmp_food_years
    INNER JOIN tmp_payroll_years ON food_year = payroll_year
),

-- CTE to filter out food data for only the first and last available year
tmp_food_selected_years AS (
	SELECT 
		food.food_year_to
		, food.food_category
		, food.food_volume
		, food.food_unit_volume
		, food.food_unit
	FROM tmp_food food
		INNER JOIN tmp_common_years years ON food.food_year_to = years.food_year
	WHERE food.food_year_to = (SELECT MIN(food_year) FROM tmp_common_years)
       OR food.food_year_to = (SELECT MAX(food_year) FROM tmp_common_years)
)

-- The Final SELECT to get the information about total sold volume in selected years for two specific food categories.
SELECT 
	food.food_year_to AS 'year',
	food.food_category AS category
	, round(SUM(food.food_volume), 0) AS total_volume
	, food.food_unit AS unit
FROM tmp_food_selected_years food
WHERE 1=1
	AND (LOWER(food.food_category) LIKE '%mléko%' OR LOWER(food.food_category) LIKE '%chléb%')
GROUP BY food.food_category, food.food_year_to, food.food_unit
ORDER BY food.food_category;

-- END of the SQL BLOCK for the Q2