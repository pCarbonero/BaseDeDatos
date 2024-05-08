--1.Crea una función inline llamada FnCarrerasCaballo que reciba un rango de fechas (inicio y fin) 
-- y nos devuelva el número de carreras disputadas por cada caballo entre esas dos fechas. 
-- Las columnas serán ID (del caballo), nombre, sexo, fecha de nacimiento y número de carreras disputadas.
SELECT * FROM LTCaballosCarreras
SELECT * FROM LTCaballos
SELECT * FROM LTCarreras

CREATE OR ALTER FUNCTION FnCarrerasCaballo(@fechaInicio date, @fechaFin date)
RETURNS TABLE 
RETURN(SELECT C.ID, C.Nombre, C.Sexo, C.FechaNacimiento, COUNT(CR.IDCarrera) AS numCarreras FROM LTCaballos AS C
INNER JOIN LTCaballosCarreras AS CR ON C.ID = CR.IDCaballo
INNER JOIN LTCarreras AS R ON CR.IDCarrera = R.ID 
WHERE R.Fecha BETWEEN @fechaInicio AND @fechaFin
GROUP BY C.ID, C.Nombre, C.Sexo, C.FechaNacimiento)

SELECT * FROM dbo.FnCarrerasCaballo('2018-03-01', '2018-03-10')

--2. Crea una función escalar llamada FnTotalApostadoCC que reciba como parámetros el ID de un caballo y
-- el ID de una carrera y nos devuelva el dinero que se ha apostado a ese caballo en esa carrera.

Create or Alter function FnTotalApostadoCC(@idCaballo int, @idCarrera int)
returns int
AS BEGIN
declare @dinero int = (SELECT Importe from LTApuestas WHERE IDCaballo = @idCaballo AND IDCarrera = @idCarrera)
return @dinero
END

SELECT dbo.FnTotalApostadoCC(1,1)

--3. Crea una función escalar llamada FnPremioConseguido que reciba como parámetros el ID de una apuesta 
-- y nos devuelva el dinero que ha ganado dicha apuesta. Si todavía no se conocen las posiciones de los caballos, 
-- devolverá un NULL. 
SELECT * FROM LTApuestas
SELECT * FROM LTCaballosCarreras

CREATE OR ALTER function FnPremioConseguido(@idApuesta int)
RETURNS numeric
AS BEGIN
declare @caballo numeric
declare @carrera numeric
declare @posicion numeric
declare @importe numeric
declare @premio numeric
declare @dineroObtenido numeric

SELECT @caballo = IDcaballo, @carrera = IDCarrera, @importe = Importe FROM LTApuestas WHERE ID = @idApuesta
SELECT @posicion = Posicion FROM LTCaballosCarreras WHERE @caballo = IDCaballo AND @carrera = IDCarrera

IF (@posicion = 1)
	begin
     SET @dineroObtenido = (SELECT Premio1*@importe FROM LTCaballosCarreras WHERE @caballo = IDCaballo AND @carrera = IDCarrera)
	END 
ELSE IF (@posicion = 2)
	BEGIN
	 SET @dineroObtenido = (SELECT Premio2*@importe FROM LTCaballosCarreras WHERE @caballo = IDCaballo AND @carrera = IDCarrera)
	END
ELSE IF (@posicion is NULL)
	BEGIN
	SET @dineroObtenido = NULL
	END
ELSE
	BEGIN
	SET @dineroObtenido = -@importe
	END

return @dineroObtenido
END
	
SELECT dbo.FnPremioConseguido(2)

--4. 
SELECT * FROM LTApuestas
SELECT * FROM LTCaballosCarreras

CREATE OR ALTER FUNCTION FnCaballosCarrera(@idCarrera int)
RETURNS TABLE
RETURN(SELECT IDCaballo, SUM((dbo.FnDineroApostado(@idCarrera)/dbo.FnTotalApostadoCC(@idCarrera,IDCaballo))) AS A FROM LTApuestas 
		WHERE IDCarrera = @idCarrera GROUP BY IDCaballo)

SELECT * FROM dbo.FnCaballosCarrera(1) 

CREATE OR ALTER FUNCTION FnDineroApostado(@idCarrera int)
RETURNS int
AS BEGIN
	declare @totalCarrera int = (SELECT SUM(Importe) FROM LTApuestas WHERE IDCarrera = @idCarrera)
	return @totalCarrera
END

SELECT dbo.FnDineroApostado(1) as TotalCarrera

SELECT dbo.FnTotalApostadoCC(1,1)  as TotalAUnCaballo

CREATE OR ALTER FUNCTION FnPremio1(@idCarrera int, @idCaballo int)
RETURNS decimal(2,1)
AS BEGIN
	declare @Premio1 decimal(2,1) = (dbo.FnDineroApostado(@idCarrera)/dbo.FnTotalApostadoCC(@idCarrera, @idCaballo) * 0.6)
Return @Premio1
END

SELECT dbo.FnPremio1(1,1)


