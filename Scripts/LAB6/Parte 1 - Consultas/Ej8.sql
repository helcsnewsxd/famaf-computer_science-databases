# Usar la DB

USE classicmodels;

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