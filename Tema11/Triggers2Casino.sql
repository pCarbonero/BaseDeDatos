-- 6.- Haz un trigger que asegure que una vez se introduce el número de una apuesta, no pueda cambiarse.

SELECT * FROM COL_NumerosApuesta

DISABLE TRIGGER trgNoCambiarNum ON COL_NumerosApuesta

CREATE OR ALTER TRIGGER trgNoCambiarNum ON COL_NumerosApuesta
AFTER UPDATE 
AS BEGIN
	UPDATE COL_NumerosApuesta
	SET Numero = (SELECT Numero FROM deleted)
	WHERE Numero = (SELECT Numero FROM inserted)
END

BEGIN TRANSACTION cambiaNumero 
Update COL_NumerosApuesta
SET Numero = 35
WHERE Numero = 10
ROLLBACK

-- 7.- Haz untrigger que garantice que no se puedan hacer más apuestas en una jugada si la columna NoVaMas tiene el valor 1.
SELECT * FROM COL_Jugadas
SELECT * FROM COL_Apuestas
SELECT * FROM COL_Jugadores

CREATE OR ALTER TRIGGER noMasApuesta ON COL_Apuestas
AFTER INSERT 
AS BEGIN	
	if((SELECT J.NoVaMas FROM COL_Jugadas J
		INNER JOIN inserted i ON i.IDJugada = J.IDJugada WHERE i.IDMesa = J.IDMesa) = 1)
		BEGIN
			PRINT('NO ES POSIBLE REALIZAR MÁS APUESTAS A EA JUGADA')
			ROLLBACK
		END
		ELSE
			BEGIN
				PRINT('ALGO PASA')
			END
END	

BEGIN TRANSACTION apostarANoVaMas
UPDATE COL_Jugadas
SET NoVaMas = 1
WHERE IDMesa = 1 AND IDJugada = 1

INSERT INTO COL_Jugadores (ID, Nombre, Apellidos, Nick, PassWord, FechaNacimiento, Saldo)
VALUES (4, 'Pablo', 'Carbonero', 'tano', 'holahola', '2003-01-02', 99999)

INSERT INTO COL_Apuestas (IDJugador, IDMesa, IDJugada, Tipo, Importe)
VALUES (4, 1, 1, 1, 100)

ROLLBACK