-- table 2
-- total death count by continents
Select location, SUM(new_deaths) as TotalDeathCount
From covidDeath
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc;