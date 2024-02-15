create DATABASE Ejercicio3
USE Ejercicio3

CREATE TABLE Futbolista(
	DNI varChar(9) Primary Key)

CREATE TABLE Partido(
	ID int Primary Key,
	fecha date not null)

CREATE TABLE Juega(
	DNI_Futbolista varChar(9)
	CONSTRAINT FKfutbolista FOREIGN KEY(DNI_Futbolista)
	REFERENCES Futbolista(DNI),
	fecha_partido date 
	CONSTRAINT FKpartido FOREIGN KEY(fecha_partido)
	REFERENCES Partido(fecha)
)