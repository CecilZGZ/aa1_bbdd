CREATE TABLE IF NOT EXISTS movimientos (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR (20) NOT NULL UNIQUE,
	tipo ENUM('Acero', 'Agua', 'Bicho', 'Dragón', 'Eléctrico', 'Fantasma', 'Fuego', 'Hada', 'Hielo', 'Lucha', 'Normal', 'Planta', 'Psíquico', 'Roca', 'Siniestro', 'Tierra', 'Veneno', 'Volador'),
	clase ENUM('Físico', 'Especial', 'Estado'),
	potencia INT UNSIGNED,
	acierto INT UNSIGNED,
	pp INT UNSIGNED NOT NULL,
	efecto VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS habilidades (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(20) NOT NULL UNIQUE,
	descripcion VARCHAR(500),
	efecto_visual VARCHAR(100),
	efecto_sonoro VARCHAR(100),
	es_unica BOOLEAN DEFAULT FALSE,
	afecta_a ENUM('Uno mismo', 'Oponente', 'Otros'),
	categoria_efecto VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS regiones ( 
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nombre ENUM('Kanto', 'Johto', 'Hoenn', 'Sinnoh') NOT NULL UNIQUE,
	iniciales ENUM('Charmander, Squirtle y Bulbasaur', 'Cyndaquil, Totodile y Chikorita', 'Torchic, Mudkip y Treecko', 'Chimchar, Piplup y Turtwig'),
	villanos ENUM('Team Rocket', 'Equipo Magma o Aqua', 'Equipo Galaxia'),
	profesor ENUM('Oak', 'Elm', 'Abedul', 'Serbal'),
	videojuego_origen ENUM('Pokémon Rojo y Verde', 'Pokémon Plata y Oro', 'Pokémon Rubí y Zafiro', 'Pokémon Diamante y Perla'),
	fecha_lanzamiento DATE,
	tiene_concursos BOOLEAN
);

CREATE TABLE IF NOT EXISTS rutas (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(50) NOT NULL UNIQUE,
	tiene_agua BOOLEAN DEFAULT FALSE,
	clima_primario ENUM('Despejado', 'Soleado', 'Lluvia', 'Granizo', 'Tormenta de arena', 'Niebla', 'Especial') NOT NULL,
	cantidad_entrenadores INT UNSIGNED,
	entorno VARCHAR(30),
	nivel_min INT UNSIGNED,
	nivel_max INT UNSIGNED,
	id_region INT UNSIGNED,
	FOREIGN KEY (id_region) REFERENCES regiones(id)
);

CREATE TABLE IF NOT EXISTS pokemon (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	numero_pokedex INT UNSIGNED UNIQUE,
	nombre VARCHAR(20) NOT NULL UNIQUE,
	primer_tipo ENUM('Acero', 'Agua', 'Bicho', 'Dragón', 'Eléctrico', 'Fantasma', 'Fuego', 'Hada', 'Hielo', 'Lucha', 'Normal', 'Planta', 'Psíquico', 'Roca', 'Siniestro', 'Tierra', 'Veneno', 'Volador') NOT NULL,
	segundo_tipo ENUM('Acero', 'Agua', 'Bicho', 'Dragón', 'Eléctrico', 'Fantasma', 'Fuego', 'Hada', 'Hielo', 'Lucha', 'Normal', 'Planta', 'Psíquico', 'Roca', 'Siniestro', 'Tierra', 'Veneno', 'Volador'),
	generacion ENUM('Primera', 'Segunda', 'Tercera', 'Cuarta'),
	tiene_evolucion BOOLEAN,
	descripcion VARCHAR (500),
	id_region INT UNSIGNED,
	FOREIGN KEY (id_region) REFERENCES regiones(id),
	id_evoluciona_de INT UNSIGNED,
	FOREIGN KEY (id_evoluciona_de) REFERENCES pokemon(id)
);

CREATE TABLE IF NOT EXISTS pokemon_movimiento (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nivel_aprendizaje INT UNSIGNED DEFAULT 1,
	id_pokemon INT UNSIGNED,
	FOREIGN KEY (id_pokemon) REFERENCES pokemon(id),
	id_movimiento INT UNSIGNED,
	FOREIGN KEY (id_movimiento) REFERENCES movimientos(id)
);

CREATE TABLE IF NOT EXISTS pokemon_ruta (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	id_pokemon INT UNSIGNED,
	FOREIGN KEY (id_pokemon) REFERENCES pokemon(id),
	id_ruta INT UNSIGNED,
	FOREIGN KEY (id_ruta) REFERENCES rutas(id)
);

CREATE TABLE IF NOT EXISTS pokemon_habilidad (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	tipo_ranura ENUM('Primaria', 'Secundaria', 'Oculta') NOT NULL DEFAULT 'Primaria',
	id_pokemon INT UNSIGNED,
	FOREIGN KEY (id_pokemon) REFERENCES pokemon(id),
	id_habilidad INT UNSIGNED,
	FOREIGN KEY (id_habilidad) REFERENCES habilidades(id)
);







