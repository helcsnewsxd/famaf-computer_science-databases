# 2023 - Bases de Datos - Primer Parcial
# Emanuel Nicolas Herrador
# DNI: 44.898.601

# Usar la DB

USE olympics;

# ================== VISTAS A UTILIZAR ==================
# Vista de personas argentinas
DROP VIEW IF EXISTS argentinian_persons;

CREATE VIEW argentinian_persons AS (
	SELECT p.id AS id, p.full_name AS name
	FROM olympics.person p 
		INNER JOIN olympics.person_region pr 
			ON pr.person_id = p.id 
		INNER JOIN olympics.noc_region nr 
			ON nr.id = pr.region_id 
	WHERE nr.region_name = 'Argentina'
);

# Vista de cantidad de medallas por persona (incluye las NA y si no participo nunca)
DROP VIEW IF EXISTS medal_for_person;

CREATE VIEW medal_for_person AS (
	SELECT	p.id AS id,
			p.full_name AS name,
			COUNT(IF(m.medal_name != 'NA', 1, NULL)) AS total_medals,
			COUNT(IF(m.medal_name = 'Gold', 1, NULL)) AS gold_medals,
			COUNT(IF(m.medal_name = 'Silver', 1, NULL)) AS silver_medals,
			COUNT(IF(m.medal_name = 'Bronze', 1, NULL)) AS bronze_medals
	FROM olympics.person p 
		LEFT JOIN olympics.games_competitor gc 
			ON (gc.person_id = p.id)
		LEFT JOIN olympics.competitor_event ce 
			ON (ce.competitor_id = gc.id)
		INNER JOIN olympics.medal m 
			ON (m.id = ce.medal_id)
	GROUP BY p.id
);

# Vista de cantidad de medallas por pais
DROP VIEW IF EXISTS medal_for_region;

CREATE VIEW medal_for_region AS (
	SELECT	nr.id AS id,
			nr.region_name AS name,
			SUM(mfp.total_medals) AS total_medals,
			SUM(mfp.gold_medals) AS gold_medals,
			SUM(mfp.silver_medals) AS silver_medals,
			SUM(mfp.bronze_medals) AS bronze_medals
	FROM olympics.medal_for_person mfp
		RIGHT JOIN olympics.person_region pr 
			ON (pr.person_id = mfp.id)
		RIGHT JOIN olympics.noc_region nr 
			ON (nr.id = pr.region_id)
	GROUP BY nr.id
);

# ================== Ejercicio 1 ==================
-- Crear un campo nuevo `total_medals` en la tabla `person` que almacena la cantidad
-- de medallas ganadas por cada persona. Por defecto, con valor 0.
ALTER TABLE olympics.person 
	ADD COLUMN total_medals SMALLINT UNSIGNED NOT NULL DEFAULT 0;

# ================== Ejercicio 2 ==================
-- Actualizar la columna  `total_medals` de cada persona con el recuento real de
-- medallas que ganó. Por ejemplo, para Michael Fred Phelps II, luego de la actualización
-- debería tener como valor de `total_medals` igual a 28.
UPDATE olympics.person p, medal_for_person mfp
SET p.total_medals = mfp.total_medals
WHERE p.id = mfp.id;

# ================== Ejercicio 3 ==================
-- Devolver todos los medallistas olímpicos de Argentina, es decir, los que hayan 
-- logrado alguna medalla de oro, plata, o bronce, enumerando la cantidad por tipo 
-- de medalla.  Por ejemplo, la query debería retornar casos como el siguiente:
--  (Juan Martín del Potro, Bronze, 1), (Juan Martín del Potro, Silver,1)
SELECT ap.name AS name, m.medal_name AS medal_type, COUNT(ce.medal_id) AS cnt_medals
FROM argentinian_persons ap
	INNER JOIN olympics.games_competitor gc 
		ON gc.person_id = ap.id
	INNER JOIN olympics.competitor_event ce 
		ON ce.competitor_id = gc.id
	INNER JOIN olympics.medal m 
		ON m.id = ce.medal_id
WHERE m.medal_name != 'NA'
GROUP BY ap.id, ce.medal_id;
	
# ================== Ejercicio 4 ==================
-- Listar el total de medallas ganadas por los deportistas argentinos en cada deporte.
-- IMPORTANTE: No es util usar las vistas aca porque solo pide el total
SELECT 	s.sport_name AS sport_name,
		COUNT(m.id) AS total_medals
FROM argentinian_persons ap
	INNER JOIN olympics.games_competitor gc 
		ON (gc.person_id = ap.id)
	INNER JOIN olympics.competitor_event ce 
		ON (ce.competitor_id = gc.id)
	LEFT JOIN olympics.medal m 
		ON (m.id = ce.medal_id AND m.medal_name != 'NA')
	INNER JOIN olympics.event e 
		ON (e.id = ce.event_id)
	RIGHT JOIN olympics.sport s 
		ON (s.id = e.sport_id)
GROUP BY s.sport_name;

# ================== Ejercicio 5 ==================
-- Listar el número total de medallas de oro, plata y bronce ganadas por cada país
--  (país representado en la tabla `noc_region`), agruparlas los resultados por pais.
-- IMPORTANTE: En el caso de paises que no participaron de las olimpiadas nunca, para diferenciarlos
-- de los que si, les dejo colocado el campo NULL (por ejemplo, Singapore o Crete)
SELECT 	mfr.name AS name,
		mfr.gold_medals AS gold_medals,
		mfr.silver_medals AS silver_medals,
		mfr.bronze_medals AS bronze_medals
