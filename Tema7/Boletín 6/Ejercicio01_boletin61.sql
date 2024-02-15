DROP DATABASE IF EXISTS Agenda
go
CREATE DATABASE Agenda
go
USE Agenda
go

CREATE TABLE  Contactos (
  nombre varchar(25),
  dni varchar(9) PRIMARY KEY,
) 
go

CREATE TABLE  Telefonos (
  id int IDENTITY,
  numero varchar(9),
  dni varchar(9),
   PRIMARY KEY(id),
   FOREIGN KEY(dni) REFERENCES Contactos(dni)
   --ON DELETE CASCADE ON UPDATE CASCADE
   --ON DELETE NO ACTION ON UPDATE NO ACTION
   ON DELETE SET NULL ON UPDATE SET NULL
)
go


INSERT INTO Contactos values('Ana', '111');
INSERT INTO Contactos values('Pepe', '222');
INSERT INTO Contactos values('Juan', '333');

INSERT INTO Telefonos (numero, dni) values ('1111', '111');
INSERT INTO Telefonos (numero, dni) values ('2222', '111');
INSERT INTO Telefonos (numero, dni) values ('3333', '111');
INSERT INTO Telefonos (numero, dni) values ('4444', '222');
INSERT INTO Telefonos (numero, dni) values ('5555', '222');
INSERT INTO Telefonos (numero, dni) values ('5555', '333');

SELECT * FROM Contactos;
SELECT * FROM Telefonos;

DELETE FROM CONTACTOS WHERE dni = '111';

drop table Contactos
drop table Telefonos