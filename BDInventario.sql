create database BDinventario

use BDinventario;


CREATE TABLE Proveedor(
IdProveedor int not null primary key identity(1,1),
  NombreProveedor varchar(50) not null unique,
  Empresa varchar(20),
  Producto varchar(30),
  DiasDeReparto varchar(30),
  Telefono char(10),
  Cod_Producto int
);
select * from Proveedor;

insert into Proveedor values ('Juan Manuel Hernández Cordoba','Bonafont', 'Botellas de agua', 'Martes y Jueves', '2261857984', 20);

CREATE TABLE Entrada (
  IdEntrada int not null primary key identity(1,1),
  FechaEntrada date,
  Cod_Proveedor int not null,
  CodigoProducto int not null unique,
  NombreProducto varchar (50) not null,
  Marca varchar(35),
  Presentacion varchar(20),
  Cantidad int,
  PrecioUnitario float,
  FOREIGN KEY (Cod_Proveedor) REFERENCES Proveedor(IdProveedor)
);
INSERT INTO Entrada VALUES ('2023-04-03', 1, 123, 'Producto de prueba', 'Marca de prueba', 'prueba', 10, 5.99);

select * from Entrada;

CREATE TABLE Stock (
  IdStock int not null primary key identity(1,1),
  CodigoProducto int not null unique,
  NombreProducto varchar(50) not null,
  Marca varchar(35),
  Presentacion varchar(20),
  Cantidad int not null default 0,
  PrecioUnitario float,
  CHECK (Cantidad >= 0)
);

INSERT INTO Stock VALUES (52147, 'Coca Cola', 'Coca Cola', 'Lata', 50, 17),
(123, 'Producto de prueba', 'Marca de prueba', 'prueba', 10, 5.99);
select * from Stock;

CREATE TABLE Salida (
  IdSalida int not null primary key identity(1,1),
  FechaSalida date,
  CodigoProducto int not null unique,
  NombreProducto varchar(50) not null,
  Marca varchar(35),
  Presentacion varchar(20),
  Cantidad int not null,
  PrecioUnitario float,
  Cod_Proveedor int not null,
  CHECK (Cantidad > 0),
  FOREIGN KEY (CodigoProducto) REFERENCES Stock(CodigoProducto),
  FOREIGN KEY (Cod_Proveedor) REFERENCES Proveedor(IdProveedor));

  INSERT INTO Salida VALUES ('2023-04-03', 123, 'Producto de prueba', 'Marca de prueba', 'prueba', 8,  5.99, 1);
  select * from Salida;

CREATE TRIGGER tr_Salida
ON Salida
AFTER INSERT
AS
BEGIN
UPDATE Stock
SET Cantidad = Stock.Cantidad - inserted.Cantidad
FROM Stock
JOIN inserted ON Stock.CodigoProducto = inserted.CodigoProducto;
END;
GO

CREATE TRIGGER tr_Entrada
ON Entrada
AFTER INSERT
AS
BEGIN
UPDATE Stock
SET Cantidad = Stock.Cantidad + inserted.Cantidad
FROM Stock
JOIN inserted ON Stock.CodigoProducto = inserted.CodigoProducto;
END;
GO


CREATE TRIGGER tr_Stock_Delete
ON Stock
AFTER DELETE
AS
BEGIN
DELETE FROM Entrada WHERE CodigoProducto IN (SELECT CodigoProducto FROM deleted);
DELETE FROM Salida WHERE CodigoProducto IN (SELECT CodigoProducto FROM deleted);
END;
CREATE TRIGGER tr_AlertaStock
ON Stock
AFTER INSERT, UPDATE
AS
BEGIN
DECLARE @Producto varchar(50);
DECLARE @Cantidad int;

SELECT @Producto = i.NombreProducto, @Cantidad = s.Cantidad
FROM Stock s
JOIN inserted i ON s.CodigoProducto = i.CodigoProducto;

IF @Cantidad <= 5
BEGIN
PRINT 'ALERTA: Quedan ' + CAST(@Cantidad AS varchar) + ' unidades del producto ' + @Producto + ' en stock.';
END
END;
Create table Usuarios(
Id_Usuario int not null primary key identity(1,1),
Nombre varchar (50) null,
Usuario varchar (50) null,
Contrasena varchar(50) null,
Tipo_usuario varchar (50) null);

select * from Usuarios;


insert into Usuarios values ('Silvia','Admin1', '11223344', 'Admin'),
							('Diana', 'Empleado1','1234', 'Empleado');
 