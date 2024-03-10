--/////PRIMERA PARTE/////--
use Empresa
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
SELECT * FROM Oficinas SELECT * FROM Empleados

--99. Listar las oficinas que tengan un objetivo mayor que la suma de las cuotas de sus empleados.
SELECT * FROM Oficinas
SELECT * FROM Empleados

SELECT * FROM  Oficinas
WHERE objetivo > (SELECT SUM(cuota) FROM Empleados)


--/////SEGUNDA PARTE/////--
--53. Mostrar la información de los empleados junto a la información de las oficinas en las que trabajan.
SELECT * FROM Empleados AS E
INNER JOIN Oficinas AS O
on E.oficina = O.oficina

--54. Igual que el ejercicio anterior, pero mostrando solo los empleados que trabajan en las oficinas del sur.
SELECT * FROM Empleados AS E
INNER JOIN Oficinas AS O
on E.oficina = O.oficina
WHERE O.region = 'sur'

--55. Igual que el ejercicio anterior, ordenando los empleados por edad.
SELECT * FROM Empleados AS E
INNER JOIN Oficinas AS O
on E.oficina = O.oficina
ORDER BY E.edad 

--56. Escribir una consulta que muestre la información de todos los empleados junto a los datos de su oficina.
SELECT * FROM Empleados AS E
INNER JOIN Oficinas AS O
on E.oficina = O.oficina

--57. Escribir una consulta que muestre la información de todos los empleados (trabajen o no en una oficina) junto a la información de su oficina.
SELECT * FROM Empleados AS E
LEFT JOIN Oficinas AS O
on E.oficina = O.oficina
ORDER BY E.edad 

--58. Listar las oficinas del este indicando para cada una de ellas su número, ciudad, números y nombres de sus empleados.
-- Hacer una versión en la que aparecen sólo las que tienen empleados, y hacer otra en las que además aparezcan las oficinas del este que no tienen empleados.			
SELECT * FROM Oficinas
SELECT * FROM Empleados

--V1
SELECT O.oficina, O.ciudad, O.objetivo, O.ventas, E.nombre FROM Oficinas AS O
INNER JOIN Empleados AS E ON O.oficina = E.oficina
WHERE O.region = 'este'

--V2
SELECT O.oficina, O.ciudad, O.objetivo, O.ventas, E.nombre FROM Oficinas AS O
LEFT JOIN Empleados AS E ON O.oficina = E.oficina
WHERE O.region = 'este'

--59. Listar los pedidos mostrando su número de pedido e importe, junto a la información del cliente (nombre y límite de crédito) que realiza el pedido.
SELECT P.numpedido, p.importe FROM Pedidos AS P
INNER JOIN Clientes AS C ON P.clie = C.numclie

--60. Igual que el ejercicio anterior mostrando además la información del empleado que fue responsable de este pedido.
SELECT * FROM Empleados
SELECT * FROM Clientes
SELECT * FROM Pedidos

SELECT P.numpedido, p.importe, E.* FROM Pedidos AS P --E.* significa que además añada la informacion del empleado
INNER JOIN Clientes AS C ON P.clie = C.numclie
INNER JOIN Empleados AS E On p.resp = e.numemp

--61. Mostrar para cada producto la información de sus pedidos
SELECT * FROM Productos
SELECT * FROM Pedidos

SELECT * FROM Productos
LEFT JOIN Pedidos ON Productos.idproducto = Pedidos.producto

--62. Listar los datos de cada uno de los empleados, la ciudad y región en donde trabaja.
SELECT E.*, o.ciudad, o.region FROM Empleados AS E
INNER JOIN Oficinas AS O ON E.oficina = O.oficina

--63. Listar todas las oficinas con objetivo superior a 60.000 euros indicando para cada una de ellas el nombre de su director.
SELECT * FROM Empleados
SELECT * FROM Oficinas

SELECT O.*, E.nombre AS Jefe FROM Oficinas AS O
INNER JOIN Empleados AS E ON O.oficina = E.oficina
WHERE O.objetivo > 60000 AND O.dir = E.numemp

--64. Listar los pedidos superiores a 2.500 euros, incluyendo el nombre del empleado responsable del
-- pedido y el nombre del cliente que lo solicitó. Ordenar la consulta por el nombre del cliente.
SELECT * FROM Pedidos
SELECT * FROM Clientes
SELECT * FROM Empleados

SELECT P.*, E.nombre AS Responsable, C.nombre AS Cliente FROM Pedidos AS P
INNER JOIN Clientes AS C ON P.clie = C.numclie
INNER JOIN Empleados AS E ON P.resp = E.numemp
WHERE importe > 2500
ORDER BY C.nombre

