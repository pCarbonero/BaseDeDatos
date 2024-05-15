--5. Para la base de datos Empresa crear un disparador que cada vez que se inserta un empleado sustituya su nombre por �Pepe�.
Select * FROM Empleados

DISABLE TRIGGER nomprePepe ON Empleados

CREATE OR ALTER TRIGGER nomprePepe ON Empleados
AFTER INSERT 
AS BEGIN
SET NOCOUNT	 ON
Update Empleados
SET nombre = 'Pepe'
Where numemp = (SELECT numemp FROM inserted)
END
ROLLBACK

INSERT INTO Empleados (numemp, nombre, edad, oficina, puesto, contrato, jefe, cuota, ventas) 
VALUES (999, 'Lucas Ocampos', 27, 5, 'Representante', '2006-10-20', 104, 350000, 3050)


--6. Escribir un disparador, que cada vez que se modifique un empleado, a�ada �Don� al principio de su nombre.
Disable TRIGGER donEmpledo ON Empleados

CREATE OR ALTER TRIGGER donEmpledo ON Empleados
AFTER UPDATE
AS BEGIN
UPDATE Empleados
SET nombre = CONCAT('Don ', nombre)
WHERE numemp = (SELECT numemp FROM inserted)
END

UPDATE Empleados
SET nombre = 'Marcos Acu�a' 
WHERE numemp = 999

--7. Realizar una versi�n mejorada del ejercicio anterior donde se compruebe que se desea modificar el campo nombre.
Select * FROM Empleados
DISBLE TRIGGER donEmpledo ON Empleados
CREATE OR ALTER TRIGGER donEmpledo ON Empleados
AFTER UPDATE
AS BEGIN
if UPDATE (nombre)
begin
UPDATE Empleados
SET nombre = CONCAT('Don ', nombre)
WHERE numemp = (SELECT numemp FROM inserted)
end
END

UPDATE Empleados
SET nombre = 'Lucas Ocampos' 
WHERE numemp = 990

UPDATE Empleados
SET numemp = 990
WHERE numemp = 998

--8. En Empresa, dise�ar un disparador que compruebe cada vez que insertamos un empleado que su
-- edad est� comprendida entre 16 �edad m�nima para trabajar� y 67 �edad de jubilaci�n�.	
Select * FROM Empleados

DISABLE TRIGGER edadEmpleados ON Empleados
CReATE OR ALTER TRIGGER edadEmpleados ON Empleados
AFTER INSERT
AS BeGIN
IF ((SELECT edad FROM inserted) NOT BETWEEN 16 AND 67)
BEGIN
	ROLLbACK
END
END

INSERT INTO Empleados (numemp, nombre, edad, oficina, puesto, contrato, jefe, cuota, ventas) 
VALUES (333, 'Oliver Sykes', 37, 5, 'Representante', '2006-10-20', 104, 350000, 3050)

INSERT INTO Empleados (numemp, nombre, edad, oficina, puesto, contrato, jefe, cuota, ventas) 
VALUES (444, 'Ni�o plastilina', 8, 5, 'Representante', '2006-10-20', 104, 350000, 3050)

INSERT INTO Empleados (numemp, nombre, edad, oficina, puesto, contrato, jefe, cuota, ventas) 
VALUES (444, 'Ana pellejona', 70, 5, 'Representante', '2006-10-20', 104, 350000, 3050)

--9. Escribir un disparador para la BD Empresa que supervise los traslados de los empleados. �stos
-- pueden moverse a otra oficina, pero el traslado ha de cumplir que sea a una oficina dentro de la
-- misma regi�n a la que est�n asignados. Es decir, si un empleado trabaja en una oficina del �Este�
-- podr� trasladarse a cualquier otra oficina, pero siempre dentro de la regi�n �Este�.
SELECT * FROM Empleados
SELECT * FROM Oficinas

CREATE OR alTER TRIGGER regionOficina ON Empleados
AFTER UPDATE
AS BEGIN
if ((SELECT o.region FROM inserted i INNER JOIN Oficinas O on O.oficina = i.oficina) != 
(SELECT o.region FROM deleted d INNER JOIN Oficinas O on O.oficina = d.oficina))
BEGIN
	rollback
END
end

UPDATE Empleados
SET oficina = 22
Where nombre = 'Luis Le�n'

--10. Crear un trigger para gestionar una copia de seguridad de todos los clientes: actuales y eliminados.
-- Para cada uno especificaremos el nombre, el l�mite de cr�dito y la fecha de alta. Para almacenar
-- estos datos dispondremos de la tabla �backupClientes�. Crear tambi�n un procedimiento almacenado 
-- que cree la nueva tabla y haga una copia de los clientes actuales

SELECT * FROM Clientes
SELECT * FROM backupClientes where nombreB = 'Alberto Andorrano'

