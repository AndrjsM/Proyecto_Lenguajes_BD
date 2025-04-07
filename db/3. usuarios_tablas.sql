-- Tabla de Clientes
CREATE TABLE clientes (
    id_cliente INT CONSTRAINT pk_clientes PRIMARY KEY, -- identificacion interna de la base de datos
    didentidad_cliente VARCHAR2(20), -- se agrega este campo ya que se requiere una identificacion valida para el usaurio y no se puede usar el id_cliente como tal
    nombre VARCHAR2(100),
    apellido VARCHAR2(100),
    email VARCHAR2(100) CONSTRAINT uq_clientes_email UNIQUE,
    telefono VARCHAR2(15),
    direccion VARCHAR2(255),
    fecha_registro DATE
);

-- Tabla de Mascotas
CREATE TABLE mascotas (
    id_mascota INT CONSTRAINT pk_mascotas PRIMARY KEY, -- identificacion interna de la base de datos
    id_cliente INT CONSTRAINT fk_mascotas_clientes REFERENCES clientes(ID_Cliente), -- se agrega este campo ya que se requiere una identificacion valida para el usaurio y no se puede usar el id_cliente como tal
    nombre VARCHAR2(100),
    especie VARCHAR2(50),
    raza VARCHAR2(50),
    meses INT,
    historial_medica CLOB
);

-- Tabla de Veterinarios
CREATE TABLE veterinarios (
    id_veterinario NUMBER(10) CONSTRAINT pk_veterinarios PRIMARY KEY, -- identificacion interna de la base de datos
    didentidad_veterinario VARCHAR2(20), -- se agrega este campo ya que se requiere una identificacion valida para el usaurio y no se puede usar el id_veterinario como tal
    nombre VARCHAR2(100),
    especialidad VARCHAR2(100),
    telefono VARCHAR2(15),
    correo VARCHAR2(100) CONSTRAINT uq_veterinarios_correo UNIQUE,
    rol VARCHAR2(20)
);

-- Otorgar permiso REFERENCES para la tabla mascotas
GRANT REFERENCES ON usuarios_tablas.mascotas TO citas_tablas;

-- Otorgar permiso REFERENCES para la tabla veterinarios
GRANT REFERENCES ON usuarios_tablas.veterinarios TO citas_tablas;

-- Tabla de Usuarios
CREATE TABLE usuarios (
    id_usuario INT CONSTRAINT pk_usuarios PRIMARY KEY, -- Identificación interna de la base de datos
    id_cliente INT CONSTRAINT fk_usuarios_clientes REFERENCES clientes(id_cliente), -- Relación con la tabla de clientes
    correo VARCHAR2(100) CONSTRAINT uq_usuarios_correo UNIQUE, -- Correo único para el usuario
    contrasena VARCHAR2(255) -- Contraseña encriptada
);

-- Otorgar permisos al usuario progra para las tablas de usuarios_tablas
GRANT INSERT ON usuarios_tablas.clientes TO progra;
GRANT INSERT ON usuarios_tablas.usuarios TO progra;