-- DROP TABLE t_tomas_pakosta_project_SQL_secondary_final

-- Table to get information about countries only. Focused on GDP and specific parameters for a country to identification

CREATE TABLE t_tomas_pakosta_project_SQL_secondary_final AS
	SELECT
		c.calling_code
		, c.currency_code
		, c.domain_tld 
		, c.country
		, c.abbreviation
		, c.continent
		, c.region_in_world
		, e.`year` 
		, e.GDP
		, e.population
		, c.iso_numeric 
		, c.iso2 
		, c.iso3
	FROM countries c
	INNER JOIN economies e ON c.country = e.country
	WHERE GDP IS NOT NULL
	-- AND c.country LIKE '%czech%'