-- 1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
SELECT * FROM Customers
SELECT Country, COUNT(Country) AS NumClientes
FROM Customers
GROUP BY Country ORDER BY Country;

-- 2. ID de producto y número de unidades vendidas de cada producto.  Añade el nombre del producto

SELECT * FROM [Order Details]

SELECT od.ProductID, SUM(od.Quantity) AS Cantidad, Products.ProductName
FROM [Order Details] od
INNER JOIN 
Products ON od.ProductID = Products.ProductID
GROUP BY od.ProductID, Products.ProductName;

-- 3. ID del cliente y número de pedidos que nos ha hecho. Añade nombre (CompanyName) y ciudad del cliente
SELECT * FROM Orders

SELECT o.CustomerID, COUNT(o.CustomerID) AS NumPedidos, Customers.CompanyName, Customers.City
FROM Orders AS o 
INNER JOIN 
Customers ON o.CustomerID = Customers.CustomerID
GROUP BY o.CustomerID, Customers.CompanyName, Customers.City

-- 4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
-- Añade nombre (CompanyName) y ciudad del cliente, así como la fecha del primer pedido que nos hizo.
SELECT O.CustomerID, YEAR(O.OrderDate) Anho, COUNT(O.OrderDate) AS NumPedido, Customers.CompanyName, Customers.City, MIN(Year(O.OrderDate)) AS PrimeraCompra
FROM Orders AS O
INNER JOIN
Customers ON O.CustomerID = Customers.CustomerID
GROUP BY O.CustomerID, YEAR(O.OrderDate), Customers.CompanyName, Customers.City

ORDER BY CustomerID;

-- 5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. 
-- Si hay varios precios unitarios para el mismo producto tomaremos el mayor. Añade el nombre del producto
SELECT * FROM [Order Details]

SELECT OD.ProductID, MAX(OD.UnitPrice) AS Price, SUM((OD.UnitPrice * OD.Quantity)*(1-OD.Discount)) AS TotalFacturado, Products.ProductName
FROM [Order Details] AS OD
INNER JOIN Products ON OD.ProductID = Products.ProductID
GROUP BY OD.ProductID, Products.ProductName
ORDER BY TotalFacturado

-- 6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor. 
-- Añade el nombre del proveedor.
SELECT P.SupplierID, SUM(P.UnitsInStock * P.UnitPrice) AS Total, Suppliers.CompanyName
    FROM Products AS P
	INNER JOIN Suppliers ON P.SupplierID = Suppliers.SupplierID
    Group by P.SupplierID, Suppliers.CompanyName

-- 9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor. 
-- Añade el nombre del distribuidor
SELECT O.CustomerID, COUNT(O.OrderID) AS 'OrdersPerCostumers', Shippers.CompanyName
FROM Orders AS O
INNER JOIN Shippers ON O.ShipVia = Shippers.ShipperID
GROUP BY O.CustomerID, Shippers.CompanyName

-- 10. ID de cada proveedor y número de productos distintos que nos suministra. 
-- Añade el nombre del proveedor.
SELECT P.SupplierID, COUNT(P.QuantityPerUnit) AS 'ProductSupplies', Suppliers.CompanyName
FROM Products AS P
INNER JOIN Suppliers ON P.SupplierID = Suppliers.SupplierID
GROUP BY P.SupplierID, Suppliers.CompanyName