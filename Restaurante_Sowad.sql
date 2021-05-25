create database restaurante_sowad;

use restaurante_sowad;

create table Tbl_Productos (
idProductos varchar(100) primary key not null,
Nombre varchar(100),
Precio double,
idTipoCategoria int
);

create table Tbl_CategoriaProductos (
idCategoria int primary key not null AUTO_INCREMENT,
Descripcion varchar(100)
);

create table Tbl_IngredientesXProducto (
idProducto varchar(100) not null,
Cantidad int,
idIngredientes int
);

create table Tbl_Ingredientes (
idIngredientes int primary key not null AUTO_INCREMENT,
Nombre varchar(100),
Vencimiento date,
idMarca int
);

create table Tbl_Marca (
idMarca int primary key not null AUTO_INCREMENT ,
Descripcion varchar(100)
);


create table Tbl_Empleado (
idEmpleado varchar(100) primary key not null,
nombres varchar(50),
apellidos varchar(50),
dni int,
nacimiento date,
telefono varchar(50),
correo varchar(100),
idCargo int,
idUsuario int
);

create table Tbl_HorarioEmpleado(
idEmpleado varchar(100),
hora_entrada datetime,
hora_salida datetime
);


create table Tbl_Cargo (
idCargo int primary key not null AUTO_INCREMENT,
Descripcion varchar(50)
);

create table Tbl_Usuario (
idUsuario int primary key not null AUTO_INCREMENT,
Usuario varchar(100),
Contraseña varchar(100),
TipoUsuario Varchar(10) /*Si es de clientes o empleados*/
);


create table Tbl_Detalle_Pedidos (
idDetallePedido varchar(100) primary key not null,
idPedido varchar(100),
idProducto varchar(100) not null,
Cantidad int,
precio double
);


create table Tbl_Pedidos (
idPedidos varchar(100) primary key not null,
idCliente varchar(100),
idEmpleado varchar(100),
Fecha_pedido datetime,
longitud double,
latirud double,
Total double,
Estado varchar(20)
);

create table Tbl_Cliente ( /*Falta Tabla Usuario para clientes*/
idCliente varchar(100) primary key not null,
Nombres varchar(50),
Apellido varchar(50),
Telefono varchar(10),
idUsuario int
);

create table Tbl_Combos (
     idProducto varchar(100) not null,
     idProductosContenido varchar(100) not null,
     Primary key (idProducto,idProductosContenido),
     constraint foreign key idProd (idProducto) references  Tbl_Productos(idProductos),
     constraint foreign key idProdCont (idProductosContenido) references Tbl_Productos(idProductos)
);

ALTER TABLE Tbl_Pedidos /*PEDIDO - CLIENTES*/
ADD FOREIGN KEY (idCliente) REFERENCES Tbl_Cliente(idCliente);

ALTER TABLE Tbl_Productos /*PRODUCTOS - CATEGORIA*/
ADD FOREIGN KEY (idTipoCategoria) REFERENCES Tbl_CategoriaProductos(idCategoria);

ALTER TABLE Tbl_IngredientesXProducto /*INGREDIENTEXPRODUCTO - PRODUCTO*/
ADD FOREIGN KEY (idProducto) REFERENCES Tbl_Productos (idProductos);

ALTER TABLE Tbl_IngredientesXProducto /*INGREDIENTESXPRODUCTO - INGREDIENTES*/
ADD FOREIGN KEY (idIngredientes) REFERENCES Tbl_Ingredientes(idIngredientes) ;

ALTER TABLE Tbl_Ingredientes /*INGREDIENTES-MARCA*/
ADD FOREIGN KEY (idMarca) REFERENCES Tbl_Marca(idMarca); 

ALTER TABLE Tbl_Detalle_Pedidos  /*DETALLE PEDIDO - PRODUCTOS */
ADD FOREIGN KEY (idProducto) REFERENCES Tbl_Productos (idProductos);

ALTER TABLE Tbl_Detalle_Pedidos  /* DETALLE_PEDIDO PEDIDO*/
ADD FOREIGN KEY (idPedido) REFERENCES Tbl_Pedidos (idPedidos);

ALTER TABLE Tbl_Pedidos /*PEDIDO - EMPLEADO*/
ADD FOREIGN KEY (idEmpleado) REFERENCES Tbl_Empleado (idEmpleado);

ALTER TABLE Tbl_Empleado /*EMPLEADO - CARGO*/
ADD FOREIGN KEY (idCargo) REFERENCES Tbl_Cargo (idCargo);

ALTER TABLE Tbl_HorarioEmpleado /*HORARIO EMPLEADO - EMPLEADO*/
ADD FOREIGN KEY (idEmpleado) REFERENCES Tbl_Empleado(idEmpleado);

ALTER TABLE Tbl_Cliente /*CLIENTE - USUARIOO*/
ADD FOREIGN KEY (idUsuario) REFERENCES Tbl_Usuario (idUsuario);

ALTER TABLE Tbl_Empleado /*EMPLEADO - USUARIO */
ADD FOREIGN KEY (idUsuario) REFERENCES Tbl_Usuario (idUsuario);


