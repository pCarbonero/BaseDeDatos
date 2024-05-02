SET Dateformat ymd
Create DataBase AntonioTurf
Go
USE AntonioTurf
GO
/****** Object:  StoredProcedure [dbo].[AsignaPremios]    ******/

CREATE Procedure [dbo].[AsignaPremios] (@Carrera SmallInt) AS
  Begin
    SET NOCOUNT ON
	Declare @TotalApostado SmallMoney, @PremioPrimero SmallMoney, @PremioSegundo SmallMoney
	-- Calculamos el total de las apuestas de esa carrera
	Select @TotalApostado = Sum (Importe) From LTApuestas
		Where IDCarrera = @Carrera
	-- Repartimos por categorias
	--Para los que acierten el primero el 60%
	Set @PremioPrimero = @TotalApostado * 0.6
	-- Para los que acierten el segundo, el 20%
	Set @PremioSegundo = @TotalApostado * 0.2
	Update LTCaballosCarreras 
		Set Premio1 = IsNull(@PremioPrimero/dbo.TotalApostadoCC(IDCaballo,@Carrera),100)
		, Premio2 = IsNull(@PremioSegundo/dbo.TotalApostadoCC(IDCaballo,@Carrera),100)
		Where IDCarrera = @Carrera
	SET NOCOUNT OFF
  End -- Procedure AsignaPremios
GO
/****** Object:  StoredProcedure [dbo].[grabaApuesta]     ******/

CREATE PROCEDURE [dbo].[grabaApuesta] 
	@Carrera SmallInt
	,@Caballo SmallInt
	,@Importe SmallMoney
	,@Clave Char(12)
	,@Id SmallInt OUTPUT
	AS Begin
		INSERT INTO LTApuestas ( Clave, IDCaballo, IDCarrera,Importe) VALUES (@Clave, @Caballo, @Carrera, @Importe) 
		SET @ID = @@IDENTITY
	End --PROCEDURE grabaApuesta 
GO
/****** Object:  UserDefinedFunction [dbo].[TotalApostadoCC]    ******/

  -- Función que nos devuelve la cantidad apostada por un caballo en una carrera. Si no se ha apostado nada, devuelve NULL
  Create Function [dbo].[TotalApostadoCC] (@Caballo SmallInt, @Carrera SmallInt) Returns SmallMoney AS
  Begin
	Declare @Importe SmallMoney
	Select @Importe = Sum (Importe) From LTApuestas
		Where IDCaballo = @Caballo AND IDCarrera = @Carrera
	Return @Importe
  End	--Function TotalApostadoCC
GO
/****** Object:  StoredProcedure GeneraApuntes     ******/
-- Actualiza la tablaApuntes con las apuestas realizadas entre dos fechas
Create Procedure GeneraApuntes @FechaInicio Date, @FechaFin Date AS
Begin
	SET NOCOUNT ON
	Declare @IDAp Int, @Pasta SmallMoney, @IDJug Int, @UltimoApunte Int, @Fecha Date
	Declare CApuestas Cursor For
		Select A.ID,A.Importe, A.IDJugador, C.Fecha FROM LTApuestas AS A
			Inner JOIN LTCarreras AS C ON A.IDCarrera = C.ID
			Where C.Fecha Between @FechaInicio AND @FechaFin
			Order By A.ID
	Open CApuestas
	-- Recorremos las apuestas
	Fetch Next From CApuestas INTO @IDAp, @Pasta, @IDJug, @Fecha
	While @@FETCH_STATUS = 0
	Begin
		Begin Transaction
		Select @UltimoApunte = MAX(Orden) From LTApuntes Where IDJugador = @IDJug
		-- Insertamos el apunte correspondiente a la apuesta
		Insert INTO LTApuntes (IDJugador,Orden,Fecha,Importe,Saldo,Concepto)
			SELECT @IDJug,@UltimoApunte+1,@Fecha,-@Pasta, Saldo-@Pasta, 'Apuesta '+CAST(@IDAp AS VarChar) FROM LTApuntes
				Where IDJugador = @IDJug AND Orden = @UltimoApunte
		Set @Pasta = dbo.PremioConseguido(@IDAp)
		IF @Pasta > 0
			Insert INTO  LTApuntes (IDJugador,Orden,Fecha,Importe,Saldo,Concepto)
				SELECT @IDJug,@UltimoApunte+2,@Fecha,@Pasta, Saldo+@Pasta, 'Premio por la apuesta '+CAST(@IDAp AS VarChar) FROM LTApuntes
					Where IDJugador = @IDJug AND Orden = @UltimoApunte+1
		Commit
		Fetch Next From CApuestas INTO @IDAp, @Pasta, @IDJug, @Fecha
	End	-- While
	Close CApuestas
	Deallocate CApuestas
	SET NOCOUNT OFF
End	--Procedure GeneraApuntes
GO
/****** Object:  UserDefinedFunction PremioConseguido    ******/
-- Devuelve la cantidad ganada con una apuesta
Create Function PremioConseguido ( @IDApuesta Int )
	Returns SmallMoney AS
	Begin
	Declare @Premio SmallMoney = 0
	Declare @Posicion TinyInt
	Select @Posicion = Posicion FROM LTCaballosCarreras AS CC
		Inner Join LTApuestas AS A ON CC.IDCaballo = A.IDCaballo AND CC.IDCarrera = A.IDCarrera
		Where A.ID = @IDApuesta
	IF @Posicion = 1
		Select @Premio = A.Importe*CC.Premio1 FROM LTCaballosCarreras AS CC
			Inner Join LTApuestas AS A ON CC.IDCaballo = A.IDCaballo AND CC.IDCarrera = A.IDCarrera
			Where A.ID = @IDApuesta
	Else If @Posicion = 2
		Select @Premio = A.Importe*CC.Premio2 FROM LTCaballosCarreras AS CC
			Inner Join LTApuestas AS A ON CC.IDCaballo = A.IDCaballo AND CC.IDCarrera = A.IDCarrera
			Where A.ID = @IDApuesta
	Return @Premio
	End	--Function PremioConseguido
