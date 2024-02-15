CREATE DATABASE Ejercicio10
USE Ejercicio10

Create Table Alumno(
	dni char(9) Primary Key)

Create Table Ordenador(
	id smallint Primary Key)

Create Table Aula(
	número int Primary Key)

Create Table Utiliza(
	Curso varChar(9),
	dni_alumno char(9),
	id_ordenador smallint
	CONSTRAINT PKutiliza Primary Key(Curso, dni_alumno, id_ordenador)
	CONSTRAINT FKalumno FOREIGN KEY(dni_alumno)
	REFERENCES alumno(dni),
	CONSTRAINT FKordenador FOREIGN KEY(id_ordenador)
	REFERENCES ordenador(id)
	)

Create Table Está(
	Curso varChar(9) Primary Key,
	num_aula int,
	id_ordenador smallint
	CONSTRAINT FKaula FOREIGN KEY(num_aula)
	REFERENCES Aula(número),
	CONSTRAINT FKordenadorDos FOREIGN KEY(id_ordenador)
	REFERENCES ordenador(id)
	)


