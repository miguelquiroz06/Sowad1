/*Creacion de la base de datos*/
create database restaurante_sowad;

/*Uso de base de datos creada*/
use restaurante_sowad;

/*Creacion de tablas*/

create table Tbl_Productos (
idProductos varchar(100) primary key not null,
Nombre varchar(100),
Precio double,
idTipoCategoria int,
estado varchar(50)
);

create table Tbl_CategoriaProductos (
idCategoria int primary key not null AUTO_INCREMENT,
Descripcion varchar(100),
estado bit not null
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
Descripcion varchar(100),
estado bit not null
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
idUsuario int,
estado varchar(50)
);

create table Tbl_HorarioEmpleado(
idEmpleado varchar(100),
hora_entrada datetime,
hora_salida datetime
);


create table Tbl_Cargo (
idCargo int primary key not null AUTO_INCREMENT,
Descripcion varchar(50),
estado bit not null
);

create table Tbl_Usuario (
idUsuario int primary key not null AUTO_INCREMENT,
Usuario varchar(100),
Contraseña varchar(100),
TipoUsuario Varchar(10), /*Si es de clientes o empleados*/
estado varchar(50)
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
idUsuario int,
estado varchar(50)
);

create table Tbl_Combos (
     idProducto varchar(100) not null,
     idProductosContenido varchar(100) not null,
     Primary key (idProducto,idProductosContenido),
     constraint foreign key idProd (idProducto) references  Tbl_Productos(idProductos)
     on delete cascade on update cascade,
     constraint foreign key idProdCont (idProductosContenido) references Tbl_Productos(idProductos) 
     on delete cascade on update cascade
);

/*Relaciones de tablas*/

ALTER TABLE Tbl_Pedidos /*PEDIDO - CLIENTES*/
ADD FOREIGN KEY (idCliente) REFERENCES Tbl_Cliente(idCliente) 
on update cascade on delete cascade;

ALTER TABLE Tbl_Productos /*PRODUCTOS - CATEGORIA*/
ADD FOREIGN KEY (idTipoCategoria) REFERENCES Tbl_CategoriaProductos(idCategoria) 
on update cascade on delete cascade;

ALTER TABLE Tbl_IngredientesXProducto /*INGREDIENTEXPRODUCTO - PRODUCTO*/
ADD FOREIGN KEY (idProducto) REFERENCES Tbl_Productos (idProductos) 
on update cascade on delete cascade;

ALTER TABLE Tbl_IngredientesXProducto /*INGREDIENTESXPRODUCTO - INGREDIENTES*/
ADD FOREIGN KEY (idIngredientes) REFERENCES Tbl_Ingredientes(idIngredientes) 
on update cascade on delete cascade;

ALTER TABLE Tbl_Ingredientes /*INGREDIENTES-MARCA*/
ADD FOREIGN KEY (idMarca) REFERENCES Tbl_Marca(idMarca) 
on update cascade on delete cascade;

ALTER TABLE Tbl_Detalle_Pedidos  /*DETALLE PEDIDO - PRODUCTOS */
ADD FOREIGN KEY (idProducto) REFERENCES Tbl_Productos (idProductos) 
on update cascade on delete cascade;

ALTER TABLE Tbl_Detalle_Pedidos  /* DETALLE_PEDIDO PEDIDO*/
ADD FOREIGN KEY (idPedido) REFERENCES Tbl_Pedidos (idPedidos) 
on update cascade on delete cascade;

ALTER TABLE Tbl_Pedidos /*PEDIDO - EMPLEADO*/
ADD FOREIGN KEY (idEmpleado) REFERENCES Tbl_Empleado (idEmpleado) 
on update cascade on delete cascade;

ALTER TABLE Tbl_Empleado /*EMPLEADO - CARGO*/
ADD FOREIGN KEY (idCargo) REFERENCES Tbl_Cargo (idCargo) 
on update cascade on delete cascade;

ALTER TABLE Tbl_HorarioEmpleado /*HORARIO EMPLEADO - EMPLEADO*/
ADD FOREIGN KEY (idEmpleado) REFERENCES Tbl_Empleado(idEmpleado) 
on update cascade on delete cascade;

