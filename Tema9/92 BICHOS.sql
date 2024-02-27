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