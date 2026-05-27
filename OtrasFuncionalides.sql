-- Cinco vistas e intersecciones

-- 1. Vista de Pokédex básica ordenada	

CREATE VIEW vista_pokedex AS
SELECT numero_pokedex, nombre, generacion 
FROM pokemon
ORDER BY numero_pokedex ASC;

SELECT * FROM vista_pokedex;

-- 2. Lista de movimientos básica

CREATE VIEW lista_movimientos AS
SELECT nombre, potencia, acierto
FROM movimientos
ORDER BY nombre ASC;

SELECT * FROM lista_movimientos;

-- 3. Lista de Pokémon de tercera generación con evolución

SELECT nombre
FROM pokemon
WHERE generacion = 'Tercera'
INTERSECT
SELECT nombre
FROM pokemon
WHERE tiene_evolucion IS TRUE;

-- 4. Lista de rutas con y sin agua con clima despejado

SELECT nombre, nivel_min, nivel_max
FROM rutas
WHERE tiene_agua IS TRUE AND clima_primario = 'Despejado'
UNION
SELECT nombre, nivel_min, nivel_max
FROM rutas
WHERE tiene_agua IS FALSE AND clima_primario = 'Despejado'
ORDER BY nivel_min ASC;

-- 5. Lista de habilidades con descripción y a quién afecta

CREATE VIEW lista_habilidades AS
SELECT nombre, descripcion, afecta_a
FROM habilidades
ORDER BY afecta_a ASC;

SELECT * FROM lista_habilidades;


-- Cinco consultas de más de cuatro tablas

-- 1. Pokémon con sus habilidades y rutas donde aparecen

SELECT pokemon.nombre, GROUP_CONCAT(DISTINCT habilidades.nombre SEPARATOR ', '), GROUP_CONCAT(DISTINCT rutas.nombre SEPARATOR ', ')
FROM pokemon
INNER JOIN pokemon_habilidad ON pokemon.id = pokemon_habilidad.id_pokemon
INNER JOIN habilidades ON habilidades.id = pokemon_habilidad.id_habilidad
INNER JOIN pokemon_ruta ON pokemon.id = pokemon_ruta.id_pokemon
INNER JOIN rutas ON rutas.id = pokemon_ruta.id_ruta
GROUP BY pokemon.nombre;

-- 2. Pokémon con sus habilidades y movimientos (si tienen asignados)

SELECT pokemon.nombre, GROUP_CONCAT(DISTINCT habilidades.nombre SEPARATOR ', '), GROUP_CONCAT(movimientos.nombre SEPARATOR ', ')
FROM pokemon
INNER JOIN pokemon_habilidad ON pokemon.id = pokemon_habilidad.id_pokemon
INNER JOIN habilidades ON habilidades.id = pokemon_habilidad.id_habilidad
INNER JOIN pokemon_movimiento ON pokemon.id = pokemon_movimiento.id_pokemon
INNER JOIN movimientos ON movimientos.id = pokemon_movimiento.id_movimiento
GROUP BY pokemon.nombre;

-- 3. Rutas donde capturar Pokémon que aprenden movimientos de alta potencia
SELECT rutas.nombre, pokemon.nombre, movimientos.nombre, movimientos.potencia
FROM rutas
INNER JOIN pokemon_ruta ON rutas.id = pokemon_ruta.id_ruta
INNER JOIN pokemon ON pokemon_ruta.id_pokemon = pokemon.id
INNER JOIN pokemon_movimiento ON pokemon.id = pokemon_movimiento.id_pokemon
INNER JOIN movimientos ON pokemon_movimiento.id_movimiento = movimientos.id
WHERE movimientos.potencia > 90;

-- 4. Pokémon con ataques potentes de su mismo tipo

SELECT pokemon.nombre, regiones.nombre, pokemon.primer_tipo, movimientos.nombre, movimientos.potencia
FROM pokemon
INNER JOIN regiones ON pokemon.id_region = regiones.id
INNER JOIN pokemon_movimiento ON pokemon.id = pokemon_movimiento.id_pokemon
INNER JOIN movimientos ON pokemon_movimiento.id_movimiento = movimientos.id
WHERE (pokemon.primer_tipo = movimientos.tipo OR pokemon.segundo_tipo = movimientos.tipo)
  AND movimientos.potencia >= 80
ORDER BY movimientos.potencia DESC, pokemon.nombre;

-- 5. Los ataques de los Pokémon en las primeras rutas
SELECT rutas.nombre, rutas.nivel_max, pokemon.nombre, movimientos.nombre, movimientos.potencia
FROM rutas
INNER JOIN pokemon_ruta ON rutas.id = pokemon_ruta.id_ruta
INNER JOIN pokemon ON pokemon_ruta.id_pokemon = pokemon.id
INNER JOIN pokemon_movimiento ON pokemon.id = pokemon_movimiento.id_pokemon
INNER JOIN movimientos ON pokemon_movimiento.id_movimiento = movimientos.id
WHERE rutas.nivel_max <= 10
ORDER BY rutas.nivel_max ASC;

-- Cinco OUTER JOIN

-- 1. Lista de Pokémon y sus pre-evoluciones

