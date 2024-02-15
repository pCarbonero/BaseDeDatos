If Not Exists (SELECT * From Sys.databases Where name = 'Ejemplos' )
	Create Database Ejemplos
GO
USE Ejemplos
GO

CREATE TABLE CriaturitasRaras(
	ID tinyint Not NULL,
	Nombre nvarchar(30) Not NULL,
	FechaNac Date NULL, 
	NumeroPie SmallInt NULL,
	NivelIngles NChar(2) NULL,
	Historieta VarChar(300) NULL,
	NumeroChico TinyInt NULL,
	NumeroGrande BigInt NULL,
	NumeroIntermedio SmallInt NULL,
	Temperatura Decimal(3,1) NULL,
	CONSTRAINT [PK_CriaturitasEx] PRIMARY KEY(ID),
	CONSTRAINT CK_Pie CHECK(NumeroPie BETWEEN 25 AND 60),
	CONSTRAINT CK_NumChico CHECK(NumeroChico < 1000),
	CONSTRAINT CK_NumMediano CHECK(NumeroIntermedio BETWEEN NumeroChico AND NumeroGrande),
	CONSTRAINT CK_FechaNac CHECK(FechaNac < CURRENT_TIMESTAMP),
	CONSTRAINT CK_NivelIngles CHECK (NivelIngles IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')),
	CONSTRAINT CK_Historieta CHECK (Historieta NOT LIKE ('oscuro' + 'apocalipsis')),
	CONSTRAINT CK_Temp CHECK (Temperatura BETWEEN 32.5 AND 44)
)
 

GO
