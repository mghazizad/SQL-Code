-- I explored the COVID-19 Deaths and COVID-19 Vaccinations data files (found here: https://ourworldindata.org/covid-deaths, https://ourworldindata.org/covid-vaccinations)

-- Table 1-- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/(SUM(new_cases)+0.000001)*100 AS Death_Percentage
FROM PortfolioProject..[Covid Deaths]
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


--Table 2 -- Continential Numbers

SELECT location, SUM(new_deaths) AS total_death_count
FROM PortfolioProject..[Covid Deaths]
WHERE continent IS NULL
AND location NOT IN ('World', 'High income', 'Upper middle income', 'lower middle income', 'low income', 'european union')
GROUP BY location
ORDER BY 2 DESC

-- Showing continents with the highest death count per population

SELECT continent, MAX(total_deaths) AS total_deaths
FROM PortfolioProject..[Covid Deaths]
WHERE continent IS NOT NULL
GROUP BY continent
ORDER By total_deaths DESC


--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM PortfolioProject..[Covid Deaths] dea
JOIN PortfolioProject..[Covid Vaccinations] vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- USE CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM PortfolioProject..[Covid Deaths] dea
JOIN PortfolioProject..[Covid Vaccinations] vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

	
--Table 3 --Countries with the highest infection rates compared to the population


SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX(total_cases)/population*100 AS infection_percentage
FROM PortfolioProject..[Covid Deaths]
GROUP BY location, population
ORDER By 4 DESC

--Countries with highest death count per population

SELECT location, MAX(total_deaths) AS total_deaths
FROM PortfolioProject..[Covid Deaths]
WHERE continent IS NOT NULL
GROUP BY location
ORDER By total_deaths DESC


--Looking at Death Percentage for Canada

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM PortfolioProject..[Covid Deaths]
WHERE location LIKE '%Canada%'
ORDER BY 1,2


--Looking at Total Cases vs Population for Canada

SELECT location, date, total_cases, population, (total_cases/population)*100 AS Percent_of_population_infected
FROM PortfolioProject..[Covid Deaths]
WHERE location LIKE '%Canada%'
ORDER BY 1,2




