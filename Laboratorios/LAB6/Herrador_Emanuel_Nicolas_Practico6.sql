# Usar la DB

USE classicmodels;

# EJERCICIO 1
# Devuelva la oficina con mayor número de empleados.

SELECT e.officeCode AS officeCode , COUNT(e.employeeNumber) AS nroEmployees
FROM classicmodels.employees e 
GROUP BY e.officeCode
ORDER BY nroEmployees DESC
LIMIT 1;

# EJERCICIO 2
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

# EJERCICIO 3
# Devolver el valor promedio, máximo y mínimo de pagos que se hacen por mes.

SELECT MONTH(p.paymentDate) AS month_number, MONTHNAME(p.paymentDate) AS month_name, AVG(p.amount) AS avg_amount, MAX(p.amount) AS max_amount, MIN(p.amount) AS min_amount
FROM classicmodels.payments p 
GROUP BY month_number;

# EJERCICIO 4
# Crear un procedimiento "Update Credit" en donde se modifique el límite de crédito de
# un cliente con un valor pasado por parámetro.

DELIMITER $$;

	CREATE PROCEDURE IF NOT EXISTS update_credit (IN customer_id INT(11) , new_credit_limit DECIMAL(10, 2))
	BEGIN
		UPDATE classicmodels.customers 
		SET creditLimit = new_credit_limit
		WHERE customerNumber = customer_id;
	END	

$$
DELIMITER ;

# EJERCICIO 5
# Cree una vista "Premium Customers" que devuelva el top 10 de clientes que más
# dinero han gastado en la plataforma. La vista deberá devolver el nombre del cliente,
# la ciudad y el total gastado por ese cliente en la plataforma.

CREATE VIEW IF NOT EXISTS premium_customers AS (
	SELECT c.customerName AS name, c.city AS city, SUM(p.amount) AS total_money_spent
	FROM classicmodels.customers c 
		INNER JOIN classicmodels.payments p 
		WHERE p.customerNumber = c.customerNumber 
	GROUP BY c.customerNumber 
	ORDER BY total_money_spent DESC
	LIMIT 10
);

# EJERCICIO 6
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

# EJERCICIO 7
# Crear una nueva tabla "Product Refillment". Deberá tener una relación varios a uno
# con "products" y los campos: `refillmentID`, `productCode`, `orderDate`, `quantity`.

CREATE TABLE IF NOT EXISTS product_refillment (
	refillmentID INT UNSIGNED AUTO_INCREMENT NOT NULL,
	productCode VARCHAR(15) NOT NULL,
	orderDate DATE NOT NULL,
	quantity SMALLINT UNSIGNED NOT NULL DEFAULT 0,
	
	PRIMARY KEY (refillmentID),
	CONSTRAINT product_refillment_fk_1
		FOREIGN KEY (productCode) REFERENCES products (productCode)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

# EJERCICIO 8
# Definir un trigger "Restock Product" que esté pendiente de los cambios efectuados
# en `orderdetails` y cada vez que se agregue una nueva orden revise la cantidad de
# productos pedidos (`quantityOrdered`) y compare con la cantidad en stock
# (`quantityInStock`) 
# En caso de tener menos stock que lo pedido, se debe generar un pedido en la tabla
# "Product Refillment" por la diferencia

DELIMITER $$

CREATE TRIGGER IF NOT EXISTS restock_product
	AFTER INSERT ON classicmodels.orderdetails
	FOR EACH ROW
BEGIN
	DECLARE cnt_ordered INT;
	DECLARE cnt_stock INT;
	DECLARE diff INT;

	SET cnt_ordered = NEW.quantityOrdered;
	SET cnt_stock = (
		SELECT p.quantityInStock 
		FROM classicmodels.products p 
		WHERE p.productCode = NEW.productCode
	);

	SET diff = cnt_ordered - cnt_stock;
	
	IF (diff > 0) THEN
		INSERT INTO classicmodels.product_refillment (productCode, orderDate, quantity)
			VALUES (NEW.productCode, CURDATE(), diff);
	END IF;
END
	
$$
DELIMITER ;

# EJERCICIO 9
# Crear un rol "Empleado" en la BD que establezca accesos de lectura a todas las
# tablas y accesos de creación de vistas.

CREATE ROLE IF NOT EXISTS Empleado;

GRANT SELECT
	ON classicmodels.*
	TO Empleado;

GRANT CREATE VIEW
	ON classicmodels.*
	TO Empleado;
