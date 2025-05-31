SELECT *FROM covid.coviddeaths;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid.coviddeaths;

-- Looking Countries in "Indonesia" at Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as persentase 
FROM covid.coviddeaths 
WHERE location = 'Indonesia';

-- Looking Countries in "Indonesia" at Total Cases vs Population

SELECT location, date, total_cases, population, (total_cases/population)*100 as persentase 
FROM covid.coviddeaths 
WHERE location = 'Indonesia';

-- Looking at Countries in "Indonesia" Highest Infection compare to Population

SELECT location, population, MAX(total_cases) as HighestInfection, MAX((total_cases/population))*100 as persentase 
FROM covid.coviddeaths 
GROUP BY location, population
HAVING location = 'Indonesia';

-- Looking at Countries Highest Infection compare to Population

SELECT location, population, MAX(total_cases) as HighestInfection, MAX((total_cases/population))*100 as persentase 
FROM covid.coviddeaths 
GROUP BY location, population 
ORDER BY persentase DESC;

-- Showing Countries with Highest Death Count per Population

SELECT location, MAX(CAST(NULLIF(total_deaths, '') AS UNSIGNED)) AS Highestdeaths
FROM covid.coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Highestdeaths DESC;

-- show by continent with the with Highest Death Count per Population

SELECT continent, MAX(CAST(NULLIF(total_deaths, '') AS UNSIGNED)) AS Highestdeaths
FROM covid.coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Highestdeaths DESC;

-- Global Numbers by date

SELECT date, SUM(CAST(new_cases AS UNSIGNED)) AS total_cases, SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths, 
((SUM(CAST(new_deaths AS UNSIGNED)) / NULLIF(SUM(CAST(new_cases AS UNSIGNED)), 0)) * 100
    ) AS death_percentage
FROM covid.coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- Vaccination

SELECT *FROM covid.covidvaksin;

-- Looking at Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM covid.coviddeaths dea
JOIN covid.covidvaksin vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null;

-- TOP 10 Countries With Highest Vaccination

SELECT location, MAX(CAST(NULLIF(total_vaccinations, '') AS UNSIGNED)) AS total_vaccinations
FROM covid.covidvaksin
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_vaccinations DESC
LIMIT 10;

-- Create CTE Global Summary Test Vaccination

WITH vaksin_summary AS (
    SELECT 
        SUM(new_tests) AS total_new_tests,
        SUM(total_tests) AS total_tests,
        AVG(total_tests_per_thousand) AS avg_tests_per_thousand,
        AVG(new_tests_per_thousand) AS avg_new_tests_per_thousand
    FROM covid.covidvaksin
    WHERE continent IS NOT NULL
)

SELECT * FROM vaksin_summary;

-- Create Daily CTE Global Summary Test Vaccination

WITH daily_vaksin_summary AS (
    SELECT 
        date,
        SUM(new_tests) AS total_new_tests,
        SUM(total_tests) AS total_tests
    FROM covid.covidvaksin
    WHERE continent IS NOT NULL
    GROUP BY date
)

SELECT * FROM daily_vaksin_summary
ORDER BY date;