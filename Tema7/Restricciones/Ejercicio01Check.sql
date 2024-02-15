Create DATABASE Ejercicio01Check
Use Ejercicio01Check

Create Table CriaturasExtrañas(
	ID smallint PRIMARY KEY,
	Nombre Varchar(30),
	FechaNac Date,
	NumeroPie smallint,
	NivelIngles nchar(2),
	Historieta VarChar(150),
	CONSTRAINT CK_NoJohnConnor CHECK (FechaNac < GetDate()),
	CONSTRAINT CK_NivelEuropeo CHECK (NivelIngles IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')),
	CONSTRAINT CK_Imaginacion CHECK (Historieta NOT IN (ID + 'Pecadores' + NumeroPie))
)