FROM medal_for_region mfr;

# ================== Ejercicio 6 ==================
-- Listar el país con más y menos medallas ganadas en la historia de las olimpiadas. 
-- IMPORTANTE: Consulte y me comentaron que, en caso de empate, consideremos uno solo
-- IMPORTANTE 2: Consideramos solo paises que participaron de las olimpiadas ==>
-- Crete no por ejemplo
( # Mas medallas
	SELECT mfr.name, mfr.total_medals
	FROM medal_for_region mfr 
	WHERE mfr.total_medals IS NOT NULL
	ORDER BY mfr.total_medals DESC
	LIMIT 1
)
UNION
( # Menos medallas
	SELECT mfr.name, mfr.total_medals
	FROM medal_for_region mfr 
	WHERE mfr.total_medals IS NOT NULL
	ORDER BY mfr.total_medals ASC
	LIMIT 1
);

# ================== Ejercicio 7 ==================
-- Crear dos triggers:
-- 	a. Un trigger llamado `increase_number_of_medals` que incrementará en 1 el valor
-- 	del campo `total_medals` de la tabla `person`.
-- 	b. Un trigger llamado `decrease_number_of_medals` que decrementará en 1 el valor
-- 	del campo `totals_medals` de la tabla `person`.
-- El primer trigger se ejecutará luego de un `INSERT` en la tabla `competitor_event` y
-- deberá actualizar el valor en la tabla `person` de acuerdo al valor introducido 
-- (i.e. sólo aumentará en 1 el valor de `total_medals` para la persona que ganó una
-- medalla). Análogamente, el segundo trigger se ejecutará luego de un `DELETE` en la 
-- tabla `competitor_event` y sólo actualizará el valor en la persona correspondiente.
DROP TRIGGER IF EXISTS increase_number_of_medals;
DROP TRIGGER IF EXISTS decrease_number_of_medals;

DELIMITER $$
CREATE TRIGGER increase_number_of_medals
	AFTER INSERT ON olympics.competitor_event
	FOR EACH ROW
BEGIN
	DECLARE person_won INT;
	DECLARE medal_won VARCHAR(50);

	SET person_won = (
		SELECT gc.person_id
		FROM olympics.games_competitor gc 
		WHERE gc.id = NEW.competitor_id
		LIMIT 1
	);
	SET medal_won = (
		SELECT m.medal_name
		FROM olympics.medal m 
		WHERE m.id = NEW.medal_id
		LIMIT 1
	);	

	IF (medal_won != 'NA') THEN
		UPDATE olympics.person p
		SET p.total_medals = p.total_medals + 1
		WHERE p.id = person_won;
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER decrease_number_of_medals
	AFTER DELETE ON olympics.competitor_event
	FOR EACH ROW
BEGIN
	DECLARE person_won INT;
	DECLARE medal_won VARCHAR(50);

	SET person_won = (
		SELECT gc.person_id
		FROM olympics.games_competitor gc 
		WHERE gc.id = OLD.competitor_id
		LIMIT 1
	);
	SET medal_won = (
		SELECT m.medal_name
		FROM olympics.medal m 
		WHERE m.id = OLD.medal_id
		LIMIT 1
	);	

	IF (medal_won != 'NA') THEN
		UPDATE olympics.person p
		SET p.total_medals = p.total_medals - 1
		WHERE p.id = person_won;
	END IF;
END $$
DELIMITER ;

# ================== Ejercicio 8 ==================
-- Crear un procedimiento  `add_new_medalists` que tomará un `event_id`, y tres ids 
-- de atletas `g_id`, `s_id`, y `b_id` donde se deberá insertar tres registros en la 
-- tabla `competitor_event`  asignando a `g_id` la medalla de oro, a `s_id` la medalla
-- de plata, y a `b_id` la medalla de bronce.
DROP PROCEDURE IF EXISTS add_new_medalists

DELIMITER //
CREATE PROCEDURE add_new_medalists
	(IN event_id INT, IN g_id INT, IN s_id INT, IN b_id INT)
BEGIN
	# Lo hago porque consideramos segun dijeron que las IDs de las medallas se
	# obtienen del string que las representa, no debemos usar sus IDs a "mano"
	DECLARE gold_medal_id INT;
	DECLARE silver_medal_id INT;
	DECLARE bronze_medal_id INT;

	SET gold_medal_id = (
		SELECT m.id
		FROM olympics.medal m 
		WHERE m.medal_name = 'Gold'
		LIMIT 1 # Teoricamente es 1
	);
	SET silver_medal_id = (
		SELECT m.id
		FROM olympics.medal m 
		WHERE m.medal_name = 'Silver'
		LIMIT 1 # Teoricamente es 1
	);
	SET bronze_medal_id = (
		SELECT m.id
		FROM olympics.medal m 
		WHERE m.medal_name = 'Bronze'
		LIMIT 1 # Teoricamente es 1
	);

	INSERT INTO olympics.competitor_event 
	VALUES	(event_id, g_id, gold_medal_id),
			(event_id, s_id, silver_medal_id),
			(event_id, b_id, bronze_medal_id);
END //
DELIMITER ;

# ================== Ejercicio 9 ==================
-- Crear el rol `organizer` y asignarle permisos de eliminación sobre la tabla 
-- `games` y permiso de actualización sobre la columna `games_name` de la tabla `games`
DROP ROLE IF EXISTS organizer;
CREATE ROLE organizer;

GRANT DELETE 
	ON olympics.games 
	TO organizer;

GRANT UPDATE (games_name)
	ON olympics.games
	TO organizer;