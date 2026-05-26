ALTER TABLE pokemon
	ADD altura FLOAT NOT NULL,
	ADD peso FLOAT NOT NULL;

ALTER TABLE regiones
	DROP COLUMN tiene_concursos;

ALTER TABLE pokemon
	MODIFY COLUMN generacion INT; 

ALTER TABLE pokemon_movimiento
	MODIFY COLUMN nivel_aprendizaje INT NOT NULL DEFAULT 1;

