# Usar la DB

USE classicmodels;

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