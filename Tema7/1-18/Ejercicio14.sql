Create Database Ejercicio14
Use Ejercicio14

Create Table Edificio(
	nombre varChar(15) Primary Key,
	direcion varChar(50)
	)

Create Table Obra(
	id smallint Primary Key
	)

Create Table Oficina(
	numero smallint,
	nombre_edificio varChar(15)
	CONSTRAINT PKoficina Primary Key(numero, nombre_edificio),
	CONSTRAINT FKedificio Foreign Key(nombre_edificio)
	REFERENCES Edificio(nombre)
	)

Create Table EmpleadoOficinista(
	dni varChar(9) Primary Key,
	nombre varChar(15),
	sueldo money,
	titulacion varChar(15),
	numero_oficina smallint,
	nombre_edificio varChar(15)
	CONSTRAINT FKoficina Foreign Key (numero_oficina, nombre_edificio)
	REFERENCES oficina(numero, nombre_edificio),
	jefe varChar(9)
	CONSTRAINT FKjefe Foreign Key(jefe)
	References EmpleadoOficinista(dni)
	)

Create Table EmpleadoObrero(
	dni varChar(9) Primary Key,
	nombre varChar(15),
	sueldo money,
	fechaInicio date,
	id_obra smallint
	CONSTRAINT FKobra Foreign Key(id_obra)
	REFERENCES Obra(id),
	jefe varChar(9)
	CONSTRAINT FKjefe Foreign Key(jefe)
	References EmpleadoOficinista(dni)
	)