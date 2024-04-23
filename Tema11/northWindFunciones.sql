USE Northwind
--1. OBTENER CANTIDAD DE PRODUCTOS VENDIDOS
select * from [Order Details]
CREATE or alter FUNCTION ej01Cantidad ()
RETURNS TABLE
AS
RETURN (SELECT SUM(Quantity) as cantidad fROM [Order Details]);

SELECT * from dbo.ej01Cantidad()

--2. C�LCULO DE FIBONACCI. A partir de un n�mero obtener la sucesi�n de Fibonacci hasta ese n�mero
-- (en la sucesi�n de Fibonacci, el siguiente n�mero es la suma de los dos anteriores): 
-- En la sucesi�n de fibonacci los dos primeros n�meros son 1 y 
-- luego la suma de los dos anteriores. 1, 1, 2, 3, 5, 8, 13, 21....
DROP FUNCTION ej02Fibonacci(@num int)
CREATE OR ALTER FUNCTION ej02Fibonacci(@num int)
RETURNS varChar(500)
AS BEGIN
declare @actual int = 1;
declare @anterior int = 0;
declare @aux int = 0;
declare @sucesion varChar(500) = '';

while @actual < @num
	BEGIN
		SET @sucesion += CONCAT(@actual, ', ');
		SET @aux = @actual;
		SET @actual += @anterior;
		SET @anterior = @aux;
	END
RETURN @sucesion
END
SELECT dbo.ej02Fibonacci(15) AS SUCESION

--3. OBTENER DESCUENTO M�XIMO POR CATEGOR�A:
select * from [Order Details]
CREATE FUNCTION ej03Dis()
RETURNS TABLE
AS 
RETURN (SELECT P.CategoryID, MAX(OD.Discount) as descuentoMaximo FROM [Order Details] OD
INNER JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.CategoryID)

SELECT * FROM dbo.ej03Dis()

--4. Obtener los D�AS LABORABLES ENTRE DOS FECHAS:

--5. OBTENER TOTAL DE PEDIDOS POR CLIENTE:
SELECT * FROM 
