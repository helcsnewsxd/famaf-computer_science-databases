# Usar la DB

USE sakila;

# Calcule, por cada mes, el promedio de pagos (Hint: vea la manera de extraer el
# nombre del mes de una fecha).

SELECT MONTHNAME(p.payment_date) AS `Month`, AVG(p.amount) AS amount_average
FROM sakila.payment p 
GROUP BY `Month`;