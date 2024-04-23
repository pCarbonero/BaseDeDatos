--1. Pasar a May�sculas un nombre y apellido pasado por par�metro 
SELECT * FROM estudian
CREATE FUNCTION FNnombreMayus 
(@mayus varchar(50))
RETURNS varChar(50)
AS BEGIN
declare @nombreCompleto varChar(50);
SET @nombreCompleto = UPPER(@mayus);
return @nombreCompleto
END

SELECT dbo.FNnombreMayus(Enombre) FROM estudian
WHERE Enombre = 'Pedro Sauza';

--2.Pasar el n�mero del d�a (lunes 1, domingo 7) y devolver el texto Lunes, Martes...
CREATE FUNCTION ej02Dia
(@numDia int)
RETURNS varChar(15)
AS BEGIN 
declare @diaSemana varChar(15)

SET @diaSemana = datename(WEEKDAY, @numDia-1);
RETURN @diaSemana

END
SELECT dbo.ej02Dia(7)

--3. Crear una funcion a la que pasar dos n�meros y realizar la suma
CREATE FUNCTION ej03Suma
(@num1 int,
@num2 int)
RETURNS int
AS BEGIN 
declare @suma int
SET @suma = @num1 + @num2;
RETURN @suma
END
SELECT dbo.ej03Suma(3,9)

--4. Dise�e un programa que calcule la suma de las cifras de un n�mero sin importar cu�ntas cifras tenga el n�mero.
CREATE FUNCTION ej04SumaCifras
(@num int)
RETURNS int
AS BEGIN
declare @aux int
SET @aux = @num;
declare @res int;
SET @res = 0;

while @aux > 10
BEGIN 
	SET @res += @aux%10;
	SET @aux = @aux/10;
END
set @res += @aux;
RETURN @res 
END

SELECT dbo.ej04SumaCifras(123456)

--5.Dise�e un programa que reciba un n�mero natural y retorne la 
--suma de sus d�gitos impares.
CREATE FUNCTION ej05SumaImpares
(@num int)
RETURNS int
AS BEGIN
declare @aux int
SET @aux = @num;
declare @res int;
SET @res = 0;

while @aux > 0
BEGIN 
if (@aux%10)%2 != 0
BEGIN
	SET @res += @aux%10;
END
	SET @aux = @aux/10;
END
RETURN @res 
END

SELECT dbo.ej05SumaImpares(21334)

--6. Dado un n�mero natural de cuatro cifras dise�e una funci�n que permita obtener el rev�s del n�mero. 
-- As�, si se lee el n�mero 2385 el programa deber� imprimir 5832.
DROP FUNCTION ej06reves
CREATE FUNCTION ej06reves
(@num int)
RETURNS char(4)
AS BEGIN
declare @reves char(4) = '';
SET @reves = CAST(@num AS char);
SET @reves = REVERSE(@reves)
RETURN @reves
END
SELECT dbo.ej06reves(1234)

--7. Crear una funci�n que invierta una palabra pasada por  par�metro
CREATE FUNCTION ej07
(@palabra varChar(50))
RETURNS varChar(50)
AS BEGIN
declare @inverse varChar(50);
SET @inverse = REVERSE(@palabra);
RETURN @inverse;
END
SELECT dbo.ej07('Zaratustra')