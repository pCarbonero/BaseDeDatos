--1. Nombre de la mascota, raza, especie y fecha de nacimiento de aquellos que hayan sufrido leucemia, moquillo o toxoplasmosis
select * from BI_Mascotas
select * from BI_Mascotas_Enfermedades
select * from BI_Enfermedades

SELECT M.Alias, M.Raza, M.Especie, M.FechaNacimiento
FROM BI_Mascotas AS M 
INNER JOIN BI_Mascotas_Enfermedades AS MF ON M.Codigo = MF.Mascota
INNER JOIN BI_Enfermedades AS E ON MF.IDEnfermedad = E.ID
WHERE E.Nombre IN ('Leucemia', 'Moquillo', 'Toxoplasmosis');

--2. Nombre, raza y especie de las mascotas que hayan ido a alguna visita en primavera (del 20 de marzo al 20 de Junio)
select * from BI_Mascotas
SELECT * FROM BI_Visitas

SELECT M.Alias AS Name, M.Raza, M.Especie, M.FechaNacimiento
FROM BI_Mascotas AS M 
INNER JOIN BI_Visitas AS V ON M.Codigo = V.Mascota
WHERE MONTH(V.Fecha) = 3 AND DAY(V.Fecha) >= 20
OR MONTH(V.Fecha) = 4 OR MONTH(V.Fecha) = 5
OR MONTH(V.Fecha) = 6 AND DAY(V.Fecha) <= 20

--3. Nombre y teléfono de los propietarios de mascotas que hayan sufrido rabia, sarna, artritis o filariosis y hayan tardado más de 10 días en curarse. 
-- Los que no tienen fecha de curación, considera la fecha actual para calcular la duración del tratamiento.
SELECT * FROM BI_Clientes
select * from BI_Mascotas
select * from BI_Mascotas_Enfermedades
select * from BI_Enfermedades

SELECT C.Nombre, C.Telefono
FROM BI_Clientes AS C
INNER JOIN BI_Mascotas AS M ON C.Codigo = M.CodigoPropietario
INNER JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
INNER JOIN BI_Enfermedades AS E ON ME.IDEnfermedad = E.ID
WHERE E.Nombre IN ('Rabia', 'Sarna', 'Artritis', 'Filariosis') 
AND	DATEDIFF(DAY, ME.FechaInicio, ISNULL(Me.fechaCura,GETDATE()))>10

--4. Nombre y especie de las mascotas que hayan ido alguna vez a consulta mientras estaban enfermas. 
--Incluye el nombre de la enfermedad que sufrían y la fecha de la visita.
select * from BI_Mascotas
select * from BI_Mascotas_Enfermedades
select * from BI_Enfermedades
SELECT * FROM BI_Visitas

SELECT M.Alias AS Nombre, M.Especie, E.Nombre AS NombreEnfermedad, V.Fecha AS FechaVisita 
FROM BI_Mascotas AS M
JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
JOIN BI_Enfermedades AS E ON ME.IDEnfermedad = E.ID
JOIN BI_Visitas AS V ON ME.Mascota = V.Mascota
WHERE V.Fecha BETWEEN ME.FechaInicio AND ME.FechaCura

--5. Nombre, dirección y teléfono de los clientes que tengan mascotas de al menos dos especies diferentes
SELECT * FROM BI_Clientes
select * from BI_Mascotas

SELECT C.Nombre AS NombreCliente, C.Direccion, C.Telefono
FROM BI_Clientes C
JOIN BI_Mascotas M ON C.Codigo = M.CodigoPropietario
GROUP BY C.Codigo, C.Nombre, C.Direccion, C.Telefono
HAVING COUNT(DISTINCT M.Especie) >= 2

--6. Nombre, teléfono y número de mascotas de cada especie que tiene cada cliente. Mostrar también la especie de la mascota
SELECT * FROM BI_Clientes
select * from BI_Mascotas

SELECT C.Nombre AS NombreCliente, C.Telefono, COUNT(M.Codigo) AS NumeroMascotas, M.Especie
FROM BI_Clientes C
JOIN BI_Mascotas M ON C.Codigo = M.CodigoPropietario
GROUP BY C.Codigo, C.Nombre, C.Telefono, M.Especie
ORDER BY C.Nombre, M.Especie

--7. Nombre, especie y nombre del propietario de aquellas mascotas que hayan sufrido una enfermedad de tipo infeccioso (IN) o genético (GE) más de una vez.
SELECT * FROM BI_Clientes
select * from BI_Mascotas
select * from BI_Mascotas_Enfermedades
select * from BI_Enfermedades

SELECT C.Nombre, C.Telefono, M.Especie
FROM BI_Clientes AS C
JOIN BI_Mascotas AS M ON C.Codigo = M.CodigoPropietario
JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
JOIN BI_Enfermedades AS E ON ME.IDEnfermedad = E.ID
GROUP BY C.Nombre, C.Telefono, M.Especie
HAVING COUNT(E.Tipo) > 1