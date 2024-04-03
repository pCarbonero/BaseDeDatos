DROP DATABASE IF EXISTS Instituto;
go
CREATE DATABASE Instituto;
go
USE Instituto;

CREATE TABLE Asignatura (
  cod 	INT 			PRIMARY KEY,
  nombre VARCHAR(15) NOT NULL UNIQUE,
  horas 	INT
  );

CREATE TABLE Profesor (
  nombre 	VARCHAR(20) NOT NULL,
  dni 		VARCHAR(9),
  jefeDpto 	VARCHAR(1) NOT NULL DEFAULT 'F',

  CONSTRAINT PK_PROF PRIMARY KEY (dni)
  );
  

CREATE TABLE Alumno (
  nombre VARCHAR(20) 	NOT NULL,
  dni 	VARCHAR(9)  	PRIMARY KEY,
  fecNac DATE  			NOT NULL,
  tutor 	VARCHAR(9),

  CONSTRAINT fkAlumProfe FOREIGN KEY (tutor) REFERENCES Profesor(dni) 
  );

CREATE TABLE Matriculado (
  dni VARCHAR(9) ,
  cod INT ,
  repe VARCHAR(1) NOT NULL DEFAULT 'F',
  nota INT,
  curso VARCHAR(9),

  CONSTRAINT PKMatric PRIMARY KEY(dni, cod, curso),
  CONSTRAINT fkMatAlum FOREIGN KEY (dni) REFERENCES Alumno(dni),
  CONSTRAINT fkMatAsig FOREIGN KEY (cod) REFERENCES Asignatura(cod)
  );

CREATE TABLE Imparte (
  dni 	VARCHAR(9),
  cod 	INT,
  turno VARCHAR(10) DEFAULT 'Ma?ana',

  CONSTRAINT pkImparte PRIMARY KEY(dni, cod),
  CONSTRAINT fkImpProfe FOREIGN KEY (dni) REFERENCES Profesor(dni),
  CONSTRAINT fkImpAsig  FOREIGN KEY (cod) REFERENCES Asignatura(cod)
  );