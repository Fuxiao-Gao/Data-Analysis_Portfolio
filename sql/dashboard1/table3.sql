-- table 3
--looking at percent infected each country
select location, population, max(total_cases) as totalCaseCount,
(max(total_cases)/population)*100 as percentInfected
from covidDeath
where continent is not null
group by location, population
order by percentInfected DESC;