GO
/****** Object:  Table [dbo].[LTHipodromos]    ******/

CREATE TABLE LTHipodromos(
	[Nombre] [varchar](30) NOT NULL,
 CONSTRAINT [PKHipodromo] PRIMARY KEY (Nombre)
)
GO
/****** Object:  Table [dbo].[LTCarreras]     ******/

CREATE TABLE LTCarreras(
	ID smallint NOT NULL,
	Hipodromo varchar(30) NOT NULL,
	Fecha date NOT NULL,
	NumOrden smallint NOT NULL,
 CONSTRAINT PKCarreras PRIMARY KEY (ID),
 CONSTRAINT FKCarrerasHipodromos FOREIGN KEY (Hipodromo)
	REFERENCES LTHipodromos (Nombre) ON UPDATE CASCADE,
 CONSTRAINT UQDenominacionInformal UNIQUE (Hipodromo,Fecha,NumOrden)
)
/****** Object:  Table [dbo].[LTCaballos]     ******/

CREATE TABLE LTCaballos(
	ID smallint NOT NULL,
	Nombre varchar(30) NOT NULL,
	FechaNacimiento date NULL,
	Sexo char(1) NULL,
 CONSTRAINT PKCaballos PRIMARY KEY (ID),
 CONSTRAINT CKSexo CHECK (Sexo IN ('M','H')),
 CONSTRAINT UQNombre UNIQUE (Nombre)
) 

/****** Object:  Table [dbo].[LTJugadores]     ******/

CREATE TABLE LTJugadores(
	ID int NOT NULL,
	[Nombre] [varchar](20) NOT NULL,
	[Apellidos] [varchar](30) NOT NULL,
	[Direccion] [varchar](50) NULL,
	[Telefono] [char](9) NULL,
	[Ciudad] [varchar](20) NOT NULL,
 CONSTRAINT [PKJugadores] PRIMARY KEY (ID)
) 
GO
/****** Object:  Table LTApuntes     ******/
CREATE Table LTApuntes(
	IDJugador Int Not NULL
	,Orden Int Not NULL
	,Fecha Date Not NULL
	,Importe SmallMoney Not NULL
	,Saldo SmallMoney Not NULL
	,Concepto VarChar(80) NULL
	,Constraint PKApuntes Primary Key (IDJugador, Orden)
	,Constraint FKApuntesJugadores Foreign Key (IDJugador) References LTJugadores (ID) On Delete No Action On Update No action
)
GO
/****** Object:  Table LTApuestas     ******/

CREATE TABLE LTApuestas(
	ID int IDENTITY(1,1) NOT NULL,
	Clave char(12) NULL,
	IDCaballo smallint NOT NULL,
	IDCarrera smallint NOT NULL,
	Importe smallmoney NOT NULL,
	IDJugador int NULL,
 CONSTRAINT PKApuestas PRIMARY KEY (ID),
 CONSTRAINT CK_ImporteApuesta CHECK (Importe>1),
 CONSTRAINT FKApuestasCaballos FOREIGN KEY(IDCarrera)
	REFERENCES LTCarreras (ID),
 CONSTRAINT FKApuestasCarreras FOREIGN KEY(IDCaballo)
	REFERENCES LTCaballos (ID),
 CONSTRAINT FKApuestasJugadores FOREIGN KEY(IDJugador)
	REFERENCES LTJugadores (ID) ON UPDATE CASCADE
) 

GO

/****** Object:  Table [dbo].[LTCaballosCarreras]     ******/

CREATE TABLE LTCaballosCarreras(
	IDCaballo smallint NOT NULL,
	IDCarrera smallint NOT NULL,
	Numero tinyint NOT NULL,
	Posicion tinyint NULL,
	Premio1 decimal(4, 1) NULL,
	Premio2 decimal(4, 1) NULL,
 CONSTRAINT PKCaballosCarreras PRIMARY KEY (IDCaballo,IDCarrera),
 CONSTRAINT FKCarrerasCaballos FOREIGN KEY(IDCarrera)
	REFERENCES LTCarreras (ID),
 CONSTRAINT FKCaballosCarreras FOREIGN KEY(IDCaballo)
	REFERENCES LTCaballos (ID),
 CONSTRAINT UQNumeroUnico UNIQUE (IDCarrera,Numero)
)

