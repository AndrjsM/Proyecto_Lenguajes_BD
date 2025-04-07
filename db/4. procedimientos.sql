-- Función para verificar si un cliente existe
CREATE OR REPLACE FUNCTION existeCliente(p_ID_Cliente IN NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM usuarios_tablas.clientes
    WHERE id_cliente = p_ID_Cliente;

    RETURN v_count > 0;
END;
/

-- Función para verificar si una mascota existe
CREATE OR REPLACE FUNCTION existeMascota(p_ID_Mascota IN NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM usuarios_tablas.mascotas
    WHERE id_mascota = p_ID_Mascota;

    RETURN v_count > 0;
END;
/

-- Función para verificar si una mascota pertenece a un cliente
CREATE OR REPLACE FUNCTION mascotaPerteneceACliente(p_ID_Mascota IN NUMBER, p_ID_Cliente IN NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM usuarios_tablas.mascotas
    WHERE id_mascota = p_ID_Mascota AND id_cliente = p_ID_Cliente;

    RETURN v_count > 0;
END;
/

-- Función para verificar si una mascota tiene una cita activa
CREATE OR REPLACE FUNCTION mascotaTieneCitaActivaNowMismoServicio(p_ID_Mascota IN NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM citas_tablas.citas
    WHERE id_mascota = p_ID_Mascota AND estado = 'Activa';

    RETURN v_count > 0;
END;
/

-- Función para verificar si un veterinario existe
CREATE OR REPLACE FUNCTION existeVeterinario(p_ID_Veterinario IN NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM usuarios_tablas.veterinarios
    WHERE id_veterinario = p_ID_Veterinario;

    RETURN v_count > 0;
END;
/

-- Función para verificar si un veterinario está disponible
CREATE OR REPLACE FUNCTION veterinarioDisponible(p_ID_Veterinario IN NUMBER, p_Fecha_Cita IN DATE) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM citas_tablas.citas
    WHERE id_veterinario = p_ID_Veterinario
      AND fecha_cita = p_Fecha_Cita
      AND estado = 'Activa';

    RETURN v_count = 0; -- Devuelve TRUE si no hay citas activas en esa fecha
END;
/

-- Función para verificar si un servicio existe
CREATE OR REPLACE FUNCTION existeServicio(p_ID_Servicio IN NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM servicios_tablas.servicios
    WHERE id_servicio = p_ID_Servicio;

    RETURN v_count > 0;
END;
/

-- Función para verificar si un servicio requiere productos
CREATE OR REPLACE FUNCTION servicioRequiereProductos(p_ID_Servicio IN NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM servicios_tablas.productos
    WHERE id_producto IN (
        SELECT id_producto
        FROM servicios_tablas.servicios_productos
        WHERE id_servicio = p_ID_Servicio
    );

    RETURN v_count > 0;
END;
/

-- Función para verificar si un producto existe
CREATE OR REPLACE FUNCTION existeProducto(p_ID_Producto IN NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM servicios_tablas.productos
    WHERE id_producto = p_ID_Producto;

    RETURN v_count > 0;
END;
/

-- Función para insertar una cita
CREATE OR REPLACE FUNCTION insertarCita(
    p_ID_Mascota IN NUMBER,
    p_ID_Veterinario IN NUMBER,
    p_Fecha_Cita IN DATE,
    p_Estado IN VARCHAR2
) RETURN NUMBER IS
    v_ID_Cita NUMBER;
BEGIN
    INSERT INTO citas_tablas.citas (id_mascota, id_veterinario, fecha_cita, estado)
    VALUES (p_ID_Mascota, p_ID_Veterinario, p_Fecha_Cita, p_Estado)
    RETURNING id_cita INTO v_ID_Cita;

    RETURN v_ID_Cita;
END;
/

-- Función para insertar un servicio asociado a una cita
CREATE OR REPLACE FUNCTION insertarCitaServicio(
    p_ID_Cita IN NUMBER,
    p_ID_Servicio IN NUMBER
) RETURN NUMBER IS
    v_ID_Cita_Servicio NUMBER;
BEGIN
    INSERT INTO citas_tablas.citas_servicios (id_cita, id_servicio)
    VALUES (p_ID_Cita, p_ID_Servicio)
    RETURNING id_cita_servicio INTO v_ID_Cita_Servicio;

    RETURN v_ID_Cita_Servicio;
END;
/

-- Procedimiento para agendar una cita
CREATE OR REPLACE PROCEDURE agendarCita(
    p_ID_Cliente IN NUMBER,
    p_ID_Mascota IN NUMBER,
    p_ID_Veterinario IN NUMBER,
    p_Fecha_Cita IN DATE,
    p_Servicios IN SYS.ODCINUMBERLIST -- Lista de IDs de servicios
) AS
    v_ID_Cita NUMBER;
    v_ID_Factura NUMBER;
    v_idCitaServicio NUMBER;
    v_Total NUMBER;
BEGIN
    -- Validar cliente
    IF NOT existeCliente(p_ID_Cliente) THEN
        RAISE_APPLICATION_ERROR(-20001, 'El cliente no existe');
    END IF;

    -- Validar mascota
    IF NOT existeMascota(p_ID_Mascota) THEN
        RAISE_APPLICATION_ERROR(-20002, 'La mascota no existe');
    END IF;

    IF NOT mascotaPerteneceACliente(p_ID_Mascota, p_ID_Cliente) THEN
        RAISE_APPLICATION_ERROR(-20003, 'La mascota no pertenece al cliente');
    END IF;

    -- Validar si la mascota ya tiene una cita activa
    IF mascotaTieneCitaActivaNowMismoServicio(p_ID_Mascota) THEN
        RAISE_APPLICATION_ERROR(-20004, 'La mascota ya tiene una cita activa a la misma hora');
    END IF;

    -- Validar veterinario
    IF NOT existeVeterinario(p_ID_Veterinario) THEN
        RAISE_APPLICATION_ERROR(-20005, 'El veterinario no existe');
    END IF;

    -- Validar disponibilidad del veterinario
    IF NOT veterinarioDisponible(p_ID_Veterinario, p_Fecha_Cita) THEN
        RAISE_APPLICATION_ERROR(-20006, 'El veterinario no está disponible en esa fecha y hora');
    END IF;

    -- Crear la cita
    v_ID_Cita := insertarCita(p_ID_Mascota, p_ID_Veterinario, p_Fecha_Cita, 'Activa');

    -- Registrar servicios
    FOR i IN 1..p_Servicios.COUNT LOOP
        IF NOT existeServicio(p_Servicios(i)) THEN
            RAISE_APPLICATION_ERROR(-20007, 'El servicio solicitado no es válido');
        END IF;

        v_idCitaServicio := insertarCitaServicio(v_ID_Cita, p_Servicios(i));

        -- Registrar productos si el servicio los requiere
        IF servicioRequiereProductos(p_Servicios(i)) THEN
            FOR producto IN (SELECT ID_Producto, cantidad FROM productos WHERE ID_Servicio = p_Servicios(i)) LOOP
                IF NOT existeProducto(producto.ID_Producto) THEN
                    RAISE_APPLICATION_ERROR(-20008, 'El producto con ID ' || producto.ID_Producto || ' no existe');
                END IF;

                IF producto.stock < producto.cantidad THEN
                    RAISE_APPLICATION_ERROR(-20009, 'No hay suficiente stock para el producto con ID ' || producto.ID_Producto);
                END IF;

                insertarServicioProducto(producto.ID_Producto, producto.cantidad, v_idCitaServicio);
                actualizarStock(producto.ID_Producto, producto.cantidad);
            END LOOP;
        END IF;
    END LOOP;

    -- Generar factura
    v_Total := calcularTotalServicios(v_ID_Cita);
    v_ID_Factura := insertarFactura(v_ID_Cita, v_Total);
    vincularFacturaConCita(v_ID_Cita, v_ID_Factura);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cita agendada exitosamente. ID_Cita: ' || v_ID_Cita || ', ID_Factura: ' || v_ID_Factura);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END agendarCita;
/

-- Procedimiento para registrar un cliente
CREATE OR REPLACE PROCEDURE registrarCliente(
    p_didentidad_cliente IN VARCHAR2,
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_email IN VARCHAR2,
    p_telefono IN VARCHAR2,
    p_direccion IN VARCHAR2,
    p_contrasena IN VARCHAR2
) AS
    v_ID_Cliente NUMBER;
    v_ID_Usuario NUMBER;
    v_contrasenaEncriptada VARCHAR2(255);
BEGIN
    -- Validar cédula o documento de identidad
    IF existeCedula(p_didentidad_cliente) THEN
        RAISE_APPLICATION_ERROR(-20010, 'La cédula o documento de identidad ya está registrada');
    END IF;

    -- Validar correo electrónico en la tabla de clientes
    IF existeCorreo(p_email) THEN
        RAISE_APPLICATION_ERROR(-20011, 'El correo electrónico ya está registrado');
    END IF;

    -- Validar correo electrónico en la tabla de usuarios
    IF existeCorreoUsuario(p_email) THEN
        RAISE_APPLICATION_ERROR(-20012, 'El correo electrónico ya está registrado en la tabla de usuarios');
    END IF;

    -- Encriptar la contraseña
    v_contrasenaEncriptada := encriptarContrasena(p_contrasena);

    -- Insertar cliente en la tabla de clientes
    v_ID_Cliente := insertarCliente(
        p_didentidad_cliente,
        p_nombre,
        p_apellido,
        p_email,
        p_telefono,
        p_direccion,
        SYSDATE
    );

    -- Insertar usuario en la tabla de usuarios
    v_ID_Usuario := insertarUsuario(
        p_email,
        v_contrasenaEncriptada
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cliente registrado exitosamente. ID_Cliente: ' || v_ID_Cliente || ', ID_Usuario: ' || v_ID_Usuario);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END registrarCliente;
/

SELECT * 
FROM USER_TAB_PRIVS 
WHERE GRANTEE = 'PROGRA';