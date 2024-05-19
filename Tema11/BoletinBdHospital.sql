--1. Sacar todos los empleados que se dieron de alta entre una determinada fecha inicial 
-- y fecha final y que pertenecen a un determinado departamento.
CREATE PROCEDURE ej01
@departamento smallint,
@fechaInicial date,
@fechaFinal date
as Begin
Select Apellido FROM Emp
WHERE fecha_Alt > @fechaInicial AND fecha_Alt < @fechaFinal 
END

EXECUTE ej01 @departamento = 10,
@fechaInicial = '1981-12-23',
@fechaFinal = '1982-10-12'

--2. Crear procedimiento que inserte un empleado.
CREATE PROCEDURE ej02
@numEmp Int,
@apellido varChar(50),
@oficio varChar(50),
@dir Int,
@fechaAlt smallDateTime,
@salario numeric,
@comision numeric,
@deptNo Int
as Begin
Insert into Emp (Emp_No, Apellido, Oficio, dir, Fecha_Alt, Salario, Comision, Dept_No)
VALUES (@numEmp, @apellido, @oficio, @dir, @fechaAlt, @salario, @comision, @deptNo)
end

EXECUTE ej02 
@numEmp = 8774,
@apellido = 'DE NAZARET',
@oficio = 'DIRECTOR',
@dir = null,
@fechaAlt = '1983-02-01',
@salario = 300000,
@comision = 150000,
@deptNo = 20

select * from Emp

--3. Crear un procedimiento que recupere el nombre, 
-- número de departamento y número de personas a partir del número de departamento.
CREATE PROCEDURE ej03
@numD smallint
AS BEGIN 

SELECT D.Dept_No, D.DNombre, COUNT(E.Emp_No) AS NumeroEmpleados FROM Dept D
INNER JOIN Emp E ON D.Dept_No = E.Dept_No
WHERE D.Dept_No = @numD
GROUP BY D.Dept_No, D.DNombre

END

EXECUTE ej03
@numD = 20

--4. Crear un procedimiento igual que el anterior, 
-- pero que recupere también las personas que trabajan en dicho departamento, 
-- pasándole como parámetro el nombre.
CREATE PROCEDURE ej04
@dNom varChar(50)
AS BEGIN 

SELECT D.Dept_No, D.DNombre, COUNT(E.Emp_No) AS NumeroEmpleados FROM Dept D
INNER JOIN Emp E ON D.Dept_No = E.Dept_No
WHERE D.DNombre = @dNom
GROUP BY D.Dept_No, D.DNombre

SELECT E.Apellido FROM Emp E
INNER JOIN Dept D ON E.Dept_No = D.Dept_No
WHERE D.DNombre = @dNom

END

EXECUTE ej04
@dNom = 'INVESTIGACIÓN'

--5. Crear procedimiento para devolver salario, oficio y comisión, pasándole el apellido.
crEate proCEDURE ej05
@apellido varChar(50)
AS BEGIN
SELECT salario, oficio, comision FROM Emp 
WHERE Apellido = @apellido
END

EXECUTE ej05 
@apellido = 'DE NAZARET'

--6. Igual que el anterior, pero si no le pasamos ningún valor, mostrará los datos de todos los empleados.
CReATE proCEDURE ej06
@apellido varChar(50)
AS BEGIN
if @apellido IS NOT NULL 	
	SELECT salario, oficio, comision FROM Emp 
	WHERE Apellido = @apellido	
ELSE 
	SELECT salario, oficio, comision FROM Emp
END

execute ej06
@apellido = NULL

--7.  Crear un procedimiento para mostrar el salario, oficio, apellido y nombre del departamento 
-- de todos los empleados que contengan en su apellido el valor que le pasemos como parámetro.
CReATE PROCEDURE ej07
@valor varchar(10)
AS BEGIN
SELECT E.Salario, E.Oficio, E.Apellido, E.Apellido FROM Emp E
INNER JOIN Dept D ON E.Dept_No = D.Dept_No
WHERE E.Apellido LIKE '%' + @valor + '%'
END

EXECUTE ej07
@valor = 'DE'

--8.  Crear un procedimiento que recupere el número departamento, el nombre y número de empleados, 
-- dándole como valor el nombre del departamento, si el nombre introducido no es válido, 
-- mostraremos un mensaje informativo comunicándolo.
CREATE PROCEDURE ej08
@dNom varCHar(20)
AS BEGIN

if @dNom IS NOT NULL AND @dNom IN (SELECT DNombre FROM Dept)
	SELECT D.Dept_No, D.DNombre, COUNT(E.Emp_No) AS NumeroEmpleados FROM Dept D
	INNER JOIN Emp E ON D.Dept_No = E.Dept_No
	WHERE D.DNombre = @dNom
	GROUP BY D.Dept_No, D.DNombre
ELSE
	PRINT 'Nombre no válido'
END

EXECUTE ej08
@dNom = 'INVESTIGACIÓN'

--9. 
DROP PROCEDURE ej09
CREATE PROCEDURE ej09
@campo varChar(50)
AS BEGIN
if @campo in (SELECT Nombre FROM Hospital)
	BEGIN
	SELECT COUNT(P.Empleado_No) AS numEmpleados, AVG(Salario) as mediaSalario, SUM(Salario) as totalSalario, H.Nombre
	FROM Plantilla P
	INNER JOIN Hospital H On H.Hospital_Cod = P.Hospital_Cod where @campo = H.Nombre
	GROUP BY H.Nombre
	END
