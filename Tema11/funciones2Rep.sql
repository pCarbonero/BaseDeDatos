--2. C�LCULO DE FIBONACCI. A partir de un n�mero obtener la sucesi�n de Fibonacci hasta ese n�mero (en la sucesi�n de Fibonacci,
-- el siguiente n�mero es la suma de los dos anteriores): En la sucesi�n de fibonacci los dos primeros n�meros son 1 y luego la suma de los dos anteriores. 1, 1, 2, 3, 5, 8, 13, 21....

CREATE OR ALTER FUNCTION fnFibonnacci (@numero int)
returns varChar(MAX)
as begin

	declare @primero int = 1;
	declare @ultimo int = 1;
	declare @auxiliar int;
	declare @sucesion varCHar(max) = '' + CAST(@primero as varchar) + ',' + Cast(@ultimo as varchar);
	

	while (@ultimo < @numero)
		begin
			set @auxiliar = @ultimo;
			set @ultimo = @primero+@ultimo;	
			set @primero = @auxiliar;
			set @sucesion += ',' + Cast(@ultimo as varchar);
		end
return @sucesion
end

select dbo.fnFibonnacci(800)

--3. bOBTENER DESCUENTO M�XIMO POR CATEGOR�A:

select * from Categories
select * from [Order Details]

select c.CategoryName, MAX(od.Discount) from Categories c
inner join products p on c.CategoryID = p.CategoryID
inner join [Order Details] od on od.ProductID = p.ProductID
group by c.CategoryName

--4. Obtener los D�AS LABORABLES ENTRE DOS FECHAS:

select datename(MONTH, '4-05-2024')
select datepart(MONTH, '4-05-2024')

create or alter function fn_diasLaborales(@fechaInicio date, @fechaFin date)
returns int
as begin
	declare @fechaAux date = @fechaInicio;
	declare @diasLaborales int = 1;

	while (@fechaAux < @fechaFin)
		begin
			if ((DATENAME(weekday, @fechaAux) != 'Domingo'))
				begin
					set @diasLaborales += 1;
				end
			SET @fechaAux = dateadd(day, 1, @fechaAux)
		end
return @diasLaborales;
end

select dbo.fn_diasLaborales('01-05-2024', '31-05-2024')

--select numero as numero from (VALUES (1), (29), (69)) as valor(numero)

-- 6 Funci�n que calcule el promedio de una serie de valores. Los par�metros de la funci�n se pasar�n de forma �1,2,3,4�.�:
select AVG(CAST(value AS decimal(4,2))) from string_split('1,2,3,4,5', ',') as a

--7. OBTENER LOS DETALLES DE PEDIDOS DE  TODOS LOS CLIENTES. Obtener el identificador de la orden, el nombre del producto, la cantidad pedida y el nombre de la compa��ia.:

select * from [Order Details]
select * from orders

--8. OBTENER VENTAS MENSUALES POR CATEGOR�A. Mostrar por cada a�o y mes, el nombre de la categor�a y la cantidad de ventas realizadas.:

select * from [Order Details]
select * from orders
select * from Products
select * from Categories

select datename(year, o.OrderDate) as a�o, datename(month, o.OrderDate) as mes, c.CategoryName, count(o.orderid) as a from orders o
inner join [Order Details] od on od.OrderID = o.orderId
inner join Products p on od.ProductID = p.ProductID
inner join Categories c on c.CategoryID = p.CategoryID
group by datename(year, o.OrderDate), datename(month, o.OrderDate), c.CategoryName
order by a�o, mes

-- 10. OBTENER LOS 10 PRODUCTOS M�S VENDIDOS:

select * from [Order Details]
select Top 10 * from [Order Details] od

select Top 10 p.ProductName, count(od.productid) as cantidad from [Order Details] od
inner join Products p on od.ProductID = p.ProductID
group by p.ProductName
order by a desc
