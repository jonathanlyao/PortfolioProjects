
SELECT * 
FROM PortfolioProject001.dbo.owidcoviddata
WHERE continent IS NOT NULL -- Add this so the continent will not be counted in the table
ORDER BY 3, 4



-- Looking at total Cases vs total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject001.dbo.owidcoviddata
WHERE Location Like '%States%' AND continent IS NOT NULL
ORDER BY Location, Date 

-- Looking at Total Cases vs. Population
-- Show what percentage of population got Covid

SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject001.dbo.owidcoviddata
WHERE continent IS NOT NULL
ORDER BY Location, Date 



-- Looking at countries with Highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCase, MAX((total_cases/population)*100) AS PercentPopulationInfected
FROM PortfolioProject001.dbo.owidcoviddata
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

-- Showing Countries with Highest Death Count per Population

SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount -- We need to cast total_death because it was set to be nvarchar(255) as we can check on the total_deaths on the Columns of the table
FROM PortfolioProject001.dbo.owidcoviddata
WHERE continent IS NOT NULL -- Add this query line so the continent will not be counted in the table, only the countries
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- Let's Break Things Down By CONTINENT


SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount -- We need to cast total_death because it was set to be nvarchar(255) as we can check on the total_deaths on the Columns of the table
FROM PortfolioProject001.dbo.owidcoviddata
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Showing continents with the Highest Death Count per population

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount -- We need to cast total_death because it was set to be nvarchar(255) as we can check on the total_deaths on the Columns of the table
FROM PortfolioProject001.dbo.owidcoviddata
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject001.dbo.owidcoviddata 
WHERE continent IS NOT NULL
 

-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, vac.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated-- the int range is -2,147,483,648 to 2,147,483,647; that's why the int can't handle the data; we need to put bigint which is -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807; now the query should work.
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject001.dbo.Coviddeaths dea
JOIN PortfolioProject001.dbo.Covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY location, date

-- USE CTE 

With popvsvac (continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated) -- So we created a new table name popvsvac to specify and include all the information that was in the last table we created
AS 
(
SELECT dea.continent, dea.location, dea.date, vac.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated-- the int range is -2,147,483,648 to 2,147,483,647; that's why the int can't handle the data; we need to put bigint which is -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807; now the query should work.
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject001.dbo.Coviddeaths dea
JOIN PortfolioProject001.dbo.Covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/population)*100 
FROM popvsvac


-- TEMP TABLE 

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255), 
location nvarchar(255),
Date datetime, 
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, vac.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated-- the int range is -2,147,483,648 to 2,147,483,647; that's why the int can't handle the data; we need to put bigint which is -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807; now the query should work.
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject001.dbo.Coviddeaths dea
JOIN PortfolioProject001.dbo.Covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
SELECT *, (RollingPeopleVaccinated/population)*100 
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, vac.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated-- the int range is -2,147,483,648 to 2,147,483,647; that's why the int can't handle the data; we need to put bigint which is -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807; now the query should work.
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject001.dbo.Coviddeaths dea
JOIN PortfolioProject001.dbo.Covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL


SELECT * 
FROM PercentPopulationVaccinated
