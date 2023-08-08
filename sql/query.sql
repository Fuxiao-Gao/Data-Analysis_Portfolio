
-- look at the total death vs total cses
-- show likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathPercentage
from covidDeath
where location like '%china%'
and continent is not null
order by 1,2;

-- looking at total cases vs population
-- shows what percentage got covid
select location, date, total_cases, population, (total_cases/population)*100 as casePercentage
from covidDeath
where location like '%china%'
and continent is not null
order by 1,2;


-- showing the country with highest death count per population
select location, max(total_deaths) as totalDeathCount
from covidDeath
where continent is not null
group by location
order by totalDeathCount DESC;

-- lets break things down by continent
-- showing the continents with the highest death count per population
select continent, max(total_deaths) as totalDeathCountByConti
from covidDeath
where continent is not null
group by continent
order by totalDeathCountByConti DESC;

-- global numbers grouped by date
select date, sum(new_cases) as globalCases, sum(new_deaths) as globalDeaths, sum(new_deaths)/sum(new_cases)*100 as globalDeathPercentage
from covidDeath
where continent is not null
group by date
order by 1,2;

-- looking at total population vs vaccination
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER(
    PARTITION BY dea.location
ORDER BY
    dea.location,
    dea.date
) AS totalVacByLoc
FROM
    covidDeath dea
JOIN covidVaccination vac ON
    dea.location = vac.location AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL AND vac.new_vaccinations > 0
ORDER BY
    2,
    3;


-- looking at total population vs vaccination
-- very inefficient query?
-- use CTE: common table expression. It is a temporary named result set that can be used for multiple times
-- CTE is used to simplify complex queries, and make them more readable
with vacPerPopByLoc (continent, location, date, population, new_vaccinations, totalVacByLoc)
as
(
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER(
    PARTITION BY dea.location
ORDER BY
    dea.location,
    dea.date
) AS totalVacByLoc
FROM
    covidDeath dea
JOIN covidVaccination vac ON
    dea.location = vac.location AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY
    2,
    3)
select *, (totalVacByLoc/population)*100 as vaccinationRate
from vacPerPopByLoc;

-- Create the temporary table
drop table if exists populationVaccinated;
CREATE TABLE populationVaccinated (
    continent VARCHAR(20),
    location VARCHAR(100),
    date DATE,
    population BIGINT,
    new_vaccinations INT,
    totalVacByLoc BIGINT
);

-- Insert data into the temporary table
-- same logic as the CTE query above
INSERT INTO populationVaccinated (continent, location, date, population, new_vaccinations, totalVacByLoc)
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (
        PARTITION BY dea.location
        ORDER BY dea.location, dea.date
    ) AS totalVacByLoc
FROM
    covidDeath dea
JOIN covidVaccination vac ON
    dea.location = vac.location AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL;

-- Select from the temporary table with the calculation
SELECT
    *,
    (totalVacByLoc / population) * 100 AS vaccinationRate
FROM
    populationVaccinated;


-- the same query using derived table 
-- seems correct and much faster
SELECT
    derived.continent,
    derived.location,
    derived.date,
    derived.population,
    derived.new_vaccinations,
    derived.totalVacByLoc,
    (derived.totalVacByLoc / derived.population) * 100 AS vaccinationRate
FROM
    (
        SELECT
            dea.continent,
            dea.location,
            dea.date,
            dea.population,
            vac.new_vaccinations,
            SUM(vac.new_vaccinations) OVER (
                PARTITION BY dea.location
                ORDER BY dea.location, dea.date
            ) AS totalVacByLoc
        FROM
            covidDeath dea
        JOIN covidVaccination vac ON
            dea.location = vac.location AND dea.date = vac.date
        WHERE
            dea.continent IS NOT NULL
    ) AS derived
ORDER BY
    derived.location, derived.date;

