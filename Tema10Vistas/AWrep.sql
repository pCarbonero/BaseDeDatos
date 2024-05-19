--1. Nombre y dirección completas de todos los clientes que tengan alguna sede en Canada.
select * from SalesLT.Customer
select * from SalesLT.CustomerAddress
select * from SalesLT.Address

CREATE VIEW ej01 AS
SELECT C.FirstName, C.LastName, A.AddressLine1 FROM SalesLT.Customer C
INNER JOIN SalesLT.CustomerAddress CA ON C.CustomerID = CA.CustomerID
inner JOIN SalesLT.Address A ON CA.AddressID = A.AddressID
WHERE A.CountryRegion = 'Canada'

SELECT * FROM ej01

--2. Nombre de cada categoría y producto más caro y más barato de la misma, incluyendo los precios.
SELECT * FROM SalesLT.Product
SELECT * FROM SalesLT.ProductCategory

CREATE VIEW ej02 AS
SELECT PC.ProductCategoryID, PC.Name, MAX(P.ListPrice) AS MasCaro, MIN(P.ListPrice) AS MasBarato FROM SalesLT.ProductCategory PC
INNER JOIN SalesLT.Product P ON PC.ProductCategoryID = P.ProductCategoryID
GROUP BY PC.ProductCategoryID, PC.Name

SELECT * FROM ej02

--4. Número de clientes que tenemos en cada país. Contaremos cada dirección como si fuera un cliente distinto.
SELECT * FROM SalesLT.CustomerAddress 
SELECT * FROM SalesLT.Address

CREATE OR ALTER VIEW ej04 AS
SELECT A.CountryRegion, COUNT(CA.AddressID) AS ClientesPoPais FROM SalesLT.Address as A
INNER JOIN SalesLT.CustomerAddress as CA
ON A.AddressID=CA.AddressID
GROUP BY A.CountryRegion

SELECT * FROM ej04

--5. Repite la consulta anterior pero contando cada cliente una sola vez. Si el cliente tiene varias direcciones, sólo consideraremos aquella en la que nos haya comprado la última vez.
SELECT * FROM SalesLT.SalesOrderHeader

CREATE OR ALTER VIEW ej05 AS
SELECT A.CountryRegion, COUNT(DISTINCT CA.AddressID) AS ClientesPoPais FROM SalesLT.Address as A
INNER JOIN SalesLT.CustomerAddress as CA
ON A.AddressID=CA.AddressID
GROUP BY A.CountryRegion


SELECT * FROM ej05

--7. Los tres países en los que más hemos vendido, incluyendo la cifra total de ventas y la fecha de la última venta.
SELECT * FROM SalesLT.Address
SELECT * FROM SalesLT.SalesOrderHeader


SELECT TOP 3 A.CountryRegion, COUNT(SOH.SalesOrderID) numeroVentas, MAX(SOH.OrderDate) AS FechaIltimaVenta FROM SalesLT.Address A
INNER JOIN SALESLT.SalesOrderHeader SOH ON A.AddressID = SOH.ShipToAddressID
GROUP BY A.CountryRegion

--9. Nombre de la categoría y número de clientes diferentes que han comprado productos de cada una.
SELECT * FROM SalesLT.SalesOrderDetail
SELECT * FROM SALESLT.Product
SELECT * FROM SALESLT.ProductCategory

SELECT PC.Name, COUNT(DISTINCT SOD.SalesOrderID) AS numeroVentas FROM SalesLT.SalesOrderDetail SOD
INNER JOIN SalesLT.Product P ON P.ProductID = SOD.ProductID
INNER JOIN SalesLT.ProductCategory PC ON PC.ProductCategoryID = P.ProductCategoryID
GROUP BY PC.Name

--10. Clientes que nunca han comprado ninguna bicicleta (discriminarlas por categorías)
SELECT * FROM SalesLT.Customer
SELECT * FROM SalesLT.SalesOrderHeader
SELECT * FROM SalesLT.SalesOrderDetail
SELECT * FROM SalesLT.CustomerAddress
SELECT * FROM SalesLT.ProductCategory

SELECT DISTINCT C.* FROM SalesLT.Customer C
INNER JOIN SalesLT.SalesOrderHeader SOH ON SOH.CustomerID = C.CustomerID
INNER JOIN SalesLT.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN SALESLT.Product P ON SOD.ProductID = P.ProductID
INNER JOIN SALESLT.ProductCategory PC ON P.ProductCategoryID = PC.ProductCategoryID
WHERE PC.Name NOT LIKE '[%Bikes%]'

--11. A la consulta anterior, añádele el total de compras (en dinero) efectuadas por cada cliente.
SELECT DISTINCT C.*, SOH.TotalDue FROM SalesLT.Customer C
INNER JOIN SalesLT.SalesOrderHeader SOH ON SOH.CustomerID = C.CustomerID
INNER JOIN SalesLT.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN SALESLT.Product P ON SOD.ProductID = P.ProductID
INNER JOIN SALESLT.ProductCategory PC ON P.ProductCategoryID = PC.ProductCategoryID
WHERE PC.Name NOT LIKE '[%Bikes%]'

