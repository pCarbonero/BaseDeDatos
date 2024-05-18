USE [master]
GO
/****** Object:  Database [CasinOnLine]    Script Date: 25/01/2022 9:41:29 ******/
CREATE DATABASE [CasinOnLine]
/* CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CasinOnLine', FILENAME = N'D:\Databases\CasinOnLine.mdf' , SIZE = 8384KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CasinOnLine_log', FILENAME = N'D:\Databases\CasinOnLine_log.ldf' , SIZE = 48384KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
*/
GO
ALTER DATABASE [CasinOnLine] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CasinOnLine].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CasinOnLine] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CasinOnLine] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CasinOnLine] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CasinOnLine] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CasinOnLine] SET ARITHABORT OFF 
GO
ALTER DATABASE [CasinOnLine] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CasinOnLine] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CasinOnLine] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CasinOnLine] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CasinOnLine] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CasinOnLine] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CasinOnLine] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CasinOnLine] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CasinOnLine] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CasinOnLine] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CasinOnLine] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CasinOnLine] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CasinOnLine] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CasinOnLine] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CasinOnLine] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CasinOnLine] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CasinOnLine] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CasinOnLine] SET RECOVERY FULL 
GO
ALTER DATABASE [CasinOnLine] SET  MULTI_USER 
GO
ALTER DATABASE [CasinOnLine] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CasinOnLine] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CasinOnLine] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CasinOnLine] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [CasinOnLine] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'CasinOnLine', N'ON'
GO
ALTER DATABASE [CasinOnLine] SET QUERY_STORE = OFF
GO
USE [CasinOnLine]
GO
/****** Object:  UserDefinedFunction [dbo].[ApuestaFavorita]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Nos devuelve la apuesta favorita de un jugador en un intervalo de tiempo
CREATE FUNCTION [dbo].[ApuestaFavorita] (@Jugador Int, @Inicio Date, @Fin DATE) RETURNS TinyInt AS
BEGIN
	DECLARE @Tipo TinyInt
	SELECT @Tipo=Tipo FROM FrecuenciaTipo (@Jugador, @Inicio, @Fin) WHERE Numero = (SELECT MAX(Numero) FROM FrecuenciaTipo (@Jugador, @Inicio, @Fin))
	RETURN @Tipo
END --FUNCTION ApuestaFavorita
GO
/****** Object:  UserDefinedFunction [dbo].[ApuestaGanadora]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Esta función nos dice si una apuesta es ganadora (1) o no (0)
--CREATE
CREATE FUNCTION [dbo].[ApuestaGanadora] (@Mesa SmallInt, @Jugada Int, @Jugador Int) RETURNS Bit AS
BEGIN
	DECLARE @Gana Bit = 0
	IF EXISTS(SELECT * FROM COL_APuestas AS A
				JOIN COL_NumerosApuesta AS N ON A.IDMesa=N.IDMesa AND A.IDJugada=N.IDJugada AND A.IDJugador=N.IDJugador
				JOIN COL_Jugadas As J ON A.IDMesa=J.IDMesa AND A.IDJugada=J.IDJugada
				WHere A.IDMesa=@Mesa AND A.IDJugada=@Jugada AND A.IDJugador=@Jugador AND N.Numero=J.Numero)
		SET @Gana = 1
	RETURN @Gana
END --FUNCTION ApuestaGanadora
GO
/****** Object:  UserDefinedFunction [dbo].[datosJugada]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[datosJugada]
(
	@IDJugada Int, 
	@IDMesa Int
)
RETURNS @tabla TABLE 
(
	ID Int,
	Nombre VarChar (15),
	Apellidos VarChar (25),
	Apuesta Money,
	Ganancia Money
)
as
BEGIN

	DECLARE @IDJugador Int,
			@ganancia Money
			
	DECLARE cGanancia CURSOR FOR
		SELECT ID
		FROM COL_Jugadores
		
	OPEN cGanancia
	
	FETCH NEXT FROM cGanancia INTO @IDJugador
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	
		SELECT @ganancia = (SELECT Pelotazo 
		FROM dbo.Ganancias (@IDMesa, @IDJugada, (SELECT Numero FROM COL_Jugadas 
												 WHERE IDMesa = @IDMesa and IDJugada = @IDJugada))
		WHERE Jugador = @IDJugador)
		
		INSERT INTO @tabla (ID, Nombre, Apellidos)
		(SELECT ID, Nombre, Apellidos FROM COL_Jugadores WHERE ID = @IDJugador)
		
		UPDATE @tabla 
		SET Apuesta = 
		(SELECT Importe FROM COL_Apuestas WHERE IDJugador = @IDJugador and IDMesa = @IDMesa and IDJugada = @IDJugada)
		WHERE ID = @IDJugador
		
		UPDATE @tabla 
		SET Ganancia = @ganancia
		WHERE ID = @IDJugador
		
		FETCH NEXT FROM cGanancia INTO @IDJugador
	
	END
	
	CLOSE cGanancia
	DEALLOCATE cGanancia
	
	RETURN 
	
END

GO
/****** Object:  UserDefinedFunction [dbo].[EstadisticasJugadores]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Funcion del Problema
--CREATE 
CREATE FUNCTION [dbo].[EstadisticasJugadores] (@Inicio DATE, @Fin DATE) 
	RETURNS @Stats TABLE (
		ID Int
		,Nombre NVarChar(15)
		,Apellidos NVarChar(25)
		,Ganancias Money DEFAULT 0
		,ApuestaFavorita TinyInt
		,ApuestaMedia Money
	) AS
	BEGIN
	DECLARE @Jugador Int, @Mesa SmallInt, @Jugada Int, @Tipo TinyInt, @importe Money, @Numero TinyInt
	DECLARE @Premio Money, @ApMedia Money
	DECLARE CurJugadores CURSOR FORWARD_ONLY FOR SELECT ID FROM @Stats
	
	-- En primer lugar, introducimos los datos de los jugadores
	INSERT @Stats (ID,Nombre,Apellidos) SELECT ID,Nombre,Apellidos FROM COL_Jugadores
	OPEN CurJugadores
	FETCH NEXT FROM CurJugadores INTO @Jugador
	-- Recoremos los jugadores
	WHILE @@FETCH_STATUS = 0
	BEGIN
DECLARE CurAPuestas CURSOR FORWARD_ONLY FOR 
		SELECT A.IDMesa, A.IDJugada, A.Tipo, A.Importe FROM COL_Apuestas AS A 
			JOIN COL_Jugadas AS J ON A.IDMesa = J.IDMesa AND A.IDJugada = J.IDJugada
			WHERE A.IDJugador = @Jugador AND J.MomentoJuega BETWEEN @Inicio AND @Fin AND J.Numero IS NOT NULL
		OPEN CurApuestas
		FETCH NEXT FROM CurApuestas INTO @Mesa, @Jugada, @Tipo, @Importe
		-- Recorremos las apuestas de ese jugador
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--Obtenemos el número ganador
			SELECT @Numero = Numero FROM COL_Jugadas WHERE IDMesa = @Mesa AND IDJugada=@Jugada
			IF dbo.ApuestaGanadora (@Mesa, @Jugada, @Jugador) = 1
			BEGIN
				SELECT @Premio=Pelotazo FROM dbo.Ganancias(@Mesa,@Jugada,@Numero) WHERE Jugador = @Jugador
				UPDATE @Stats SET Ganancias = Ganancias + @Premio WHERE CURRENT OF CurJugadores
			END
			ELSE
				UPDATE @Stats SET Ganancias = Ganancias - @Importe WHERE CURRENT OF CurJugadores
			FETCH NEXT FROM CurApuestas INTO @Mesa, @Jugada, @Tipo, @Importe
		END -- WHILE
		CLOSE CurApuestas
DEALLOCATE CurApuestas
		SET @ApMedia = (SELECT AVG(Importe) FROM COL_APuestas AS A 
							JOIN COL_Jugadas AS J ON A.IDMesa=J.IDMesa AND A.IDJugada=J.IDJugada
							WHERE A.IDJugador=@Jugador AND J.MomentoJuega BETWEEN @Inicio AND @Fin)
		UPDATE @Stats SET ApuestaMedia = @ApMedia
					,ApuestaFavorita = dbo.ApuestaFavorita (@Jugador, @Inicio, @Fin)
			WHERE CURRENT OF CurJugadores
		FETCH NEXT FROM CurJugadores INTO @Jugador
	END -- WHILE
	CLOSE CurJugadores
	
	DEALLOCATE CurJugadores
	RETURN
	END --FUNCTION EstadisticasJugadores
GO
/****** Object:  UserDefinedFunction [dbo].[totalGanado]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[totalGanado] (@ID INT) RETURNS MONEY
AS
BEGIN
	DECLARE @TOTAL MONEY
	DECLARE @PERDIDO MONEY
	DECLARE @GANADO MONEY
	
	SELECT @GANADO = SUM(Importe*T.Premio) FROM COL_Apuestas AS A JOIN COL_NumerosApuesta AS NA 
								 ON A.IDJugador = NA.IDJugador AND A.IDMesa = NA.IDMesa AND A.IDJugada = NA.IDJugada 
								 JOIN COL_TiposApuesta AS T ON A.Tipo = T.ID
								 JOIN COL_Jugadas AS JU ON NA.IDJugada = JU.IDJugada
								 WHERE A.IDJugador = @ID AND JU.Numero = NA.Numero
								 
	SELECT @PERDIDO =  SUM(Importe) FROM COL_Apuestas AS A 
										JOIN COL_Jugadas AS JU
										ON A.IDJugada = JU.IDJugada
										WHERE A.IDMesa = JU.IDMesa AND A.IDJugador NOT IN( SELECT A.IDJugador 
																						   FROM COL_Apuestas AS A 
																						   JOIN COL_NumerosApuesta AS N
																						   ON A.IDJugador = N.IDJugador AND A.IDMesa = N.IDMesa AND A.IDJugada = N.IDJugada
																						   WHERE N.Numero = JU.Numero AND A.IDMesa = JU.IDMesa AND A.IDJugada = JU.IDJugada)
										 
	SET @TOTAL = @GANADO - @PERDIDO
	
	RETURN @TOTAL
END
GO
/****** Object:  Table [dbo].[COL_Apuestas]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_Apuestas](
	[IDJugador] [int] NOT NULL,
	[IDMesa] [smallint] NOT NULL,
	[IDJugada] [int] NOT NULL,
	[Tipo] [tinyint] NOT NULL,
	[Importe] [money] NOT NULL,
 CONSTRAINT [PK_Apuestas] PRIMARY KEY CLUSTERED 
(
	[IDJugador] ASC,
	[IDMesa] ASC,
	[IDJugada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COL_Jugadas]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_Jugadas](
	[IDMesa] [smallint] NOT NULL,
	[IDJugada] [int] NOT NULL,
	[MomentoJuega] [datetime] NULL,
	[NoVaMas] [bit] NOT NULL,
	[Numero] [tinyint] NULL,
 CONSTRAINT [PK_Jugadas] PRIMARY KEY CLUSTERED 
(
	[IDMesa] ASC,
	[IDJugada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FrecuenciaTipo]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Nos devuelve la frecuencia de cada tipo de apuesta de un jugador en un intervalo de tiempo
CREATE FUNCTION [dbo].[FrecuenciaTipo] (@Jugador Int, @Inicio Date, @Fin DATE) RETURNS TABLE AS
RETURN SELECT A.Tipo, Count(*) AS Numero FROM COL_Apuestas AS A JOIN COL_Jugadas AS J ON A.IDMesa=J.IDMesa AND A.IDJugada=J.IDJugada
		WHERE A.IDJugador = @Jugador AND J.MomentoJuega BETWEEN @Inicio AND @Fin
		GROUP BY Tipo

GO
/****** Object:  Table [dbo].[COL_NumerosApuesta]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_NumerosApuesta](
	[IDJugador] [int] NOT NULL,
	[IDMesa] [smallint] NOT NULL,
	[IDJugada] [int] NOT NULL,
	[Numero] [tinyint] NOT NULL,
 CONSTRAINT [PK_NumerosJugada] PRIMARY KEY CLUSTERED 
(
	[IDJugador] ASC,
	[IDMesa] ASC,
	[IDJugada] ASC,
	[Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COL_TiposApuesta]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_TiposApuesta](
	[ID] [tinyint] NOT NULL,
	[Nombre] [varchar](15) NOT NULL,
	[Numeros] [tinyint] NOT NULL,
	[Premio] [decimal](3, 1) NOT NULL,
 CONSTRAINT [PK_TiposApuesta] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Ganancias]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Nos devuelve las ganacias de los ganadores
*/
CREATE FUNCTION [dbo].[Ganancias] (@Mesa SmallInt,@Jugada Int,@Numero TinyInt) RETURNS TABLE AS
RETURN SELECT A.Importe*T.Premio AS Pelotazo, A.IDJugador AS Jugador FROM COL_Apuestas AS A JOIN COL_NumerosApuesta AS N
	ON A.IDJugador = N.IDJugador AND A.IDMesa = N.IDMesa AND A.IDJugada = N.IDJugada
	JOIN COL_TiposApuesta AS T ON A.Tipo = T.ID
	WHERE N.Numero = @Numero AND A.IDMesa = @Mesa AND A.IDJugada = @Jugada

