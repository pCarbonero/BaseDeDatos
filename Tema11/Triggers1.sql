--5. Para la base de datos Empresa crear un disparador que cada vez que se inserta un empleado sustituya su nombre por “Pepe”.
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


--6. Escribir un disparador, que cada vez que se modifique un empleado, añada “Don” al principio de su nombre.
Disable TRIGGER donEmpledo ON Empleados

CREATE OR ALTER TRIGGER donEmpledo ON Empleados
AFTER UPDATE
AS BEGIN
UPDATE Empleados
SET nombre = CONCAT('Don ', nombre)
WHERE numemp = (SELECT numemp FROM inserted)
END

UPDATE Empleados
SET nombre = 'Marcos Acuña' 
WHERE numemp = 999

--7. Realizar una versión mejorada del ejercicio anterior donde se compruebe que se desea modificar el campo nombre.
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

--8. En Empresa, diseñar un disparador que compruebe cada vez que insertamos un empleado que su
-- edad esté comprendida entre 16 –edad mínima para trabajar– y 67 –edad de jubilación–.	
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
VALUES (444, 'Niño plastilina', 8, 5, 'Representante', '2006-10-20', 104, 350000, 3050)

INSERT INTO Empleados (numemp, nombre, edad, oficina, puesto, contrato, jefe, cuota, ventas) 
VALUES (444, 'Ana pellejona', 70, 5, 'Representante', '2006-10-20', 104, 350000, 3050)

--9. Escribir un disparador para la BD Empresa que supervise los traslados de los empleados. Éstos
-- pueden moverse a otra oficina, pero el traslado ha de cumplir que sea a una oficina dentro de la
-- misma región a la que están asignados. Es decir, si un empleado trabaja en una oficina del ‘Este’
-- podrá trasladarse a cualquier otra oficina, pero siempre dentro de la región ‘Este’.
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
Where nombre = 'Luis León'

--10. Crear un trigger para gestionar una copia de seguridad de todos los clientes: actuales y eliminados.
-- Para cada uno especificaremos el nombre, el límite de crédito y la fecha de alta. Para almacenar
-- estos datos dispondremos de la tabla «backupClientes». Crear también un procedimiento almacenado 
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
COMMIT TRANSACTION tranUpdatebu
	
select * from backupClientes where nombreB='Alberto Andorrano'
select * from Clientes