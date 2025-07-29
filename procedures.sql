-- create procedures
 use parks_and_recreation;
 DELIMITER $$
CREATE PROCEDURE large_salary()
SELECT *  
from employee_salary
WHERE salary >= 50000;

CALL large_salary();

CREATE PROCEDURE large_salary2()
BEGIN
	SELECT *  
	from employee_salary
	WHERE salary >= 50000;
	SELECT * 
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;
CALL large_salary2();

DELIMITER $$
DROP PROCEDURE  IF EXISTS large_salary4 $$
CREATE PROCEDURE large_salary4(emp_id INT)
BEGIN
	SELECT salary, first_name
	from employee_salary
	WHERE employee_id = emp_id;
END $$
DELIMITER ;

CALL large_salary4(2);