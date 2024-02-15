Drop DataBase if exists Ejercicio01Modificaciones
go
Create DataBase Ejercicio01Modificaciones
go
USE Ejercicio01Modificaciones
go

Create Table Empleados(
    numEmp smallint identity,
    nombre varchar (50),
    edad smallint,
    oficina smallint,
    puesto varchar (50),
    fecha_contrato date,
    jefe smallint,
    cuota smallint,
    ventas smallint
)

Create Table Cliente(
    numClie int identity,
    nombre varChar (50),
    resp smallint,
    limiteCredito int
)

Create Table Oficinas(
    oficina smallint NOT NULL,
    ciudad varChar (15),
    region varChar (15),
    dir smallint,
    objetivo varchar (100),
    ventas decimal(3,1)
)

Create Table Productos(
    ID_Fab smallint NOT NULL,
    ID_Producto smallint NOT NULL,
    descripcion varChar (100), 
    precio smallint,
    existencias int
)
Create Table Pedidos(
    fechaPedido date NOT NULL,
    clie int,
    resp smallint,
    fab smallint,
    producto smallint,
    cant smallint,
    importe smallint
)

ALTER TABLE Empleados ADD Constraint PK_Empleados
PRIMARY KEY (numEmp)

ALTER TABLE Oficinas ADD Constraint PK_Oficinas
PRIMARY KEY (oficina)

ALTER TABLE Empleados ADD Constraint FK_Empleados_Oficinas_oficina
FOREIGN KEY (oficina) REFERENCES Oficinas (oficina)

ALTER TABLE Empleados ADD Constraint FK_Empleados_Empleados_jefe
FOREIGN KEY (jefe) REFERENCES Empleados (numEmp)

ALTER TABLE Cliente ADD Constraint PK_Cliente
PRIMARY KEY (numClie)

ALTER TABLE cliente ADD Constraint FK_cliente_Empleados_resp
FOREIGN KEY (resp) REFERENCES Empleados (numEmp)

ALTER TABLE Oficinas ADD Constraint FK_Oficinas_Empleados_dir
FOREIGN KEY (dir) REFERENCES Empleados (numEmp)

ALTER TABLE Productos ADD Constraint PK_Productos
PRIMARY KEY (ID_Fab, ID_Producto)

ALTER TABLE Pedidos ADD Constraint PK_Pedidos
PRIMARY KEY (fechaPedido)

ALTER TABLE Pedidos ADD Constraint FK_Pedidos_cliente_clie
FOREIGN KEY (clie) REFERENCES cliente (numClie)

ALTER TABLE Pedidos ADD Constraint FK_Pedidos_Empleados_resp
FOREIGN KEY (resp) REFERENCES Empleados (numemp)

ALTER TABLE Pedidos ADD Constraint FK_Pedidos_Productos_fab_producto 
FOREIGN KEY (fab, producto) REFERENCES Productos (ID_Fab, ID_Producto)


ALTER TABLE Empleados DROP Constraint FK_Empleados_Oficinas_oficina
ALTER TABLE Empleados DROP Constraint FK_Empleados_Empleados_jefe
ALTER TABLE cliente DROP Constraint FK_cliente_Empleados_resp
ALTER TABLE Oficinas DROP Constraint FK_Oficinas_Empleados_dir
ALTER TABLE Pedidos DROP Constraint FK_Pedidos_cliente_clie
ALTER TABLE Pedidos DROP Constraint FK_Pedidos_Empleados_resp
ALTER TABLE Pedidos DROP Constraint FK_Pedidos_Productos_fab_producto 
ALTER TABLE Empleados DROP Constraint PK_Empleados
ALTER TABLE Oficinas DROP Constraint PK_Oficinas
ALTER TABLE Pedidos DROP Constraint PK_Pedidos
ALTER TABLE Cliente DROP Constraint PK_Cliente
ALTER TABLE Productos DROP Constraint PK_Productos


ALTER TABLE Empleados ADD sueldo money
ALTER TABLE Cliente ADD cuentaBancaria int
ALTER TABLE Productos ADD color varChar(20)


ALTER TABLE Empleados ALTER COLUMN sueldo decimal(3,1)
ALTER TABLE Empleados ALTER COLUMN nombre varChar(60)
ALTER TABLE Oficinas ALTER COLUMN ventas decimal(3,1)

ALTER TABLE Empleados DROP COLUMN sueldo 
ALTER TABLE Empleados DROP COLUMN cuentaBancaria 
ALTER TABLE Oficinas DROP COLUMN color


USE master
go