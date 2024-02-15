CREATE DATABASE Ejercicio9
USE Ejercicio9

Create Table Aula(
	n�mero int Primary Key
	)

Create Table Ordenador(
	id int Primary Key,
	num_aula int
	CONSTRAINT FKaula FOREIGN KEY (num_aula)
	REFERENCES Aula(n�mero)
	)

CREATE TABLE Alumno(
	dni varChar(9) Primary Key,
	num_ordenador int
	CONSTRAINT FKordenador FOREIGN KEY (num_ordenador)
	REFERENCES Ordenador(id)
	)