GO
-- Hipódromos
INSERT LTHipodromos (Nombre) VALUES ('Argentino de Palermo')
, ('Costa del Sol'),('Gran Hipodromo de Andalucia'), ('La Zarzuela'), ('Las Mestas')
INSERT LTHipodromos (Nombre) VALUES ('Lasarte')
, ('Pineda'), ('Royal Ascott'), ('Son Pardo')
GO
INSERT LTJugadores (ID,Nombre, Apellidos, Direccion, Telefono, Ciudad) VALUES (1, 'Aitor', 'Tilla Perez', 'Calle Japon, 32', '954054940', 'Sevilla')
, (2, 'Armando', 'Bronca Segura', 'Calle Pakistan, 18', '954654345', 'Sevilla')
, (3, N'Cristina', N'Sanchez Salcedo', N'Plaza Redonda, 14 ', N'954752006', N'Málaga')
, (4, N'Jesus', N'Rodriguez Jurado', N'Avda de las Letanias, 19 ', N'954090439', N'Sevilla')
, (5, N'Javier', N'Rodriguez Pariente', N'Calle Fandango, 5', N'954041392', N'Huelva')
, (6, N'Borja', N'Monero', N'Av. del Sol, 47                                   ', N'678002451', N'Sevilla')
, (7, N'Elena', N'Dadora', N'Calle 14 de Abril, 10   ', N'606441980', N'Sevilla')
, (8, N'Rocio', N'Marin Romero', N'Calle Estadio, 76', N'959654425', N'Córdoba')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (9, N'Vicente', N'Mata Gente', N'Calle Afganistan   ', N'954092930', N'Sevilla')
,(10, N'Joyce', N'Greer', N'Paseo de la Castellana', N'600123945', N'Madrid')
, (11, N'Armando', N'El Pollo', N'Av. de la República', N'600123958', N'Madrid')
,(12, N'Rick', N'Hendricks', N'Plaza de la Concordia', N'600123971', N'Salamanca')
, (13, N'Joa', N'Baker', N'Calle Pi y Margall', N'612123984', N'Girona')
, (14, N'Clifford', N'Underwood', N'Calle Iturbi, 12', N'600123997', N'Bilbao')
, (15, N'Juan', N'Ybarra', N'Paseo de la Castellana', N'600124010', N'Madrid')
, (16, N'Dominique', N'Lyons', N'Calle Larios, 31', N'694124023', N'Málaga')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (17, N'Jasmine', N'Callahan', N'47, Regent Crescent', N'600124036', N'Manchester')
, (18, N'Neil', N'Lynch', N'19, Brunswick Terrace', N'649354049', N'Brighton')
, (19, N'Kimberly', N'Huerta', N'Almirante Topete, 36', N'600124062', N'Madrid')
, (20, N'Margarita', N'García', N'Filipinas, 157', N'600124075', N'Santander')
, (21, N'Kara', N'Cardenas', N'Paseo de la Castellana', N'600124088', N'Cáceres')
, (22, N'Dustin', N'Torres', N'Av. de la Libertad, 4', N'600124101', N'Madrid')
, (23, N'Lewis', N'Wagner', N'Plaza Mayor, 87', N'600124114', N'Valladolid')
, (24, N'Abigail', N'Lowery', N'Calle Ramón y Cajal. 73', N'600124127', N'Utrera')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (25, N'Gabriel', N'Sosa', N'Paseo de la Castellana', N'600124140', N'Madrid')
, (26, N'Teddy', N'Nielsen', N'Recogidas, 48', N'600124153', N'Granada')
, (27, N'Stephany', N'Knox', N'Plaza de las Monjas, 25', N'600124166', N'Huelva')
, (28, N'Ethan', N'Booth', N'Rector Esperabé, 114', N'679224179', N'Salamanca')
, (29, N'Olga', N'Melto', N'Paseo de la Castellana, 112', N'600124192', N'Madrid')
, (100, N'Juan', N'Tanamera', N'Av. de la República Argentina, 25', N'663124205', N'Sevilla')
, (101, N'Ana', N'Vegante', N'Calle Pelota', N'600124218', N'Cádiz')
, (200, N'Esteban', N'Quero', N'Calle Habana', N'600124231', N'Sevilla')
INSERT [dbo].[LTJugadores] ([ID], [Nombre], [Apellidos], [Direccion], [Telefono], [Ciudad]) VALUES (207, N'Fernando', N'Minguero', N'Av. de la Victoria', N'674355989', N'Málaga')
, (214, N'Elisa', N'Ladita', N'Calle Mediterráneo, 54', N'600124257', N'Sevilla')
, (220, N'Paco', N'Merselo', N'Calle Pelota', N'600124270', N'Cádiz')
, (234, N'Simon', N'Toncito', N'Gran Vía, 27', N'600124283', N'Granada')
, (245, N'Aitor', N'Menta', N'Plaza del Txakolí, 10', N'633874296', N'Bilbao')
, (307, N'Olga', N'Llinero', N'Calle Pelota, 31', N'600124309', N'Valladolid')
, (407, N'Jeremias', N'Mas', N'Don Remondo, 38', N'600124322', N'Sevilla')
, (440, N'Juan Luis', N'Guerra', N'Calle Pelota', N'600124335', N'Cádiz')
INSERT LTJugadores (ID, Nombre, Apellidos, Direccion, Telefono, Ciudad) VALUES (507, 'Salud', 'Itos', 'Carrer de Napols', '600124348', 'Barcelona')
, (516, 'Ramon', 'Tañero', 'Calle General Riego', '600124361', 'Málaga')
, (607, 'Susana', 'Tillas', 'Av. Pablo Picasso', '600124374', 'Cáceres')
, (736, 'Pedro', 'Medario', 'Calle Sahara, 14', '600124387', 'Huelva')


-- Caballos