/*Iniciar Sesion*/
DELIMITER @@ 
create procedure InicioSesion(
Usu varchar(100),
Con varchar(100),
out Verdad bit
)
sp:Begin
    Declare exiteUsuario int;
    set exiteUsuario = (Select count(*) from Tbl_Usuario where Usuario = Usu and Contraseña = Con);
    if exiteUsuario = 0 THEN
       SET Verdad = 0;
       leave sp;
	else
       SET Verdad = 1;
       leave sp;
    end if;
End @@
DELIMITER ;

/*Registrar Cliente*/
DELIMITER @@
CREATE PROCEDURE RegistrarCliente(
Nom Varchar(50),
Ape varchar(50),
Tel varchar(50),
Usu varchar(100),
Con varchar(100)
)
sp:Begin
    Declare IdUs,numeroFilas,NumeroUsuario int;
    declare Codigo,Mensaje varchar(50);
    set Codigo = (select Concat('CLI',Right(Concat('00000000',convert(((max(substring(idCliente,4,8))*1)+1),varchar(10))),8)) as Codigo from Tbl_Cliente);
    set numeroFilas = (select count(*) from Tbl_Cliente);
    set Mensaje = "Usuario Ya Existe. Por Favor, Eliga Otro Usuario";
    set NumeroUsuario = (select count(*) from Tbl_Usuario where usuario = usu and contraseña = Con and TipoUsuario = "CLI" Limit 1);
    if numeroFilas = 0  then  
               Insert Into Tbl_Usuario(Usuario,Contraseña,TipoUsuario) values(Usu,Con,"CLI");
               set idUs = (Select idUsuario from  Tbl_Usuario where Usuario = Usu and Contraseña=Con and TipoUsuario = "CLI" Limit 1);
               Insert Into Tbl_Cliente(idCliente,Nombres,Apellido,Telefono,idUsuario) values ("CLI00000001",Nom,Ape,Tel,idUs);
    elseif numeroFilas > 0 and NumeroUsuario = 0 then 
			   Insert Into Tbl_Usuario(Usuario,Contraseña,TipoUsuario) values(Usu,Con,"CLI");
			   set idUs = (Select idUsuario from  Tbl_Usuario where Usuario = Usu and Contraseña=Con and TipoUsuario = "CLI" Limit 1);
			   Insert Into Tbl_Cliente(idCliente,Nombres,Apellido,Telefono,idUsuario) values (Codigo,Nom,Ape,Tel,idUs);
	else 
        select Mensaje;
        leave sp;
    end if;
End @@
DELIMITER ;

/*Registrar Cargo*/
DELIMITER @@
CREATE PROCEDURE RegistrarCargo(
Descrip varchar(100),
out valor bit
)
sp:Begin
Declare Filas int;
set Filas = (Select count(*) From Tbl_Cargo where Descripcion = Descrip );
if Filas = 0 then 
    insert into Tbl_Cargo(Descripcion) value(Descrip);
    set valor = 1;
    leave sp;
else 
	set valor = 0;
    leave sp; 
end if;
End @@
DELIMITER ;

/*Registrar Empleado*/
DELIMITER @@
CREATE PROCEDURE RegistrarEmpleado(
Nom Varchar(50),
Ape varchar(50),
dni int,
Nac date,
tel varchar(50),
cor varchar(100),
idCar int,
usu varchar(100),
Con varchar(100)
)
sp:Begin
    Declare IdUs,numeroFilas,NumeroUsuario int;
    declare Codigo,Mensaje varchar(50);
    set Codigo = (select Concat('EMP',Right(Concat('00000000',convert(((max(substring(idEmpleado,4,8))*1)+1),varchar(10))),8)) as Codigo from Tbl_Empleado);
    set numeroFilas = (select count(*) from Tbl_Empleado);
    set Mensaje = "Usuario Ya Existe. Por Favor, Eliga Otro Usuario";
    set NumeroUsuario = (select count(*) from Tbl_Usuario where usuario = usu and contraseña = Con and TipoUsuario = "EMP" Limit 1);
    if numeroFilas = 0  then  
               Insert Into Tbl_Usuario(Usuario,Contraseña,TipoUsuario) values(Usu,Con,"EMP");
               set idUs = (Select idUsuario from  Tbl_Usuario where Usuario = Usu and Contraseña=Con and TipoUsuario = "EMP" Limit 1);
               Insert Into Tbl_Empleado(idEmpleado,nombres,apellidos,dni,nacimiento,telefono,correo,idCargo,idUsuario) values ("EMP00000001",Nom,Ape,dni,Nac,Tel,cor,idCar,idUs);
    elseif numeroFilas > 0 and NumeroUsuario = 0 then 
			   Insert Into Tbl_Usuario(Usuario,Contraseña,TipoUsuario) values(Usu,Con,"EMP");
			   set idUs = (Select idUsuario from  Tbl_Usuario where Usuario = Usu and Contraseña=Con and TipoUsuario = "EMP" Limit 1);
			   Insert Into Tbl_Empleado(idEmpleado,nombres,apellidos,dni,nacimiento,telefono,correo,idCargo,idUsuario) values (Codigo,Nom,Ape,dni,Nac,Tel,cor,idCar,idUs);
	else 
        select Mensaje;
        leave sp;
    end if;
End @@
DELIMITER ;















CALL RegistrarCliente("Yaneli Elvita","Carpio Arevalo","970271929","ADMIN4","12345",@mensaje);


select * from Tbl_Cliente;


/*Reinicar El auto_Increment de la tabla*/
alter table Tbl_Usuario AUTO_INCREMENT=1;




