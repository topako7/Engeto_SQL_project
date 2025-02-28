-- DROP TABLE t_tomas_pakosta_project_SQL_primary_final

-- Table to get information about payroll and prices over specific categories and within the same years.

CREATE TABLE t_tomas_pakosta_project_SQL_primary_final AS
	SELECT 
		cp.payroll_year AS year,
		COALESCE(cpib.name, 'Unknown') AS category, -- Handle NULL values
		'Mzdy' AS value_type,
		cpvt.name AS value_category,
		AVG(cp.value) AS avg_value,
		cpu.name AS units
		
	FROM czechia_payroll cp 
		LEFT JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code 
		LEFT JOIN czechia_payroll_calculation cpc ON cp.calculation_code = cpc.code
		LEFT JOIN czechia_payroll_unit cpu ON cp.unit_code = cpu.code
		LEFT JOIN czechia_payroll_value_type cpvt ON cp.value_type_code = cpvt.code 
		INNER JOIN czechia_price cp2 ON cp.payroll_year = YEAR(cp2.date_from)
		
	WHERE 1=1
	 AND cp.value IS NOT NULL  -- Exclude rows where payroll value is NULL
	 AND cp.calculation_code = 100
	 AND cp.unit_code = 200
	GROUP BY year, category, units, value_type
	 -- ORDER BY industry_branch, cp.payroll_year, cp.payroll_quarter 
UNION ALL
	SELECT 
		YEAR(cp.date_from) AS year,
		cpc.name AS category,
		'Ceny' AS value_type,
		CONCAT("Průměrná cena na ",cpc.price_value, " ", cpc.price_unit) AS value_category,
		AVG(cp.value) AS avg_value,
		'Kč' AS units
	FROM czechia_price cp 
		LEFT JOIN czechia_price_category cpc ON cp.category_code = cpc.code
		INNER JOIN czechia_payroll cp2 ON YEAR(cp.date_from) = cp2.payroll_year
	AND cp.value IS NOT NULL
	GROUP BY year, category, value_type, units