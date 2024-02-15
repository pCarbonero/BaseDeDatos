DROP DATABASE if exists Ejercicio06_boletin61
go
CREATE DATABASE Ejercicio06_boletin61
go 
USE Ejercicio06_boletin61
go

/*Drop table Sevilla
Drop table SevillaAtletico
Drop table SevillaSub19*/


CREATE TABLE Sevilla(
	presidente varChar(100) default 'por decidir',
	entrenador varChar(100),
	idEquipo tinyInt,
	CONSTRAINT PK_Sevilla PRIMARY KEY (presidente, idEquipo)
)

CREATE TABLE SevillaAtletico(
	presidente varChar(100) default 'por decidir',
	entrenador varChar(100),
	idEquipo tinyInt,
	idFilial tinyInt,
	CONSTRAINT PK_SevillaAtletico PRIMARY KEY (idFilial),
	CONSTRAINT FK_SevillAtletico_Sevilla_presidente FOREIGN KEY(presidente, idEquipo)
	REFERENCES Sevilla(presidente, idEquipo) on delete set null
)

CREATE TABLE SevillaSub19(
	presidente varChar(100) default 'por decidir',
	entrenador varChar(100),
	idEquipo tinyInt,
	idFilial tinyInt,
	CONSTRAINT PK_sevilla19 PRIMARY KEY (idFilial),
	CONSTRAINT FK_SevillaSub19_SevillaAtletico_presidente FOREIGN KEY(presidente, idEquipo)
	REFERENCES Sevilla(presidente, idEquipo) on delete set null
)


INSERT INTO Sevilla (presidente, entrenador, idEquipo) VALUES ('José María del Nido Benavente', 'Quique Sánchez Flores', '1');

INSERT INTO SevillaAtletico (presidente, entrenador, idEquipo, idFilial) VALUES ('José María del Nido Benavente', 'Jesús Galván', '1', '10');

INSERT INTO SevillaSub19 (presidente, entrenador, idEquipo, idFilial) VALUES ('José María del Nido Benavente', 'Lolo Rosano', '1', '20');

Select * From Sevilla
Select * From SevillaAtletico
Select * From SevillaSub19

/*ALTER TABLE Sevilla ADD CONSTRAINT PK_entrenadorSS PRIMARY KEY (entrenador)
ALTER TABLE SevillaAtletico ADD CONSTRAINT PK_entrenadorA PRIMARY KEY (entrenador)
ALTER TABLE SevillaSun19 ADD CONSTRAINT PK_entrenador19 PRIMARY KEY (entrenador)*/

DELETE FROM Sevilla WHERE presidente = 'José María del Nido Benavente';

use master;