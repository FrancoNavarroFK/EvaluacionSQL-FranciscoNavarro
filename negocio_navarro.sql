CREATE schema IF NOT EXISTS negocio_navarro;
-- comienzo creando mi schema

CREATE table `negocio_navarro`.`tipoDeProductos` (
`tipoDeProductos_id` int NOT NULL auto_increment,
`nombreCategoria` varchar(15) NOT NULL,
PRIMARY KEY (`tipoDeProductos_id`)
);

CREATE table `negocio_navarro`.`producto` (
`producto_id` int NOT NULL auto_increment,
`nombreProducto` varchar(25) NOT NULL,
`precio` int NOT NULL,
`stock` int NOT NULL,
primary key (`producto_id`) 
);

CREATE TABLE `negocio_navarro`.`proveedores` (
`proveedores_id` int NOT NULL auto_increment,
`nombreProveedor` varchar(20) NOT NULL,
`nombrePersonaProveedor` varchar(20) NOT NULL,
`teléfono` int NOT NULL,
`correo` varchar(25) NOT NULL,
`precioProveedor` int NOT NULL,
primary key (`proveedores_id`)
);

CREATE TABLE negocio_navarro.efectivoODigital (
efectivoODigital_id int NOT NULL auto_increment,
nombre varchar(20) NOT NULL,
otrosDetalles varchar(20) NOT NULL,
primary key (efectivoODigital_id)
);

CREATE TABLE negocio_navarro.boletaCarroCompra (
boletaCarroCompra_id int NOT NULL auto_increment,
fecha date NOT NULL,
nombre varchar(20) NOT NULL,
primary key (boletaCarroCompra_id)
);

-- Aquí haremos la foreign key de tipo de producto que va dentro de la tabla producto
ALTER TABLE negocio_navarro.producto ADD tipoDeProductos_id INT NOT NULL;
ALTER TABLE negocio_navarro.producto ADD CONSTRAINT productoCategoria foreign key (tipoDeProductos_id) references negocio_navarro.tipodeproductos(tipoDeProductos_id);
-- -------------------------------------------------------------------------------

-- Aquí haremos la foreign key de producto_id que va dentro de proveedores
ALTER TABLE negocio_navarro.proveedores ADD producto_id INT NOT NULL;
ALTER TABLE negocio_navarro.proveedores ADD CONSTRAINT productoProveedores foreign key (producto_id) references negocio_navarro.producto(producto_id);
-- --------------------------------------------------------------------------------

-- Aquí haremos la foreign key de efectivoODigital_id que va dentor de la tabla boletaCarroCompra
ALTER TABLE negocio_navarro.boletacarrocompra ADD efectivoODigital_id INT NOT NULL;
ALTER TABLE negocio_navarro.boletacarrocompra ADD constraint boletatipodepago foreign key (efectivoODigital_id) references negocio_navarro.efectivoodigital(efectivoODigital_id);
-- ----------------------------------------------------------------

-- Aquí crearemos una tabla relacional, pero que tiene una primary key compuesta (incluye una fk), además se crea todo de un viaje las foreign key con sus contraints, no se editan posteriormente con el alter table
CREATE TABLE negocio_navarro.detalleCantidad (
detalleCantidad_id int NOT NULL auto_increment,
boletaCarroCompra_id int,
producto_id int,
cantidad int NOT NULL,
precio int NOT NULL,
PRIMARY KEY (detalleCantidad_id, boletaCarroCompra_id),
CONSTRAINT boletaDetalle FOREIGN KEY (boletaCarroCompra_id) REFERENCES negocio_navarro.boletacarrocompra(boletaCarroCompra_id),
constraint productoDetalle foreign key (producto_id) references negocio_navarro.producto(producto_id)
);

-- AÑADIR VALORES EN TIPO DE PRODUCTOS -----------------------------------------
USE negocio_navarro; 

INSERT INTO tipodeproductos (nombreCategoria)
VALUES ('Bebidas'), ('Chocolates'), ('Cigarros'), ('Casero');
SELECT * FROM negocio_navarro.tipodeproductos;

-- AÑADIR VALORES EN PRODUCTOS -----------------------------------------
INSERT INTO producto (nombreProducto,precio,stock,tipoDeProductos_id)
VALUES ('CocaCola 3L', 2500, 50, 1 ), ('CocaCola 1.5L', 1500, 80, 1 ), ('Malboro Ice', 2500, 50, 1 ), ('Sahne Nuss 250gr', 5500, 10, 2 ), ('Trozo Queque', 500, 15, 4 );
UPDATE producto SET tipoDeProductos_id = 3
  WHERE producto_id = 3;
SELECT * FROM negocio_navarro.producto;

-- AÑADIR VALORES A LAS OTRAS TABLAS -----------------------------------
INSERT INTO efectivoodigital (nombre,otrosdetalles)
VALUES ('efectivo', '-' ), ('débito', 'transback' ), ('transferencia', 'cuenta jaime' );
SELECT * FROM negocio_navarro.efectivoodigital;

INSERT INTO boletacarrocompra (fecha,nombre,efectivoodigital_id)
-- aquí añadimos una compra realizada en 2021 para poder ocupar el llamado de datos con filtro de fecha BETWEEN
VALUES (20221111, 'compra2cocas', 3 ), ('20220101', '5cocas', 1 ), ('20211229', '1coca', 2 ), (20221211, 'compra8cocas3L', 3 );
SELECT * FROM negocio_navarro.boletacarrocompra;


