# Agregar clave foránea a Country
USE world;

ALTER TABLE country
ADD FOREIGN KEY(Continent) REFERENCES Continent(Name);