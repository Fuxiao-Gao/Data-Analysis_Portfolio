-- the vaccination rate by country
SELECT
    derived.continent,
    derived.location,
    derived.date,
    derived.population,
    derived.new_vaccinations,
    derived.total_people_vaccinated,
    (derived.total_people_vaccinated / derived.population) * 100 AS vaccinationRate
FROM
    (
        SELECT
            dea.continent,
            dea.location,
            dea.date,
            dea.population,
            vac.new_vaccinations,
            MAX(vac.people_vaccinated) as total_people_vaccinated
        FROM
            covidDeath dea
        JOIN covidVaccination vac ON
            dea.location = vac.location AND dea.date = vac.date
        WHERE
            dea.continent IS NOT NULL
    ) AS derived
ORDER BY
    derived.location, derived.date;