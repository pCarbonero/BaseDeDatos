Create DataBase Ejercicio15
Use Ejercicio15

Create Table Asignatura(
	codigo smallint Primary Key
	)

Create Table Estudio(
	codigo smallint Primary Key
	)

Create Table AsignaturEstudio(
	codAsig smallint,
	codEstudio smallint
	CONSTRAINT PKasig_est Primary Key(codAsig, codEstudio),
	CONSTRAINT FKasignatura Foreign Key(codAsig)
	REFERENCES Asignatura(codigo),
	CONSTRAINT FKestudio Foreign Key(codEstudio)
	REFERENCES Estudio(codigo)
	)

Create Table Expediente(
	numReg smallint Primary Key,
	dni_alumno char(9)
	)

Create Table Ficha(
	curso varChar(9),
	junio bit default(0),
	sepriembre bit default 0,
	numReg smallint,
	codAsig smallint
	CONSTRAINT PKficha Primary Key(numReg, codAsig),
	CONSTRAINT FKasignatura_ficha Foreign Key(codAsig)
	REFERENCES Asignatura(codigo),
	CONSTRAINT FKexpediente Foreign Key(numReg)
	REFERENCES Expediente(numReg)
	)

Create Table Grupo(
	codigo smallint Primary Key
	)

Create Table Profesor(
	nrp smallint Primary Key,
	horaAlumn time,
	horaPadres time,
	cod_seminario smallint
	)

Create Table Imparte(
	cod_asig smallint
	CONSTRAINT FKasignatura_imparte Foreign Key(cod_asig)
	REFERENCES Asignatura(codigo),
	nrp_prof smallint
	CONSTRAINT FKprofesor Foreign Key(nrp_prof)
	REFERENCES Profesor(nrp),
	cod_grupo smallint
	CONSTRAINT FKgrupo Foreign Key(cod_grupo)
	REFERENCES Grupo(codigo),
	CONSTRAINT PKimparte Primary Key(cod_asig, nrp_prof, cod_grupo),
	)

Create Table Tutoria(
	fecha date,
	nrp_profesor smallint
	CONSTRAINT FKprofesor_tutoria Foreign Key(nrp_profesor)
	REFERENCES Profesor(nrp),
	dni_alumno char(9)
	)

Create Table Seminario(
	codigo smallint Primary Key,
	jefe smallint
	CONSTRAINT FKprofesor_sem Foreign Key (jefe)
	REFERENCES Profesor(nrp)
	)

	ALTER TABLE Profesor ADD CONSTRAINT FKseminario
	FOREIGN KEY (cod_seminario) REFERENCES Seminario (codigo)


Create Table Alumno(
	dni char(9) primary key,
	codEstudio smallint,
	expediente smallint
	CONSTRAINT FKexpediente_alumno Foreign Key(expediente)
	REFERENCES Expediente(numReg),
	cod_grupo smallint
	CONSTRAINT FKgrupo_alumno Foreign Key(cod_grupo)
	REFERENCES Grupo(codigo)
	)

	ALTER TABLE Expediente ADD CONSTRAINT FKalumno_expediente
	FOREIGN KEY (dni_alumno) REFERENCES Alumno (dni)

	ALTER TABLE Tutoria ADD CONSTRAINT FKalumno_tuto
	FOREIGN KEY (dni_alumno) REFERENCES Alumno (dni)

Create Table TutorLegal(
	dni char(9) primary key)

Create Table AlumnoTutorLegal(
	dni_alumno char (9)
	CONSTRAINT FKalumno_tutoLegal Foreign Key (dni_alumno)
	REFERENCES Alumno(dni),
	dni_tutor char(9)
	CONSTRAINT FKtutorLegal Foreign Key (dni_tutor)
	REFERENCES TutorLegal(dni),
	CONSTRAINT PKalumnoTutorLegal Primary Key (dni_alumno, dni_tutor)
	)


