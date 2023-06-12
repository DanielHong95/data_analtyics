-- Queries used for excel export to Tableau

-- 1. total global numbers

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidProject..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 1, 2

-- 2. Total death count by continent

SELECT location, SUM(new_deaths) AS TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
GROUP BY location
ORDER BY TotalDeathCount desc

-- 3. Percentage of population infected by location

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM CovidProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc

-- 4. Percentage of population infected by location and date

SELECT Location, population, date,  MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM CovidProject..CovidDeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected desc