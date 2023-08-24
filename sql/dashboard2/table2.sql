SELECT continent, MAX(people_vaccinated) as max_people_vaccinated
FROM covidVaccination
WHERE 
    continent IS NOT NULL AND
    TRIM(continent) <> ''
GROUP BY continent;
