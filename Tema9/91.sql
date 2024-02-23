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
SELECT * FROM Customers
SELECT * FROM Orders

SELECT 
E.EmployeeID, (E.FirstName + ' ' + E.LastName) AS Name, E.HomePhone, C.CompanyName
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
WHERE C.CompanyName IN ('Bon app''', 'Frankenversand');


-- 6. Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Portugal. 

SELECT 
E.EmployeeID, (E.FirstName + ' ' + E.LastName) AS Name, BirthDate AS Cumple
FROM Employees AS E WHERE EXISTS (SELECT Country FROM Customers WHERE Country NOT IN ('Portugal'));


-- 7.Total de ventas en US$ de productos de cada categoría (nombre de la categoría).
SELECT SUM(P.UnitPrice) AS Price, C.CategoryName
FROM Products AS P
INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
GROUP BY P.UnitPrice, C.CategoryName

--9. Ventas de cada producto en el año 97. Nombre del producto y unidades.
SELECT * FROM [Product Sales for 1997]
SELECT * FROM Products

SELECT ProductId, ProductName
FROM Products WHERE EXISTS (SELECT ProductName FROM [Product Sales for 1997]);

-- 11. Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.
SELECT * FROM Employees

SELECT (FirstName + ' ' + LastName) AS Nombre 
FROM Employees WHERE ReportsTo = 2

-- 12. Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
SELECT (FirstName + ' ' + LastName) AS Nombre, COUNT(ReportsTo) AS Subordiados 
FROM Employees 
GROUP BY FirstName, LastName