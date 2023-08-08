-- table 1
-- looking at the death rate
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
From covidDeath
where continent is not null 
order by 1,2;