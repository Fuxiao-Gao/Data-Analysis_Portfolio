-- get the max population by location
WITH MaxPopByLocation AS (
    SELECT MAX(population) as total_population
    FROM covidDeath
    WHERE location = "World"
),

-- get the max people vaccinated by location
MaxVaccinatedByLocation AS (
    SELECT MAX(people_vaccinated) as total_people_vaccinated
    FROM covidVaccination
    WHERE location = "World"
)

-- get the vaccination rate percentage
SELECT 
    MaxPopByLocation.total_population,
    MaxVaccinatedByLocation.total_people_vaccinated,
    (MaxVaccinatedByLocation.total_people_vaccinated * 100.0 / MaxPopByLocation.total_population) as vaccination_rate_percentage
FROM 
    MaxPopByLocation, MaxVaccinatedByLocation;

