# Usar la DB

USE sakila;

# Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` de
# los 10 clientes con mayor dinero gastado en la plataforma.

# Tabla de customer - sum of payments

CREATE TEMPORARY TABLE totalPaymentForCustomer AS (
	SELECT c.customer_id AS customer, SUM(p.amount) AS totalAmount
	FROM sakila.customer c
		LEFT JOIN sakila.payment p 
		ON p.customer_id = c.customer_id
	GROUP BY c.customer_id
);

# Tabla del top10

CREATE TEMPORARY TABLE customerTop10ForPayment AS (
	SELECT tc.customer AS customer
	FROM sakila.totalPaymentForCustomer tc
	ORDER BY tc.totalAmount
	LIMIT 10
);


# Marcar con T premium_customer para el TOP 10

UPDATE sakila.customer c
SET c.premium_customer = 'T'
WHERE c.customer_id IN (
    SELECT top10.customer
    FROM customerTop10ForPayment top10
);

# Eliminar tablas temporales

DROP TABLE sakila.totalPaymentForCustomer;
DROP TABLE sakila.customerTop10ForPayment;