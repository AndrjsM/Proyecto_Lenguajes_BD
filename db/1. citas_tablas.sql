-- Tabla de Citas
CREATE TABLE citas (
    id_cita INT CONSTRAINT pk_citas PRIMARY KEY, -- identificacion interna de la base de datos
    id_mascota INT CONSTRAINT fk_citas_mascotas REFERENCES usuarios_tablas.mascotas(id_mascota), -- referencia a la tabla de mascotas en usuarios_tablas
    id_veterinario INT CONSTRAINT fk_citas_veterinarios REFERENCES usuarios_tablas.veterinarios(id_veterinario), -- referencia a la tabla de veterinarios en usuarios_tablas
    fecha_cita DATE, -- fecha programada para la cita
    estado VARCHAR2(20) -- estado de la cita (ejemplo: pendiente, completada, cancelada)
);

-- Tabla de Facturas
CREATE TABLE facturas (
    id_factura INT CONSTRAINT pk_facturas PRIMARY KEY, -- identificacion interna de la factura
    fecha_factura DATE, -- fecha de emision de la factura
    total DECIMAL(10,2) -- monto total de la factura
);

-- Tabla de Relación entre Citas y Servicios
CREATE TABLE citas_servicios (
    id_cita_servicio INT CONSTRAINT pk_citas_servicios PRIMARY KEY, -- identificacion interna de la relacion
    id_cita INT CONSTRAINT fk_citas_servicios_citas REFERENCES citas(id_cita), -- referencia a la tabla de citas
    id_servicio INT CONSTRAINT fk_citas_servicios_servicios REFERENCES servicios_tablas.servicios(id_servicio), -- referencia a la tabla de servicios
    facturas_id_factura INT CONSTRAINT fk_citas_servicios_facturas REFERENCES facturas(id_factura) -- referencia a la tabla de facturas
);


-- Otorgar permiso REFERENCES para la tabla servicios
GRANT REFERENCES ON citas_tablas.citas_servicios TO servicios_tablas;

-- Otorgar permisos al usuario progra para las tablas de citas_tablas
GRANT INSERT, UPDATE ON citas_tablas.citas TO progra;
GRANT INSERT, UPDATE ON citas_tablas.citas_servicios TO progra;
GRANT INSERT ON citas_tablas.facturas TO progra;
GRANT REFERENCES ON citas_tablas.citas TO progra;
GRANT REFERENCES ON citas_tablas.facturas TO progra;
