--SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE Proyectos
GO
--DROP SCHEMA Proyectos 
--GO
  --CHARACTER SET latin1 COLLATE latin1_swedish_ci GO
USE Proyectos 

--DROP TABLE IF EXISTS Proyectos.Departamentos 
--GO
--DROP TABLE IF EXISTS Proyectos.Empleados 
GO
CREATE TABLE Empleados (
  dni INT NOT NULL,
  nombre VARCHAR(50) NULL,
  tratamiento VARCHAR(5) NULL,
  apellidos VARCHAR(50) NULL,
  fechanac DATETIME NULL,
  direccion VARCHAR(50) NULL,
  sexo VARCHAR(1) NULL,
  salario INT NULL,
  dnisuper INT NULL,
  numd INT NULL,
  CONSTRAINT PK_Empleados PRIMARY KEY (dni),
  --CONSTRAINT FK_Empleado_Empleado (dnisuper) REFERENCES Empleados (dni),
  --CONSTRAINT FK_Empleado_Departamentos FOREIGN KEY(numd) REFERENCES Departamentos (numd)
)


 GO
 --DROP TABLE IF EXISTS Proyectos.Dependientes 
CREATE TABLE Dependientes (
  dniempl INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  sexo VARCHAR(1) NULL,
  fechanac DATETIME NULL,
  parentesco VARCHAR(50) NULL,
  CONSTRAINT PK_Dependientes PRIMARY KEY (dniempl,nombre),
  CONSTRAINT Dependiente_Empleado FOREIGN KEY (dniempl) REFERENCES Empleados (dni)
)
 GO

 --DROP TABLE IF EXISTS Proyectos.Departamentos
CREATE TABLE Departamentos (
  numd INT NOT NULL,
  nombred VARCHAR(50) NULL,
  dnigte INT NULL,
  inicgte DATETIME NULL,
  CONSTRAINT PK_Departamentos PRIMARY KEY (numd),
  CONSTRAINT FK_Departman_Empleados FOREIGN KEY(dnigte) REFERENCES Empleados(dni)
)

 GO
  CREATE TABLE Lugar (
  lugar VARCHAR(50),
  descripcionLugar varchar(50),
  CONSTRAINT PK_Lugar PRIMARY KEY (lugar)
 )

 GO
ALTER TABLE EMPLEADOS 
ADD CONSTRAINT FK_Empleado_Empleado FOREIGN KEY(dnisuper) REFERENCES Empleados (dni),
    CONSTRAINT FK_Empleado_Departamentos FOREIGN KEY(numd) REFERENCES Departamentos (numd)

GO
--DROP TABLE IF EXISTS Proyectos.Lugares_dptos 
CREATE TABLE Lugares_dptos (
  numd INT NOT NULL,
  lugar VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Lugares_dptos PRIMARY KEY (numd, lugar),
  CONSTRAINT FK_LugaresDpto_Departmanto FOREIGN KEY(numd) REFERENCES Departamentos (numd),
  CONSTRAINT FK_LugaresDpto_Lugar FOREIGN KEY(lugar) REFERENCES Lugar(lugar)
)


GO
--DROP TABLE IF EXISTS Proyectos.Proyectos 
CREATE TABLE Proyectos (
  nump INT NOT NULL,
  nombrep VARCHAR(50) NULL,
  lugarp VARCHAR(50) NULL,
  numd INT NULL,
  CONSTRAINT PK_Proyectos PRIMARY KEY (nump),
  CONSTRAINT FK_Proyectos_Departamentos FOREIGN KEY(numd) REFERENCES Departamentos (numd)
)
 GO

--DROP TABLE IF EXISTS Proyectos.Trabaja_en
--GO
CREATE TABLE Trabaja_en (
  dni INT NOT NULL,
  nump INT NOT NULL,
  horas DECIMAL(7, 2) NULL,
  CONSTRAINT PK_Trabaja_en PRIMARY KEY (dni, nump),
  CONSTRAINT FK_Trabaja_en_Empleados FOREIGN KEY(dni) REFERENCES Empleados (dni),
  CONSTRAINT FK_Trabaja_en_Proyectos FOREIGN KEY(nump) REFERENCES Proyectos (nump)
)
;


--SET FOREIGN_KEY_CHECKS = 1;
