Create DataBase Ejercicio17
USE Ejercicio17

Create Table Municipio(
	cp char(5) primary key
)

Create Table Vivienda(
	calle varChar(20),
	numero smallint,
	cp_mun char(5)
	CONSTRAINT FKmunicipio Foreign Key(cp_mun)
	REFERENCES Municipio(cp),
	CONSTRAINT PKvivienda Primary Key (calle, numero, cp_mun)
)

Create Table Persona(
	dni char(9) PRIMARY KEY,
	vive int,
	empadronada_municipio char(5),
	calle_vivienda varChar(20),
	numero_vivienda smallint,
	cp_vivienda char(5),
	cabezaFamilia char(9),
	CONSTRAINT FKmunicipio_persona Foreign Key(empadronada_municipio)
	REFERENCES Municipio(cp),
	CONSTRAINT FKvivienda Foreign Key(calle_vivienda, numero_vivienda, cp_vivienda)
	REFERENCES Vivienda(calle, numero, cp_mun),
	CONSTRAINT FKpersona Foreign Key(cabezaFamilia)
	REFERENCES Persona(dni) 
)

Create Table Propietaria(
	dni_persona char(9),
	calle_vivienda varChar(20),
	numero_vivienda smallint,
	cp_vivienda char(5),
	CONSTRAINT FKpersona_propietaria Foreign Key(dni_persona)
	REFERENCES Persona(dni),
	CONSTRAINT FKvivienda_propietaria Foreign Key(calle_vivienda, numero_vivienda, cp_vivienda)
	REFERENCES Vivienda(calle, numero, cp_mun)
)