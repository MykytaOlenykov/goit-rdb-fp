-- DROP
DROP TABLE IF EXISTS diseases_cases;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS diseases;
DROP PROCEDURE IF EXISTS `fill_diseases_tables`;


-- CREATE TABLES
CREATE TABLE countries(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL,
	code VARCHAR(100)
);

CREATE TABLE diseases(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL
);

CREATE TABLE diseases_cases(
	id INT PRIMARY KEY AUTO_INCREMENT,
	year YEAR NOT NULL,
	cases FLOAT NOT NULL,
	disease_id INT NOT NULL,
	country_id INT NOT NULL,
	
	FOREIGN KEY (disease_id) REFERENCES diseases(id),
	FOREIGN KEY (country_id) REFERENCES countries(id)
);


-- FILL TABLES
INSERT INTO countries(name, code)
SELECT DISTINCT Entity, Code
FROM infectious_cases;


DELIMITER $$

CREATE PROCEDURE `fill_diseases_tables`(IN disease_name VARCHAR(255), IN field_name VARCHAR(255))
BEGIN
	DECLARE disease_id INT;

    SELECT id INTO disease_id
    FROM diseases
    WHERE name = disease_name
    LIMIT 1;

    IF disease_id IS NULL THEN
        INSERT INTO diseases (name) VALUES (disease_name);

        SET disease_id = LAST_INSERT_ID();
    END IF;
	
    SET @sql = CONCAT('INSERT INTO diseases_cases (year, cases, disease_id, country_id) ',
                     'SELECT Year, ', field_name, ', ', disease_id, ', c.id ',
                     'FROM infectious_cases ic ',
                     'JOIN countries c ON ic.Entity = c.name AND ic.Code = c.code ',
                     'WHERE ', field_name, ' IS NOT NULL AND ', field_name, ' <> ""');
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END $$

DELIMITER ;

CALL fill_diseases_tables('Yaws', 'Number_yaws');
CALL fill_diseases_tables('Polio', 'polio_cases');
CALL fill_diseases_tables('Guinea worm', 'cases_guinea_worm');
CALL fill_diseases_tables('Rabies', 'Number_rabies');
CALL fill_diseases_tables('Malaria', 'Number_malaria');
CALL fill_diseases_tables('Hiv', 'Number_hiv');
CALL fill_diseases_tables('Tuberculosis', 'Number_tuberculosis');
CALL fill_diseases_tables('Smallpox', 'Number_smallpox');
CALL fill_diseases_tables('Cholera cases', 'Number_cholera_cases');

