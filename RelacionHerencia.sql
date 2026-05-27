CREATE TABLE objetos (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(50) NOT NULL,
	precio INT NOT NULL	
);

CREATE TABLE capturas (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	probabilidades_captura DECIMAL(5, 2),
	id_objeto INT UNSIGNED,
	FOREIGN KEY (id_objeto) REFERENCES objetos(id)
);

CREATE TABLE curaciones (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	cantidad_ps INT UNSIGNED,
	id_objeto INT UNSIGNED,
	FOREIGN KEY (id_objeto) REFERENCES objetos(id)
);

CREATE TABLE pokemon_captura (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	id_pokemon INT UNSIGNED,
	FOREIGN KEY (id_pokemon) REFERENCES pokemon(id),
	id_captura INT UNSIGNED,
	FOREIGN KEY (id_captura) REFERENCES capturas(id)
);
	
CREATE TABLE pokemon_curacion (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	id_pokemon INT UNSIGNED,
	FOREIGN KEY (id_pokemon) REFERENCES pokemon(id),
	id_curacion INT UNSIGNED,
	FOREIGN KEY (id_curacion) REFERENCES curaciones(id)
);

