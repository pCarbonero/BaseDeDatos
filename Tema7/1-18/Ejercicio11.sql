Create DataBase Ejercicio11
Use Ejercicio11

Create Table Alumno(
	dni char(9) Primary Key)

Create Table Ordenador(
	id smallint Primary Key)
	
Create Table Aplicación(
	título varChar(30) Primary Key)

Create Table Utiliza(
	Tiempo Char(8),
	dni_alumno char(9),
	id_ordenador smallint,
	tit_app varChar(30)
	CONSTRAINT PKutiliza Primary Key (dni_alumno, tit_app),
	CONSTRAINT FKalumno FOREIGN KEY (dni_alumno)
	REFERENCES Alumno(dni),
	CONSTRAINT FKordenador FOREIGN KEY (id_ordenador)
	REFERENCES Ordenador(id),	
	CONSTRAINT FKapp FOREIGN KEY (tit_app)
	REFERENCES Aplicación(título)
	)