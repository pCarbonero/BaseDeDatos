Create Database Ejercicio13
Use Ejercicio13

Create Table Edificio(
	nombre varChar(15) Primary Key,
	direccion varChar(50)
	)

Create Table Empresa(
	cif Char(9) Primary Key,
	nombre varCHar(15)
	)

Create Table Oficinas(
	numero smallint,
	nombre_edificio varChar(15)
	CONSTRAINT PKoficinas Primary Key(numero, nombre_edificio)
	CONSTRAINT FKedificio Foreign Key(nombre_edificio)
	REFERENCES Edificio(nombre),
	cif_empresa Char(9)
	CONSTRAINT FKempresa Foreign Key(cif_empresa)
	REFERENCES Empresa(cif)
	)
