-- 1. Nombre de los proveedores y número de productos que nos vende cada uno
SELECT * FROM Products
SELECT * FROM Suppliers

SELECT S.CompanyName AS Nombre, COUNT(P.SupplierId) AS cantidad
FROM Suppliers AS S
INNER JOIN Products AS P ON S.SupplierID = P.SupplierId
GROUP BY S.CompanyName, P.SupplierId

-- 2.Nombre completo y telefono de los vendedores que trabajen 
-- en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT * FROM Employees
SELECT * FROM Suppliers

SELECT (E.FirstName + ' ' + E.LastName) AS Name, E.City, E.HomePhone 
FROM Employees AS E
WHERE E.City IN ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond', 'Atalanta')
GROUP BY E.FirstName, E.LastName, E.City, E.HomePhone

-- 3. Número de productos de cada categoría y nombre de la categoría.
SELECT * FROM Products
SELECT * FROM Categories

SELECT C.CategoryName, COUNT(P.CategoryID) AS Cantidad
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName

-- 4. Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT * FROM Customers
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT CompanyName
FROM Customers
WHERE EXISTS (SELECT ProductId FROM Products WHERE ProductId = 14 OR ProductId = 11);

-- 5. Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Frankenversand (nombre de la compañía).
SELECT * FROM Employees
SELECT * FROM Suppliers
SELECT * FROM Shippers
SELECT * FROM Orders
SELECT * FROM [Order Details]

-- 6. 