ALTER TABLE Tbl_Cliente /*CLIENTE - USUARIOO*/
ADD FOREIGN KEY (idUsuario) REFERENCES Tbl_Usuario (idUsuario) 
on update cascade on delete cascade;

ALTER TABLE Tbl_Empleado /*EMPLEADO - USUARIO */
ADD FOREIGN KEY (idUsuario) REFERENCES Tbl_Usuario (idUsuario) 
on update cascade on delete cascade;


/*-------------------------Iniciar Sesion-------------------------*/
DELIMITER @@ 
create procedure InicioSesion(
Usu varchar(100),
Con varchar(100),
out Verdad bit
)
sp:Begin
    Declare exiteUsuario int;
    set exiteUsuario = (Select count(*) from Tbl_Usuario where Usuario = Usu and Contraseña = Con);
    if exiteUsuario < 1 THEN
       SET Verdad = 0;
       leave sp;
	else
       SET Verdad = 1;
       leave sp;
    end if;
End @@
DELIMITER ;




/*-------------------------Triggers-------------------------*/

/*Codigo Cliente*/
DELIMITER @@
create trigger Cliente_Codigo
BEFORE insert on tbl_Cliente for each row
begin
declare Siguiente_Codigo int;
set Siguiente_Codigo = (select ifnull(max(Convert(substring(idCliente,8),signed integer)),0) from tbl_Cliente) + 1;
   set new.idcliente = concat('CLI',lpad(siguiente_Codigo,8,'0'));
END @@
DELIMITER ;

/*Codigo Empleado*/
DELIMITER @@
CREATE TRIGGER Empleado_Codigo
BEFORE INSERT on tbl_empleado FOR each row
begin
declare Siguiente_Codigo int;
set siguiente_Codigo = (select ifnull(max(Convert(substring(idEmpleado,8),signed integer)),0) from tbl_empleado) + 1; 
set new.idempleado = concat('EMP',lpad(siguiente_Codigo,8,'0'));
end @@
DELIMITER ;


/*PROCEDIMIENTOS ALMACENADOS*/

/*-------------------------Cliente-------------------------*/


/*Mostrar*/
DELIMITER @@
CREATE PROCEDURE cliente_Mostrar()
Begin
Select cli.idCliente,cli.Nombres,cli.Apellido,cli.Telefono,usu.Usuario,usu.contraseña
From tbl_Cliente cli 
inner join tbl_Usuario usu on cli.idUsuario = usu.idUsuario;
end @@
DELIMITER ;

/*Registrar */
DELIMITER @@
CREATE PROCEDURE Cliente_Registrar(
Nom Varchar(50),
Ape varchar(50),
Tel varchar(50),
Usu varchar(100),
Con varchar(100),
out mensaje varchar(100)
)
sp:Begin
    Declare IdUs,NumeroUsuario int;
    set Mensaje = "Usuario Ya Existe. Por Favor, Eliga Otro Usuario";
    set NumeroUsuario = (select count(*) from Tbl_Usuario where usuario = usu and contraseña = Con and TipoUsuario = "CLI" Limit 1);
    if NumeroUsuario > 0 then 
      select Mensaje;
      leave sp;
    else 
	Insert Into Tbl_Usuario(Usuario,Contraseña,TipoUsuario,Estado) values(Usu,Con,"CLI","ACTIVO");
	set idUs = (Select idUsuario from  Tbl_Usuario where Usuario = Usu and Contraseña=Con and TipoUsuario = "CLI" Limit 1);
	Insert Into Tbl_Cliente(Nombres,Apellido,Telefono,idUsuario,Estado) values (Nom,Ape,Tel,idUs,"ACTIVO");
end if;
End @@
DELIMITER ;


