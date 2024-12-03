SELECT 
    DISTINCT `year`,
    MAKEDATE(`year`, 1) AS start_date,
    CURDATE() AS `current_date`,
    TIMESTAMPDIFF(YEAR, MAKEDATE(`year`, 1), CURDATE()) AS year_difference
FROM diseases_cases;
