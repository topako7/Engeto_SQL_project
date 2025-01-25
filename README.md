# Engeto_SQL_project
Engeto kurz - Datový analýza s Pythonem - data_academy_2024_09_11

# Project Assignment: Analysis of Food Availability Based on Average Incomes

## Introduction
In the analytical department of an independent company focused on the living standards of citizens, the goal is to answer defined research questions related to the availability of basic foods for the general public. These insights will be provided to the press department, which will present the findings at an upcoming conference.

The task is to prepare robust datasets to compare food availability based on average incomes over a specific time period. Additionally, a table with GDP, GINI coefficient, and population data for other European countries during the same period should be included for comparison with the Czech Republic.

---

## Data Sources
### Primary Tables:
- **`czechia_payroll`**: Information on wages in various sectors over several years (source: Open Data Portal of the Czech Republic).
- **`czechia_payroll_calculation`**: Codebook of calculations in the payroll table.
- **`czechia_payroll_industry_branch`**: Codebook of industries in the payroll table.
- **`czechia_payroll_unit`**: Codebook of value units in the payroll table.
- **`czechia_payroll_value_type`**: Codebook of value types in the payroll table.
- **`czechia_price`**: Information on prices of selected foods over several years (source: Open Data Portal of the Czech Republic).
- **`czechia_price_category`**: Codebook of food categories in the dataset.

### Codebooks of Shared Information About the Czech Republic:
- **`czechia_region`**: Codebook of regions (CZ-NUTS 2 standard).
- **`czechia_district`**: Codebook of districts (LAU standard).

### Additional Tables:
- **`countries`**: Data on various global information, such as capital cities, currencies, and average population height.
- **`economies`**: Information on GDP, GINI coefficient, tax burden, and other economic indicators by country and year.

---

## Research Questions
1. Do wages in all sectors increase over the years, or do they decrease in some?
2. How many liters of milk and kilograms of bread can be purchased for the first and last comparable periods in the available price and wage data?
3. Which food category has the slowest price increase (lowest percentage year-on-year growth)?
4. Was there a year in which the year-on-year increase in food prices was significantly higher than the increase in wages (greater than 10%)?
5. Does GDP growth significantly impact wage and food price changes? Specifically, if GDP increases significantly in one year, is there a corresponding increase in wages or food prices in the same or following year?

---

## Project Output
1. **Database Tables**:
   - **`t_{name}_{surname}_project_SQL_primary_final`**: Contains unified wage and food price data for the Czech Republic for comparable years.
   - **`t_{name}_{surname}_project_SQL_secondary_final`**: Includes additional data on GDP, GINI coefficient, and population for other European countries.

2. **SQL Queries**:
   - Prepare SQL statements to extract and analyze data for the research questions from the final tables.

3. **GitHub Repository**:
   - Create a repository (private or public) to store:
     - SQL scripts generating the final tables.
     - Documentation of intermediate results (e.g., processing steps, transformations).
     - Notes on missing or incomplete data in the outputs.

---

## Instructions and Guidelines
- **Do Not Modify Primary Tables**: Perform any required transformations only in new tables or views.
- **Documentation**:
  - Clearly document the processing pipeline and intermediate steps.
  - Note any data inconsistencies or missing values in the output.

---

## Tools and Technologies
- **SQL**: For data extraction, transformation, and analysis.
- **GitHub**: For version control and storing project files.
- **Data Sources**: Open Data Portal of the Czech Republic and relevant economic datasets.

---

Feel free to contact the analytical department for further clarifications or data-related queries.




# Zadání projektu: Analýza dostupnosti potravin na základě průměrných příjmů

## Úvod do projektu
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.

Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

---

## Datové sady, které je možné použít pro získání vhodného datového podkladu

### Primární tabulky:
- **`czechia_payroll`**: Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
- **`czechia_payroll_calculation`**: Číselník kalkulací v tabulce mezd.
- **`czechia_payroll_industry_branch`**: Číselník odvětví v tabulce mezd.
- **`czechia_payroll_unit`**: Číselník jednotek hodnot v tabulce mezd.
- **`czechia_payroll_value_type`**: Číselník typů hodnot v tabulce mezd.
- **`czechia_price`**: Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
- **`czechia_price_category`**: Číselník kategorií potravin, které se vyskytují v našem přehledu.

### Číselníky sdílených informací o ČR:
- **`czechia_region`**: Číselník krajů České republiky dle normy CZ-NUTS 2.
- **`czechia_district`**: Číselník okresů České republiky dle normy LAU.

### Dodatečné tabulky:
- **`countries`**: Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
- **`economies`**: HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

---

## Výzkumné otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

---

## Výstup projektu
1. **Tabulky v databázi**:
   - **`t_{jmeno}_{prijmeni}_project_SQL_primary_final`**: Pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období (společné roky).
   - **`t_{jmeno}_{prijmeni}_project_SQL_secondary_final`**: Pro dodatečná data o dalších evropských státech.

2. **SQL dotazy**:
   - Připravte SQL skripty, které z vámi připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné otázky.

3. **GitHub repozitář**:
   - Vytvořte repozitář (může být soukromý), kam uložíte:
     - SQL skripty generující výsledné tabulky.
     - Popis mezivýsledků (průvodní dokumentaci).
     - Informace o výstupních datech (například kde chybí hodnoty apod.).

---

## Instrukce a doporučení
- **Neupravujte data v primárních tabulkách**: Pokud bude potřeba transformovat hodnoty, dělejte tak až v tabulkách nebo pohledech, které si nově vytváříte.
- **Dokumentace**:
  - Jasně popište zpracování a mezivýsledky.
  - Zaznamenejte případné nekonzistence nebo chybějící hodnoty ve výstupech.

---

## Nástroje a technologie
- **SQL**: Pro získávání, transformaci a analýzu dat.
- **GitHub**: Pro verzování a ukládání souborů projektu.
- **Datové zdroje**: Portál otevřených dat ČR a ekonomické datasetové zdroje.

---
