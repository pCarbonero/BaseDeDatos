use CasinOnLine

-- Inserting sample data for table COL_Mesas
INSERT INTO [dbo].[COL_Mesas] ([ID], [LimiteJugada], [Saldo]) VALUES
(1, 1000, 10000),
(2, 2000, 20000),
(3, 1500, 15000);

-- Inserting sample data for table COL_Jugadores
INSERT INTO [dbo].[COL_Jugadores] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Saldo], [Credito]) VALUES
(1, 'Juan', 'Perez', 'jperez', '123456', '1990-05-10', 5000, NULL),
(2, 'Maria', 'Gonzalez', 'mgonz', 'abcdef', '1985-12-15', 8000, NULL),
(3, 'Carlos', 'Lopez', 'clopez', 'qwerty', '1998-07-20', 3000, NULL);

-- Inserting sample data for table COL_TiposApuesta
INSERT INTO [dbo].[COL_TiposApuesta] ([ID], [Nombre], [Numeros], [Premio]) VALUES
(1, 'Par', 18, 2.0),
(2, 'Impar', 18, 2.0),
(3, 'Rojo', 18, 2.0),
(4, 'Negro', 18, 2.0),
(5, 'Docena 1', 12, 3.0),
(6, 'Docena 2', 12, 3.0),
(7, 'Docena 3', 12, 3.0),
(8, 'Columna 1', 12, 3.0),
(9, 'Columna 2', 12, 3.0),
(10, 'Columna 3', 12, 3.0);

-- Inserting sample data for table COL_Jugadas
INSERT INTO [dbo].[COL_Jugadas] ([IDMesa], [IDJugada], [MomentoJuega], [NoVaMas], [Numero]) VALUES
(1, 1, '30-04-2024 14:00:00', 0, NULL),
(1, 2, '30-04-2024 14:10:00', 0, NULL),
(2, 1, '30-04-2024 14:05:00', 0, NULL),
(2, 2, '30-04-2024 14:15:00', 0, NULL),
(3, 1, '30-04-2024 14:07:00', 0, NULL),
(3, 2, '30-04-2024 14:17:00', 0, NULL);

-- Inserting sample data for table COL_Apuestas
INSERT INTO [dbo].[COL_Apuestas] ([IDJugador], [IDMesa], [IDJugada], [Tipo], [Importe]) VALUES
(1, 1, 1, 1, 50.0),
(2, 1, 1, 2, 100.0),
(3, 1, 1, 3, 150.0),
(3, 2, 1, 4, 200.0),
(2, 2, 1, 5, 250.0),
(3, 2, 2, 6, 300.0),
(2, 2, 2, 7, 350.0),
(1, 2, 1, 8, 400.0),
(1, 2, 2, 9, 450.0),
(3, 1, 2, 10, 500.0)

delete from COL_Apuestas
-- Inserting sample data for table COL_Apuestas
-- Insertar datos de muestra en la tabla COL_Apuestas
INSERT INTO Col_apuestas (IDJugador, IDMesa, IDJugada, Tipo, Importe)
VALUES
(1, 1, 1, 1, 50.0),
(1, 2, 1, 2, 100.0),
(1, 3, 1, 3, 150.0),
(2, 1, 1, 4, 200.0),
(3, 1, 1, 5, 250.0),
(2, 2, 1, 1, 50.0),
(2, 3, 1, 2, 100.0),
(2, 1, 2, 3, 150.0),
(2, 2, 2, 4, 200.0),
(3, 1, 2, 2, 100.0),
(3, 2, 1, 4, 200.0),
(3, 3, 1, 5, 250.0),
(1, 1, 2, 1, 50.0);
-- Insertar datos de muestra en la tabla COL_NumerosApuestas
INSERT INTO Col_NumerosApuesta (IDJugador, IDMesa, IDJugada, Numero)
VALUES
(1, 1, 1, 10),
(1, 1, 1, 20),
(1, 1, 1, 30),
(1, 1, 1, 11),
(1, 1, 1, 12),
(2, 1, 1, 13),
(2, 1, 1, 14),
(2, 1, 1, 15),
(2, 1, 1, 16),
(2, 1, 1, 17),
(3, 1, 1, 18),
(3, 1, 1, 19),
(3, 1, 1, 20),
(3, 1, 1, 21),
(3, 1, 1, 22),
(3, 1, 2, 23),
(3, 1, 2, 24),
(3, 1, 2, 25),
(3, 1, 2, 26),
(3, 1, 2, 27),
(3, 1, 2, 28)