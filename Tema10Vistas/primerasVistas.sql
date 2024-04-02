-- Unidades vendidas de cada producto en 1996
SELECT OD.ProductID, P.ProductName, SUM(OD.Quantity) AS VentasAnuales FROM Products AS P
	INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
	Where Year (O.OrderDate) = 1996 
	Group By OD.ProductID, P.ProductName


-- Las del 97. Incluimos los productos con ventas cero
SELECT P.ProductID, P.ProductName, SUM(ISNULL(OD.Quantity,0)) AS VentasAnuales FROM Products AS P
	LEFT JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
	LEFT JOIN Orders AS O ON OD.OrderID = O.OrderID
	Where Year (O.OrderDate) = 1997 OR O.OrderDate IS NULL
	Group By P.ProductID, P.ProductName

-- REALIZAR CON UNA CONSULTA
-- Queremos saber la diferencia entre ambos ambos: Obtener nombre del producto,
-- ventas del producto en el 96, ventas en el 97, INCREMENTO DE VENTAS DEL A�O 96 AL 97,
-- y Diferencia porcentual entre los dos valores.
-- Para obtener la diferencia porcentual usar: CAST (((V97.VentasAnuales - ISNULL(V96.VentasAnuales, 0))*100)/V96.VentasAnuales AS Decimal(5,1)) AS Porcentaje
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders


SELECT Año97.ProductName, Año96.Ventas96, Año97.Ventas97, (Año97.Ventas97-Año96.Ventas96) AS IncrementoAnual, 
CAST (((Año97.Ventas97 - ISNULL(Año96.Ventas96, 0))*100)/Año96.Ventas96 AS Decimal(5,1)) AS Porcentaje 
FROM 
(SELECT OD.ProductID, P.ProductName, SUM(OD.Quantity) AS Ventas96 FROM Products AS P
	INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
	Where Year (O.OrderDate) = 1996
	Group By OD.ProductID, P.ProductName) AS Año96
	RIGHT JOIN 
	(SELECT P.ProductID, P.ProductName, SUM(ISNULL(OD.Quantity,0)) AS Ventas97 FROM Products AS P
	LEFT JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
	LEFT JOIN Orders AS O ON OD.OrderID = O.OrderID
	Where Year (O.OrderDate) = 1997 OR O.OrderDate IS NULL
	Group By P.ProductID, P.ProductName) AS Año97
	ON Año96.ProductID = Año97.ProductID


-- Ahora crea las vistas necesarias y reescribe la consulta anterior
-- con las vistas
-- VISTAS TABLA 96
CREATE View Ventas1996 AS
SELECT OD.ProductID, P.ProductName, SUM(OD.Quantity) AS VentasAnuales FROM Products AS P
	INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
	Where Year (O.OrderDate) = 1996 
	Group By OD.ProductID, P.ProductName

-- VISTA 997
CREATE VIEW Ventas1997 AS
SELECT P.ProductID, P.ProductName, SUM(ISNULL(OD.Quantity,0)) AS VentasAnuales FROM Products AS P
	LEFT JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
	LEFT JOIN Orders AS O ON OD.OrderID = O.OrderID
	Where Year (O.OrderDate) = 1997 OR O.OrderDate IS NULL
	Group By P.ProductID, P.ProductName

-- VISTA DIFERENCIA VENTAS 
SELECT Ventas1996.ProductName, Ventas1996.VentasAnuales, Ventas1997.VentasAnuales, (Ventas1997.VentasAnuales-Ventas1996.VentasAnuales) AS IncrementoAnual, 
CAST (((Ventas1997.VentasAnuales - ISNULL(Ventas1996.VentasAnuales, 0))*100)/Ventas1996.VentasAnuales AS Decimal(5,1)) AS Porcentaje 
FROM Ventas1996
RIGHT JOIN Ventas1997
ON Ventas1996.ProductID = Ventas1997.ProductID
