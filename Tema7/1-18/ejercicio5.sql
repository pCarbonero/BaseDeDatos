create DATABASE Ejercicio5
USE Ejercicio5

CREATE TABLE Persona(
	DNI varChar(9) Primary Key)

CREATE TABLE Coche(
	Matricula varChar(7),
	Color varChar(10) not Null,
	Due�o varChar(9)
	CONSTRAINT FKpersona FOREIGN KEY(Due�o)
	REFERENCES Persona(DNI)
	)