--65. Listar ordenados por el nombre los empleados que han realizado algún pedido.
SELECT * FROM Empleados
WHERE numemp IN (SELECT resp FROM Pedidos)

--66. Hallar los empleados que realizaron su primer pedido el mismo día que fueron contratados.
SELECT * FROM Empleados
WHERE numemp IN (SELECT resp FROM Pedidos WHERE Empleados.contrato = Pedidos.fechapedido)

-- 68. Listar los números de los empleados que son responsables de un pedido superior a 1.000 euros o
-- que tengan una cuota inferior a 5.000 euros.
SELECT E.numemp FROM Empleados AS E
INNER JOIN Pedidos AS P On E.numemp = P.resp 
WHERE P.importe > 1000 OR E.cuota < 5000

-- 69. Mostrar las oficinas que no tienen director o que se encuentran en la región sur.
SELECT * FROM Oficinas
WHERE dir IS NULL OR region = 'sur'

-- 70. Listar las oficinas que no tienen director o en las que trabaja alguien.
--nose :(


-- 71. ¿Cuál es la cuota media y las ventas medias de todos los empleados?
SELECT AVG(cuota) AS CuotaMedia, AVG(ventas) AS VentasMedia FROM Empleados 

-- 72. Edad media de los empleados.
SELECT AVG(edad) AS EdadMedia FROM Empleados 

-- 73. Edad del empleado más joven y del mayor.
SELECT edad FROM Empleados
WHERE edad = (SELECT MAX(edad) FROM Empleados)
OR edad = (SELECT MIN(edad) FROM Empleados)

-- 74. Hallar el importe medio de pedidos, el importe total de pedidos y el precio medio de venta (el precio de venta es el precio unitario en cada pedido).
SELECT * FROM Pedidos
SELECT * FROM Productos

SELECT AVG(Pe.importe) AS importeMedio, SUM(Pe.importe) AS totalPedidos, AVG(Pr.precio) AS precioMedioVentas FROM Pedidos AS Pe
INNER JOIN Productos AS Pr ON Pe.producto = Pr.idproducto

-- 75. Hallar el precio medio de los productos del fabricante ‘ACI’.
SELECT AVG(precio) FROM Productos
WHERE idfab IN ('ACI')

-- 76. ¿Cuál es el importe total de los pedidos realizados por el empleado Vicente Vino?
SELECT * FROM Empleados
SELECT * FROM Pedidos

SELECT SUM(P.importe) AS precioTotal FROM Pedidos AS P
WHERE resp = (SELECT numemp FROM Empleados AS E WHERE E.nombre = 'Vicente Vino')

-- 77. Hallar en qué fecha se realizó el primer pedido.
SELECT MIN(fechaPedido) FROM Pedidos

-- 78. Hallar cuántos pedidos hay de más de 5.000 euros.
SELECT COUNT(importe) AS numPedidosMayor5k FROM Pedidos
WHERE importe > 5000

-- 79. Listar cuántos empleados están asignados a cada oficina, indicar el número de oficina.
SELECT O.oficina, COUNT(E.oficina) AS cant FROM Oficinas AS O
INNER JOIN Empleados AS E ON O.oficina = E.oficina
GROUP BY O.oficina 

-- 80. Mostrar el número de oficinas que existen en cada región.
SELECT region, COUNT(oficina) as numOfis From Oficinas
GROUP BY region

-- 81. Saber cuántas oficinas tienen algún empleado con ventas superiores a su cuota, no queremos saber cuales sino cuántas hay.
SELECT COUNT(O.oficina) AS numOfis FROM Oficinas AS O
INNER JOIN Empleados AS E ON O.oficina = E.oficina
WHERE E.ventas > E.cuota

-- 82. Para cada empleado, obtener su número, nombre, e importe vendido a cada cliente indicando el número de cliente.
SELECT E.numemp, E.nombre, P.importe, P.clie FROM Empleados AS E
LEFT JOIN Pedidos AS P ON E.numemp = P.resp

-- 83. Para cada empleado cuyos pedidos suman más de 3.000 euros, hallar su importe medio de pedidos. 
-- En el resultado indicar el número de empleado y su importe medio de pedidos.

-- 85. Escribir una consulta SQL que indique el número de empleados que trabaja en cada oficina.
SELECT O.oficina, COUNT(E.oficina) AS cant FROM Oficinas AS O
LEFT JOIN Empleados AS E ON O.oficina = E.oficina
GROUP BY O.oficina 

-- 86. Igual que el ejercicio anterior pero mostrando las oficinas donde trabajan 3 o más empleados.
SELECT O.oficina, COUNT(E.oficina) AS cant FROM Oficinas AS O
LEFT JOIN Empleados AS E ON O.oficina = E.oficina
GROUP BY O.oficina 
HAVING COUNT(E.oficina) >= 3

