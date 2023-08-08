-- table 4
-- percent population infected per country
Select location, population, date, total_cases, (total_cases/population)*100 as percentInfected
from covidDeath
where continent is not null
order by percentInfected desc;