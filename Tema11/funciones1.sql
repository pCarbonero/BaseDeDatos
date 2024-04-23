--1. Pasar a Mayúsculas un nombre y apellido pasado por parámetro 
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

--2.Pasar el número del día (lunes 1, domingo 7) y devolver el texto Lunes, Martes...
CREATE FUNCTION ej02Dia
(@numDia int)
RETURNS varChar(15)
AS BEGIN 
declare @diaSemana varChar(15)

SET @diaSemana = datename(WEEKDAY, @numDia-1);
RETURN @diaSemana

END
SELECT dbo.ej02Dia(7)

--3. Crear una funcion a la que pasar dos números y realizar la suma
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

--4. Diseñe un programa que calcule la suma de las cifras de un número sin importar cuántas cifras tenga el número.
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

--5.Diseñe un programa que reciba un número natural y retorne la 
--suma de sus dígitos impares.
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

--6. Dado un número natural de cuatro cifras diseñe una función que permita obtener el revés del número. 
-- Así, si se lee el número 2385 el programa deberá imprimir 5832.
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

--7. Crear una función que invierta una palabra pasada por  parámetro
CREATE FUNCTION ej07
(@palabra varChar(50))
RETURNS varChar(50)
AS BEGIN
declare @inverse varChar(50);
SET @inverse = REVERSE(@palabra);
RETURN @inverse;
END
SELECT dbo.ej07('Zaratustra')