/*Actualizar*/
DELIMITER @@
CREATE PROCEDURE Cliente_Actualizar(
Nom Varchar(50),
Ape varchar(50),
Tel varchar(50),
Usu varchar(100),
Con varchar(100),
idCli VARCHAR(100),
out mensaje varchar(100)
)
BEGIN 
declare codigo_usu int;
set codigo_usu = (Select idUsuario from Tbl_Cliente where idCliente = idCLi);
update tbl_usuario set Usuario = Usu, Contraseña = Con where idUsuario = codigo_usu;
update tbl_Cliente set nombres = Nom, Apellido = Ape, Telefono = Tel where idCliente = idCli;
END @@
DELIMITER ;


/*Eliminar*/
DELIMITER @@
CREATE PROCEDURE Cliente_Eliminar(
    idCli varchar(50)
)
begin
declare codigo_usu int;
set codigo_usu = (Select idUsuario from Tbl_cliente where idCliente = idCli);
update tbl_usuario set Estado = "Eliminado" where idUsuario = codigo_usu;
update tbl_cliente set Estado = "Eliminado" where idCliente = idCli;
end @@
DELIMITER ;



/*-------------------------Cargo-------------------------*/

/*Mostrar*/
DELIMITER @@
create PROCEDURE cargo_Mostrar()
begin
select idCargo,Descripcion from Tbl_Cargo;
end @@
DELIMITER ;

/*Registrar*/
DELIMITER @@
CREATE PROCEDURE Cargo_Registrar(
Descrip varchar(100),
out valor bit
)
sp:Begin
Declare Filas int;
set Filas = (Select count(*) From Tbl_Cargo where Descripcion = Descrip );
if Filas < 1 then 
    insert into Tbl_Cargo(Descripcion) value(Descrip);
    set valor = 1;
    leave sp;
else 
	set valor = 0;
    leave sp; 
end if;
End @@
DELIMITER ;


/*Eliminar*/
DELIMITER @@
Create PROCEDURE Cargo_Eliminar(
idCar int
)
Begin
update Tbl_Cargo set Estado = 0 where IdCargo = idCar;
end @@
DELIMITER ;


/*-------------------------Empleado-------------------------*/

/*Mostrar*/
Select * from Tbl_Empleado ;

/*Registrar*/
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
Con varchar(100),
out Mensaje varchar(100)
)
sp:Begin
    Declare IdUs,NumeroUsuario int;
    set Mensaje = "Usuario Ya Existe. Por Favor, Eliga Otro Usuario";
    set NumeroUsuario = (select count(*) from Tbl_Usuario where usuario = usu and contraseña = Con and TipoUsuario = "EMP" Limit 1);
    if NumeroUsuario > 0 then
    select Mensaje;
    leave sp;
    else
	Insert Into Tbl_Usuario(Usuario,Contraseña,TipoUsuario,Estado) values(Usu,Con,"EMP","ACTIVO");
	set idUs = (Select idUsuario from  Tbl_Usuario where Usuario = Usu and Contraseña=Con and TipoUsuario = "EMP" Limit 1);
	Insert Into Tbl_Empleado(nombres,apellidos,dni,nacimiento,telefono,correo,idCargo,idUsuario,Estado) values (Nom,Ape,dni,Nac,Tel,cor,idCar,idUs,"ACTIVO");
end if;
End @@
DELIMITER ;


/*-------------------------Categoria Producto-------------------------Miguel*/ 

/*-------------------------Combos-------------------------Miguel*/

/*-------------------------Pedidos-------------------------Renato*/

/*-------------------------Detalle Pedidos-------------------------Renato*/

/*-------------------------HorarioEmpleado-------------------------Renato*/

/*-------------------------Ingredientes-------------------------Miguel*/ 

/*-------------------------Ingredientes X Productos-------------------------Miguel*/

/*-------------------------Marca-------------------------Renato*/

/*-------------------------Productos-------------------------Miguel*/





/*-------------------------Pruebas-------------------------*/

CALL Cliente_Registrar("Yaneli Elvita","Carpio Arevalo","970271929","ADMIN4","12345",@mensaje);

call InicioSesion("ADMIN4","12345",@vedad);

delete from tbl_usuario where idUsuario = 1;

select * from tbl_Cliente;

select * from tbl_usuario;

/*Reinicar El auto_Increment de la tabla*/
alter table Tbl_Usuario AUTO_INCREMENT=1;






