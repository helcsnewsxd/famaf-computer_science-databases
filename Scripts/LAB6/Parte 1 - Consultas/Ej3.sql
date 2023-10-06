# Usar la DB

USE classicmodels;

# Devolver el valor promedio, máximo y mínimo de pagos que se hacen por mes.

SELECT MONTH(p.paymentDate) AS month_number, MONTHNAME(p.paymentDate) AS month_name, AVG(p.amount) AS avg_amount, MAX(p.amount) AS max_amount, MIN(p.amount) AS min_amount
FROM classicmodels.payments p 
GROUP BY month_number;