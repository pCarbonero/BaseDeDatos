-- 1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.
SELECT * FROM Customers
SELECT Country, COUNT(Country) AS NumClientes
FROM Customers
GROUP BY Country ORDER BY Country;

-- 2. ID de producto y n�mero de unidades vendidas de cada producto (El n�mero de unidades las obtenemos del campo
-- Quantity de Order Detail.
SELECT * FROM [Order Details]
SELECT ProductID, SUM(Quantity) AS UdsVendidas FROM [Order Details] GROUP BY ProductID ORDER BY ProductID

-- 3. ID del cliente y n�mero de pedidos que nos ha hecho.
SELECT * FROM Orders
SELECT CustomerID, COUNT(OrderID) AS NumPedidos FROM Orders GROUP BY CustomerID

-- 4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.
SELECT CustomerID, YEAR(OrderDate) Anho, COUNT(OrderDate) AS NumPedido
FROM Orders 
GROUP BY CustomerID, YEAR(OrderDate)
ORDER BY CustomerID;

-- 5. ID del producto, precio unitario y total facturado de ese producto, 
-- ordenado por cantidad facturada de mayor a menor. 
-- Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
SELECT * FROM [Order Details]
SELECT ProductID, MAX(UnitPrice) AS Price, SUM((UnitPrice * Quantity)*(1-Discount)) AS TotalFacturado FROM [Order Details] 
GROUP BY ProductID 
ORDER BY TotalFacturado

-- 6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor
SELECT * FROM Suppliers