GO
/****** Object:  View [dbo].[EJERCICIO4]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EJERCICIO4] AS
SELECT     dbo.COL_Jugadas.IDMesa, dbo.COL_Jugadas.MomentoJuega, dbo.COL_Jugadas.IDJugada, dbo.COL_Apuestas.Tipo, 
                      dbo.COL_NumerosApuesta.Numero
FROM         dbo.COL_Apuestas INNER JOIN
                      dbo.COL_Jugadas ON dbo.COL_Apuestas.IDMesa = dbo.COL_Jugadas.IDMesa AND 
                      dbo.COL_Apuestas.IDJugada = dbo.COL_Jugadas.IDJugada INNER JOIN
                      dbo.COL_NumerosApuesta ON dbo.COL_Apuestas.IDJugador = dbo.COL_NumerosApuesta.IDJugador AND 
                      dbo.COL_Apuestas.IDMesa = dbo.COL_NumerosApuesta.IDMesa AND dbo.COL_Apuestas.IDJugada = dbo.COL_NumerosApuesta.IDJugada
                      

GO
/****** Object:  Table [dbo].[COL_Jugadores]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_Jugadores](
	[ID] [int] NOT NULL,
	[Nombre] [nvarchar](15) NOT NULL,
	[Apellidos] [nvarchar](25) NOT NULL,
	[Nick] [nchar](12) NOT NULL,
	[PassWord] [nchar](12) NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[Saldo] [money] NOT NULL,
	[Credito] [money] NULL,
 CONSTRAINT [PK_Jugadores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Nick] UNIQUE NONCLUSTERED 
(
	[Nick] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Ganacias]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--VISTA PARA SACAR GANANCIAS
CREATE VIEW [dbo].[Ganacias] AS
SELECT ID AS IDJugador, SUM(Acierto.Importe*Acierto.Premio) AS Ganado  FROM COL_Jugadores AS J1
	JOIN COL_Apuestas AS A
	ON J1.ID=A.IDJugador
	JOIN (SELECT NA.IDMesa, NA.IDJugada, A.Importe ,TA.Premio FROM COL_NumerosApuesta AS NA --aciertosTipo
			JOIN COL_Apuestas AS A
			ON NA.IDJugada=A.IDJugada
			JOIN COL_TiposApuesta AS TA
			ON A.Tipo=TA.ID
			JOIN COL_Jugadas AS J2
			ON A.IDJugada=J2.IDJugada
				WHERE NA.Numero=J2.Numero
				GROUP BY NA.IDMesa, NA.IDJugada, A.Importe, TA.Premio
			) AS Acierto
	ON A.IDJugada=Acierto.IDJugada
	GROUP BY J1.ID
GO
/****** Object:  View [dbo].[Perdidas]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--VISTA DE PERDIDAS
CREATE VIEW [dbo].[Perdidas] AS
SELECT ID AS IDJugador, SUM(Error.Importe) AS Perdido FROM COL_Jugadores AS J1
	JOIN COL_Apuestas AS A
	ON J1.ID=A.IDJugador
	JOIN (SELECT NA.IDMesa, NA.IDJugada, A.Importe ,TA.Premio FROM COL_NumerosApuesta AS NA --aciertosTipo
			JOIN COL_Apuestas AS A
			ON NA.IDJugada=A.IDJugada
			JOIN COL_TiposApuesta AS TA
			ON A.Tipo=TA.ID
			JOIN COL_Jugadas AS J2
			ON A.IDJugada=J2.IDJugada
				WHERE NA.Numero!=J2.Numero
				GROUP BY NA.IDMesa, NA.IDJugada, A.Importe, TA.Premio
			) AS Error
	ON A.IDJugada=Error.IDJugada
	GROUP BY J1.ID

GO
/****** Object:  View [dbo].[DatosJugadores]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--VISTA QUE SE PIDE
CREATE VIEW [dbo].[DatosJugadores] AS
SELECT J.Nombre, J.Apellidos, J.Nick, COUNT(A.IDJugada) AS NumeroJugadas, SUM(A.Importe) AS TotalApostado, (G.Ganado-P.Perdido) AS GANANCIAS FROM COL_Jugadores AS J
	JOIN COL_Apuestas AS A
	ON J.ID=A.IDJugador
	JOIN Ganacias AS G
	ON G.IDJugador=J.ID
	JOIN Perdidas AS P
	ON P.IDJugador=J.ID
GROUP BY J.Nombre, J.Apellidos, J.Nick, (G.Ganado-P.Perdido)
GO
/****** Object:  Table [dbo].[COL_Mesas]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_Mesas](
	[ID] [smallint] NOT NULL,
	[LimiteJugada] [money] NULL,
	[Saldo] [money] NULL,
 CONSTRAINT [PK_Mesas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[COL_Jugadas] ADD  DEFAULT ((0)) FOR [NoVaMas]
GO
ALTER TABLE [dbo].[COL_Jugadores] ADD  DEFAULT ((0)) FOR [Saldo]
GO
ALTER TABLE [dbo].[COL_Jugadores] ADD  DEFAULT ((0)) FOR [Credito]
GO
ALTER TABLE [dbo].[COL_Mesas] ADD  DEFAULT ((0)) FOR [Saldo]
GO
ALTER TABLE [dbo].[COL_Apuestas]  WITH CHECK ADD  CONSTRAINT [FK_Apuesta_Jugada] FOREIGN KEY([IDMesa], [IDJugada])
REFERENCES [dbo].[COL_Jugadas] ([IDMesa], [IDJugada])
GO
ALTER TABLE [dbo].[COL_Apuestas] CHECK CONSTRAINT [FK_Apuesta_Jugada]
GO
ALTER TABLE [dbo].[COL_Apuestas]  WITH CHECK ADD  CONSTRAINT [FK_Apuesta_Jugador] FOREIGN KEY([IDJugador])
REFERENCES [dbo].[COL_Jugadores] ([ID])
GO
ALTER TABLE [dbo].[COL_Apuestas] CHECK CONSTRAINT [FK_Apuesta_Jugador]
GO
ALTER TABLE [dbo].[COL_Apuestas]  WITH CHECK ADD  CONSTRAINT [FK_Apuesta_Tipo] FOREIGN KEY([Tipo])
REFERENCES [dbo].[COL_TiposApuesta] ([ID])
GO
ALTER TABLE [dbo].[COL_Apuestas] CHECK CONSTRAINT [FK_Apuesta_Tipo]
GO
ALTER TABLE [dbo].[COL_Jugadas]  WITH CHECK ADD  CONSTRAINT [FK_Jugada_Mesa] FOREIGN KEY([IDMesa])
REFERENCES [dbo].[COL_Mesas] ([ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COL_Jugadas] CHECK CONSTRAINT [FK_Jugada_Mesa]
GO
ALTER TABLE [dbo].[COL_NumerosApuesta]  WITH CHECK ADD  CONSTRAINT [FK_Numero_Apuesta] FOREIGN KEY([IDJugador], [IDMesa], [IDJugada])
REFERENCES [dbo].[COL_Apuestas] ([IDJugador], [IDMesa], [IDJugada])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[COL_NumerosApuesta] CHECK CONSTRAINT [FK_Numero_Apuesta]
GO
ALTER TABLE [dbo].[COL_Apuestas]  WITH CHECK ADD  CONSTRAINT [CK_ImportePositivo] CHECK  (([Importe]>(1)))
GO
ALTER TABLE [dbo].[COL_Apuestas] CHECK CONSTRAINT [CK_ImportePositivo]
GO
ALTER TABLE [dbo].[COL_Jugadas]  WITH CHECK ADD  CONSTRAINT [CK_NoVaMasTrasJugar] CHECK  (([MomentoJuega]<getdate() OR [NoVaMas]=(0)))
GO
ALTER TABLE [dbo].[COL_Jugadas] CHECK CONSTRAINT [CK_NoVaMasTrasJugar]
GO
ALTER TABLE [dbo].[COL_Jugadas]  WITH CHECK ADD  CONSTRAINT [CK_Numero] CHECK  (([Numero]>=(0) AND [Numero]<=(36)))
GO
ALTER TABLE [dbo].[COL_Jugadas] CHECK CONSTRAINT [CK_Numero]
GO
ALTER TABLE [dbo].[COL_Jugadas]  WITH CHECK ADD  CONSTRAINT [CK_NumeroDespues] CHECK  (([NovaMas]=(1) OR [Numero] IS NULL))
GO
ALTER TABLE [dbo].[COL_Jugadas] CHECK CONSTRAINT [CK_NumeroDespues]
GO
ALTER TABLE [dbo].[COL_Jugadores]  WITH CHECK ADD  CONSTRAINT [CK_MayorEdad] CHECK  (((datepart(year,getdate()-CONVERT([smalldatetime],[FechaNacimiento]))-(1900))>=(18)))
GO
ALTER TABLE [dbo].[COL_Jugadores] CHECK CONSTRAINT [CK_MayorEdad]
GO
ALTER TABLE [dbo].[COL_NumerosApuesta]  WITH CHECK ADD  CONSTRAINT [CK_NumeroJ] CHECK  (([Numero]>=(0) AND [Numero]<=(36)))
GO
ALTER TABLE [dbo].[COL_NumerosApuesta] CHECK CONSTRAINT [CK_NumeroJ]
GO
/****** Object:  StoredProcedure [dbo].[FinApuestas]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Asigna el número premiado y paga y cobra las apuestas, actualizando las mesas y los jugadores ganadores
Entradas: La mesa y el número ganador
Precondiciones: La mesa existe. Hay una jugada cerrada (NovaMas=1) sin número
*/
CREATE PROCEDURE [dbo].[FinApuestas] @Mesa SmallInt, @Numero TinyInt AS
BEGIN 
	DECLARE @Jugada Int, @GananTotal Money, @PierdenTotal Money
	BEGIN TRANSACTION Pagos
	-- Obtenemos la jugada
	SET @Jugada = (SELECT MAX(IDJugada) FROM COL_Jugadas WHERE IDMesa = @Mesa AND NoVaMas = 1 And Numero IS NULL)
	-- Ponemos el numero ganador
	UPDATE COL_Jugadas SET Numero = @Numero WHERE IDMesa = @Mesa AND IDJugada = @Jugada
	-- Pagamos a los ganadores
	UPDATE COL_Jugadores SET Saldo = Saldo + Pelotazo FROM Ganancias (@Mesa,@Jugada,@Numero)
		WHERE ID = Jugador
	SET @GananTotal = (SELECT SUM (Pelotazo) FROM Ganancias (@Mesa,@Jugada,@Numero))
	UPDATE COL_Mesas SET Saldo = Saldo - @GananTotal
	-- Nos quedamos con la pasta de los perdedores
	SET @PierdenTotal = (SELECT SUM(Importe) FROM COL_Apuestas 
		WHERE IDMesa = @Mesa AND IDJugada = @Jugada AND IDJugador NOT IN(
			SELECT A.IDJugador FROM COL_Apuestas AS A JOIN COL_NumerosApuesta AS N
				ON A.IDJugador = N.IDJugador AND A.IDMesa = N.IDMesa AND A.IDJugada = N.IDJugada
				WHERE N.Numero = @Numero AND A.IDMesa = @Mesa AND A.IDJugada = @Jugada))
	UPDATE COL_Mesas SET Saldo = Saldo + @PierdenTotal
	COMMIT TRANSACTION
