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
-- n�mero de departamento y n�mero de personas a partir del n�mero de departamento.
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
-- pero que recupere tambi�n las personas que trabajan en dicho departamento, 
-- pas�ndole como par�metro el nombre.
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
@dNom = 'INVESTIGACI�N'

--5. Crear procedimiento para devolver salario, oficio y comisi�n, pas�ndole el apellido.
crEate proCEDURE ej05
@apellido varChar(50)
AS BEGIN
SELECT salario, oficio, comision FROM Emp 
WHERE Apellido = @apellido
END

EXECUTE ej05 
@apellido = 'DE NAZARET'

--6. Igual que el anterior, pero si no le pasamos ning�n valor, mostrar� los datos de todos los empleados.
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
-- de todos los empleados que contengan en su apellido el valor que le pasemos como par�metro.
CReATE PROCEDURE ej07
@valor varchar(10)
AS BEGIN
SELECT E.Salario, E.Oficio, E.Apellido, E.Apellido FROM Emp E
INNER JOIN Dept D ON E.Dept_No = D.Dept_No
WHERE E.Apellido LIKE '%' + @valor + '%'
END

EXECUTE ej07
@valor = 'DE'

--8.  

