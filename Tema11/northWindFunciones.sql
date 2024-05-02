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
SELECT dbo.ej02Fibonacci(620) AS SUCESION

--

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
CREATE OR ALTER FUNCTION ej04dias(@fechaInicio date, @fechaFinal date)
RETURNS int
AS BEGIN
declare @diasTot int = 0
declare @fechaLimit date = @fechaInicio

WHILE @fechaLimit < @fechaFinal
	BEGIN
	SET @fechaLimit = DATEADD(DAY, 1, @fechaLimit);
	if (DATEPART(WEEKDAY, @fechaLimit) IN (1,2,3,4,5))
	BEGIN
		SET @diasTot+=1;
		END
	END
RETURN @diasTot;
END

SELECT dbo.ej04dias('02-01-2003', '02-01-2004') as a






--5. OBTENER TOTAL DE PEDIDOS POR CLIENTE:
SELECT * FROM Orders
SELECT * FROM Customers

CREATE OR ALTER FUNCTION ej05pedidosClientes()
RETURNS TABLE
RETURN (SELECT CustomerID, COUNT(CustomerID) as totalPedidos FROM Orders
GROUP BY CustomerID)

SElECT * FROM ej05pedidosClientes()

--6. Función que calcule el promedio de una serie de valores. 
-- Los parámetros de la función se pasarán de forma ‘1,2,3,4….’:
CREATE OR ALTER FUNCTION ej06Numeros(@numeritos varChar(100))
RETURNS VARCHAR(100)
AS BEGIN
declare @res decimal(9,2) 
SET @res = (SELECT AVG(CAST(VALUE AS decimal(9,2))) as asaa FROM STRING_SPLIT(@numeritos, ','))
RETURN @res
END
SELECT dbo.ej06Numeros('3, 0, 5, 3') as asaa

--7. OBTENER LOS DETALLES DE PEDIDOS DE  TODOS LOS CLIENTES. 
-- Obtener el identificador de la orden, el nombre del producto, la cantidad pedida y el nombre de la compañia.:	
CREATE FUNCTION ej07details()
RETURNS TABLE 
RETURN(SELECT O.customerID, OD.* FROM [Order Details] OD
INNER JOIN ORDERS AS O ON OD.OrderID = O.OrderID)

SELECT * FROM ej07details()

--8.  OBTENER VENTAS MENSUALES POR CATEGORÍA. 
-- Mostrar por cada año y mes, el nombre de la categoría y la cantidad de ventas realizadas.:
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM [Summary of Sales by Year]
select * from [Sales by Category]

CREATE OR ALTER FUNCTION ej08 ()
RETURNS TABLE
RETURN (SELECT DATENAME(year, SS.ShippedDate) as año, DATENAME(month, SS.ShippedDate) as mes, C.CategoryName, C.ProductSales FROM [Summary of Sales by Year] AS SS
inner join [Order Details] as OD ON SS.OrderID = OD.OrderID
INNER JOIN Products AS P ON OD.ProductID = P.ProductID
INNER JOIN [Sales by Category] AS C ON P.CategoryID = C.CategoryID
GROUP BY DATENAME(year, SS.ShippedDate), DATENAME(month, SS.ShippedDate), C.CategoryName, C.ProductSales)

SELECT * FROM dbo.ej08()


--9. OBTENER RESUMEN SEMANAL DE VENTAS. Queremos mostrar por cada semana, las ventas realizadas.
CREATE or ALTER FUNCTION ej09semanas (
) RETURNS table 
AS return (
    SELECT datepart(week,o.OrderDate) as semana, sum(od.Quantity)  as ventas
    from Orders as o
    inner join [Order Details] as od
    on o.OrderID = od.OrderID
    group by datepart(week,o.OrderDate)
)

SELECT * from dbo.ej09semanas() order by semana;


-- 10. OBTENER LOS 10 PRODUCTOS MÁS VENDIDOS:
CREATE OR ALTER FUNCTION ej10top()
RETURNS TABLE 
RETURN(SELECT TOP 10 * FROM [Sales by Category] order by ProductSales desc)

select * from ej10top()