END --PROCEDURE FinApuestas

GO
/****** Object:  StoredProcedure [dbo].[NuevaApuestaCuadro]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Crea una apuesta transversal en la mesa que se indique, en la jugada que está abierta en ese momento
Entradas: Mesa, jugador, importe, primer número de la apuesta. Si el primer número es incorrecto, la apuesta no se creará
Precondiciones: El jugador y la mesa deben existir
*/
CREATE PROCEDURE [dbo].[NuevaApuestaCuadro] @Mesa SmallInt, @Jugador Int, @Pasta Money, @Numero1 TinyInt AS
BEGIN
	DECLARE @Jugada Int, @Cont TinyInt
	-- Comprobamos si el jugador tiene suficiente dinero
	IF @Pasta <= (SELECT Saldo+Credito FROM COL_Jugadores WHERE ID = @Jugador)
	BEGIN
		-- Comprobamos que el número sea correcto
		IF @Numero1%3 > 0 AND @Numero1<= 32
		BEGIN
			-- Obtenemos el ID de la Jugada
			SET @Jugada = (SELECT IDJugada FROM COL_Jugadas WHERE IDMesa = @Mesa AND NoVaMas=0)
			IF @Jugada IS NOT NULL -- Se puede apostar en esa mesa
			BEGIN
				INSERT INTO COL_Apuestas (IDJugador,IDMesa,IDJugada,Tipo,Importe) VALUES 
					(@Jugador,@Mesa,@Jugada,9,@Pasta)
				INSERT INTO COL_NumerosApuesta (IDJugador,IDMesa,IDJugada,Numero) VALUES 
					(@Jugador,@Mesa,@Jugada,@Numero1)
					,(@Jugador,@Mesa,@Jugada,@Numero1+1)
					,(@Jugador,@Mesa,@Jugada,@Numero1+3)
					,(@Jugador,@Mesa,@Jugada,@Numero1+4)
				UPDATE COL_Jugadores SET Saldo = Saldo - @Pasta WHERE ID = @Jugador
			END
		END
	END
