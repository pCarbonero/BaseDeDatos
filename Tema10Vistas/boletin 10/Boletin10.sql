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

--3. Crear la vista ProfeRepetidores que muestre el dni de los profes que imparten clase a algún alumno repetidor.
SELECT * FROM Imparte
SELECT * FROM Matriculado

CREATE VIEW ProfesoresImpartenRepetidores AS
SELECT Distinct I.dni
FROM Imparte I WHERE cod IN (SELECT cod FROM Matriculado WHERE repe = 1)

--4.  Crear la vista ProfeSinAsignatura (nombre y dni) que muestre a los profesores que no imparten
-- ninguna asignatura
SELECT * FROM Imparte
SELECT * FROM Profesor

CREATE VIEW ProfesoresSinAsig AS
SELECT P.nombre, P.dni
FROM Profesor P
WHERE NOT EXISTS (SELECT dni FROM Imparte I where I.dni = P.dni)

--5. Crear la vista ProfeSinAlumnos que muestre a los profesores que imparten una asignatura donde
-- no hay ningún alumno matriculado
SELECT * FROM Imparte
SELECT * FROM Matriculado
SELECT * FROM Profesor

CREATE VIEW ProfesorSinAlumn AS
SELECT P.nombre, P.dni
FROM Profesor P WHERE P.dni IN (SELECT I.dni FROM Imparte I
WHERE NOT EXISTS (SELECT cod FROM Matriculado where Matriculado.cod = I.cod))

--6. Crear la vista ProfeSinClase que muestra los profesores que no dan clase. Ya sea por no impartir
-- ninguna asignatura o por impartir una asignatura donde no hay ningún alumno matriculado.
CREATE VIEW ProfesoresSinClase AS
SELECT * FROM 
ProfesoresSinAsig AS ProfesorSinAsignatura
UNION
SELECT * FROM ProfesorSinAlumn AS ProfesorSinAlumno

--7. Modificar la vista Repetidores para que muestre la edad del alumno.
ALTER VIEW AlumnosRepetidores AS
SELECT A.nombre, A.dni, DATEDIFF(YEAR, A.fecNac, CURRENT_TIMESTAMP) AS edad
From Alumno A
where dni IN (SELECT dni FROM Matriculado WHERE repe = 1)

--8. Eliminar la vista ProfeSinClase
Drop VIEW ProfesoresSinClase



