DROP DATABASE IF EXISTS Ferreteria
go
CREATE DATABASE Ferreteria
go
USE Ferreteria
go


CREATE TABLE Tipo(
	tipo varChar(15) PRIMARY KEY,
	Descripcion varChar(200)
)
go

CREATE TABLE Tienda(
	id smallint Identity PRIMARY KEY,
	nombre varCHar(15)
)
go


CREATE TABLE Producto(
	nombre varChar(30),
	tipo varChar(15),
	precio money,
	CONSTRAINT PK_Producto PRIMARY KEY (nombre, tipo),
	CONSTRAINT FK_Producto_Tipo_tipo FOREIGN KEY (tipo)
	REFERENCES Tipo(tipo) ON DELETE NO ACTION ON UPDATE NO ACTION
)
go

CREATE TABLE Venta(
	tipo varChar(15),
	nombre varChar(30),
	fecha date,
	cantidad smallint,
	CONSTRAINT PK_Venta PRIMARY KEY (tipo, nombre, fecha),
	CONSTRAINT FK_Venta_Producto FOREIGN KEY (nombre, tipo) 
	REFERENCES Producto(nombre, tipo) ON DELETE NO ACTION
)
go

CREATE TABLE Vende(
	tipo varChar(15),
	nombre varChar(30),
	id_tienda smallint,
	CONSTRAINT FK_Vende_Producto FOREIGN KEY (nombre, tipo) 
	REFERENCES Producto(nombre, tipo),
	CONSTRAINT FK_Vende_Tienda_id FOREIGN KEY (id_tienda) 
	REFERENCES Tienda(id) ON DELETE SET NULL
)







Drop Table Tipo
Drop Table Tienda
Drop Table Producto
Drop Table Venta
Drop Table Vende