END --PROCEDURE NuevaApuestaCuadro

GO
/****** Object:  StoredProcedure [dbo].[NuevaApuestaPI]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Crea una apuesta Par/Impar en la mesa que se indique, en la jugada que está abierta en ese momento
Entradas: Mesa, jugador, importe, opcion de la apuesta. Si la opcion es 0 se apuesta a Par y en caso contrario, a Impar
Precondiciones: El jugador y la mesa deben existir
*/
CREATE PROCEDURE [dbo].[NuevaApuestaPI] @Mesa SmallInt, @Jugador Int, @Pasta Money, @Opcion Bit AS
BEGIN
	DECLARE @Jugada Int, @Cont TinyInt
	-- Comprobamos si el jugador tiene suficiente dinero
	IF @Pasta <= (SELECT Saldo+Credito FROM COL_Jugadores WHERE ID = @Jugador)
	BEGIN
		-- Obtenemos el ID de la Jugada
		SET @Jugada = (SELECT IDJugada FROM COL_Jugadas WHERE IDMesa = @Mesa AND NoVaMas=0)
		IF @Jugada IS NOT NULL -- Se puede apostar en esa mesa
		BEGIN
			INSERT INTO COL_Apuestas (IDJugador,IDMesa,IDJugada,Tipo,Importe) VALUES 
				(@Jugador,@Mesa,@Jugada,2,@Pasta)
			SET @Cont = CASE @Opcion
							WHEN 0 THEN 2
							ELSE 1
						END
			WHILE @Cont <= 36
			BEGIN
				INSERT INTO COL_NumerosApuesta (IDJugador,IDMesa,IDJugada,Numero)
					VALUES (@Jugador,@Mesa,@Jugada,@Cont)
				SET @Cont += 2
			END -- WHILE
			UPDATE COL_Jugadores SET Saldo = Saldo - @Pasta WHERE ID = @Jugador
		END
	END
