USE master
go
DROP DATABASE IF EXISTS Colegas
go
Create Database Colegas
go
Use Colegas
GO
-- People
Create Table People (
	ID SmallInt Not NULL Constraint PKPeople Primary Key,
	Nombre VarChar(20) Not NULL,
	Apellidos VarChar(20) Not NULL,
	FechaNac Date NULL
)
GO
-- Carros
Create Table Carros (
	ID SmallInt Not NULL Constraint PKCarros Primary Key,
	Marca VarChar(15) Not NULL,
	Modelo VarChar(20) Not NULL,
	Anho SmallInt NULL Constraint CKAnno Check (Anho Between 1900 AND YEAR(Current_Timestamp)),
	Color VarChar(15),
	IDPropietario SmallInt NULL Constraint FKCarroPeople Foreign Key References People (ID) On Update No action On Delete No action
)
-- Libros
Create Table Libros(
	ID Int Not NULL Constraint PKLibros Primary Key,
	Titulo VarChar(60) Not NULL,
	Autors VarChar(50) NULL
)
GO
--Lecturas
Create Table Lecturas(
	IDLibro Int Not NULL,
	IDLector SmallInt Not NULL,
	Constraint PKLecturas Primary Key (IDLibro, IDLector),
	Constraint FKLecturasLibros Foreign Key (IDLibro) References Libros (ID) On Update No action On Delete No action,
	Constraint FKLecturasLectores Foreign Key (IDLector) References People (ID) On Update No action On Delete No action,
	AnhoLectura SmallInt NULL
)

--INSERT PEOPLE
INSERT INTO People (ID, Nombre, Apellidos, FechaNac) VALUES (1, 'Eduardo', 'Mingo', '14/07/1990');
INSERT INTO People (ID, Nombre, Apellidos, FechaNac) VALUES (2, 'Margarita', 'Padera', '11/11/1992');
INSERT INTO People (ID, Nombre, Apellidos, FechaNac) VALUES (4, 'Eloisa', 'Lamandra', '02/03/2000');
INSERT INTO People (ID, Nombre, Apellidos, FechaNac) VALUES (5, 'Jordi', 'Wild', '28/05/1989');
INSERT INTO People (ID, Nombre, Apellidos, FechaNac) VALUES (6, 'Alfonso', 'Sito', '10/10/1978');


--INSERTS CARROS
INSERT INTO Carros (ID, Marca, Modelo, Anho, Color) VALUES 
(1, 'Seat', 'Ibiza', 2014, 'Blanco');
INSERT INTO Carros (ID, Marca, Modelo, Anho, Color, IDPropietario) VALUES
(2, 'Ford', 'Focus', 2016, 'Rojo', 1),
(3, 'Toyota', 'Prius', 2017, 'Blanco', 4),
(5, 'Renault', 'Megane', 2004, 'Azul', 2),
(8, 'Mitsubishi', 'Colt', 2011, 'Rojo', 6)

--INSERTS LIBROS
INSERT INTO Libros (ID, Titulo, Autors) VALUES
(2, 'El corazón de las Tinieblas', 'Joseph Conrad'),
(4, 'Cien años de soledad', 'Gabriel García Márquez'),
(8, 'Harry Potter y la cámara de los secretos', 'J.K. Rowling'),
(16, 'Evangelio del Flying Spaguetti Monster', 'Bobby Henderson')

--INSERTS LECTURAS
INSERT INTO Lecturas (IDLibro, IDLector) VALUES
(4, 1), 
(2, 2), 
(4, 4), (8, 4), 
(16, 5),
(16, 6)


SELECT * From People
SELECT * From Carros
SELECT * From Libros
SELECT * From Lecturas

--5
BEGIN TRANSACTION VentaCocheMargarita
UPDATE Carros
Set IDPropietario = 6 Where IDPropietario = 2
SELECT * FROM Carros
COMMIT TRANSACTION VentaCocheMargarita

--6
SELECT Nombre, Apellidos FROM People
WHERE FechaNac < '01/01/1994'

--7
SELECT Marca, Anho, Modelo From Carros
WHERE Color Not Like 'Blanco'

--8
Insert into Libros (ID, Titulo, Autors)  Values (33, 'Vidas Santas', 'Abate Bringas')
BEGIN TRANSACTION CambioReligion
UPDATE Lecturas
Set IDLibro = 33 WHERE IDLibro = 16
SELECT * FROM Lecturas
COMMIT TRANSACTION CambioReligion

--9
INSERT INTO Lecturas (IDLibro, IDLector) Values (2, 4)

--10
BEGIN TRANSACTION CompraSeat
UPDATE Carros 
Set IDPropietario = 5 Where IDPropietario is NULL
SELECT * FROM Carros
COMMIT TRANSACTION CompraSeat

--11
SELECT IDLector FROM Lecturas
WHERE IDLibro%2 = 0