ELSE IF @campo in (SELECT Nombre FROM Sala)
	BEGIN
	SELECT COUNT(P.Empleado_No) AS numEmpleados, AVG(Salario) as mediaSalario, SUM(Salario) as totalSalario, S.Nombre
	FROM Plantilla P 
	INNER JOIN Sala S ON P.Sala_Cod = S.Sala_Cod
	GROUP BY S.Nombre
	END
ELSE IF @campo in (SELECT t FROM Plantilla)
	BEGIN
	SELECT COUNT(P.Empleado_No) AS numEmpleados, AVG(P.Salario) as mediaSalario, SUM(P.Salario) as totalSalario, P.T
	FROM Plantilla P
	GROUP BY P.T
	END
ELSE IF @campo in (SELECT funcion FROM Plantilla)
	BEGIN
	SELECT COUNT(P.Empleado_No) AS numEmpleados, AVG(P.Salario) as mediaSalario, SUM(P.Salario) as totalSalario, P.Funcion
	FROM Plantilla P WHERE @campo = P.Funcion
	GROUP BY P.Funcion
	END
ELSE 
	BEGIN 
	PRINT 'NO VALE'
	END
END
SELECT * FROM Plantilla
EXECUTE ej09 
@campo = 'ENFERMERO'

--10. Crear un procedimiento en el que pasaremos como parámetro el Apellido de un empleado.
-- El procedimiento devolverá los subordinados del empleado escrito, si el empleado no existe en la base de datos, 
-- informaremos de ello, si el empleado no tiene subordinados, lo informa remos con un mensaje y mostraremos su jefe.
-- Mostrar el número de empleado, Apellido, Oficio y Departamento de los subordinados.

CREATE OR ALTER PROCEDURE ej10
@apellido varchar(50)
AS BEGIN 
IF (((SELECT Emp_No FROM Emp WHERE Apellido = @apellido)) IS NOT NULL)
		BEGIN 
			if exists ((SELECT EMp_No, Apellido, OFicio, Dept_No FROM Emp
			WHERE dir = (SELECT Emp_No FROM Emp WHERE Apellido = @apellido)))
				BEGIN 
					(SELECT EMp_No, Apellido, OFicio, Dept_No FROM Emp
					WHERE dir = (SELECT Emp_No FROM Emp WHERE Apellido = @apellido))
				END
			ELSE
				BEGIN
					PRINT ('El nombre introducido no tiene subordinados')
					declare @jefe int = (SELECT dir FROM Emp WHERE Apellido = @apellido)
					SELECT EMp_no, Apellido FROM Emp WHERE EMp_no = @jefe
				END
		END
	ELSE 
		BEgin
			PRINT ('El nombre introducido no existe')
		END
END


EXECUTE ej10
@apellido = 'ASFADSFV'


--11) Crear procedimiento que borre un empleado que coincida con los parámetros indicados (los parámetros serán todos los campos de la tabla empleado).
SELECT * FROM Emp

CREATE OR ALTER PROCEDURE ej11
@empNo int, @apellido varChar(50), @oficio varChar(50), @dir int, @fechaAlta date, @salario money, @comision money, @deptNo int
AS BEGIN
	DELETE Emp
	WHERE Emp_No = @empNo AND Apellido = @apellido AND Oficio = @oficio AND	Dir = @dir AND Fecha_Alt = @fechaAlta AND Salario = @salario AND Comision = @comision AND Dept_No = @deptNo
END

--12 
SELECT * FROM Emp
create OR ALTER PROCEDURE ej12
@empNo int, @apellido varChar(50), @oficio varChar(50), @dir int, @fechaAlta date, @salario money, @comision money, @deptNo int
AS BEGIN
	IF EXISTS (SELECT * FROM Emp WHERE Emp_No = @empNo AND Apellido = @apellido AND Oficio = @oficio AND	Dir = @dir AND Fecha_Alt = @fechaAlta AND Salario = @salario AND Comision = @comision AND Dept_No = @deptNo)
		BEGIN
			BEGIN TRY
			print('TRY')
				DELETE Emp
				WHERE Emp_No = @empNo --AND Apellido = @apellido AND Oficio = @oficio AND	Dir = @dir AND Fecha_Alt = @fechaAlta AND Salario = @salario AND Comision = @comision AND Dept_No = @deptNo
				
				BEGIN 
					PRINT('DELETE HECHO BIEN')
				END
			END TRY
			BEGIN CATCH
				PRINT('ERROR')
				--PRINT('DATOS INTRODUCIDOS ' + @empNo + ' ' + @apellido + ' ' + @oficio + ' ' + @dir + ' ' + @fechaAlta 
				--+ ' ' + @salario + ' ' + @comision + ' ' + @deptNo)
			END CATCH
		END
END

BEGIN TRANSACTION EJ12
DELETE Emp
WHERE Emp_No = 7119


execute ej12
@empNo = 7119,
@apellido = 'SERRA', 
@oficio = 'DIRECTOR', 
@dir = 7782,
@fechaAlta = '1983-11-19 00:00:00', 
@salario = 225000.00, 
@comision = 39000.00, 
@deptNo = 20
ROLLBACK