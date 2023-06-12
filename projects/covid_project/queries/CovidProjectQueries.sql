SELECT * 
FROM CovidProject..CovidDeaths
ORDER BY 3, 4

--SELECT * 
--FROM CovidProject..CovidVaccinations
--ORDER BY 3, 4

-- Select data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject..CovidDeaths
ORDER BY 1, 2

-- Looking at total cases vs total deaths i.e. how many cases are there for a country and how many deaths do they have for those cases (percentage of people who died)
-- shows likelihood of dying from covid

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidProject..CovidDeaths
WHERE location like '%states%'
ORDER BY 1, 2

-- Looking at the total cases vs population
-- shows what percentage has gotten covid

SELECT Location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
FROM CovidProject..CovidDeaths
WHERE location like '%states%'
ORDER BY 1, 2

-- Looking at countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as CasePercentage
FROM CovidProject..CovidDeaths
GROUP BY Location, Population
ORDER BY CasePercentage desc

-- Show countries with highest death counts per population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount desc

-- Break down by continent

-- showing continent with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc

-- global numbers

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidProject..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 1, 2

-- Join CovidDeaths and CovidVaccinations tables on location and date
-- Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3

-- use CTE

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

-- Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

-- create view to store data for later visualizations

CREATE VIEW
PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

select * from PercentPopulationVaccinated
