--1. Nombre y dirección completas de todos los clientes que tengan alguna sede en Canada.
SELECT * FROM SalesLT.Customer
SELECT * FROM SalesLT.CustomerAddress
SELECT * FROM SalesLT.Address

SELECT (C.FirstName + ' ' + ISNULL(C.MiddleName, '') + C.LastName) AS Name, (A.AddressLine1 + ' | ' + A.City + ' | ' + A.CountryRegion) AS Address
FROM SalesLT.Customer C
INNER JOIN SalesLT.CustomerAddress CA ON C.CustomerID = CA.CustomerID
INNER JOIN SalesLT.Address A ON CA.AddressID = A.AddressID WHERE A.CountryRegion = 'Canada'

--2. Nombre de cada categoría y producto más caro y más barato de la misma, incluyendo los precios.
SELECT * FROM SalesLT.ProductCategory
SELECT Name, MAX(ListPrice) FROM SalesLT.Product GROUP BY Name

SELECT PA.Name, MAX(P.ListPrice) AS MaxPrice, MIN(P.ListPrice) AS MinPrice
FROM SalesLT.ProductCategory PA
INNER JOIN SalesLT.Product P ON PA.ProductCategoryID = P.ProductCategoryID
GROUP BY PA.Name

