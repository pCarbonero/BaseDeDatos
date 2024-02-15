DROP DATABASE IF EXISTS Agenda
go
CREATE DATABASE Agenda
go
USE Agenda
go

CREATE TABLE  Contactos (
  nombre varchar(25),
  dni varchar(9),
  PRIMARY KEY (dni)
) 

CREATE TABLE  Telefonos (
  id  int identity,
  numero varchar(9),
  dni varchar(9),
   PRIMARY KEY(id),
   FOREIGN KEY(dni) REFERENCES Contactos(dni) 
) 

INSERT INTO Contactos values('Ana', 111);
INSERT INTO Contactos values('Pepe', 222);
INSERT INTO Contactos values('Juan', 333);

INSERT INTO Telefonos (numero, dni) values (1111, 111);
INSERT INTO Telefonos (numero, dni) values (2222, 111);
INSERT INTO Telefonos (numero, dni) values (3333, 111);
INSERT INTO Telefonos (numero, dni) values (4444, 222);
INSERT INTO Telefonos (numero, dni) values (5555, 222);
INSERT INTO Telefonos (numero, dni) values (5555, 333);
