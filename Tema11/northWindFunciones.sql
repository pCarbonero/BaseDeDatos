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
SELECT dbo.ej02Fibonacci(620) AS SUCESION

--

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
SELECT * FROM Orders
SELECT * FROM Customers

CREATE OR ALTER FUNCTION ej05pedidosClientes()
RETURNS TABLE
RETURN (SELECT CustomerID, COUNT(CustomerID) as totalPedidos FROM Orders
GROUP BY CustomerID)

SElECT * FROM ej05pedidosClientes()

--6. Funci�n que calcule el promedio de una serie de valores. 
-- Los par�metros de la funci�n se pasar�n de forma �1,2,3,4�.�:
CREATE OR ALTER FUNCTION ej06Numeros(@numeritos varChar(100))
RETURNS VARCHAR(100)
AS BEGIN
declare @res decimal(9,2) 
SET @res = (SELECT AVG(CAST(VALUE AS decimal(9,2))) as asaa FROM STRING_SPLIT(@numeritos, ','))
RETURN @res
END
SELECT dbo.ej06Numeros('3, 0, 5, 3') as asaa

--7. OBTENER LOS DETALLES DE PEDIDOS DE  TODOS LOS CLIENTES. 
-- Obtener el identificador de la orden, el nombre del producto, la cantidad pedida y el nombre de la compa�ia.:	
CREATE FUNCTION ej07details()
RETURNS TABLE 
RETURN(SELECT O.customerID, OD.* FROM [Order Details] OD
INNER JOIN ORDERS AS O ON OD.OrderID = O.OrderID)

SELECT * FROM ej07details()

--8.  OBTENER VENTAS MENSUALES POR CATEGOR�A. 
-- Mostrar por cada a�o y mes, el nombre de la categor�a y la cantidad de ventas realizadas.:
SELECT * FROM [Sales by Category]
SELECT * FROM [Summary of Sales by Year]

--9. OBTENER RESUMEN SEMANAL DE VENTAS. Queremos mostrar por cada semana, las ventas realizadas.




-- 10. OBTENER LOS 10 PRODUCTOS M�S VENDIDOS:
CREATE OR ALTER FUNCTION ej10top()
RETURNS TABLE 
RETURN(SELECT TOP 10 * FROM [Sales by Category] order by ProductSales desc)

select * from ej10top()


