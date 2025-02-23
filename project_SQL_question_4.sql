-- QUESTION 4: Is there a year in which the year-on-year increase in food prices was significantly higher than wage growth (greater than 10%)?

-- START of the SQL block for Q4

-- CTE to get the mandatory fields from payroll table and calculate Year-Over-Year change in avg. salaries.
WITH tmp_payroll AS (
	SELECT 
		year, 
		AVG(avg_value) AS avg_payroll,
		LAG(AVG(avg_value)) OVER (ORDER BY year) AS avg_payroll_py,
		((AVG(avg_value) / LAG(AVG(avg_value)) OVER (ORDER BY year)) - 1) * 100 AS YoY_avg_payroll_change
	FROM t_tomas_pakosta_project_SQL_primary_final
	WHERE value_type = 'Mzdy'
	GROUP BY year
),

-- CTE to get the mandatory fields from table of prices and calculate Year-Over-Year change in avg. prices.
tmp_food AS (
	SELECT 
		year,
		AVG(avg_value) AS avg_price,
		LAG(AVG(avg_value)) OVER (ORDER BY year) AS avg_price_py,
		((AVG(avg_value) / LAG(AVG(avg_value)) OVER (ORDER BY year)) - 1) * 100 AS YoY_avg_price_change
	FROM t_tomas_pakosta_project_SQL_primary_final
	WHERE value_type = 'Ceny'
	GROUP BY year
)

-- Final SELECT to get the compare of YoY changes between prices and salaries over the years.
	SELECT 
		pay.year,
		CONCAT(CAST(ROUND(food.YoY_avg_price_change, 2) AS CHAR), "%") AS YoY_avg_price_change,
		CONCAT(CAST(ROUND(pay.YoY_avg_payroll_change, 2) AS CHAR), "%") AS YoY_avg_payroll_change,
		ROUND(food.YoY_avg_price_change - pay.YoY_avg_payroll_change, 0) AS price_payroll_change_diff,
		'ppt' AS Unit_change -- change in percentage points
	FROM tmp_payroll pay
		INNER JOIN tmp_food food ON pay.year = food.year
	WHERE food.avg_price_py IS NOT NULL AND pay.avg_payroll_py IS NOT NULL
	-- HAVING price_payroll_change_diff <= 10
	ORDER BY price_payroll_change_diff DESC

-- THE RESULT: There is no year that has more than 10% faster Year-Over-Year growth in prices compared to Year-Over-Year salary growth.
-- We can see that the fastest growth within prices is in the year 2017 (almost +10%). 
-- There is year 2009 that shows -10 percentage points higher growth compared to YoY change in prices.