END --PROCEDURE NuevaApuestaPI

GO
/****** Object:  StoredProcedure [dbo].[NuevaApuestaRN]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Crea una apuesta Rojo/Negro en la mesa que se indique, en la jugada que está abierta en ese momento
Entradas: Mesa, jugador, importe, opcion de la apuesta. Si la opcion es 0 se apuesta a Rojo y en caso contrario, a Negro
Precondiciones: El jugador y la mesa deben existir
*/
CREATE PROCEDURE [dbo].[NuevaApuestaRN] @Mesa SmallInt, @Jugador Int, @Pasta Money, @Opcion Bit AS
BEGIN
	DECLARE @Jugada Int, @Cont TinyInt
	-- Comprobamos si el jugador tiene suficiente dinero
	IF @Pasta <= (SELECT Saldo+Credito FROM COL_Jugadores WHERE ID = @Jugador)
	BEGIN
		-- Obtenemos el ID de la Jugada
		SET @Jugada = (SELECT IDJugada FROM COL_Jugadas WHERE IDMesa = @Mesa AND NoVaMas=0)
		IF @Jugada IS NOT NULL -- Se puede apostar en esa mesa
		BEGIN
			INSERT INTO COL_Apuestas (IDJugador,IDMesa,IDJugada,Tipo,Importe) VALUES 
				(@Jugador,@Mesa,@Jugada,1,@Pasta)
			IF @Opcion = 0 -- Apuesta al Rojo
				INSERT INTO COL_NumerosApuesta (IDJugador,IDMesa,IDJugada,Numero) VALUES 
					(@Jugador,@Mesa,@Jugada,1)
					,(@Jugador,@Mesa,@Jugada,3)
					,(@Jugador,@Mesa,@Jugada,5)
					,(@Jugador,@Mesa,@Jugada,7)
					,(@Jugador,@Mesa,@Jugada,9)
					,(@Jugador,@Mesa,@Jugada,12)
					,(@Jugador,@Mesa,@Jugada,14)
					,(@Jugador,@Mesa,@Jugada,16)
					,(@Jugador,@Mesa,@Jugada,18)
					,(@Jugador,@Mesa,@Jugada,19)
					,(@Jugador,@Mesa,@Jugada,21)
					,(@Jugador,@Mesa,@Jugada,23)
					,(@Jugador,@Mesa,@Jugada,25)
					,(@Jugador,@Mesa,@Jugada,27)
					,(@Jugador,@Mesa,@Jugada,30)
					,(@Jugador,@Mesa,@Jugada,32)
					,(@Jugador,@Mesa,@Jugada,34)
					,(@Jugador,@Mesa,@Jugada,36)
			ELSE -- Apuesta al Negro
				INSERT INTO COL_NumerosApuesta (IDJugador,IDMesa,IDJugada,Numero) VALUES 
					(@Jugador,@Mesa,@Jugada,2)
					,(@Jugador,@Mesa,@Jugada,4)
					,(@Jugador,@Mesa,@Jugada,6)
					,(@Jugador,@Mesa,@Jugada,8)
					,(@Jugador,@Mesa,@Jugada,10)
					,(@Jugador,@Mesa,@Jugada,11)
					,(@Jugador,@Mesa,@Jugada,13)
					,(@Jugador,@Mesa,@Jugada,15)
					,(@Jugador,@Mesa,@Jugada,17)
					,(@Jugador,@Mesa,@Jugada,20)
					,(@Jugador,@Mesa,@Jugada,22)
					,(@Jugador,@Mesa,@Jugada,24)
					,(@Jugador,@Mesa,@Jugada,26)
					,(@Jugador,@Mesa,@Jugada,28)
					,(@Jugador,@Mesa,@Jugada,29)
					,(@Jugador,@Mesa,@Jugada,31)
					,(@Jugador,@Mesa,@Jugada,33)
					,(@Jugador,@Mesa,@Jugada,35)
			UPDATE COL_Jugadores SET Saldo = Saldo - @Pasta WHERE ID = @Jugador
		END
	END
