-- Consulta 1: ¿Cuántos Pokémon se originan de cada región?

SELECT regiones.nombre,
COUNT(pokemon.id)
FROM pokemon
JOIN regiones ON pokemon.id_region = regiones.id
GROUP BY regiones.nombre
ORDER BY COUNT(pokemon.id) DESC;

-- Consulta 2: ¿A quién evoluciona Eevee?

SELECT nombre
FROM pokemon
WHERE id_evoluciona_de = (SELECT id FROM pokemon WHERE nombre = 'Eevee');