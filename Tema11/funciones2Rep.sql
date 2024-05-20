--2. CÁLCULO DE FIBONACCI. A partir de un número obtener la sucesión de Fibonacci hasta ese número (en la sucesión de Fibonacci,
-- el siguiente número es la suma de los dos anteriores): En la sucesión de fibonacci los dos primeros números son 1 y luego la suma de los dos anteriores. 1, 1, 2, 3, 5, 8, 13, 21....

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

--3. bOBTENER DESCUENTO MÁXIMO POR CATEGORÍA:

select * from Categories
select * from [Order Details]

select c.CategoryName, MAX(od.Discount) from Categories c
inner join products p on c.CategoryID = p.CategoryID
inner join [Order Details] od on od.ProductID = p.ProductID
group by c.CategoryName

--4. Obtener los DÍAS LABORABLES ENTRE DOS FECHAS:

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

-- 6 Función que calcule el promedio de una serie de valores. Los parámetros de la función se pasarán de forma ‘1,2,3,4….’:
select AVG(CAST(value AS decimal(4,2))) from string_split('1,2,3,4,5', ',') as a

--7. OBTENER LOS DETALLES DE PEDIDOS DE  TODOS LOS CLIENTES. Obtener el identificador de la orden, el nombre del producto, la cantidad pedida y el nombre de la compañçia.:

select * from [Order Details]
select * from orders

--8. OBTENER VENTAS MENSUALES POR CATEGORÍA. Mostrar por cada año y mes, el nombre de la categoría y la cantidad de ventas realizadas.:

select * from [Order Details]
select * from orders
select * from Products
select * from Categories

select datename(year, o.OrderDate) as año, datename(month, o.OrderDate) as mes, c.CategoryName, count(o.orderid) as a from orders o
inner join [Order Details] od on od.OrderID = o.orderId
inner join Products p on od.ProductID = p.ProductID
inner join Categories c on c.CategoryID = p.CategoryID
group by datename(year, o.OrderDate), datename(month, o.OrderDate), c.CategoryName
order by año, mes

-- 10. OBTENER LOS 10 PRODUCTOS MÁS VENDIDOS:

select * from [Order Details]
select Top 10 * from [Order Details] od

select Top 10 p.ProductName, count(od.productid) as cantidad from [Order Details] od
inner join Products p on od.ProductID = p.ProductID
group by p.ProductName
order by a desc
