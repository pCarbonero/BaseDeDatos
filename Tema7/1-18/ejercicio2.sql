CREATE DATABASE Ejercicio2
use Ejercicio2

create TABLE Empleado(
DNI Char(9) primary key
)

create TABLE Departamento(
NumDpto int primary key
)

create TABLE Trabaja(
    DNI_Empleado Char(9),
	NumDpto_Departamento int
	CONSTRAINT PKtrabaja primary key(DNI_Empleado, NumDpto_Departamento)
    CONSTRAINT FKempleado FOREIGN KEY (DNI_Empleado)
    REFERENCES Empleado(DNI),
    CONSTRAINT FKdepartamento FOREIGN KEY (NumDpto_Departamento)
    REFERENCES Departamento(NumDpto),

)