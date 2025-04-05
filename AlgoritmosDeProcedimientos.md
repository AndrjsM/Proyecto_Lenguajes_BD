# Seudoalgoritmo propuesto G7

Algoritmo para la creación de una cita en la veterinaria Patitas al Rescate.
Una solicitud de cita en la veterinaria "Patitas al Rescate" requiere recibir el
identificador del cliente, la mascota, el veterinario, la fecha y hora deseada, así
como los servicios que se desean aplicar.
Para lograr agendar su cita, primero el código valida que el cliente, la mascota y
el veterinario existan en la base de datos. El siguiente paso que se realiza es que
la mascota efectivamente pertenezca a su correspectivo dueño.
Después, se verifica que el veterinario esté disponible en la fecha y hora
indicadas (que no tenga ninguna otra cita).
Si todo está correcto, se crea la cita, se vinculan los servicios que se le van a
realizar a la mascota y se registran los productos que se utilizarán en cada
servicio.
También se actualiza el inventario, descontando los productos consumidos.
Finalmente, se puede generar una factura si el cliente así lo se desea.
Si en algún paso hay un error (por ejemplo, el veterinario no está disponible o
falta producto en inventario), se cancela la transacción y se rechaza la solicitud
para agendar citas.
agendarCita(peticion)
si existe el cliente con ID = peticion.ID_Cliente
si existe la mascota con ID = peticion.ID_Mascota
si mascota pertenece al cliente
si existe el veterinario con ID = peticion.ID_Veterinario -- Validar disponibilidad del veterinario
si el veterinario no tiene otra cita en peticion.Fecha_Cita -- Insertar cita en la tabla 'citas'
crear nueva cita con: ID_Mascota, ID_Veterinario, Fecha_Cita,
Estado = 'Activa'
obtener ID_Cita generado -- Registrar servicios en 'citas_servicios'
para cada servicio en peticion.servicios
si servicio existe
                                insertar en citas_servicios: ID_Cita, ID_Servicio
                                obtener idCitaServicio

    -- Verificar si el servicio requiere productos
                                si servicio requiere productos
                                    para cada producto necesario
                                        si producto existe y stock >= cantidad requerida
                                            insertar en servicios_productos: ID_Producto,
Cantidad_Consumida, idCitaServicio
                                            actualizar stock del producto
                                        si no
                                            cancelar transacción
                                            mostrar "No hay suficiente stock del producto"
                                    fin para
                                fin si
                            si no
                                cancelar transacción
                                mostrar "Servicio no válido"
                        fin para

    -- (Opcional) Generar factura
                        si desea generar factura
                            calcular el total sumando precios de los servicios
                            insertar en tabla facturas con la fecha y el total
                            vincular la factura con los registros en citas_servicios

    mostrar "Cita agendada exitosamente"

    si no
                        mostrar "El veterinario no está disponible en esa fecha y hora"
                si no
                    mostrar "El veterinario no existe"
            si no
                mostrar "La mascota no pertenece al cliente"
        si no
            mostrar "La mascota no existe"
    si no
        mostrar "El cliente no existe"

fin agendarCita

## Seudoalgoritmo mejorado

agendarCita(peticion)
    iniciar transacción

    -- Validar cliente
    si no existeCliente(peticion.ID_Cliente)
        devolver { exito: false, mensaje: "El cliente no existe" }
        cancelar transacción
        fin agendarCita

    -- Validar mascota
    si no existeMascota(peticion.ID_Mascota)
        devolver { exito: false, mensaje: "La mascota no existe" }
        cancelar transacción
        fin agendarCita

    si no mascotaPerteneceACliente(peticion.ID_Mascota, peticion.ID_Cliente)
        devolver { exito: false, mensaje: "La mascota no pertenece al cliente" }
        cancelar transacción
        fin agendarCita

    -- Validar veterinario
    si no existeVeterinario(peticion.ID_Veterinario)
        devolver { exito: false, mensaje: "El veterinario no existe" }
        cancelar transacción
        fin agendarCita

    si no veterinarioDisponible(peticion.ID_Veterinario, peticion.Fecha_Cita)
        devolver { exito: false, mensaje: "El veterinario no está disponible en esa fecha y hora" }
        cancelar transacción
        fin agendarCita

    -- Crear la cita
    ID_Cita = insertarCita(peticion.ID_Mascota, peticion.ID_Veterinario, peticion.Fecha_Cita, "Activa")

    -- Registrar servicios
    para cada servicio en peticion.servicios
        si no existeServicio(servicio.ID_Servicio)
            devolver { exito: false, mensaje: "El servicio solicitado no es válido" }
            cancelar transacción
            fin agendarCita

    idCitaServicio = insertarCitaServicio(ID_Cita, servicio.ID_Servicio)

    -- Registrar productos si el servicio los requiere
        si servicioRequiereProductos(servicio.ID_Servicio)
            para cada producto en servicio.productos
                si no existeProducto(producto.ID_Producto)
                    devolver { exito: false, mensaje: "El producto con ID " + producto.ID_Producto + " no existe" }
                    cancelar transacción
                    fin agendarCita

    si producto.stock < producto.cantidad
                    devolver { exito: false, mensaje: "No hay suficiente stock del producto con ID " + producto.ID_Producto }
                    cancelar transacción
                    fin agendarCita

    insertarServicioProducto(producto.ID_Producto, producto.cantidad, idCitaServicio)
                actualizarStock(producto.ID_Producto, producto.cantidad)
            fin para
        fin si
    fin para

    -- Generar factura (opcional)
    si peticion.generarFactura
        total = calcularTotalServicios(ID_Cita)
        ID_Factura = insertarFactura(ID_Cita, total)
        vincularFacturaConCita(ID_Cita, ID_Factura)

    confirmar transacción
    devolver { exito: true, mensaje: "Cita agendada exitosamente", id_cita: ID_Cita }
fin agendarCita

---

registrarCliente(peticion)

    iniciar transacción

    -- Validar cédula o documento de identidad
    si existeCedula(peticion.didentidad_cliente)
        devolver { exito: false, mensaje: "La cédula o documento de identidad ya está registrada" }
        cancelar transacción
        fin registrarCliente

    -- Validar correo electrónico
    si existeCorreo(peticion.email)
        devolver { exito: false, mensaje: "El correo electrónico ya está registrado" }
        cancelar transacción
        fin registrarCliente

    -- Insertar cliente en la base de datos
    ID_Cliente = insertarCliente(
        peticion.didentidad_cliente,
        peticion.nombre,
        peticion.apellido,
        peticion.email,
        peticion.telefono,
        peticion.direccion,
        obtenerFechaActual()
    )

    confirmar transacción
    devolver { exito: true, mensaje: "Cliente registrado exitosamente", id_cliente: ID_Cliente }
fin registrarCliente
