--1. Nombre y direcci�n completas de todos los clientes que tengan alguna sede en Canada.
SELECT * FROM SalesLT.Customer
SELECT * FROM SalesLT.CustomerAddress
SELECT * FROM SalesLT.Address

SELECT (C.FirstName + ' ' + ISNULL(C.MiddleName, '') + C.LastName) AS Name, (A.AddressLine1 + ' | ' + A.City + ' | ' + A.CountryRegion) AS Address
FROM SalesLT.Customer C
INNER JOIN SalesLT.CustomerAddress CA ON C.CustomerID = CA.CustomerID
INNER JOIN SalesLT.Address A ON CA.AddressID = A.AddressID WHERE A.CountryRegion = 'Canada'

--2. Nombre de cada categor�a y producto m�s caro y m�s barato de la misma, incluyendo los precios.
SELECT * FROM SalesLT.ProductCategory
SELECT Name, MAX(ListPrice) FROM SalesLT.Product GROUP BY Name

SELECT PA.Name, P.Name, MIN(P.ListPrice) AS MinPrice
FROM SalesLT.ProductCategory PA
INNER JOIN SalesLT.Product P ON PA.ProductCategoryID = P.ProductCategoryID
Group By PA.Name, P.Name, P.ListPrice
ORDER BY PA.Name, P.ListPrice

SELECT PA.Name, P.Name, MAX(P.ListPrice) AS MAXPrice
FROM SalesLT.ProductCategory PA
INNER JOIN SalesLT.Product P ON PA.ProductCategoryID = P.ProductCategoryID
Group By PA.Name, P.Name, P.ListPrice
ORDER BY PA.Name, P.ListPrice

-------------------------------------------------------------------------------------------
SELECT PA.Name, P.Name, MIN(P.ListPrice) AS MinPrice
FROM SalesLT.ProductCategory PA
INNER JOIN SalesLT.Product P ON PA.ProductCategoryID = P.ProductCategoryID
WHERE P.Name IN
	(SELECT top 1 SalesLT.Product.Name
	FROM SalesLT.Product WHERE PA.ProductCategoryID = SalesLT.Product.ProductCategoryID
	order by SalesLT.Product.ListPrice)
GROUP BY PA.Name, P.Name, P.ListPrice


SELECT PA.Name, P.Name, Max(P.ListPrice) AS MaxPrice
FROM SalesLT.ProductCategory PA
INNER JOIN SalesLT.Product P ON PA.ProductCategoryID = P.ProductCategoryID
WHERE P.Name IN
	(SELECT top 1 SalesLT.Product.Name
	FROM SalesLT.Product WHERE PA.ProductCategoryID = SalesLT.Product.ProductCategoryID
	order by SalesLT.Product.ListPrice desc)
GROUP BY PA.Name, P.Name, P.ListPrice
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------



--4.N�mero de clientes que tenemos en cada pa�s. Contaremos cada direcci�n como si fuera un cliente distinto.
CREATE VIEW ClientesPoPais AS
SELECT A.CountryRegion, COUNT(CA.AddressID) AS ClientesPoPais FROM SalesLT.Address as A
INNER JOIN SalesLT.CustomerAddress as CA
ON A.AddressID=CA.AddressID
GROUP BY A.CountryRegion

--5.Repite la consulta anterior pero contando cada cliente una sola vez. Si el cliente tiene varias direcciones, 
--  s�lo consideraremos aquella en la que nos haya comprado la �ltima vez.
SELECT A.CountryRegion, COUNT(DISTINCT CA.CustomerID) AS [Clientes por pa�s] FROM SalesLT.Address as A
INNER JOIN SalesLT.CustomerAddress as CA
ON A.AddressID=CA.AddressID
GROUP BY A.CountryRegion