SELECT p1.nombre, p2.nombre
FROM pokemon p1
LEFT JOIN pokemon p2 ON p1.id_evoluciona_de = p2.id
WHERE p1.id_evoluciona_de IS NOT NULL;

-- 2. Pokémon y su región

SELECT pokemon.nombre, regiones.nombre
FROM pokemon
LEFT JOIN regiones ON pokemon.id_region = regiones.id;

-- 3. Rutas y su región

SELECT regiones.nombre, rutas.nombre
FROM regiones
LEFT JOIN rutas ON regiones.id = rutas.id_region;

-- 4. Rutas y el número de la Pokédex de los Pokémon que la habitan

SELECT rutas.nombre, pokemon_ruta.id_pokemon
FROM pokemon_ruta
RIGHT JOIN rutas ON pokemon_ruta.id_ruta = rutas.id;

-- 5. Habilidades de Pokémon junto con el id de quien la posee

SELECT habilidades.nombre, pokemon_habilidad.id_pokemon
FROM habilidades
LEFT JOIN pokemon_habilidad ON habilidades.id = pokemon_habilidad.id_habilidad;

-- Cinco funciones de fecha

-- 1. ¿Cuántos días pasaron desde el lanzamiento del primer juego al segundo?

SELECT DATEDIFF(
	(SELECT DATE(regiones.fecha_lanzamiento) FROM regiones WHERE regiones.nombre = 'Johto'), 
	(SELECT DATE(regiones.fecha_lanzamiento) FROM regiones WHERE regiones.nombre = 'Kanto')
) / 365 AS Diferencia;

-- 2. ¿Qué día de la semana se lanzaron Pokémon Rubí y Zafiro?

SELECT DAYNAME(
	(SELECT DATE(regiones.fecha_lanzamiento) FROM regiones WHERE regiones.nombre = 'Hoenn')
) AS Dia_semana;

-- 3. ¿En qué meses del año se lanzaron los juegos?

SELECT videojuego_origen, 
    MONTHNAME(fecha_lanzamiento)
FROM regiones;

-- 4. ¿En qué fecha se celebrará el 50º aniversario del lanzamiento del primer juego?

SELECT videojuego_origen,
	DATE_FORMAT(DATE_ADD(fecha_lanzamiento, INTERVAL 50 YEAR), '%e/%m/%Y') AS aniversario
FROM regiones
WHERE regiones.nombre = 'Kanto';

-- 5. Años de lanzamiento ordenados del más nuevo al más viejo

SELECT nombre, CAST(YEAR(fecha_lanzamiento) AS CHAR)
FROM regiones
ORDER BY YEAR(fecha_lanzamiento) ASC;

-- Triggers

-- 1. Si Groudon o Kyogre son posicionados en una ruta, el clima de la ruta cambia a Especial

CREATE TRIGGER clima_alterado AFTER INSERT ON pokemon_ruta
FOR EACH ROW
BEGIN
	UPDATE rutas
		SET clima_primario = 'Especial'
		WHERE id = NEW.id_ruta AND NEW.id_pokemon IN (SELECT id FROM pokemon WHERE nombre = 'Kyogre' OR nombre = 'Groudon');
END;

-- 2. Si se inserta un movimiento con 0 de potencia, su clase cambia a 'Estado'

CREATE TRIGGER clasificador_movimiento BEFORE INSERT ON movimientos
FOR EACH ROW
BEGIN
	IF NEW.potencia = 0 THEN
		SET NEW.clase = 'Estado';
	END IF;
END;

-- Funciones almacenadas

-- 1. Función para saber en qué ruta sale un pokémon

CREATE FUNCTION buscar_ruta_pokemon(numero_pokedex INT)
RETURNS VARCHAR(255)
BEGIN
	DECLARE nombre_ruta VARCHAR(255);
	
	IF numero_pokedex <= 0 THEN
		RETURN 'Número de Pokédex inválido.';
	END IF;
	
	SELECT GROUP_CONCAT(rutas.nombre SEPARATOR ', ') INTO nombre_ruta
	FROM rutas
	INNER JOIN pokemon_ruta ON pokemon_ruta.id_ruta = rutas.id
	INNER JOIN pokemon ON pokemon.id = pokemon_ruta.id_pokemon
	WHERE pokemon.id = numero_pokedex;
	
	RETURN nombre_ruta;
	
END;

-- 2. Ataques que aprende un Pokémon

CREATE FUNCTION buscar_ataques_pokemon(numero_pokedex INT)
RETURNS VARCHAR(255)
BEGIN
	DECLARE ataques_posibles VARCHAR(255);

	IF numero_pokedex <= 0 THEN
		RETURN 'Número de Pokédex inválido.';
	END IF;
	
	SELECT GROUP_CONCAT(movimientos.nombre SEPARATOR ', ') INTO ataques_posibles
	FROM movimientos
	INNER JOIN pokemon_movimiento ON pokemon_movimiento.id_movimiento = movimientos.id
	INNER JOIN pokemon ON pokemon.id = pokemon_movimiento.id_pokemon
	WHERE pokemon.id = numero_pokedex;
	
	RETURN ataques_posibles;
END;	

SELECT buscar_ataques_pokemon(1);