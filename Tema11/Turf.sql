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
RETURNS decimal(2,1)
AS BEGIN
declare @caballo int
declare @carrera int
declare @posicion int
declare @importe decimal(3,1)
declare @premio decimal (3,1)

SELECT @caballo = IDcaballo, @carrera = IDCarrera, @importe = Importe FROM LTApuestas WHERE ID = @idApuesta
SELECT @posicion = Posicion FROM LTCaballosCarreras WHERE @caballo = IDCaballo AND @carrera = IDCarrera

CASE @posicion
     WHEN 1 THEN SET @premio = 
END 



END

SELECT dbo.FnPremioConseguido(1)





