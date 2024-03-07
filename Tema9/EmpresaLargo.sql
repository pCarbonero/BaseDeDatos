--87. Listar los nombres de los clientes que tienen asignado como responsable a Alvaro Aluminio (su-
-- poniendo que no pueden haber empleados con el mismo nombre).
SELECT * FROM Clientes
SELECT * FROM Empleados

SELECT nombre FROM Clientes
WHERE resp = (SELECT numemp FROM Empleados WHERE nombre = 'Alvaro Aluminio');

--88. Mostrar información de los productos cuyas existencias estén por debajo de la existencia media
-- de los productos.
SELECT * FROM Productos

SELECT * FROM Productos
WHERE existencias < (SELECT AVG(existencias) FROM Productos )

--89. Listar los empleados (numemp, nombre, y no de oficina) que trabajan en oficinas “buenas” (las
-- que tienen ventas superiores a su objetivo). NO FUNCIONA
SELECT * FROM Empleados
SELECT * FROM Oficinas

SELECT numemp, nombre, oficina 
FROM Empleados WHERE EXISTS (SELECT oficina FROM Oficinas WHERE ventas > objetivo AND Empleados.oficina = Oficinas.oficina)

--90. Listar los empleados que trabajan en una oficina de la región norte o de la región sur.
SELECT * FROM Empleados
SELECT * FROM Oficinas

SELECT nombre, oficina FROM EMPLEADOS
WHERE EXISTS (SELECT oficina FROM Oficinas WHERE region IN ('sur', 'norte') AND EMPLEADOS.oficina = Oficinas.oficina)

--91. Listar los empleados (numemp, nombre y oficina) que no trabajan en oficinas dirigidas por el
-- empleado 108.

SELECT numemp, nombre, oficina FROM Empleados
WHERE NOT EXISTS(SELECT * FROM Oficinas where Oficinas.dir = 108 AND Oficinas.oficina = Empleados.oficina)

--92. Escribir una consulta que muestre los empleados cuyo nombre coincide con el de algún cliente.
-- Hacer dos versiones: con subconsulta de tipo lista y de tipo tabla.
SELECT nombre FROM Empleados
SELECT nombre FROM Clientes

--93. Escribir una consulta que muestre los empleados cuyo primer nombre coincide con el primer
-- nombre de algún cliente.

--94. Mostrar los empleados que no son directores de ninguna oficina.
SELECT * FROM Empleados
SELECT * FROM Oficinas

SELECT numemp, nombre, oficina FROM Empleados
WHERE NOT EXISTS(SELECT * FROM Oficinas where Oficinas.dir = Empleados.numemp)

--95. Listar los productos (idfab, idproducto y descripción) para los cuales no existe ningún pedido con
-- importe igual o superior a 2.500 euros.
SELECT * FROM Productos
SELECT * FROM Pedidos

SELECT idfab, idproducto, descripcion FROM Productos
WHERE NOT EXISTS (SELECT * FROM Pedidos WHERE importe >= 2500 AND Productos.idproducto = Pedidos.producto)

--96. Listar los clientes asignados a Ana Bustamante que no han hecho un pedido superior a 300 euros.
SELECT * FROM Clientes
SELECT * FROM Pedidos

SELECT * FROM Clientes
WHERE resp = (SELECT numemp FROM Empleados WHERE nombre = 'Ana Bustamante') AND resp IN (SELECT resp FROM Pedidos where importe > 300)

--97. Listar las oficinas en donde al menos haya un empleado cuyas ventas representen más del 55%
-- del objetivo de su oficina.
SELECT * FROM Oficinas
SELECT * FROM Empleados

SELECT * FROM Oficinas 
WHERE EXISTS (SELECT * FROM Empleados WHERE Empleados.ventas > Oficinas.objetivo*0.55  AND Oficinas.oficina = Empleados.oficina)

--98. Listar las oficinas donde todos los empleados tienen ventas que superan al 50% del objetivo de la oficina.
SELECT * FROM Oficinas


