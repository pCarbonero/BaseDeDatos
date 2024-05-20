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
	
SELECT dbo.FnPremioConseguido(1)

--------CON CASE
CREATE OR ALTER function FnPremioConseguido2(@idApuesta int)
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

SET @dineroObtenido = 
	case
		when @posicion = 1 then (SELECT Premio1*@importe FROM LTCaballosCarreras WHERE @caballo = IDCaballo AND @carrera = IDCarrera)
		when @posicion = 2 then (SELECT Premio2*@importe FROM LTCaballosCarreras WHERE @caballo = IDCaballo AND @carrera = IDCarrera)
		when @posicion IS NULL then  NULL
		else -@importe
	end

return @dineroObtenido
END

SELECT dbo.FnPremioConseguido(1)
SELECT dbo.FnPremioConseguido2(1)

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


CREATE OR ALTER FUNCTION FnPremio1(@idCarrera int)
RETURNS TABLE
RETURN(SELECT SUM((dbo.FnDineroApostado(1)/Importe)*0.6) AS Premio1, IDCaballo FROM LTApuestas 
WHERE IDCarrera = @idCarrera GROUP BY IDCaballo)

SELECT * FROM FnPremio1(1)

CREATE OR ALTER FUNCTION FnPremio2(@idCarrera int)
RETURNS TABLE
RETURN(SELECT SUM((dbo.FnDineroApostado(1)/Importe)*0.2) AS Premio2, IDCaballo FROM LTApuestas 
WHERE IDCarrera = @idCarrera GROUP BY IDCaballo)

SELECT * FROM FnPremio2(1)

CREATE OR ALTER FUNCTION FnCore04(@idCarrera int)
RETURNS TABLE
RETURN(SELECT a1.IDCaballo, P1.Premio1, P2.Premio2 FROM dbo.FnCaballosCarrera(@idCarrera) as a1
		INNER JOIN dbo.FnPremio1(@idCarrera) P1 ON P1.IDCaballo = a1.IDCaballo
		INNER JOIN dbo.FnPremio2(@idCarrera) P2 ON P2.IDCaballo = a1.IDCaballo)


SELECT * FROM FnCore04(1)

--5. Crea una función FnPalmares que reciba un ID de caballo y un rango de fechas y nos devuelva el palmarés de ese caballo en ese intervalo de tiempo.
-- El palmarés es el número de victorias, segundos puestos, etc. Se devolverá una tabla con dos columnas: 
-- Posición y NumVeces, que indicarán, respectivamente, cada una de las posiciones y las veces que el caballo ha obtenido ese resultado. 
SELECT * FROM LTCaballosCarreras
SELECT * FROM LTCarreras
CREATE OR ALTER FUNCTION FnPalmares (@idCaballo int, @fechaInicial date, @fechaFinal date)
RETURNS TABLE 
RETURN(SELECT CC.Posicion, Count(CC.Posicion) As numVeces FROM LTCaballosCarreras AS CC
		INNER JOIN LTCarreras as C ON CC.IDCarrera = C.ID
		WHERE CC.IDCaballo = @idCaballo AND C.Fecha BETWEEN @fechaInicial AND @fechaFinal AND CC.Posicion IS NOT NULL
		GROUP by CC.Posicion)

SELECT * FROM FnPalmares(1, '2017-02-27', '2019-03-11')

--6. Crea una función FnCarrerasHipodromo que nos devuelva las carreras celebradas en un hipódromo en un rango de fechas.
-- La función recibirá como parámetros el nombre del hipódromo y la fecha de inicio y fin del intervalo y nos devolverá una tabla con las siguientes columnas: 
-- Fecha de la carrera, número de orden, numero de apuestas realizadas, número de caballos inscritos, número de caballos que la finalizaron y nombre del ganador.
SELECT * FROM LTCarreras
SELECT * FROM LTApuestas where IDCarrera = 21
SELECT * FROM LTCaballosCarreras 
SELECT * FROM LTCaballos

CREATE OR ALTER FUNCTION FnCarrerasHipodromo(@nombre varChar(100), @fechaIncio date, @fechaFin date)
RETURNS TABLE
RETURN(SELECT C.ID, C.Fecha, C.NumOrden, COUNT(distinct A.ID) AS numApuestas, COUNT(distinct CC.IDCaballo) AS numCaballo,
COUNT(DISTINCT CASE WHEN CC.Posicion IS NOT NULL THEN CC.IDCaballo END) AS numFin,
CG.ganador 
FROM LTCarreras C
INNER JOIN LTApuestas A ON C.ID = A.IDCarrera
INNER JOIN LTCaballosCarreras CC ON C.ID = CC.IDCarrera
INNER JOIN dbo.FnCaballoGanador(@nombre, @fechaIncio, @fechaFin) CG ON CG.ID = C.ID
WHERE C.Hipodromo = @nombre AND C.Fecha BETWEEN @fechaIncio AND @fechaFin
GROUP BY C.ID, C.Fecha, C.NumOrden, CG.ganador)

SELECT * FROM dbo.FnCarrerasHipodromo('Gran Hipodromo de Andalucia', '2000-01-20', '2028-03-03')


CREATE OR ALTER FUNCTION FnCaballoGanador(@nombre varChar(100), @fechaIncio date, @fechaFin date)
RETURNS TABLE
RETURN(SELECT C.ID, ISNULL(CB.Nombre, 'NADA') AS ganador FROM LTCarreras C
INNER JOIN LTCaballosCarreras CC ON C.ID = CC.IDCarrera
INNER JOIN LTCaballos CB ON CB.ID = CC.IDCaballo
WHERE C.Hipodromo = @nombre AND C.Fecha BETWEEN @fechaIncio AND @fechaFin AND CC.Posicion = 1)

SELECT * FROM FnCaballoGanador('Gran Hipodromo de Andalucia', '2000-01-20', '2028-03-03')


-- 7.Crea una función FnObtenerSaldo a la que pasemos el ID de un jugador y una fecha y nos devuelva su saldo en esa fecha. Si se omite la fecha, se devolverá el saldo actual
SELECT * FROM LTJugadores
SELECT * FROM LTApuntes

CREATE OR ALTER FUNCTION FnObtenerSaldo(@id int, @fecha date)
RETURNS money
AS BEGIN
declare @qua money
if	(@fecha in (SELECT fecha FROM LTApuntes))
BEGIN 
	SET @qua = (SELECT A.Saldo FROM LTApuntes A
	INNER JOIN LTJugadores J ON A.IDJugador = J.ID
	WHERE A.IDJugador = @id AND A.Fecha = @fecha)
END
ELSE
	BEGIN
	SET @qua = NULL 
	END
RETURN @qua
END 
SELECT dbo.FnObtenerSaldo(1, '2015-01-01') AS SALDO
