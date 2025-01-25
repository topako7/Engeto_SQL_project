# Engeto_SQL_project
Engeto kurz - Datový analýza s Pythonem - data_academy_2024_09_11

see the English version below

Zadání projektu
Úvod do projektu
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.

Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

Datové sady, které je možné použít pro získání vhodného datového podkladu
Primární tabulky:

czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.
Číselníky sdílených informací o ČR:

czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
czechia_district – Číselník okresů České republiky dle normy LAU.
Dodatečné tabulky:

countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.
Výzkumné otázky
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
Výstup projektu
Pomozte kolegům s daným úkolem. Výstupem by měly být dvě tabulky v databázi, ze kterých se požadovaná data dají získat. Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).

Dále připravte sadu SQL, které z vámi připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné otázky. Pozor, otázky/hypotézy mohou vaše výstupy podporovat i vyvracet! Záleží na tom, co říkají data.

Na svém GitHub účtu vytvořte repozitář (může být soukromý), kam uložíte všechny informace k projektu – hlavně SQL skript generující výslednou tabulku, popis mezivýsledků (průvodní listinu) a informace o výstupních datech (například kde chybí hodnoty apod.).

Neupravujte data v primárních tabulkách! Pokud bude potřeba transformovat hodnoty, dělejte tak až v tabulkách nebo pohledech, které si nově vytváříte.








Project Assignment
Introduction to the Project
In your analytical department of an independent company that deals with the living standards of citizens, you have agreed that you will try to answer a few defined research questions that address the availability of basic foods to the general public. Colleagues have already defined the basic questions that they will try to answer and provide this information to the press department. This department will present the results at the next conference focused on this area.

To do this, they need you to prepare robust data bases in which it will be possible to see a comparison of food availability based on average incomes over a certain period of time.

As additional material, prepare a table with the GDP, GINI coefficient and population of other European countries in the same period, as a primary overview for the Czech Republic.

Data sets that can be used to obtain a suitable data base
Primary tables:

czechia_payroll – Information on wages in various sectors over a period of several years. The data set comes from the Open Data Portal of the Czech Republic.
czechia_payroll_calculation – Codebook of calculations in the payroll table.
czechia_payroll_industry_branch – Codebook of industries in the payroll table.
czechia_payroll_unit – Codebook of value units in the payroll table.
czechia_payroll_value_type – Codebook of value types in the payroll table.
czechia_price – Information on prices of selected foods for a period of several years. The dataset comes from the Open Data Portal of the Czech Republic.
czechia_price_category – Codebook of food categories that appear in our overview.
Codebooks of shared information about the Czech Republic:

czechia_region – Codebook of regions of the Czech Republic according to the CZ-NUTS 2 standard.
czechia_district – Codebook of districts of the Czech Republic according to the LAU standard.
Additional tables:

countries - All kinds of information about countries in the world, such as the capital, currency, national food or average population height.
economies - GDP, GINI, tax burden, etc. for a given country and year.
Research questions
Do wages in all sectors increase over the years, or do they decrease in some?
How many liters of milk and kilograms of bread can be purchased for the first and last comparable period in the available price and wage data?
Which food category is increasing in price the slowest (has the lowest percentage year-on-year increase)?
Is there a year in which the year-on-year increase in food prices was significantly higher than the increase in wages (greater than 10%)?
Does the level of GDP affect changes in wages and food prices? Or, if GDP increases more significantly in one year, will this be reflected in a more significant increase in food prices or wages in the same or the following year?
Project output
Help colleagues with the given task. The output should be two tables in the database from which the required data can be obtained. Name the tables t_{name}_{surname}_project_SQL_primary_final (for wage and food price data for the Czech Republic unified for the same comparable period – common years) and t_{name}_{surname}_project_SQL_secondary_final (for additional data on other European countries).

Next, prepare a set of SQL statements that will obtain the data basis for answering the research questions you have set from the tables you have prepared. Be careful, questions/hypotheses can support or refute your outputs! It depends on what the data says.

Create a repository on your GitHub account (it can be private) where you will store all information about the project – mainly the SQL script generating the resulting table, a description of the intermediate results (accompanying document) and information about the output data (for example, where values ​​are missing, etc.).

Do not edit the data in the primary tables! If you need to transform values, do so only in the tables or views you are creating.