Create DataBase Ejercicio12
Use Ejercicio12

Create Table Autobus(
	matricula char(7) Primary Key)

Create Table Linea(
	numero smallint Primary Key)

Create Table Calle(
	nombre varChar(20) Primary Key)

Create Table Conductor(
	dni Char(9) Primary Key,
	nombre_calle varChar(20)
	CONSTRAINT FKcalle FOREIGN KEY(nombre_calle)
	REFERENCES Calle(nombre)
	)

Create Table Pasa(
	num_linea smallint,
	nombre_calle varChar(20)
	CONSTRAINT PKpasa Primary Key(num_linea, nombre_calle)
	CONSTRAINT FKlinea Foreign Key (num_linea)
	REFERENCES Linea (numero),
	CONSTRAINT FKcalle_pasa FOREIGN KEY(nombre_calle) 
	REFERENCES Calle(nombre)
	)

Create Table Utiliza(
	dia varChar(8),
	dni_conductor Char(9),
	mat_autobus Char(7),
	num_linea smallint,
	CONSTRAINT PKutiliza Primary Key(dni_conductor, mat_autobus, dia),
	CONSTRAINT FKconductor Foreign Key(dni_conductor)
	REFERENCES Conductor(dni),
	CONSTRAINT FKautobus Foreign Key(mat_autobus)
	REFERENCES Autobus(Matricula),
	CONSTRAINT FKlinea_utiliza Foreign Key(num_linea)
	REFERENCES Linea(numero)
	)
