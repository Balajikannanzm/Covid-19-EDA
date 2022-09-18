USE covid_eda;

-- Covid 19 affected countries

SELECT DISTINCT location AS 'Affected Countries' FROM covid_data
WHERE total_cases IS NOT NULL
ORDER BY location;

-- Total number of Covid 19 affected countries

SELECT count(DISTINCT location) as "Total number of countries affected" FROM covid_data
WHERE total_cases IS NOT NULL;

-- Total number of cases reported Vs Total Deaths(in India) 

SELECT location AS Country, date, total_cases AS cases, total_deaths AS deaths, 
ROUND((total_deaths/total_cases)*100, 3) AS Deathpercentage
FROM covid_data
WHERE location = 'India'
ORDER BY date;

-- Total Cases Vs Total Deaths (All Countries) 

SELECT location AS Country, date, population, total_cases AS cases, total_deaths AS deaths,
ROUND((total_cases/population) * 100,3) AS PercentPopulationInfected,
ROUND((total_deaths/total_cases)*100,3) AS DeathPercentage
FROM covid_data
ORDER BY location, date, population;

-- Calculating the death percentage of covid cases per day in India

SELECT location,date, total_cases, total_deaths, round((total_deaths/total_cases)*100,4) as DeathPercentage
FROM covid_data
WHERE location = 'India'
ORDER BY location,date;


--  Highest Infection Rate Vs Population (All countries)

SELECT Location, Population, MAX(total_cases) as Infected_count,  ROUND(Max((total_cases/population))*100,3) as Percent_Population_Infected
FROM covid_data
GROUP BY Location, Population
ORDER BY Percent_Population_Infected desc;

-- Countries with Highest Death Count per Population;

SELECT location, MAX(total_deaths) as TotalDeaths
FROM covid_data
GROUP BY Location
ORDER BY TotalDeaths desc;

-- Vaccination Start Date (world wide)

SELECT location AS Country, MIN(date) AS VaccinationStartdate
FROM covid_data
WHERE total_vaccinations > 0 
GROUP BY location
ORDER BY VaccinationStartdate ;

-- Vaccination start date for India

SELECT location AS Country, MIN(date) AS VaccinationStartdate
FROM covid_data
WHERE total_vaccinations > 0 AND location = 'India'
GROUP BY location
ORDER BY VaccinationStartdate;

-- Vaccinations

WITH cte_vaccinations (location, population,total_vaccinations, people_vaccinated, people_fully_vaccinated)
AS
(
	SELECT location,
    MAX(population),
	MAX(total_vaccinations),
	MAX(people_vaccinated),
	MAX(people_fully_vaccinated)
	FROM covid_data
	GROUP BY location
)
SELECT * 
FROM cte_vaccinations;

-- Creating a view to display total deaths caused by Covid 19

create or replace view Total_death as
select location,max(total_deaths) as Totaldeaths
from covid_data
group by location
order by Totaldeaths Desc;

-- Running the view

select * from total_death;
