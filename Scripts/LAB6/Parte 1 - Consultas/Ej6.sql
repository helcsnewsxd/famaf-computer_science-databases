# Usar la DB

USE classicmodels;

# Cree una función "employee of the month" que tome un mes y un año y devuelve el
# empleado (nombre y apellido) cuyos clientes hayan efectuado la mayor cantidad de
# órdenes en ese mes.

DELIMITER $$;

CREATE FUNCTION IF NOT EXISTS employee_of_the_month
	(act_month INT, act_year INT)
	RETURNS VARCHAR(100)
BEGIN
	
	# Variables
	DECLARE best_employee INT(11);
	DECLARE best_employee_name VARCHAR(100);
	
	# Busco el ID del mejor empleado
	SET best_employee = (
		SELECT employee_of_the_month_t1.employee
		FROM classicmodels.orders o 
			RIGHT JOIN (
				# customer + employee tabla
				SELECT e.employeeNumber AS employee, c.customerNumber AS customer
				FROM classicmodels.employees e 
					LEFT JOIN classicmodels.customers c 
					ON e.employeeNumber = c.salesRepEmployeeNumber 
			) AS employee_of_the_month_t1
			ON employee_of_the_month_t1.customer = o.customerNumber 
		
		WHERE MONTH(o.orderDate) = act_month
			AND YEAR(o.orderDate) = act_year
		GROUP BY employee_of_the_month_t1.employee
		ORDER BY COUNT(o.orderNumber) DESC
		LIMIT 1		
	);

	# Preparo los valores para retornar
	SET best_employee_name = (
		SELECT CONCAT(e.firstName, ' ', e.lastName)
		FROM classicmodels.employees e 
		WHERE e.employeeNumber = best_employee
		LIMIT 1
	);

 	RETURN best_employee_name;

END

$$
DELIMITER ;

SELECT employee_of_the_month(1, 2005);