INSERT INTO detallecantidad (boletacarrocompra_id, producto_id, cantidad, precio)
  VALUES (1, 1, 2, 2500), (1, 3, 1, 3000), (2,2,5,1500), (3,1,1,2500), (4,1,8,2600);
  SELECT * FROM negocio_navarro.detallecantidad;
  


INSERT INTO proveedores (nombreProveedor, nombrePersonaProveedor, teléfono, correo, precioProveedor, producto_id)
-- tendremos dos proveedores de cocas de 1.5 litros, la de la feria y la de cocacola company
  VALUES ('CocacolaCompany', 'Juan', 55555555, 'juancoca@gmail.com', 1800, 1), ('CocaFeria', 'Sashita', 55555551, '-', 700, 2), ('CocacolaCompany', 'Juan', 55555555, 'juancoca@gmail.com', 900, 2);
  SELECT * FROM negocio_navarro.proveedores;
  
  -- -------------------------------------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------------
  -- -------------------------------------------------------- PARTE FINAL-----------------------------
  -- llamar datos con JOIN
  -- Aquí ocurre un problema de duplicación de datos porque un producto tiene 2 proveedores --
  -- una solución sería que en detalle boleta también se inserte la FK del proveedor 
  -- otra solución es que sean productos distintos, coca de 1.5L-feria, y coca 1.5L-cocacompany
  SELECT detallecantidad.boletaCarroCompra_id, detallecantidad_id, fecha, nombreProducto, cantidad, detallecantidad.precio, precioProveedor
    FROM detallecantidad CROSS JOIN producto ON (detallecantidad.producto_id=producto.producto_id)
  CROSS JOIN proveedores ON (producto.producto_id=proveedores.producto_id)
  CROSS JOIN boletacarrocompra ON (detallecantidad.boletaCarroCompra_id=boletacarrocompra.boletaCarroCompra_id);
  
  -- omitiremos el problema de los proveedores, solo sumando las ventas de cocas de 3litros que tiene un solo proveedor
  -- queremos ver las cantidad de ventas (COUNT) de cocacola 3L en 2022, y las ganancias (SUMA)
  
  #para contar cuantos resultados trae mi consulta, haremos SUM, porque COUNT me trae 2 compras, pero se compraron 3 bebidas (1 compra tiene 2 bebidas)
  # --------------- tabla de cocacolas3L compradas en 2022 --------------------
  SELECT detallecantidad.boletaCarroCompra_id, detallecantidad_id, fecha, nombreProducto, cantidad, detallecantidad.precio, precioProveedor
    FROM detallecantidad CROSS JOIN producto ON (detallecantidad.producto_id=producto.producto_id)
  CROSS JOIN proveedores ON (producto.producto_id=proveedores.producto_id)
  CROSS JOIN boletacarrocompra ON (detallecantidad.boletaCarroCompra_id=boletacarrocompra.boletaCarroCompra_id)
  #aquí aplicamos filtro de solo el año 2022
  WHERE 
  (producto.producto_id = 1)
  AND (boletacarrocompra.fecha BETWEEN '20220101' AND '20221231');
  # --------------------------------------------------------------------------------
  # --------------------------------------------------------------------------------
  
  # -------------- Sumamos todas las cocas3L vendidas en 2022 con SUM ------------------
  SELECT nombreProducto, detallecantidad.precio, precioProveedor, sum(detallecantidad.cantidad), count(detallecantidad.cantidad)
    FROM detallecantidad CROSS JOIN producto ON (detallecantidad.producto_id=producto.producto_id)
  CROSS JOIN proveedores ON (producto.producto_id=proveedores.producto_id)
  CROSS JOIN boletacarrocompra ON (detallecantidad.boletaCarroCompra_id=boletacarrocompra.boletaCarroCompra_id)
  #aquí aplicamos filtro de solo el año 2022
  WHERE 
  (producto.producto_id = 1)
  AND (boletacarrocompra.fecha BETWEEN '20220101' AND '20221231');
  
  # --------------- Calcular ganancias ----------------------
  # restamos precio - precioProveedor, y multiplicamos por SUM
  SELECT nombreProducto, detallecantidad.precio, precioProveedor, sum(detallecantidad.cantidad), ((detallecantidad.precio-precioProveedor)*sum(detallecantidad.cantidad))
    FROM detallecantidad CROSS JOIN producto ON (detallecantidad.producto_id=producto.producto_id)
  CROSS JOIN proveedores ON (producto.producto_id=proveedores.producto_id)
  CROSS JOIN boletacarrocompra ON (detallecantidad.boletaCarroCompra_id=boletacarrocompra.boletaCarroCompra_id)
  #aquí aplicamos filtro de solo el año 2022
  WHERE 
  (producto.producto_id = 1)
  AND (boletacarrocompra.fecha BETWEEN '20220101' AND '20221231');
  # --
  -- Al final nos da la ganancia de todas las cocacola3L vendidas en el año 2022
  
  # -------------------------------------------------------------------------------------
  # ------------------------------ EL FIN -----------------------------------------------
  # -------------------------------------------------------------------------------------
  

  