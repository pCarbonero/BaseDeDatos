USE Northwind
--1. OBTENER CANTIDAD DE PRODUCTOS VENDIDOS
select * from [Order Details]
CREATE or alter FUNCTION ej01Cantidad ()
RETURNS TABLE
AS
RETURN (SELECT SUM(Quantity) as cantidad fROM [Order Details]);

SELECT * from dbo.ej01Cantidad()

--2. CÁLCULO DE FIBONACCI. A partir de un número obtener la sucesión de Fibonacci hasta ese número
-- (en la sucesión de Fibonacci, el siguiente número es la suma de los dos anteriores): 
-- En la sucesión de fibonacci los dos primeros números son 1 y 
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

--3. OBTENER DESCUENTO MÁXIMO POR CATEGORÍA:
select * from [Order Details]
CREATE FUNCTION ej03Dis()
RETURNS TABLE
AS 
RETURN (SELECT P.CategoryID, MAX(OD.Discount) as descuentoMaximo FROM [Order Details] OD
INNER JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.CategoryID)

SELECT * FROM dbo.ej03Dis()

--4. Obtener los DÍAS LABORABLES ENTRE DOS FECHAS:

--5. OBTENER TOTAL DE PEDIDOS POR CLIENTE:
SELECT * FROM 
