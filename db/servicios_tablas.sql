-- Tabla de Servicios
CREATE TABLE servicios (
    id_servicio INT CONSTRAINT pk_servicios PRIMARY KEY, -- identificacion interna de la base de datos
    nombre_servicio VARCHAR2(100), -- nombre del servicio ofrecido
    descripcion CLOB, -- descripcion detallada del servicio
    precio DECIMAL(10,2), -- costo del servicio
    duracion_minutos INT -- duracion estimada del servicio en minutos
);

-- Tabla de Productos
CREATE TABLE productos (
    id_producto INT CONSTRAINT pk_productos PRIMARY KEY, -- identificacion interna de la base de datos
    nombre_producto VARCHAR2(100), -- nombre del producto
    categoria VARCHAR2(100), -- categoria del producto
    precio DECIMAL(10,2), -- precio del producto
    stock INT -- cantidad disponible en inventario
);

-- Tabla de Relación entre Servicios y Productos
-- Tabla de Relación entre Servicios y Productos
CREATE TABLE servicios_productos (
    id_producto INT CONSTRAINT fk_servicios_productos REFERENCES productos(id_producto), -- referencia a la tabla de productos
    citas_servicios_id_cita_servicio INT CONSTRAINT fk_servicios_productos_citas_servicios REFERENCES citas_tablas.citas_servicios(id_cita_servicio), -- referencia a la tabla de citas_servicios en el esquema citas_tablas
    cantidad_consumida INT, -- cantidad del producto consumido
    CONSTRAINT pk_servicios_productos PRIMARY KEY (id_producto, citas_servicios_id_cita_servicio) -- clave primaria compuesta
);

-- Otorgar permiso REFERENCES para la tabla servicios
GRANT REFERENCES ON servicios_tablas.servicios TO citas_tablas;