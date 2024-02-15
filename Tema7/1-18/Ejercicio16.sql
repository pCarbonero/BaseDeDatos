Create Database Ejercicio16
USE Ejercicio16

Create Table Empleado(
	codigo smallint primary key,
	nombre varChar(30),
	apellidos varChar(50),
	nif char(9),
	direccion varChar(30),
	telefono char(9),
	salario varChar(15)
)

Create table Capacitado(
	cod_empleado smallint primary key
	CONSTRAINT FKempleado_capacitado Foreign Key(cod_empleado)
	REFERENCES Empleado(codigo)
)

Create table No_Capacitado(
	cod_empleado smallint primary key
	CONSTRAINT FKempleado_Nocapacitado Foreign Key(cod_empleado)
	REFERENCES Empleado(codigo)
)

Create table Curso(
	codigo smallint primary key,
	nombre varChar(20),
	descripcion varChar(50)
)

Create table Edicion(
	cod_curso smallint,
	fecha_curso date,
	lugar varChar(15),
	horario time,
	cod_capacidad smallint,
	CONSTRAINT FKcurso Foreign Key (cod_curso)
	REFERENCES Curso (codigo),
	CONSTRAINT PKedicion Primary Key (cod_curso, fecha_curso)
)

Create table Recibe(
	cod_empleado smallint,
	cod_curso smallint,
	fecha_curso date,
	CONSTRAINT FKempleado_recibe Foreign Key (cod_empleado)
	REFERENCES Empleado (codigo),
	CONSTRAINT PKrecibe Primary Key (cod_curso, fecha_curso, cod_empleado),
	CONSTRAINT FKedicion Foreign key (cod_curso, fecha_curso)
	REFERENCES Edicion(cod_curso, fecha_curso)
)