END --PROCEDURE NuevaApuestaPI

GO
/****** Object:  StoredProcedure [dbo].[NuevaApuestaTran]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Crea una apuesta transversal en la mesa que se indique, en la jugada que está abierta en ese momento
Entradas: Mesa, jugador, importe, primer número de la apuesta. Si el primer número es incorrecto, la apuesta no se creará
Precondiciones: El jugador y la mesa deben existir
*/
CREATE PROCEDURE [dbo].[NuevaApuestaTran] @Mesa SmallInt, @Jugador Int, @Pasta Money, @Numero1 TinyInt AS
BEGIN
	DECLARE @Jugada Int, @Cont TinyInt
	-- Comprobamos si el jugador tiene suficiente dinero
	IF @Pasta <= (SELECT Saldo+Credito FROM COL_Jugadores WHERE ID = @Jugador)
	BEGIN
		-- Comprobamos que el número sea correcto
		IF @Numero1%3 = 1 AND @Numero1<= 34
		BEGIN
			-- Obtenemos el ID de la Jugada
			SET @Jugada = (SELECT IDJugada FROM COL_Jugadas WHERE IDMesa = @Mesa AND NoVaMas=0)
			IF @Jugada IS NOT NULL -- Se puede apostar en esa mesa
			BEGIN
				INSERT INTO COL_Apuestas (IDJugador,IDMesa,IDJugada,Tipo,Importe) VALUES 
					(@Jugador,@Mesa,@Jugada,10,@Pasta)
				INSERT INTO COL_NumerosApuesta (IDJugador,IDMesa,IDJugada,Numero) VALUES 
					(@Jugador,@Mesa,@Jugada,@Numero1)
					,(@Jugador,@Mesa,@Jugada,@Numero1+1)
					,(@Jugador,@Mesa,@Jugada,@Numero1+2)
				UPDATE COL_Jugadores SET Saldo = Saldo - @Pasta WHERE ID = @Jugador
			END
		END
	END
