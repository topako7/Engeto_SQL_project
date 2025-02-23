-- QUESTION 3: Which food category is increasing in price the slowest (has the lowest percentage year-on-year increase)?

-- Initital CTE to get all important information about food categories to next calculations and get the final result
WITH tmp_food AS (
	SELECT 
		category,
		year,
		AVG(avg_value) AS avg_price,
		value_category,
		units AS unit,
		COUNT(year) OVER (PARTITION BY category)  AS number_of_years,
		MIN(year) OVER (PARTITION BY category)  AS min_year,
		MAX(year) OVER (PARTITION BY category)  AS max_year
		
		
	FROM t_tomas_pakosta_project_SQL_primary_final
	WHERE value_type = 'Ceny'
	GROUP BY category, value_type, unit, year
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
ORDER BY POWER((max_year_price / min_year_price), (1/number_of_years))-1 ASC -- we cannot use the "CAGR" parameter because it doesn´t work correctly due to the transformation to the string.

-- THE RESULT: The food category that has the lowest increase in avg. price over the years is "Banány žluté". 
-- There are 2 categories ("Cukr krystalový", " Rajská jablka červená kulatá") that show decrease in avg. price over the years.
