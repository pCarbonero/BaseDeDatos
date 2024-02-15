Create DataBase Ejemplos2
USE Ejemplos2

Create Table DatosRestrictivos(
	ID Smallint Identity (1,2) PRIMARY KEY,
	Nombre Char(15) Unique Not null,
	Numpelos int,
	TipoRopa char,
	NumSuerte TinyInt,
	Minutos TinyInt,
	CONSTRAINT CK_Nombre CHECK(Nombre Not Like '[NXnx]'),
	CONSTRAINT CK_NumPelos CHECK(Numpelos BETWEEN 0 AND 150000),
	CONSTRAINT CK_TipoRopa CHECK(TipoRopa IN ('C','F','E','P','B','N')),
	CONSTRAINT CK_NumSuerte CHECK(NumSuerte&3 = 0 AND NumSuerte BETWEEN 20 AND 85 OR Minutos BETWEEN 120 AND 85),
	CONSTRAINT CK_Minutos CHECK(Minutos BETWEEN 20 AND 85 OR Minutos BETWEEN 120 AND 85)
)