# Usar la DB

USE classicmodels;

# ¿Cuál es el promedio de órdenes hechas por oficina?, ¿Qué oficina vendió la mayor
# cantidad de productos?

# Hacer tabla con cnt de ordenes por oficina
CREATE TEMPORARY TABLE IF NOT EXISTS cnt_orders_for_office (
	SELECT e.officeCode AS office , SUM(order_for_employee.cnt_orders) AS cnt_orders
	FROM (
		# orders agrupadas por employee
		SELECT c.salesRepEmployeeNumber AS employee , COUNT(o.orderNumber) as cnt_orders
		FROM classicmodels.orders o 
			INNER JOIN classicmodels.customers c 
			WHERE o.customerNumber = c.customerNumber
		GROUP BY c.salesRepEmployeeNumber
	) AS order_for_employee
		INNER JOIN classicmodels.employees e 
		WHERE e.employeeNumber = order_for_employee.employee
	GROUP BY e.officeCode
	ORDER BY cnt_orders DESC
);

# Promedio de ordenes hechas por oficina
SELECT AVG(ofo.cnt_orders) AS avg_orders
FROM cnt_orders_for_office AS ofo;

# Oficina con max nro de ordenes hechas
SELECT ofo.office AS office , ofo.cnt_orders AS max_cnt_orders
FROM cnt_orders_for_office AS ofo
LIMIT 1;

# Eliminar tabla temporal
DROP TABLE IF EXISTS cnt_orders_for_office;