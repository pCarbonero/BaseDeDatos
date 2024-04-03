--1. Crear la vista Repetidores con los alumnos (nombre y dni) que repiten en alguna asignatura.
SELECT * FROM Alumno
SELECT * FROM Asignatura
SELECT * FROM Matriculado

CREATE VIEW AlumnosRepetidores AS
SELECT A.nombre, A.dni
From Alumno A
where dni IN (SELECT dni FROM Matriculado WHERE repe = 1)

--2. Crear la vista AsignaturasRepetidores que muestre las asignaturas 
-- (cod como codigoAsig y nombre como asignatura) donde están matriculado algún alumno repetidor. 
-- Ordenar por código deasignatura.
CREATE VIEW AsignaturasConRepetidores AS
SELECT A.cod AS codigoAsig, A.nombre AS asignatura
FROM Asignatura A 
where cod IN (SELECT cod FROM Matriculado WHERE repe = 1)

-- Crear la vista ProfeRepetidores que muestre el dni de los profes que imparten clase a algún alumno repetidor.


