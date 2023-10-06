# Usar la DB

USE classicmodels;

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