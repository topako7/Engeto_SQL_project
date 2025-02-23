-- QUESTION 2: How many liters of milk and kilograms of bread can be purchased for the first and last comparable periods in the available price and wage data?

-- Initital CTE to get all important information about food categories
WITH tmp_food AS (
	SELECT 
		category,
		year,
		value_category,
		avg_value AS avg_price,
		units
		
	FROM t_tomas_pakosta_project_SQL_primary_final
	WHERE value_type = 'Ceny'
	
),

-- CTE to get list of years that are available within payroll table
tmp_payroll AS (
	SELECT 
		year, 
		AVG(avg_value) AS avg_payroll
	FROM t_tomas_pakosta_project_SQL_primary_final
	WHERE value_type = 'Mzdy'
	GROUP BY year
),

-- CTE to find years that exist in both food & payroll data
tmp_food_payroll AS (
    SELECT food.category
		, food.year
		, food.avg_price
		, food.value_category
		, food.units
		, pay.avg_payroll
    
    FROM tmp_food food
    INNER JOIN tmp_payroll pay ON food.year = pay.year
)

-- The Final SELECT to get the information about total volume of selected food.
SELECT 
		  food.year AS Year
		, food.category AS Food_category
		, ROUND(food.avg_price, 2) AS Avg_food_price
		, food.units AS Unit
		, ROUND(food.avg_payroll, 2) AS Avg_payroll
		, food.units AS Unit
		, FLOOR(avg_payroll / avg_price) AS Affordable_volume
		, 'Ks' AS Volume_unit
		
	FROM tmp_food_payroll food
	WHERE 1=1
		AND (food.year = (SELECT MIN(year) FROM tmp_food_payroll)
        OR food.year = (SELECT MAX(year) FROM tmp_food_payroll) )
        AND (LOWER(food.category) LIKE '%mléko%' OR LOWER(food.category) LIKE '%chléb%')

-- THE RESULT: In 2006 people could buy 1432 l of milk or 1282 Kg of bread for an avg. salary in the same year.
-- In 2018 it was 1639 l of milk or 1340 Kg of bread for an avg. salary in the same year.
-- Overall it shows that avg. payroll grows faster than avg prices of these categories.
        