INSERT LTCaballos (ID, Nombre, FechaNacimiento, Sexo) VALUES (1, 'Ciclon', CAST('2010-05-16' AS Date), 'M')
, (2, 'Nausica', CAST('2010-07-06' AS Date), 'H')
, (3, 'Avalancha', CAST('2011-01-04' AS Date), 'M')
, (4, 'Cirene', CAST('2009-11-14' AS Date), 'H')
, (5, 'Galatea', CAST('2010-10-10' AS Date), 'H')
, (6, 'Chicharito', CAST('2009-02-21' AS Date), 'M')
, (7, 'Vetonia', CAST('2011-01-30' AS Date), 'H')
, (8, 'Shumookh', CAST('2010-03-11' AS Date), 'M')
, (9, 'Anibal', CAST('2010-08-28' AS Date), 'M')
, (10, 'Path of Hope', CAST('2008-04-10' AS Date), 'M')
, (11, 'Fiona', CAST('2009-03-26' AS Date), 'H')
, (12, 'Sigerico', CAST('2009-12-15' AS Date), 'M')
INSERT LTCaballos (ID, Nombre, FechaNacimiento, Sexo) VALUES (13, 'Godofredo', CAST(N'2008-11-20' AS Date), 'M')
, (14, 'Agustina II', CAST('2011-01-06' AS Date), 'H')
, (15, 'Alarico', CAST('2010-06-09' AS Date), 'M')
, (16, 'Desdemona', CAST('2011-02-14' AS Date), 'H')
, (17, 'Gorgonia', CAST('2010-10-01' AS Date), 'H')
, (18, 'Daphne', CAST('2010-07-06' AS Date), 'H')
, (19, 'Witiza', CAST('2009-12-15' AS Date), 'M')
, (20, 'Rodrigo', CAST('2008-11-20' AS Date), 'M')
, (21, 'Ava', CAST('2011-01-06' AS Date), 'H')
, (22, 'Chindasvinto', CAST('2010-06-09' AS Date), 'M')
, (23, 'Urraca', CAST(N'2011-02-14' AS Date), 'H')
, (24, 'Malefica', CAST('2010-10-01' AS Date), 'H')
INSERT LTCaballos (ID, Nombre, FechaNacimiento, Sexo) VALUES (25, 'Recaredo', CAST('2010-04-14' AS Date), 'M')
, (26, 'Circe', CAST('2011-12-14' AS Date), 'H')
, (27, 'Ariel', CAST('2010-09-15' AS Date), 'H')
, (28, 'Celeste', CAST('2010-11-06' AS Date), 'H')
, (29, 'Wamba', CAST('2009-02-15' AS Date), 'M')
, (30, 'Sisebuto', CAST('2009-01-20' AS Date), 'M'), (31, 'Blue Arrow', CAST('2012-04-20' AS Date), 'M')
-- Carreras
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (1, 'Gran Hipodromo de Andalucia', CAST(N'2018-01-20' AS Date), 1)
, (2, 'Gran Hipodromo de Andalucia', CAST(N'2018-01-20' AS Date), 2), (3, 'Las Mestas', CAST(N'2018-01-20' AS Date), 1)
, (13, 'Gran Hipodromo de Andalucia', CAST(N'2018-03-02' AS Date), 1), (14, 'Gran Hipodromo de Andalucia', CAST(N'2018-03-04' AS Date), 2)
, (15, 'Gran Hipodromo de Andalucia', CAST(N'2018-03-02' AS Date), 3), (16, 'Gran Hipodromo de Andalucia', CAST(N'2018-03-03' AS Date), 4)
, (21, 'Gran Hipodromo de Andalucia', CAST(N'2018-03-03' AS Date), 1), (17, 'La Zarzuela', CAST(N'2018-03-02' AS Date), 1)
INSERT [dbo].[LTCarreras] ([ID], [Hipodromo], [Fecha], [NumOrden]) VALUES (18, N'La Zarzuela', CAST(N'2018-03-02' AS Date), 2)
, (19, 'La Zarzuela', CAST(N'2018-03-04' AS Date), 3), (20, 'La Zarzuela', CAST(N'2018-03-04' AS Date), 4)
, (4, 'Pineda', CAST(N'2018-02-14' AS Date), 1), (5, 'Pineda', CAST(N'2018-02-14' AS Date), 2)
, (6, 'Pineda', CAST(N'2018-02-14' AS Date), 3), (10, 'Pineda', CAST(N'2018-02-28' AS Date), 1)
, (11, 'Pineda', CAST(N'2018-02-28' AS Date), 2), (12, 'Pineda', CAST(N'2018-02-28' AS Date), 3)
,(25, 'Costa del Sol', CAST(N'2018-03-10' AS Date), 1) ,(22, 'Costa del Sol', CAST(N'2018-03-10' AS Date), 2)
,(23, 'Costa del Sol', CAST(N'2018-03-10' AS Date), 3),(24, 'Lasarte', CAST(N'2018-03-24' AS Date), 1)
GO
SET IDENTITY_INSERT [dbo].[LTApuestas] ON 

