
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

CREATE OR ALTER FUNCTION FnPalmares (@idCaballo int, @fechaInicial date, @fechaFinal date)
returns table
return()

SELECT number AS Puesto, COUNT(IDCaballo) as a FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8)) AS T(number)
left JOIN LTCaballosCarreras CC on cc.Posicion = number and cc.IDCaballo = 3 group by number

