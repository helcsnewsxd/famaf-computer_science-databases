# Usar la DB

USE classicmodels;

# Devuelva la oficina con mayor número de empleados.

SELECT e.officeCode AS officeCode , COUNT(e.employeeNumber) AS nroEmployees
FROM classicmodels.employees e 
GROUP BY e.officeCode
ORDER BY nroEmployees DESC
LIMIT 1;