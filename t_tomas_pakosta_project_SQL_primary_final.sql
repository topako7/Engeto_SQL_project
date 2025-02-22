-- QUESTION 1: Do the salaries increase over the years in all industries, or do some decline?

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

-- THE RESULT: The table shows only the years for each industry branch that recorded a decrease in salary within the given year. 
-- There is also information about the overall avg. growth/decline over the years for each industry branch. 
-- This shows that all industry branches have average growth but also specific years with a decrease in avg. salary.

-- END of the SQL BLOCK for the Q1


---------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 2: How many liters of milk and kilograms of bread can be purchased for the first and last comparable periods in the available price and wage data?

-- START of the SQL block for Q2

-- Initital CTE to get all important information about food categories
WITH tmp_food AS (
	SELECT 
		cprc.name AS category,
		YEAR(cpr.date_to) AS year,
		AVG(cpr.value) AS avg_price,
		cprc.price_value AS unit_volume,
		cprc.price_unit AS unit
		
	FROM czechia_price cpr
		LEFT JOIN czechia_price_category cprc ON cpr.category_code = cprc.code
	WHERE cpr.value IS NOT NULL
	GROUP BY category, unit_volume, unit, year
),

-- CTE to get list of years that are available within payroll table
tmp_payroll AS (
	SELECT 
		cp.payroll_year AS year, 
		AVG(cp.value) AS avg_payroll
	FROM czechia_payroll cp
	WHERE 1=1
		AND cp.value IS NOT NULL -- Exclude rows where payroll value is NULL
		AND cp.value_type_code = 5958  -- only avg. gross payroll per employee
	GROUP BY year
),

-- CTE to find years that exist in both food & payroll data
tmp_food_payroll AS (
    SELECT food.category
		, food.year
		, food.avg_price
		, food.unit_volume
		, food.unit
		, pay.avg_payroll
    
    FROM tmp_food food
    INNER JOIN tmp_payroll pay ON food.year = pay.year
)

-- The Final SELECT to get the information about total volume of selected food.
SELECT 
		  food.year AS Year
		, food.category AS Food_category
		, ROUND(food.avg_price, 2) AS Avg_food_price
		, ROUND(food.avg_payroll, 2) AS Avg_payroll
		, FLOOR(avg_payroll / avg_price) AS Affordable_volume
		, food.unit AS Unit
	FROM tmp_food_payroll food
	WHERE 1=1
		AND (food.year = (SELECT MIN(year) FROM tmp_food_payroll)
        OR food.year = (SELECT MAX(year) FROM tmp_food_payroll) )
        AND (LOWER(food.category) LIKE '%mléko%' OR LOWER(food.category) LIKE '%chléb%')

-- THE RESULT: In 2006 people could buy 1432 l of milk or 1282 Kg of bread for an avg. salary in the same year.
-- In 2018 it was 1639 l of milk or 1340 Kg of bread for an avg. salary in the same year.
-- Overall it shows that avg. payroll grows faster than avg prices of these categories.
    
-- END of the SQL BLOCK for the Q2

---------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 3: Which food category is increasing in price the slowest (has the lowest percentage year-on-year increase)?

-- START of the SQL block for Q3

-- Initital CTE to get all important information about food categories to next calculations and get the final result
WITH tmp_food AS (
	SELECT 
		cprc.name AS category,
		YEAR(cpr.date_to) AS year,
		AVG(cpr.value) AS avg_price,
		cprc.price_value AS unit_volume,
		cprc.price_unit AS unit,
		COUNT(YEAR(cpr.date_to)) OVER (PARTITION BY category)  AS number_of_years,
		MIN(YEAR(cpr.date_to)) OVER (PARTITION BY cprc.name)  AS min_year,
		MAX(YEAR(cpr.date_to)) OVER (PARTITION BY cprc.name)  AS max_year
		
		
	FROM czechia_price cpr
		LEFT JOIN czechia_price_category cprc ON cpr.category_code = cprc.code
	WHERE cpr.value IS NOT NULL
	GROUP BY category, unit_volume, unit, year
),

-- CTE to get the table that will show only min/max year with prices of each category and other auxiliary fields to calculate the  final KPI (CAGR) and to filter the table in the next step
tmp_categories AS (
	SELECT 
		category,
		year,
		max_year,
		number_of_years,
		avg_price AS max_year_price,
		LAG(avg_price) OVER (PARTITION BY category ORDER BY year) AS min_year_price

	FROM tmp_food 
	WHERE 1=1
		AND (year = min_year OR year = max_year)
	ORDER BY category, year ASC
)

-- FINAL SELECT to calculate Compound Annual Growth Rate (CAGR)
SELECT
	category,
	CONCAT(CAST(ROUND((POWER((max_year_price / min_year_price), (1/number_of_years))-1)*100,2) AS CHAR), "%") AS CAGR
FROM tmp_categories
WHERE year = max_year
ORDER BY POWER((max_year_price / min_year_price), (1/number_of_years))-1 ASC; -- we cannot use the "CAGR" parameter because it doesn´t work correctly due to the transformation to the string.

-- THE RESULT: The food category that has the lowest increase in avg. price over the years is "Banány žluté". 
-- There are 2 categories ("Cukr krystalový", " Rajská jablka červená kulatá") that show decrease in avg. price over the years.

-- END of the SQL BLOCK for the Q3


