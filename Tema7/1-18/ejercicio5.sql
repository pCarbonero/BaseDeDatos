create DATABASE Ejercicio5
USE Ejercicio5

CREATE TABLE Persona(
	DNI varChar(9) Primary Key)

CREATE TABLE Coche(
	Matricula varChar(7),
	Color varChar(10) not Null,
	Dueño varChar(9)
	CONSTRAINT FKpersona FOREIGN KEY(Dueño)
	REFERENCES Persona(DNI)
	)