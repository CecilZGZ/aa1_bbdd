pokemon[#id, numero_pokedex, nombre, primer_tipo, segundo_tipo, generacion, tiene_evolucion, descripcion, -id_region, -id_evoluciona_de]
movimientos[#id, nombre, tipo, clase, potencia, acierto, pp, efecto]
habilidades[#id, nombre, descripcion, efecto_visual, efecto_sonoro, es_unica, afecta_a, categoria_efecto]
rutas[#id, nombre, tiene_agua, clima_primario, cantidad_entrenadores, entorno, nivel_min, nivel_max, -id_region]
regiones[#id, nombre, iniciales, villanos, profesor, videojuego_origen, fecha_lanzamiento, tiene_concursos]
pokemon_movimiento[#id, nivel_aprendizaje, -id_pokemon, -id_movimiento]
pokemon_ruta[#id, -id_pokemon, -id_ruta]
pokemon_habilidad[#id, -id_pokemon, -id_habilidad, tipo_ranura]

-- Herencia

objetos[#id, nombre, precio]
capturas[#id, probabilidad_captura, -id_objeto]
curaciones[#id, cantidad_ps, -id_objeto]
pokemon_captura[#id, -id_pokemon, -id_captura]
pokemon_curacion[#id, -id_pokemon, -id_curacion]