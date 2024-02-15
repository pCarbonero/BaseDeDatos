-- 1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
SELECT * FROM Customers
SELECT Country, COUNT(Country) AS NumClientes
FROM Customers
GROUP BY Country ORDER BY Country;

-- 2. ID de producto y número de unidades vendidas de cada producto (El número de unidades las obtenemos del campo
-- Quantity de Order Detail.
SELECT * FROM [Order Details]
SELECT ProductID, SUM(Quantity) AS UdsVendidas FROM [Order Details] GROUP BY ProductID ORDER BY ProductID

-- 3. ID del cliente y número de pedidos que nos ha hecho.
SELECT * FROM Orders
SELECT CustomerID, COUNT(OrderID) AS NumPedidos FROM Orders GROUP BY CustomerID

-- 4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
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

