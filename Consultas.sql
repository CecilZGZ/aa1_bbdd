-- Consulta 1: ¿Cuántos Pokémon se originan de cada región?

SELECT regiones.nombre,
COUNT(pokemon.id)
FROM pokemon
INNER JOIN regiones 
ON pokemon.id_region = regiones.id
GROUP BY regiones.nombre
ORDER BY COUNT(pokemon.id) DESC;

-- Consulta 2: ¿A quién evoluciona Eevee?

SELECT nombre
FROM pokemon
WHERE id_evoluciona_de = (SELECT id FROM pokemon WHERE nombre = 'Eevee');

-- Consulta 3: ¿Qué Pokémon aprenden Terremoto y a qué nivel?

SELECT pokemon.nombre, movimientos.nombre, pokemon_movimiento.nivel_aprendizaje
FROM pokemon
INNER JOIN pokemon_movimiento
ON pokemon.id = pokemon_movimiento.id_pokemon
INNER JOIN movimientos
ON pokemon_movimiento.id_movimiento = movimientos.id
WHERE movimientos.nombre = 'Terremoto';

-- Consulta 4: ¿Qué Pokémon tipo Tierra hay en cada región y en qué ruta se obtienen?

SELECT pokemon.nombre, pokemon.primer_tipo, pokemon.segundo_tipo, regiones.nombre, rutas.nombre
FROM pokemon
INNER JOIN pokemon_ruta
ON pokemon.id = pokemon_ruta.id_pokemon
INNER JOIN rutas
ON rutas.id = pokemon_ruta.id_ruta
INNER JOIN regiones
ON regiones.id = rutas.id_region
WHERE primer_tipo = 'Tierra' OR segundo_tipo = 'Tierra'
ORDER BY pokemon.primer_tipo DESC;

-- Consulta 5: ¿Cuántos años han pasado desde el lanzamiento de cada videojuego?

SELECT ROUND(DATEDIFF(CURDATE(), regiones.fecha_lanzamiento)/365) AS Anos_desde_lanzamiento
FROM regiones;

-- Consulta 6: ¿Cuál es la región con el máximo número de rutas con clima Soleado?

SELECT COUNT(rutas.id), regiones.nombre
FROM rutas
INNER JOIN regiones
ON rutas.id_region = regiones.id
WHERE clima_primario = 'Soleado'
GROUP BY regiones.nombre
ORDER BY COUNT(rutas.id) DESC;


-- Consulta 7: ¿Cuál es la cantidad media de entrenadores en Johto?

SELECT ROUND(AVG(cantidad_entrenadores))
FROM rutas
INNER JOIN regiones
ON rutas.id_region = regiones.id
WHERE regiones.nombre = 'Johto';


-- Consulta 8: ¿Qué Pokémon poseen habilidades ocultas?

SELECT CONCAT('El Pokémon ', pokemon.nombre, ' posee la habilidad ', habilidades.nombre, ' como habilidad oculta.')
FROM pokemon
INNER JOIN pokemon_habilidad
ON pokemon.id = pokemon_habilidad.id_pokemon
INNER JOIN habilidades 
ON habilidades.id = pokemon_habilidad.id_habilidad
WHERE pokemon_habilidad.tipo_ranura = 'Oculta'
ORDER BY pokemon.id ASC;

-- Consulta 9: ¿Qué Pokémon básico (el primero de su línea evolutiva) puede aprender el ataque más potente?

SELECT pokemon.nombre, movimientos.nombre, movimientos.potencia
FROM pokemon
INNER JOIN pokemon_movimiento ON pokemon.id = pokemon_movimiento.id_pokemon
INNER JOIN movimientos ON movimientos.id = pokemon_movimiento.id_movimiento
WHERE pokemon.id_evoluciona_de IS NULL
AND movimientos.potencia = (SELECT MAX(movimientos.potencia)
FROM pokemon
INNER JOIN pokemon_movimiento ON pokemon.id = pokemon_movimiento.id_pokemon
INNER JOIN movimientos ON movimientos.id = pokemon_movimiento.id_movimiento
WHERE pokemon.id_evoluciona_de IS NULL);

-- Consulta 10: ¿Cuáles son los Pokémon de la región más antigua y dónde podemos encontrarlos?

SELECT pokemon.nombre, rutas.nombre
FROM pokemon
INNER JOIN pokemon_ruta ON pokemon.id = pokemon_ruta.id_pokemon
INNER JOIN rutas ON rutas.id = pokemon_ruta.id_ruta
INNER JOIN regiones ON regiones.id = rutas.id_region
WHERE regiones.fecha_lanzamiento = (SELECT MIN(fecha_lanzamiento) FROM regiones);

-- Consulta 11: Haz un listado de los Pokémon monotipo en formato 'POKÉMON' ES SÓLO 'TIPO'.

SELECT CONCAT(UPPER(pokemon.nombre), ' ES SÓLO ', UPPER(pokemon.primer_tipo)) AS Listado
FROM pokemon
WHERE pokemon.segundo_tipo IS NULL;

-- Consulta 12: ¿Cuál es la región con mayor cantidad de entrenadores?

SELECT regiones.nombre, SUM(rutas.cantidad_entrenadores) AS Total_Entrenadores
FROM rutas
INNER JOIN regiones ON regiones.id = rutas.id_region
GROUP BY regiones.nombre
ORDER BY Total_Entrenadores DESC;

-- Consulta 13: ¿Qué Pokémon poseen una habilidad única?

SELECT pokemon.nombre
FROM pokemon
INNER JOIN pokemon_habilidad ON pokemon.id = pokemon_habilidad.id_pokemon
WHERE pokemon_habilidad.id_habilidad IN (SELECT id FROM habilidades WHERE es_unica IS TRUE);


-- Consulta 14: ¿Qué Pokémon de tipo distinto al Siniestro pueden aprender Triturar?

SELECT pokemon.nombre
FROM pokemon
WHERE primer_tipo != 'Siniestro' AND IFNULL(segundo_tipo, ' ') != 'Siniestro'
INTERSECT
SELECT pokemon.nombre
FROM pokemon
INNER JOIN pokemon_movimiento ON pokemon.id = pokemon_movimiento.id_pokemon
INNER JOIN movimientos ON movimientos.id = pokemon_movimiento.id_movimiento
WHERE movimientos.nombre = 'Triturar';

-- Consulta 15: Lista todos los Pokémon finales en un línea evolutiva junto a los ataques que aprenden.

SELECT pokemon.nombre, GROUP_CONCAT(movimientos.nombre SEPARATOR ', ')
FROM pokemon
INNER JOIN pokemon_movimiento ON pokemon.id = pokemon_movimiento.id_pokemon
INNER JOIN movimientos ON movimientos.id = pokemon_movimiento.id_movimiento
WHERE pokemon.nombre IN (SELECT nombre FROM pokemon WHERE tiene_evolucion IS FALSE)
GROUP BY pokemon.nombre;