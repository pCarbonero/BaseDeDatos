Create DATABASE Ejercicio4
USE Ejercicio4

CREATE TABLE Cliente(
	DNI varChar(9) Primary Key)

CREATE TABLE Traje(
	Modelo varChar(20) Primary Key)

CREATE TABLE Compra(
	DNI_Cliente varChar(9)
	CONSTRAINT FKcliente FOREIGN KEY(DNI_Cliente)
	REFERENCES Cliente(DNI),
	Modelo_Traje varChar(20)
	CONSTRAINT FKtraje FOREIGN KEY(Modelo_Traje)
	REFERENCES Traje(Modelo),
	Unidades int not null
	)


