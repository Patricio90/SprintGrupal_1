create schema telovendov2;
--------------------------------------------------------------
use telovendov2;
---------------------------------------------------------------
CREATE TABLE cliente(
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NULL,
  apellido VARCHAR(45) NULL,
  direccion TEXT NULL,
  PRIMARY KEY (id));

select * from cliente;
---------------------------------------------------------------
CREATE TABLE categoria(
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NULL,
  PRIMARY KEY (id));
  
  select * from categoria;
----------------------------------------------------------------
CREATE TABLE proveedor (
  id INT NOT NULL AUTO_INCREMENT,
  nombreCorporativo VARCHAR(45) NULL,
  nombreRepresentante VARCHAR(45) NULL,
  correo VARCHAR(45) NULL,
  id_categoria INT NULL,
  PRIMARY KEY (id),
  INDEX rela_prove_categoria_idx (id_categoria ASC) VISIBLE,
  CONSTRAINT rela_prove_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES telovendov2.categoria (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

select * from proveedor;
---------------------------------------------------------------------------------
CREATE TABLE telefonos_proveedor (
  id INT NOT NULL AUTO_INCREMENT,
  id_proveedor INT NULL,
  numero VARCHAR(45) NULL,
  nombreReceptor VARCHAR(45) NULL,
  PRIMARY KEY (id),
  INDEX rela_numero_proveedor_idx (id_proveedor ASC) VISIBLE,
  CONSTRAINT rela_numero_proveedor
    FOREIGN KEY (id_proveedor)
    REFERENCES telovendov2.proveedor (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
    
select * from telefonos_proveedor;
    
----------------------------------------------------------------------
CREATE TABLE producto (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NULL,
  precio INT NULL,
  color VARCHAR(45) NULL,
  stock INT NULL,
  id_proveedor INT NULL,
  PRIMARY KEY (id),
  INDEX rela_proveedor_productos_idx (id_proveedor ASC) VISIBLE,
  CONSTRAINT rela_proveedor_productos
    FOREIGN KEY (id_proveedor)
    REFERENCES telovendov2.proveedor (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

select * from producto;
-----------------------------------------------------------------------------------
/*Ingreso de categorias*/
INSERT INTO categoria (nombre) VALUES ('SW');
INSERT INTO categoria (nombre) VALUES ('Audio-Sonido');
INSERT INTO categoria (nombre) VALUES ('Consolas');
INSERT INTO categoria (nombre) VALUES ('Redes');
INSERT INTO categoria (nombre) VALUES ('Servidores');
INSERT INTO categoria (nombre) VALUES ('Alamcenamiento');
INSERT INTO categoria (nombre) VALUES ('Energia');
INSERT INTO categoria (nombre) VALUES ('PCs');
INSERT INTO categoria (nombre) VALUES ('Telefonos');
INSERT INTO categoria (nombre) VALUES ('Portatiles');

select * from categoria;
------------------------------------------------------------------------------------------
/*Ingreso de clientes*/
insert into cliente (nombre, apellido, direccion) values 
('Juan','Perez','Su casa'),('Pedro','Contreras','Su casa'),('Matias','Urra','Su casa'),('Maria','Sanchez','Su casa'),('Juana','Sandoval','Su casa');

select * from cliente;
---------------------------------------------------------------------------------------------------------------------------------
/*Se inserta provreedores*/
insert into proveedor
(nombreCorporativo, nombreRepresentante, correo, id_categoria)
values
('Miguel LTDA.','Miguel','sucorreo@gmail.com',3),
('Jean LTDA.','Jean','sucorreo@gmail.com',5),
('Simon LTDA.','Simon','sucorreo@gmail.com',1),
('Jose LTDA.','Jose','sucorreo@gmail.com',2),
('Gonzalo LTDA.','Gonzalo','sucorreo@gmail.com',3);
insert into proveedor
(nombreCorporativo, nombreRepresentante, correo, id_categoria)
values
('Pedro LTDA.','Pedro','sucorreo@gmail.com',4),
('Roman LTDA.','Roman','sucorreo@gmail.com',6);
select * from proveedor;
------------------------------------------------------------------------
insert into producto
(nombre, precio, color, stock, id_proveedor)
values
('Samsung A21',140000,'Rosado',12,5),
('Router Cisco sl200',300000,'Rosado',3,4),
('SSD Corsair',140000,'Rosado',50,7),
('PS4',350000,'Negra',5,1),
('PS5',800000,'Verde',1,1),
('Office 365',100000,'Rojo',30,3),
('Windows 10',200000,'Azul',20,3),
('HP prolian 389',1200000,'Plomo',8,3),
('Audifonos Logitech',40000,'Amarillo',9,4),
('Audifonos Razer',50000,'Rojo',20,4);

select * from producto;
--------------------------------------------------------------------------------------
/* Crear tablas agregadas por consenso de los grupos */

CREATE TABLE IF NOT EXISTS vendedor (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS pedido (
  id INT NOT NULL AUTO_INCREMENT,
  fecha DATETIME NULL DEFAULT NULL,
  id_vendedor INT NULL DEFAULT NULL,
  id_cliente INT NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX rela_pedido_vende_idx (id_vendedor ASC) VISIBLE,
  INDEX rela_pedido_cliente_idx (id_cliente ASC) VISIBLE,
  CONSTRAINT rela_pedido_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES cliente (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT rela_pedido_vende
    FOREIGN KEY (id_vendedor)
    REFERENCES vendedor (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS detalle_pedido (
  id INT NOT NULL AUTO_INCREMENT,
  id_pedido INT NULL DEFAULT NULL,
  id_produ INT NULL DEFAULT NULL,
  cant INT NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX rela_detalle_pedido_idx (id_pedido ASC) VISIBLE,
  INDEX rel_pedido_produ_idx (id_produ ASC) VISIBLE,
  CONSTRAINT rel_pedido_produ
    FOREIGN KEY (id_produ)
    REFERENCES producto (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT rela_detalle_pedido
    FOREIGN KEY (id_pedido)
    REFERENCES pedido (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



select count(c.nombre),c.nombre as categoria from producto as p
inner join proveedor as provee on p.id_proveedor=provee.id
inner join categoria as c on c.id=provee.id_categoria
group by c.nombre;
------------------------------------------------------------------------------------------
select nombre,stock from producto as pro where stock = (select max(stock) from producto as pro);
--------------------------------------------------------------------------------------
select count(color), color from producto
group by color
limit 1;
-------------------------------------------------------------------------------------------
select prove.nombrecorporativo,p.stock from producto as p
inner join proveedor as prove on p.id_proveedor=prove.id
where p.stock = (select min(stock) from producto as pro);
--------------------------------------------------------------------------------------------

 update categoria set nombre='Electrónica y computación' where id in(select popular from
(select c.id as popular ,count(c.nombre) as cant from producto as p
inner join proveedor as provee on p.id_proveedor=provee.id
inner join categoria as c on c.id=provee.id_categoria
group by c.nombre,c.id) as c
where popular in (select max(cant) from (select c.id as popular ,count(c.nombre) as cant from producto as p
inner join proveedor as provee on p.id_proveedor=provee.id
inner join categoria as c on c.id=provee.id_categoria
group by c.nombre,c.id) as c2
 )
 )


