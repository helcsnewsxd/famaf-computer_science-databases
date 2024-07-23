# Usar la DB

USE sakila;

# Crear dos roles de empleado. A uno asignarle los permisos de `employee` y al otro
# de `administrator`.

CREATE ROLE IF NOT EXISTS employee1;
CREATE ROLE IF NOT EXISTS employee2;

GRANT employee
	TO employee1;

GRANT administrator
	TO employee2;

# Para ver los roles que se les asignaron
SHOW GRANTS FOR employee;
SHOW GRANTS FOR administrator;
SHOW GRANTS FOR employee1;
SHOW GRANTS FOR employee2;