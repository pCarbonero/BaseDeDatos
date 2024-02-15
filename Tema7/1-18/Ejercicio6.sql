CREATE DATABASE Ejercicio6
USE Ejercicio6

CREATE TABLE Persona(
	DNI varChar(9) Primary Key)

CREATE TABLE Coche(
	Matricula varChar(7) Primary Key,
	Color varChar(20))

CREATE TABLE Posee(
	Fecha date not null,
	DNI_Comprador varChar(9),
	Matricula_Coche varChar(7)
	CONSTRAINT PKposee primary key(Fecha, DNI_Comprador, Matricula_Coche)
	CONSTRAINT FKpersona FOREIGN KEY(DNI_Comprador)
	REFERENCES Persona(DNI),
	CONSTRAINT FKcoche FOREIGN KEY (Matricula_Coche)
	REFERENCES Coche(Matricula)
	)

