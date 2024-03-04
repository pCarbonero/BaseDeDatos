-- UPDATE AND DELETE MULTITABLA --

--1. Añadir una nueva oficina para la ciudad de Madrid, con el número de oficina 30, con un objetivo
--   de 10.000 euros y región ‘Centro’. Suponer que conocemos el orden de los campos en la tabla.
SELECT * FROM Oficinas
INSERT INTO Oficinas (oficina, ciudad, region, objetivo) 
VALUES (30, 'Madrid', 'centro', 10000);

--2. Igual que el ejercicio anterior suponiendo que no sabemos cual es el orden de los campos en la
--	 tabla Oficina.
INSERT INTO Oficinas (region, ciudad, oficina, objetivo) 
VALUES ('sur', 'Málaga', 99, 20000);

--3. Insertar tus datos como nuevo empleado. Utilizar como numemp los tres últimos dígitos del dni, la
-- oficina 23, el puesto “Programador”, sin jefe, con una cuota de 1000 y las ventas a 0. En el contrato
-- la fecha de hoy.
SELECT * FROM Empleados
INSERT INTO Empleados (numemp, nombre, edad, oficina, puesto, cuota, ventas, contrato)
VALUES (038, 'Pablo Carbonero', 21, 23, 'Programador', 1000, 0, GETDATE());

--4. Insertar un nuevo cliente con tu nombre y utilizar como numclie 999. Dejar el resto de campos a
-- su valor por defecto.
SELECT * FROM Clientes
INSERT INTO CLIENTES (numclie, nombre, resp, limitecredito)
VALUES(999, 'Tanosus McFlurry', default, default);

--5. Insertar los empleados que no tienen jefes como clientes. Como número de clientes utilizaremos
-- el mismo número de empleado, ellos mismo serán sus propios responsable y el límite de crédito
-- será 0.
SELECT * FROM Empleados
SELECT * FROM Clientes
INSERT INTO CLIENTES (numclie, nombre, resp, limitecredito) 
SELECT E.numemp, E.nombre, E.numemp, 0
FROM Empleados AS E WHERE EXISTS (SELECT E.numemp, E.nombre FROM Empleados WHERE jefe IS NULL);

--7. Subir un 5% el precio de todos los productos del fabricante ‘ACI’.
SELECT * FROM Productos
UPDATE Productos
SET precio = precio+(precio*0.05)
WHERE idfab LIKE 'aci%'

--8. Incrementar en uno la edad de los empleados.
SELECT * FROM Empleados
UPDATE Empleados
Set edad = edad+1

--9. Cambiar los empleados de la oficina 21 a la oficina 30.
SELECT * FROM Empleados
UPDATE Empleados
Set oficina = 30
WHERE oficina = 21

--10. De los empleados que trabajan en Cádiz, disminuir su cuota en un 10%.
SELECT * FROM Empleados
SELECT * FROM Oficinas

UPDATE EMPLEADOS
SET cuota = cuota-(cuota*0.1)
WHERE EXISTS(SELECT oficina
FROM Oficinas AS O WHERE O.oficina = EMPLEADOS.oficina AND O.ciudad = 'Cádiz')

--11. 