CREATE or ALTER PROCEDURE tablaBackUp
AS BEGIN
CREATE TABLE backupClientes(
	nombreB varChar(100) Primary Key,
	limCreditoB int,
	altaB date
)

INSERT INTO backupClientes (nombreB, limCreditoB, altaB)
SELECT nombre, limitecredito, '15-05-2024' FROM Clientes
END

execute tablaBackUp

--DISABLE TRIGGER updateBackup ON Clientes
CREATE OR ALTER TRIGGER updateBackup ON Clientes
AFTER UPDATE
AS BEGIN

if UPDATE (nombre)
	BEGIN
		UPDATE backupClientes
		set nombreB = (select nombre from inserted)
		where nombreB = (select nombre from deleted)
		
	END
else if UPDATE (limiteCredito)
	BEGIN
		UPDATE backupClientes
		set limCreditoB = (select limitecredito from inserted)
		where limCreditoB = (select limitecredito from deleted)
	END
END


BEGIN TRANSACTION tranUpdatebu
UPDATE Clientes
SET nombre = 'Alberto Andorrano'
WHERE numclie = 2109
ROLLBACK

-- DISABLE TRIGGER insertBackup ON Clientes
CREATE OR ALTER TRIGGER insertBackup ON Clientes
AFTER Insert
AS BEGIN

INSERT INTO backupClientes
SELECT nombre, limiteCredito, FORMAT(GETDATE(), 'dd-MM-yyyy') FROM Inserted

END
	
begin transaction tranInsertbu
INSERT INTO Clientes (numclie, nombre, resp, limitecredito)
VALUES (2222, 'Chester Bennington', 101, 6500)
ROLLBACK

select * from backupClientes
select * from Clientes


--12. Comprobar en cada inserci�n de empleado que el n�mero de oficina asignado existe. En caso
-- contrario asignaremos al empleado a la primera oficina que est� disponible.
SELECT * FROM Oficinas
SELECT * FROM Empleados

-- DISABLE TRIGGER oficinasdEj12 ON Empleados
CREATE OR ALTER TRIGGER oficinasdEj12 ON Empleados
AFTER INSERT
AS BEGIN
	
	if((SELECT oficina from inserted) IS NULL)
		BEGIN
			UPDATE Empleados
			set oficina = (SELECT MIN(oficina) FROM Oficinas)
			where numemp = (SELECT numemp FROM inserted)
		END
END

BEGIN TRANSACTION empleadoNoOfi
INSERT INTO Empleados (numemp, nombre, edad, puesto, contrato, jefe, cuota, ventas) 
VALUES (333, 'Oliver Sykes', 37, 'Representante', '2006-10-20', 104, 350000, 3050)
ROLLBACK


--13. Realizar un disparador que controle la inserci�n de un nuevo empleado. En el caso que carezca de
-- jefe, su cuota, ignorando la asignada, debe ser la media de las cuotas del resto de empleados.
SELECT * FROM Empleados
SELECT AVG(cuota) media FROM Empleados  where numemp != 102

-- DISABLE TRIGGER cuotaEmpleadoNoJefeEj13 ON Empleados
CREATE OR ALTER TRIGGER cuotaEmpleadoNoJefeEj13 ON Empleados
AFTER INSERT
AS BEGIN
SET NOCOUNT	 ON
	if ((SELECT jefe FROM inserted) IS NULL)
		BEGIN
		UPDATE Empleados 
		SET cuota = (SELECT AVG(cuota) media FROM Empleados WHERE numemp NOT IN (SELECT numemp FROM inserted))
		WHERE numemp = (SELECT numemp FROM inserted) 
		END
END

BEGIN TRANSACTION empleadoNoJEfe
INSERT INTO Empleados (numemp, nombre, edad, puesto, contrato, cuota, ventas) 
VALUES (333, 'Oliver Sykes', 37, 'Representante', '2006-10-20', 350000, 3050)
ROLLBACK

--14. A�adir a la base de datos la tabla �productosFabricante� con los campos idfab y cantidad. En dicha
-- tabla llevaremos un control del n�mero de productos de los que disponemos para cada fabricante; 
-- indistintamente de la cantidad de cada producto. Crear los trigger necesarios para mantener actualizada esta informaci�n.
SELECT idfab, SUM(existencias) aS total FROM Productos group by idfab
SELECT * FROM Productos

CREATE or ALTER PROCEDURE productosFabricante
AS BEGIN
CREATE TABLE backupClientes(
	nombreB varChar(100) Primary Key,
	limCreditoB int,
	altaB date
)

INSERT INTO backupClientes (nombreB, limCreditoB, altaB)
SELECT nombre, limitecredito, '15-05-2024' FROM Clientes
END

execute tablaBackUp