Create DataBase Ejercicio18
USE Ejercicio18

Create Table Area(
	codigo smallint primary key
)

Create Table Sede(
	codigo smallint Primary Key
)

Create Table Alumno(
	dni char(9) Primary Key
)

Create Table Coordinador(
	dni char(9) Primary Key
)

Create Table Profesor(
	dni char(9) primary key,
	cod_encarga smallint,
	cod_sede smallint,	
	CONSTRAINT FKarea_prof Foreign Key(cod_encarga)
	REFERENCES Area(codigo),
	CONSTRAINT FKsede_prof Foreign Key(cod_sede)
	REFERENCES Sede(codigo)
)

Create Table AreaProfesor(
	dni_profesor char(9),
	cod_area smallint,
	CONSTRAINT FKareaprof_area Foreign Key(cod_area)
	REFERENCES Area(codigo),
	CONSTRAINT FKareaprof_prof Foreign Key(dni_profesor)
	REFERENCES Profesor(dni),
	CONSTRAINT PKareaprof Primary Key (dni_profesor, cod_area)
)

Create Table AreaSede(
	cod_area smallint,
	cod_sede smallint,
	CONSTRAINT FKareasede_area Foreign Key(cod_area)
	REFERENCES Area(codigo),
	CONSTRAINT FKareasede_sede Foreign Key(cod_sede)
	REFERENCES Sede(codigo),
	CONSTRAINT PKareasede Primary Key (cod_sede, cod_area)
)

Create Table Curso(
	codigo smallint Primary Key,
	cod_area smallint,
	dni_coord char(9),
	CONSTRAINT FKarea_curso Foreign Key(cod_area)
	REFERENCES Area(codigo),
	CONSTRAINT FKcoor_curso Foreign Key(dni_coord)
	REFERENCES Coordinador(dni)
)

Create Table ProfesorCurso(
	dni_prof char(9),
	cod_curso smallint,
	CONSTRAINT FKprofcurso_prof Foreign Key(dni_prof)
	REFERENCES Profesor(dni),
	CONSTRAINT FKprofcurso_curso Foreign Key(cod_curso)
	REFERENCES Curso(codigo)
)

