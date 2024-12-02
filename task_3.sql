SELECT
    country.name as country_name,
    country.code as country_code,
    AVG(dc.cases) AS avg_rabies,
    MIN(dc.cases) AS min_rabies,
    MAX(dc.cases) AS max_rabies,
    SUM(dc.cases) AS sum_rabies
FROM diseases_cases dc
JOIN countries country ON dc.country_id = country.id
WHERE "Rabies" = (
	SELECT name FROM diseases d
	WHERE d.id = dc.disease_id 
) 
GROUP BY dc.country_id 
ORDER BY avg_rabies DESC
LIMIT 10;
