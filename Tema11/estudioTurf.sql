
-- 4.
select * from LTCaballosCarreras
select * from LTCaballos
select * from LTApuestas

create or alter function fn_totalApostadoCaballo(@idCarrera int, @idCaballo int)
RETURNS decimal(4,2)
AS BEGIN
	declare @valorApuesta decimal (4,2) = (SELECT importe from LTApuestas where IDCaballo = @idCaballo and IDCarrera = @idCarrera)
	return @valorApuesta
END

select dbo.fn_totalApostadoCaballo(1, 1)

create or alter function fn_totalACarrera(@idCarrera int)
returns money
as begin
	declare @totalApostado money = (select sum(importe) as sumaTotal from LTApuestas where IDCarrera = @idCarrera)
	return @totalApostado
end

select dbo.fn_totalACarrera(1)

create or alter function fn_premio1(@idCarrera int)
returns table
return(select id, (((dbo.fn_totalACarrera(@idCarrera)/(dbo.fn_totalApostadoCaballo(@idCarrera, id))*0.6))) as premio1 from LTCaballos
where (((dbo.fn_totalACarrera(@idCarrera)/(dbo.fn_totalApostadoCaballo(@idCarrera, id))*0.6))) is not null)

select * from fn_premio1(1)

create or alter function fn_premio2(@idCarrera int)
returns table
return(select id, (((dbo.fn_totalACarrera(@idCarrera)/(dbo.fn_totalApostadoCaballo(@idCarrera, id))*0.2))) as premio2 from LTCaballos
where (((dbo.fn_totalACarrera(@idCarrera)/(dbo.fn_totalApostadoCaballo(@idCarrera, id))*0.2))) is not null)


select * from fn_premio2(1)

create or alter function fn_premioCaballos(@idCarrera int)
returns table
return(select c.id, p1.premio1, p2.premio2 from LTCaballos c
		inner join dbo.fn_premio1(@idCarrera) p1 on p1.id = c.id
		inner join dbo.fn_premio2(@idCarrera) p2 on p2.id = c.id)

select * from fn_premioCaballos(1)

--5. 
--drop FUNCTION FnPalmares
select * from LTCarreras

CREATE OR ALTER FUNCTION FnPalmares (@idCaballo int, @fechaInicial date, @fechaFinal date)
returns table
return(SELECT number AS Puesto, COUNT(IDCaballo) as a FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8)) AS T(number)
left JOIN LTCaballosCarreras CC on cc.Posicion = number and cc.IDCaballo = @idCaballo 
left join LTCarreras C on cc.IDCarrera = c.ID and c.Fecha between @fechaInicial and @fechaFinal
group by number)

select * from dbo.FnPalmares(1, '2018-01-20', '2018-03-10')

--6. Crea una función FnCarrerasHipodromo que nos devuelva las carreras celebradas en un hipódromo en un rango de fechas.
-- La función recibirá como parámetros el nombre del hipódromo y la fecha de inicio y fin del intervalo y nos devolverá una tabla con las siguientes columnas: 
-- Fecha de la carrera, número de orden, numero de apuestas realizadas, número de caballos inscritos, número de caballos que la finalizaron y nombre del ganador.
select * from LTCarreras 
select * from LTApuestas where IDCarrera = 6
select * from LTCaballosCarreras where IDCarrera = 20

create or alter function FnCarrerasHipodromo (@hipodromo varCHar(59), @fechaInicial date, @fechaFinal date)
returns table 
return(select c.id, C.Fecha, C.NumOrden, count(distinct a.id) as numeroDeApuestas, 
count(distinct cc.idCaballo) as numeroDeCaballos, count(distinct cc.posicion) as numeroDeCaballosFin,
(select ng.nombre from dbo.fnNombreGanador(@hipodromo, @fechaInicial, @fechaFinal) ng where ng.id = cc.idCarrera) as ganador
from LTCarreras C
left join LTApuestas A on c.id = a.IDCarrera
left join LTCaballosCarreras CC on c.ID = CC.IDCarrera
where c.Fecha between @fechaInicial and @fechaFinal and c.Hipodromo = @hipodromo
group by c.id, C.Fecha, C.NumOrden, cc.idCarrera)

select * from dbo.FnCarrerasHipodromo('La Zarzuela', '2018-01-20', '2018-03-10')

select c.id, C.Fecha, C.NumOrden, count(distinct a.id) as numeroDeApuestas, 
count(distinct cc.idCaballo) as numeroDeCaballos, count(distinct cc.posicion) as numeroDeCaballosFin from LTCarreras C
left join LTApuestas A on c.id = a.IDCarrera
left join LTCaballosCarreras CC on c.ID = CC.IDCarrera
group by c.id, C.Fecha, C.NumOrden


select * from ltcaballos

create or alter function fnNombreGanador (@hipodromo varCHar(59), @fechaInicial date, @fechaFinal date)
returns table 
return(select cb.nombre, cr.id from LTCaballos cb
inner join LTCaballosCarreras cc on cb.ID = cc.IDCaballo
inner join LTCarreras cr on cc.IDCarrera = cr.ID
where cc.Posicion = 1 and cr.Hipodromo = @hipodromo and cr.Fecha between @fechaInicial and @fechaFinal)


select * from dbo.fnNombreGanador('La Zarzuela', '2018-01-20', '2018-03-10')
select * from dbo.FnCarrerasHipodromo('La Zarzuela', '2018-01-20', '2018-03-10')
