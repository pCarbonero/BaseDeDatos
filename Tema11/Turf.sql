--1.Crea una funci�n inline llamada FnCarrerasCaballo que reciba un rango de fechas (inicio y fin) 
-- y nos devuelva el n�mero de carreras disputadas por cada caballo entre esas dos fechas. 
-- Las columnas ser�n ID (del caballo), nombre, sexo, fecha de nacimiento y n�mero de carreras disputadas.
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

--2. 2.Crea una funci�n escalar llamada FnTotalApostadoCC que reciba como par�metros el ID de un caballo y
-- el ID de una carrera y nos devuelva el dinero que se ha apostado a ese caballo en esa carrera.
