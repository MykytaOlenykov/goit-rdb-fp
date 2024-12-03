DELIMITER $$

CREATE FUNCTION calc_year_difference(`year` INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
	DECLARE start_date DATE;
    DECLARE diff INT;
   
    SET start_date = MAKEDATE(`year`, 1);
	
	SET diff = TIMESTAMPDIFF(YEAR, start_date, CURDATE());

	RETURN diff;
END $$

DELIMITER ;

SELECT 
    DISTINCT `year`,
    calc_year_difference(`year`) AS year_difference
FROM diseases_cases;

DROP FUNCTION IF EXISTS calc_year_difference;
