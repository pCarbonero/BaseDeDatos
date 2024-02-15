DROP DATABASE IF EXISTS Libreria
go
CREATE DATABASE Libreria
go
USE Libreria
go


CREATE TABLE Editorial(
	nombre varCHar(15) PRIMARY KEY,
	telefono char(9)
)
go

CREATE TABLE Autor(
	nombre varChar(50) PRIMARY KEY,
	añoNacimiento date
)
go


CREATE TABLE Libro(
	isbn int PRIMARY KEY,
	titulo varChar(30),
	editorial varChar(15),
	autor varChar(50),
	CONSTRAINT FK_Libro_Autor_autor FOREIGN KEY (autor)
	REFERENCES Autor(nombre) ON DELETE NO ACTION,
	CONSTRAINT FK_Libro_Editorial_editorial FOREIGN KEY (editorial)
	REFERENCES Editorial(nombre) ON DELETE CASCADE
)
go

CREATE TABLE Stock(
	isbn int PRIMARY KEY,	
	cantidad smallint,
	CONSTRAINT FK_Stock_Libro_isbn FOREIGN KEY (isbn)
	REFERENCES Libro(isbn)
	ON DELETE NO ACTION
)


/*INSERT INTO Editorial values('Wheeler Bibles', '668125404');
INSERT INTO Editorial values('Barco de vapor', '954713069');

INSERT INTO Autor values('Irving Wallace', '16/04/1916');
INSERT INTO Autor values('N.D Wilson', '30/10/1969');

INSERT INTO Stock VALUES (1234, 10);
INSERT INTO Stock VALUES (6789, 5);

INSERT INTO Libro VALUES (12345, 'La Palabra', 'Wheeler Bibles', 'Irving Wallace');
INSERT INTO Libro VALUES (67899, '100 Puertas', 'Barco de vapor', 'N.D Wilson');





Select * from Libro



DROP TABLE Libro
DROP TABLE Editorial
DROP TABLE Autor
DROP TABLE Stock*/















