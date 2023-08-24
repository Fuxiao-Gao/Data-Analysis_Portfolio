SELECT
    vac.location,
    pop.population,
    MAX(vac.people_vaccinated) AS vaccinated_people,
    (MAX(vac.people_vaccinated) * 100.0 / pop.population) AS percent_population_vaccinated
FROM
    covidVaccination vac
JOIN 
    (SELECT location, MAX(population) AS population FROM covidDeath GROUP BY location) AS pop ON vac.location = pop.location
GROUP BY
    vac.location, pop.population
ORDER BY
    percent_population_vaccinated DESC;
