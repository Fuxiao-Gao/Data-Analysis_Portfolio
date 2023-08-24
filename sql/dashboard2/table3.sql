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