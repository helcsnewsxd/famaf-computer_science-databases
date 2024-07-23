# Usar la DB

USE classicmodels;

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