END --PROCEDURE NuevaApuestaTran

GO
/****** Object:  StoredProcedure [dbo].[NuevaJugada]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Cierra la jugada anterior y crea una nueva jugada en la mesa que se especifique
Entradas: Número de mesa en que se ha de crear la jugada
Precondiciones: La mesa debe existir
*/
CREATE PROCEDURE [dbo].[NuevaJugada] @Mesa SmallInt, @Fecha DATETIME AS
BEGIN
	DECLARE @Jugada Int
	SET @Fecha = ISNULL(@Fecha,GETDATE())
	BEGIN TRAN
		IF NOT EXISTS (SELECT * FROM COL_Jugadas WHERE IDMesa = @Mesa)
			INSERT INTO COL_Jugadas (IDMesa,IDJugada,MomentoJuega,NoVaMas)
				VALUES (@Mesa,1,@Fecha,0)
		ELSE
		BEGIN
			SELECT @Jugada = MAX(IDJugada) FROM COL_Jugadas WHERE IDMesa = @Mesa
			UPDATE COL_Jugadas SET NoVaMas=1 WHERE IDMesa = @Mesa AND IDJugada = @Jugada
			INSERT INTO COL_Jugadas (IDMesa,IDJugada,MomentoJuega,NoVaMas)
				VALUES (@Mesa,@Jugada+1,@Fecha,0)
		END
	COMMIT TRAN
END --PROCEDURE NuevaJugada

GO
/****** Object:  StoredProcedure [dbo].[proc2]    Script Date: 25/01/2022 9:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[proc2]
	@id int
as
begin
	declare @saldo money;
	set @saldo=( Select Saldo from COL_Jugadores where ID=@id)
	
	If @saldo>=500
	begin 
		update COL_Jugadores
		set Saldo=Saldo+20
		where ID=@id
	end
	else
	begin
		if @saldo>200
		begin
			update COL_Jugadores
			set Saldo=Saldo+10
			where ID=@id
		end
		else
		begin
			update COL_Jugadores
			set Saldo=Saldo+5
			where ID=@id
		end
		
	end
	
end

GO
USE [master]
GO
ALTER DATABASE [CasinOnLine] SET  READ_WRITE 
GO