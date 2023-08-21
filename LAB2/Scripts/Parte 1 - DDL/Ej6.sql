# Usar la DB
USE world;

# Modificar la tabla country para que sea hija de Continent --> Relacionados por Continent(Name)
ALTER TABLE country
ADD FOREIGN KEY(Continent) REFERENCES Continent(Name);