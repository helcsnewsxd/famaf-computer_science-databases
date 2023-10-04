# Usar la DB

USE sakila;

# Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la
# tabla rental, haga un update en la tabla `inventory` restando una copia al stock de la
# película rentada (Hint: revisar que el rental no tiene información directa sobre la
# tienda, sino sobre el cliente, que está asociado a una tienda en particular).

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS update_stock AFTER INSERT ON sakila.rental 
	FOR EACH ROW
	BEGIN 
		UPDATE sakila.inventory
		SET stock = stock - 1
		WHERE inventory_id = NEW.inventory_id;
	END$$
DELIMITER ;