/***********************************************************************
* Base de datos veterinaria
* Registra los datos de las mascotas, sus dueños, que son los clientes, 
* así como sus enfermedades y las visitas al veterinario.
*
* Autor: Leo
*
************************************************************************/
Create DataBase Bichos
GO
USE Bichos
GO
/****** Object:  Table BI_Clientes     ******/

CREATE TABLE BI_Clientes(
	Codigo Int NOT NULL,
	Telefono char(9) NOT NULL,
	Direccion varchar(30) NOT NULL,
	NumeroCuenta char(24) NULL,
	Nombre VarChar(30)
 ,CONSTRAINT PK_Clientes PRIMARY KEY (Codigo)
 ,CONSTRAINT [CK_Telefono] CHECK  (Telefono like '[679][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
) 

GO

/****** Object:  Table BI_Enfermedades     ******/

CREATE TABLE BI_Enfermedades(
	ID SmallInt Not NULL Identity (1,1)
	,Nombre VarChar(30) NOT NULL
	,Tipo Char(2) CONSTRAINT CKTiposPosibles Check (Tipo IN ('IN','VI','GE','PA'))
	,CONSTRAINT PK_Enfermedades PRIMARY KEY (ID)
)

GO
/****** Object:  Table [dbo].[BI_Mascotas]     ******/

CREATE TABLE BI_Mascotas(
	Codigo char(5) NOT NULL,
	Raza varchar(30) NOT NULL,
	Especie varchar(30) NOT NULL,
	FechaNacimiento date NOT NULL,
	FechaFallecimiento date NULL,
	Alias varchar(20) NOT NULL,
	CodigoPropietario Int Not NULL,
 CONSTRAINT PK_Mascotas PRIMARY KEY (Codigo)
 ,CONSTRAINT FK_MascotasPropietarios Foreign Key (CodigoPropietario) REFERENCES BI_Clientes (Codigo)
)

GO
/****** Object:  Table BI_Mascotas_Enfermedades     ******/

CREATE TABLE BI_Mascotas_Enfermedades(
	IDEnfermedad SmallInt NOT NULL,
	Mascota char(5) NOT NULL,
	FechaInicio date NOT NULL,
	FechaCura date NULL,
 CONSTRAINT PK_Mascotas_Enfermedades PRIMARY KEY (IDEnfermedad,	Mascota,FechaInicio)
 ,CONSTRAINT FK_MascotasEnfermedades_Enfermedades FOREIGN KEY(IDEnfermedad) REFERENCES BI_Enfermedades (ID) ON UPDATE CASCADE
 ,CONSTRAINT FK_MascotasEnfermedades_Mascotas FOREIGN KEY(Mascota) REFERENCES BI_Mascotas (Codigo) ON UPDATE CASCADE
)

GO
/****** Object:  Table BI_Visitas     ******/

CREATE TABLE BI_Visitas(
	IDVisita Int Not NULL Identity(1,1),
	Fecha smalldatetime NOT NULL,
	Temperatura tinyint NULL,
	Peso int NULL,
	Mascota char(5) NOT NULL,
 CONSTRAINT PK_Visitas PRIMARY KEY (IDVisita)
 ,CONSTRAINT FK_Visitas_Mascotas FOREIGN KEY(Mascota) REFERENCES BI_Mascotas (Codigo)
)

GO
/* Datos de prueba */
SET Dateformat 'ymd'

INSERT INTO BI_Clientes (Codigo,Telefono,Direccion,NumeroCuenta,Nombre)
     VALUES (101,'600000000','Desconocida',Null,'Propietario Desconocido')
	 ,(102,'601782667','Avenida de América, 104','ES4908230723061224560890','Josema Ravilla')
	 ,(103,'622687514','Calle Indalecio Prieto, 41','ES3248260728069924930821','Matilde Mente')
	 ,(104,'621479305','Plaza de la Libertad, 14','ES8046875230612245608905','Paco Barde')
	 ,(105,'654713356','Calle Sahara, 37','ES8848230523661824360834','Felipe Cador')
	 ,(106,'658004983','Calle Larga, 43','ES4901230123001234567890','Penelope Tarda')
GO
INSERT INTO BI_Enfermedades (Nombre,Tipo)
     VALUES ('Borreliosis','IN'),('Campilobacteriosis','IN'),('Rabia','VI'),('Sarna','PA')
	 ,('Hidatidiosis','VI'),('Toxoplasmosis','IN'),('Micobacteriosis','IN'),('Psitacosis','GE')
	 ,('Otitis canina','VI'),('Artritis','GE'),('Moquillo','VI'),('Parvoriosis','PA')
	 ,('Leishmaniosis','PA'),('Filariosis','IN'),('Leucemia','GE'),('Inmunodeficiencia','VI')
GO
INSERT INTO BI_Mascotas (Codigo,Raza,Especie,FechaNacimiento,FechaFallecimiento,Alias,CodigoPropietario)
     VALUES ('PM001','Galgo','Perro','20140504',Null,'Cuqui',101)
	 ,('PH002','Mastín','Perro','20160823',Null,'Sombra',102)
	 ,('GH003','Siamés','Gato','20181015',Null,'Misi',103)
	 ,('PM004','Caniche','Perro','20150106',Null,'Renato',104)
	 ,('CH005','Arabe','Caballo','20130210',Null,'Comtess',105)
	 ,('PH004','Setter','Perro','20170722',Null,'Luna',104)
	 ,('PM005','Podenco','Perro','20161127',Null,'Loco',105)
	 ,('GM006','Cartujo','Gato','20160823',Null,'Charlie',106)
	 ,('PH104','Setter','Perro','20170210',Null,'Salami',104)
	 ,('GH004','Siamés','Gato','20180516',Null,'Tuka',104)
	 ,('GM002','Británico','Gato','20190211',Null,'Pippin',102)
GO
INSERT INTO BI_Mascotas_Enfermedades (IDEnfermedad,Mascota,FechaInicio,FechaCura)
     VALUES
           (1,'PH002','20180601','20180821')
		   ,(2,'PH104','20180506','20180621')
		   ,(4,'PH002','20181221','20190321')
		   ,(7,'GH003','20180901','20181021')
		   ,(10,'GM002','20180607','20180821')
		   ,(3,'PH004','20181011','20190417')
		   ,(8,'GM006','20191214',Null)
		   ,(11,'PM004','20190216','20190511')
		   ,(13,'PM005','20200110',Null)
		   ,(10,'GM002','20180714','20180828')
		   ,(10,'CH005','20191222',Null)       

GO

INSERT INTO BI_Visitas (Fecha,Mascota,Temperatura,Peso)
     VALUES
           ('20180104 10:05','PM001',38,18),('20140104 11:00','PH002',38,32),('20150104 11:35','GH003',39,3),
		   ('20180204 12:04','PM004',38,5),('20140314 12:11','PH004',38,21),('20140310 13:00','CH005',39,400)
		   ,('20180521 10:40','PH004',38,22),('20140507 17:00','PM005',38,12),('20150724 17:20','GM006',39,2)
		   ,('20190104 10:55','PM001',38,18),('20150104 18:25','PH002',38,32),('20160104 11:30','GH003',39,3)
		   ,('20190204 10:00','PM004',38,5),('20150314 11:25','PH004',38,21),('20150310 12:40','CH005',39,400)
		   ,('20190521 12:30','PH004',38,22),('20150507 10:30','PM005',38,12),('20160724 16:50','GM006',39,2)
GO