INSERT [LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (1, N'jkdfjkasnfjk', 1, 1, 20.0000, 1)
,(2, N'jkdfjkasnfjk', 3, 1, 10.0000, 2), (3, N'jkdfjkasofjk', 10, 1, 20.0000, 3), (4, N'jkrfjkasnfjk', 21, 1, 20.0000, 4)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (5, N'jkdfjkhsnfjk', 11, 1, 20.0000, 5)
, (6, N'jkdfjkasnfjk', 6, 1, 20.0000, 6)
, (7, N'jkdfjkasnfjk', 2, 2, 20.0000, 7)
, (8, N'jkdfjkasnfjk', 4, 2, 80.0000, 8)
, (9, N'jkdfjkasnfjk', 5, 2, 20.0000, 9)
, (10, N'jkdfjkasnfjk', 7, 2, 10.0000, 10)
, (11, N'jkdfjkasnfjk', 8, 2, 60.0000, 11)
, (12, N'jkdfjkasnfjk', 9, 3, 20.0000, 12)
, (13, N'jkdfjkasnfjk', 12, 3, 20.0000, 13)
, (14, N'jkdfjkasnfjk', 13, 3, 20.0000, 14)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (15, N'jkdfjkas6fjk', 14, 3, 100.0000, 15)
, (16, N'jkdfju8snfjk', 15, 3, 20.0000, 16)
, (17, N'jkdi04asnfjk', 16, 3, 50.0000, 17)
, (18, N'61dfjkasnfjk', 17, 3, 20.0000, 18)
, (19, N'jkdi04asnfjk', 18, 4, 50.0000, 19)
, (20, N'jkdi04asnfjk', 19, 4, 50.0000, 20)
, (21, N'jkdi04asnfjk', 20, 4, 50.0000, 21)
, (22, N'jkdi04asnfjk', 22, 4, 50.0000, 22)
, (23, N'jkdi04asnfjk', 23, 4, 50.0000, 23)
, (24, N'jkdi04asnfjk', 24, 4, 20.0000, 24)
, (25, N'jkdi04aGH7jk', 20, 4, 50.0000, 25)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (26, N'jkdi04KL02jk', 22, 4, 30.0000, 26)
, (27, N'5W&i04asnfjk', 23, 4, 10.0000, 27)
, (28, N'jkdi04asnfjk', 25, 5, 50.0000, 28)
, (29, N'jkdi04asnfjk', 26, 5, 50.0000, 29)
, (30, N'jkdi04asnfjk', 27, 5, 50.0000, 100)
, (31, N'jkdi04asnfjk', 28, 5, 50.0000, 101)
, (32, N'jkdi04asnfjk', 29, 5, 50.0000, 200)
, (33, N'jkdi04asnfjk', 30, 6, 50.0000, 207)
, (34, N'0r7i04asnfjk', 2, 6, 30.0000, 214)
, (35, N'jkdi04asnfjk', 13, 6, 15.0000, 220)
, (36, N'jkdi04asnfjk', 10, 6, 50.0000, 234)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (37, N'jkdi04asnfjk', 5, 6, 25.0000, 245)
, (38, N'jkdi04asnfjk', 16, 6, 50.0000, 307)
, (39, N'jkdi04asnfjk', 17, 6, 50.0000, 407)
, (40, N'0r7i04asnfjk', 30, 10, 30.0000, 440)
, (41, N'0r7i04asnfjk', 2, 10, 30.0000, 507)
, (42, N'0r7i04asnfjk', 13, 10, 30.0000, 516)
, (43, N'0r7i04asnfjk', 10, 10, 30.0000, 607)
, (44, N'0r7i04asnfjk', 5, 10, 30.0000, 736)
, (45, N'0r7i04asnfjk', 16, 10, 30.0000, 1)
, (46, N'0r7i04asnfjk', 17, 10, 30.0000, 2)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (47, N'0r7i04K9Mfjk', 10, 10, 100.0000, 3)
, (48, N'r7i04asBX61k', 5, 10, 80.0000, 4)
, (49, N'0r7i04asnfjk', 1, 11, 30.0000, 5)
, (50, N'0r7i04asnfED', 3, 11, 30.0000, 6)
, (51, N'0r7i04asnfjk', 4, 11, 30.0000, 7)
, (52, N'M27i04as5h2Q', 21, 11, 10.0000, 8)
, (53, N'0r7i04PLDfjk', 11, 11, 100.0000, 9)
, (54, N'0r7i04asn6Mg', 6, 11, 30.0000, 10)
, (55, N'0r7i0444FfED', 3, 11, 120.0000, 11)
, (56, N'PQgi04asnfjk', 4, 11, 80.0000, 12)
, (57, N'0r7i04asnfjk', 20, 12, 70.0000, 13)
, (58, N'0r7i04aBYfjk', 14, 12, 50.0000, 14)
, (59, N'0r7i04asnfjk', 15, 12, 10.0000, 15)
, (60, N'0r7i04asnfjk', 7, 12, 130.0000, 16)
, (61, N'0r7i04asnfjk', 8, 12, 30.0000, 17)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (62, N'M27i04as5h2Q', 21, 13, 30.0000, 18)
, (63, N'M27i04as5h2Q', 22, 13, 10.0000, 19)
, (64, N'M27i04as5h2Q', 23, 13, 10.0000, 20)
, (65, N'M27i04as5h2Q', 24, 13, 10.0000, 21)
, (66, N'M27i04as5h2Q', 25, 13, 30.0000, 22)
, (67, N'M27i04as5h2Q', 26, 13, 10.0000, 23)
, (68, N'M27i04as5h2Q', 27, 13, 10.0000, 24)
, (69, N'M27i04as5h2Q', 24, 13, 40.0000, 25)
, (70, N'M27i04655h2Q', 25, 13, 120.0000, 26)
, (71, N'M27i04as5L$Q', 26, 13, 70.0000, 27)
, (72, N'M27i04as5h2Q', 28, 14, 40.0000, 28)
, (73, N'M27i04as5h2Q', 1, 14, 10.0000, 29)
, (74, N'M27i0H3u5h2Q', 4, 14, 15.0000, 100)
, (75, N'M27i04as5h2Q', 2, 14, 10.0000, 101)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (76, N'M27i04as5h2Q', 5, 14, 15.0000, 200)
, (77, N'M27i04as5h2Q', 3, 14, 10.0000, 207)
, (78, N'M27i0H3u5h2Q', 29, 15, 15.0000, 214)
, (79, N'M27i0H3u5h2Q', 6, 15, 15.0000, 220)
, (80, N'M27i0H3u5h2Q', 9, 15, 15.0000, 234)
, (81, N'M27i0H3u5h2Q', 7, 15, 15.0000, 245)
, (82, N'M27i0H3u5h2Q', 8, 15, 40.0000, 307)
, (83, N'M27i0H3u5h2Q', 9, 15, 105.0000, 407)
, (84, N'M27P=H3u5h2Q', 7, 15, 70.0000, 440)
, (85, N'M27i0H3u5K%Q', 8, 15, 20.0000, 507)
, (86, N'i0HH&g3u5h2Q', 30, 16, 85.0000, 516)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (87, N'M27i0H3u5h2Q', 20, 16, 15.0000, 607)
, (88, N'M27i0H3u5h2Q', 13, 16, 15.0000, 736)
, (89, N'M27i0H3u5h2Q', 11, 16, 15.0000, 1)
, (90, N'M27i0H3u5h2Q', 10, 16, 35.0000, 2)
, (91, N'M27i0H3u5h2Q', 16, 16, 50.0000, 3)
, (92, N'Pi7j4BB&s3kt', 17, 16, 45.0000, 4)
, (93, N'Pi5f4BB&s3O!', 30, 17, 105.0000, 5)
, (94, N'Pi7j4BB&s3kt', 20, 17, 30.0000, 6)
, (95, N'Pi7j4BB&s3Hk', 13, 17, 20.0000, 7)
, (96, N'Pi7j4BB&s3kt', 11, 17, 45.0000, 8)
, (97, N'Pi7j4BB&s3kt', 10, 17, 45.0000, 9)
, (98, N'Pi7j4BB&sT5n', 16, 17, 45.0000, 10)
, (99, N'Pi7j4BB&s3kt', 17, 17, 45.0000, 11)
GO
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (100, N'Pi7j4BB&s3kt', 29, 18, 10.0000, 12)
, (101, N'Pi7jF9u&s3kt', 6, 18, 25.0000, 13)
, (102, N'Pi7j4BB&supt', 19, 18, 20.0000, 14)
, (103, N'Pi7j4BB&s3kt', 7, 18, 45.0000, 15)
, (104, N'6l7j4BB&s3kt', 8, 18, 45.0000, 16)
, (105, N'Pi7j4BB&s3kt', 18, 19, 45.0000, 17)
, (106, N'Pi7j4BB&s3kt', 1, 19, 35.0000, 18)
, (107, N'Pi7j4d/&s3kt', 4, 19, 10.0000, 19)
, (108, N'Pi7j4BB&s3kt', 2, 19, 120.0000, 20)
, (109, N'Pi7j4BB&s3kt', 5, 19, 45.0000, 21)
, (110, N'Pi7jP3O&s3kt', 3, 19, 75.0000, 22)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (111, N'Pi7j4BB&s3kt', 21, 20, 45.0000, 23)
, (112, N'Pi7j4BB&s3kt', 22, 20, 45.0000, 24)
, (113, N'Pi%D4BB&s3kt', 23, 20, 40.0000, 25)
, (114, N'0K7j4BB&s3kt', 24, 20, 90.0000, 26)
, (115, N'Pi7j4BB&s3kt', 25, 20, 10.0000, 27)
, (116, N'Pi7j4Blll3kt', 26, 20, 75.0000, 28)
, (117, N'yi7j4BB&s3kt', 27, 20, 15.0000, 29)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (120, N'Pi7j4YB&s3kt', 1, 21, 10.0000, 12)
, (121, N'Pi7jF9u&s3kt', 5, 21, 25.0000, 13)
, (122, N'Pi7j4BB&supt', 7, 21, 20.0000, 14)
, (123, N'Pi7j4BB&s3kt', 7, 21, 45.0000, 15)
, (124, N'6l7j4BB&s3kt', 11, 21, 45.0000, 16)
, (125, N'Pi7j4BB&s3kt', 12, 21, 45.0000, 17)
, (126, N'Pi7j4BB&s3kt', 16, 21, 35.0000, 18)
, (127, N'Pi7j4d/&s3kt', 19, 21, 10.0000, 19)
, (128, N'Pi7j4BB&s3kt', 19, 21, 120.0000, 20)
, (129, N'Pi7j4BB&s3kt', 7, 21, 45.0000, 21)
, (130, N'Pi7jP3O&s3kt', 1, 21, 75.0000, 22)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (131, N'Pi7j4BB&s3kt', 21, 21, 45.0000, 23)
, (132, N'Pi7j4BB&s3kt', 5, 21, 45.0000, 24)
, (133, N'Pi%D4BB&s3kt', 11, 21, 40.0000, 25)
, (134, N'0K7j4BB&s3kt', 16, 21, 90.0000, 26)
, (135, N'Pi7j4BB&s3kt', 12, 21, 10.0000, 27)
, (136, N'Pi7j4Blll3kt', 11, 21, 75.0000, 28)
, (137, N'yi7j4BB&s3kt', 1, 21, 15.0000, 29)
, (138, N'Pi7j4BB&s3kt', 16, 21, 120.0000, 20)
, (139, N'Pi7j4BB&s3kt', 5, 21, 45.0000, 21)
, (140, N'Pi7jP3O&s3kt', 11, 21, 75.0000, 22)

INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (118, N'Pi7j4YB&s3kt', 2, 22, 10.0000, 12)
, (141, N'Pi7jF9u&s3kt', 3, 22, 35.0000, 13)
, (142, N'Pi7j4BB&supt', 6, 22, 20.0000, 14)
, (143, N'Pi7j4BB&s3kt', 10, 22, 45.0000, 15)
, (144, N'6l7j4BB&s3kt', 17, 22, 45.0000, 16)
, (145, N'Pi7j4BB&s3kt', 12, 21, 45.0000, 407)
, (146, N'Pi7j4BB&s3kt', 16, 21, 35.0000, 307)
, (147, N'Pi7j4d/&s3kt', 19, 21, 10.0000, 234)
, (150, N'Pi7jP3O&s3kt', 1, 21, 75.0000, 220)
INSERT [dbo].[LTApuestas] ([ID], [Clave], [IDCaballo], [IDCarrera], [Importe], [IDJugador]) VALUES (151, N'Pi7j4BB&s3kt', 21, 21, 45.0000, 23)
, (152, N'Pi7j4BB&s3kt', 5, 21, 45.0000, 234)
, (153, N'Pi%D4BB&s3kt', 11, 21, 40.0000, 407)
, (154, N'0K7j4BB&s3kt', 16, 21, 90.0000, 307)
, (155, N'Pi7j4BB&s3kt', 12, 21, 10.0000, 507)
, (156, N'Pi7j4Blll3kt', 11, 21, 75.0000, 28)
, (157, N'yi7j4BB&s3kt', 4, 23, 15.0000, 29)
, (158, N'Pi7j4BB&s3kt', 15, 23, 120.0000, 20)
, (159, N'Pi7j4BB&s3kt', 9, 23, 45.0000, 440)
, (160, N'Pi7jP3O&s3kt', 9, 23, 75.0000, 22)
SET IDENTITY_INSERT [dbo].[LTApuestas] OFF
GO

GO
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (1, 1, 1, 2, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
, (1, 11, 1, 1, NULL, NULL), (1, 14, 11, NULL, NULL, NULL), (1, 19, 11, NULL, NULL, NULL), (1, 21, 11, NULL, NULL, NULL)
, (2, 2, 10, 2, CAST(5.7 AS Decimal(4, 1)), CAST(1.9 AS Decimal(4, 1)))
, (2, 6, 12, 4, CAST(5.4 AS Decimal(4, 1)), CAST(1.8 AS Decimal(4, 1)))
, (2, 10, 12, 3, NULL, NULL), (2, 14, 6, 2, NULL, NULL), (2, 19, 6, 5, NULL, NULL), (2, 22, 7, NULL, NULL, NULL)
, (3, 1, 11, 4, CAST(6.6 AS Decimal(4, 1)), CAST(2.2 AS Decimal(4, 1)))
, (3, 11, 11, 2, NULL, NULL), (3, 22, 6, NULL, NULL, NULL)
, (3, 14, 2, 3, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (3, 19, 2, 4, NULL, NULL)
, (4, 2, 12, 4, CAST(1.4 AS Decimal(4, 1)), CAST(0.5 AS Decimal(4, 1))),(31, 19, 27, NULL, NULL, NULL)
, (4, 11, 7, 3, NULL, NULL), (4, 14, 7, 4, NULL, NULL), (4, 19, 47, 3, NULL, NULL), (4, 23, 3, NULL, NULL, NULL)
, (5, 2, 27, 1, CAST(5.7 AS Decimal(4, 1)), CAST(1.9 AS Decimal(4, 1)))
, (5, 6, 4, NULL, CAST(6.5 AS Decimal(4, 1)), CAST(2.2 AS Decimal(4, 1)))
, (5, 10, 4, 5, NULL, NULL), (5, 14, 12, 5, NULL, NULL), (5, 19, 12, 2, NULL, NULL), (5, 21, 44, NULL, NULL, NULL)
, (6, 1, 2, 6, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
, (6, 11, 2, 4, NULL, NULL), (6, 15, 12, 2, NULL, NULL), (6, 22, 10, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (6, 18, 12, 1, NULL, NULL)
, (7, 2, 16, 5, CAST(11.4 AS Decimal(4, 1)), CAST(3.8 AS Decimal(4, 1)))
, (7, 12, 16, 4, NULL, NULL), (7, 15, 16, 3, NULL, NULL), (7, 18, 16, 2, NULL, NULL), (7, 21, 16, NULL, NULL, NULL)
, (8, 2, 2, 3, CAST(1.9 AS Decimal(4, 1)), CAST(0.6 AS Decimal(4, 1)))
, (8, 12, 2, 1, NULL, NULL), (8, 15, 2, NULL, NULL, NULL), (8, 18, 2, 3, NULL, NULL)
, (9, 3, 3, 2, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
, (9, 15, 27, 4, NULL, NULL), (9, 23, 27, NULL, NULL, NULL),(31, 6, 27, NULL, NULL, NULL)
, (10, 1, 7, 1, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
, (10, 6, 16, 5, CAST(3.2 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
, (10, 10, 16, 1, NULL, NULL), (10, 22, 2, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (10, 16, 4, 4, NULL, NULL)
, (10, 17, 54, NULL, NULL, NULL)
, (11, 1, 12, 3, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
, (11, 11, 12, 5, NULL, NULL), (11, 16, 16, 5, NULL, NULL), (11, 17, 16, NULL, NULL, NULL)
, (12, 3, 12, 4, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
, (13, 3, 17, 1, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
, (13, 6, 8, 1, CAST(10.8 AS Decimal(4, 1)), CAST(3.6 AS Decimal(4, 1)))
, (13, 10, 8, 4, NULL, NULL), (11, 21, 12, NULL, NULL, NULL)
, (13, 16, 8, 6, NULL, NULL), (12, 21, 8, NULL, NULL, NULL), (13, 23, 8, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (13, 17, 8, 1, NULL, NULL)
, (14, 3, 16, 5, CAST(1.5 AS Decimal(4, 1)), CAST(0.5 AS Decimal(4, 1)))
, (14, 12, 12, 2, NULL, NULL)
, (15, 3, 4, NULL, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
, (15, 12, 27, NULL, NULL, NULL), (15, 23, 14, NULL, NULL, NULL), (16, 21, 3, NULL, NULL, NULL)
, (16, 3, 33, 3, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
, (16, 6, 33, 3, CAST(3.2 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
, (16, 10, 33, 2, NULL, NULL), (16, 16, 33, NULL, NULL, NULL), (16, 17, 33, 2, NULL, NULL)
, (17, 3, 50, 6, CAST(7.5 AS Decimal(4, 1)), CAST(2.5 AS Decimal(4, 1)))
, (17, 6, 50, 6, CAST(3.2 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
, (17, 10, 50, NULL, NULL, NULL), (17, 16, 50, 1, NULL, NULL), (17, 22, 20, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (17, 17, 50, 3, NULL, NULL)
, (18, 4, 1, 2, CAST(4.3 AS Decimal(4, 1)), CAST(1.4 AS Decimal(4, 1)))
, (18, 19, 51, 1, NULL, NULL), (18, 23, 15, NULL, NULL, NULL)
, (19, 4, 11, 4, CAST(4.3 AS Decimal(4, 1)), CAST(1.4 AS Decimal(4, 1)))
, (19, 18, 27, 4, NULL, NULL), (19, 21, 20, NULL, NULL, NULL)
, (20, 4, 7, 1, CAST(2.2 AS Decimal(4, 1)), CAST(0.7 AS Decimal(4, 1)))
, (20, 12, 10, 3, NULL, NULL), (20, 16, 12, 2, NULL, NULL), (20, 17, 12, 4, NULL, NULL)
, (21, 1, 6, 5, CAST(3.3 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
, (21, 11, 6, 6, NULL, NULL), (21, 13, 23, 1, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (21, 20, 23, 1, NULL, NULL)
, (22, 4, 6, 5, CAST(2.7 AS Decimal(4, 1)), CAST(0.9 AS Decimal(4, 1)))
, (22, 13, 12, 2, NULL, NULL), (22, 20, 12, 6, NULL, NULL)
, (23, 4, 12, 3, CAST(3.6 AS Decimal(4, 1)), CAST(1.2 AS Decimal(4, 1)))
, (23, 13, 8, 3, NULL, NULL), (23, 20, 8, 5, NULL, NULL), (22, 22, 14, NULL, NULL, NULL)
, (24, 4, 2, 6, CAST(10.8 AS Decimal(4, 1)), CAST(3.6 AS Decimal(4, 1)))
, (24, 13, 2, 4, NULL, NULL), (24, 20, 2, 4, NULL, NULL), (24, 23, 20, NULL, NULL, NULL)
, (25, 5, 10, 2, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
, (25, 13, 4, NULL, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (25, 20, 44, NULL, NULL, NULL)
, (26, 5, 12, 4, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
, (26, 13, 3, 5, NULL, NULL), (26, 20, 3, 3, NULL, NULL)
, (27, 5, 27, 1, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
, (27, 13, 5, 6, NULL, NULL), (27, 20, 5, 2, NULL, NULL), (22, 25, 4, NULL, NULL, NULL)
, (28, 5, 90, 5, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
, (28, 14, 1, 1, NULL, NULL)
, (29, 5, 42, 3, CAST(3.0 AS Decimal(4, 1)), CAST(1.0 AS Decimal(4, 1)))
, (29, 15, 10, 1, NULL, NULL), (29, 18, 10, 5, NULL, NULL)
INSERT [dbo].[LTCaballosCarreras] ([IDCaballo], [IDCarrera], [Numero], [Posicion], [Premio1], [Premio2]) VALUES (30, 6, 3, 2, CAST(3.2 AS Decimal(4, 1)), CAST(1.1 AS Decimal(4, 1)))
, (30, 10, 3, NULL, NULL, NULL), (30, 16, 3, 3, NULL, NULL), (30, 17, 3, 5, NULL, NULL)


GO

--Calculamos los premios
Execute AsignaPremios 1
Execute AsignaPremios 2
Execute AsignaPremios 3
Execute AsignaPremios 4
Execute AsignaPremios 5
Execute AsignaPremios 6
Execute AsignaPremios 10
Execute AsignaPremios 11
Execute AsignaPremios 12
Execute AsignaPremios 13
Execute AsignaPremios 14
Execute AsignaPremios 15
Execute AsignaPremios 16
Execute AsignaPremios 17
Execute AsignaPremios 18
Execute AsignaPremios 19
Execute AsignaPremios 20
Execute AsignaPremios 21
Execute AsignaPremios 22
Execute AsignaPremios 23
-- Apuntes iniciales
Insert Into LTApuntes (IDJugador,Orden,Fecha,Importe,Saldo, Concepto)
	Select ID,1,DateFromParts(2015,01,1),100,100, 'Ingreso inicial' FROM LTJugadores
GO
Declare @Hoy Date
Set @Hoy = GetDate()
Execute GeneraApuntes '20140101', @Hoy
GO
INSERT INTO LTApuntes (IDJugador,Orden,Fecha,Importe,Saldo,Concepto)
     VALUES (3,7,'20180304',-80,96,'Retirada fondos'),
	 (7,7,'20180304',-150,120,'Retirada fondos'),
	 (11,6,'20180303',110,57,'Ingreso'),
	 (16,7,'20180303',200,60,'Ingreso'),
	 (20,9,'20180303',500,60,'Ingreso'),
	 (22,8,'20180303',300,95,'Ingreso'),
	 (100,5,'20180304',-70,115,'Retirada fondos'),
	 (214,5,'20180305',-140,92,'Retirada fondos'),
	 (440,5,'20180305',110,110,'Ingreso')
Use Ejemplos