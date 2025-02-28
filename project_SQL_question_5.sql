-- QUESTION 5: Does the level of GDP affect changes in wages and food prices?
-- Or, if GDP increases more significantly in one year, will this translate into more significant increases in food prices or wages in the same or the following year?

-- CTE to get payroll over years and calculate Year-Over-Year change in avg. salaries.
WITH tmp_payroll AS (
	SELECT 
		year, 
		AVG(avg_value) AS avg_payroll,
		((AVG(avg_value) / LAG(AVG(avg_value)) OVER (ORDER BY year)) - 1) * 100 AS YoY_avg_payroll_change
	FROM t_tomas_pakosta_project_SQL_primary_final
	WHERE value_type = 'Mzdy'
	GROUP BY year
)

-- CTE to get prices over years and calculate Year-Over-Year change in avg. prices.
, tmp_food AS (
	SELECT 
		year,
		AVG(avg_value) AS avg_price,
		((AVG(avg_value) / LAG(AVG(avg_value)) OVER (ORDER BY year)) - 1) * 100 AS YoY_avg_price_change
	FROM t_tomas_pakosta_project_SQL_primary_final
	WHERE value_type = 'Ceny'
	GROUP BY year
)
-- CTE to get GDP over years and calculate Year-Over-Year change in avg. prices.
, tmp_GDP AS (
	SELECT 
		c.year,
		c.GDP,
		((c.GDP / LAG(c.GDP) OVER (ORDER BY year)) - 1) * 100 AS YoY_avg_gdp_change
	FROM t_tomas_pakosta_project_SQL_secondary_final c
	INNER JOIN tmp_payroll pay ON c.year = pay.year
	WHERE calling_code = 420 AND abbreviation = 'CZ'
	ORDER BY year
)
-- CTE to get differences between GDP year-over-year change and 
--	1) Price/Payroll year-over-year change in the same year
--  2) Price/Payroll year-over-year change in the next year
, tmp_impacts AS (
	SELECT 
		pay.year
		, pay.avg_payroll
		, food.avg_price
		, gdp.GDP
		, pay.YoY_avg_payroll_change
		, food.YoY_avg_price_change
		, gdp.YoY_avg_gdp_change
		, COALESCE(gdp.YoY_avg_gdp_change - pay.YoY_avg_payroll_change, 0) AS pay_impact_year
		, COALESCE(gdp.YoY_avg_gdp_change - LEAD(pay.YoY_avg_payroll_change) OVER (ORDER BY pay.year), 0) AS pay_impact_next_year
		, COALESCE(gdp.YoY_avg_gdp_change - food.YoY_avg_price_change, 0) AS food_impact_year
		, COALESCE(gdp.YoY_avg_gdp_change - LEAD(food.YoY_avg_price_change) OVER (ORDER BY pay.year), 0) AS food_impact_next_year

	FROM tmp_payroll pay
		LEFT JOIN tmp_food food ON pay.year = food.year
		LEFT JOIN tmp_GDP gdp ON pay.year = gdp.year
)

-- Final select to SUM differences and create an "impact factor" to decide where the GDP has stronger impact on prices/payrolls
SELECT 
	ROUND(SUM(pay_impact_year), 1) AS gdp_impact_on_payroll_factor
	, ROUND(SUM(pay_impact_next_year), 1) AS gdp_impact_on_payroll_next_year_factor
	, ROUND(SUM(food_impact_year), 1) AS gdp_impact_on_prices_factor
	, ROUND(SUM(food_impact_next_year), 1) AS gdp_impact_on_prices_next_year_factor

FROM tmp_impacts

-- THE RESULT: if the factor is lower then the impact is higher = which means that year-over-year changes are more similar between GDP and Prices/Payroll
-- numbers indicate that the impact of GDP growth on prices/payrolls is more likely in the year after instead of the same year.