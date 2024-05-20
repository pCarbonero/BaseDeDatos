-- 1.- Haz un trigger para que un pedido (order) no pueda incluir más de 10 productos diferentes.

SELECT * FROM Orders
SELECt * FROM [Order Details]
SELECt * FROM Products
SELECT * FROM Categories

-- esto está mal, devuelve el numero de categorias que hay en un pedido
SELECT O.OrderId, Count(Distinct C.CategoryID) AS numCategorias FROM Categories C
INNER JOIN Products P on C.CategoryID = P.CategoryID
INNER JOIN [Order Details] OD ON OD.ProductID = P.ProductID
INNER JOIN Orders O ON O.OrderID = OD.OrderID
WHERE O.OrderID = 10248
GROUP BY O.OrderId

------------------------------------------------------------------------

SELECT O.OrderId, Count(Distinct od.ProductID) AS numProdDistintos FROM [Order Details] OD
INNER JOIN ORDERS O ON O.OrderID = OD.OrderID
WHERE O.OrderID = 10248
GROUP BY O.OrderId

CREATE OR ALTER TRIGGER trg_noMas10 On [Order Details]
AFTER INSERT
AS BEGIN 
declare @var int = (SELECT COUNT(DISTINCT ProductID) FROM [Order Details] 
					WHERE OrderID = (SELECT ORderId FROM inserted))

	if (@var > 10)
		BEGIN
			PRINT('HAY MÁS DE 10')
			ROLLBACK
		END
END

select * from Products
select * from [Order Details]


Begin Transaction prueba1
Insert into [Order Details] (OrderID, ProductID) Values (10248, 1)
Insert into [Order Details] (OrderID, ProductID) Values (10248, 2)
Insert into [Order Details] (OrderID, ProductID) Values (10248, 3)
Insert into [Order Details] (OrderID, ProductID) Values (10248, 4)
Insert into [Order Details] (OrderID, ProductID) Values (10248, 5)
Insert into [Order Details] (OrderID, ProductID) Values (10248, 6)
Insert into [Order Details] (OrderID, ProductID) Values (10248, 7)
Insert into [Order Details] (OrderID, ProductID) Values (10248, 8)
rollback

--2.- Haz un trigger para que un cliente no pueda hacer más de 10 pedidos al año (años naturales) de la misma categoría
SELECT * FROM Orders
SELECt * FROM [Order Details]
SELECt * FROM Products
SELECT * FROM Categories

SELECT Count(Distinct C.CategoryID) AS numCategorias FROM ORders O 
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE O.OrderDate BETWEEN '1996-01-01' AND '1996-31-12' AND CustomerID = 'VINET'
Group by O.CustomerID, O.OrderID, O.OrderDate

CREATE OR ALTER TRIGGER trg_noMas10catAnyo On ORders
AFTER INSERT
AS BEGIN 

END