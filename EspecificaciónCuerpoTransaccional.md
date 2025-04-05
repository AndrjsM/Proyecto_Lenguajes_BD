### Especificación del Cuerpo Transaccional para "Patitas al Rescate"

El cuerpo transaccional del sistema de gestión de la clínica veterinaria "Patitas al Rescate" está diseñado para garantizar la correcta ejecución de las operaciones relacionadas con la administración de clientes, mascotas, veterinarios, citas, servicios, productos y facturación. Este cuerpo transaccional asegura la integridad de los datos, la consistencia de las transacciones y la experiencia del usuario final. A continuación, se describen las principales transacciones que forman parte del sistema:

---

#### **1. Registro de Clientes**

El sistema permite registrar nuevos clientes, validando que no existan duplicados en los campos clave como el documento de identidad y el correo electrónico. Además, se registra el correo y la contraseña en la tabla `usuarios`.

**Pasos:**

1. Validar que el documento de identidad (`didentidad_cliente`) no exista en la tabla `clientes`.
2. Validar que el correo electrónico (`email`) no exista en las tablas `clientes` y `usuarios`.
3. Encriptar la contraseña proporcionada por el cliente.
4. Insertar los datos del cliente en la tabla `clientes`, incluyendo nombre, apellido, teléfono, dirección y la fecha de registro.
5. Insertar el correo y la contraseña encriptada en la tabla `usuarios`.
6. Confirmar la transacción y devolver los identificadores del cliente y del usuario registrados.

---

#### **2. Registro de Mascotas**

Cada cliente puede registrar una o más mascotas. El sistema valida que el cliente exista antes de permitir el registro de una mascota.

**Pasos:**

1. Validar que el cliente (`id_cliente`) exista en la tabla `clientes`.
2. Insertar los datos de la mascota en la tabla `mascotas`, incluyendo nombre, especie, raza, edad (en meses) y su historial médico.
3. Confirmar la transacción y devolver el identificador de la mascota registrada.

---

#### **3. Registro de Veterinarios**

El sistema permite registrar veterinarios, asegurando que no existan duplicados en el documento de identidad y el correo electrónico.

**Pasos:**

1. Validar que el documento de identidad (`didentidad_veterinario`) no exista en la tabla `veterinarios`.
2. Validar que el correo electrónico (`correo`) no exista en la tabla `veterinarios`.
3. Insertar los datos del veterinario en la tabla `veterinarios`, incluyendo nombre, especialidad, teléfono y rol.
4. Confirmar la transacción y devolver el identificador del veterinario registrado.

---

#### **4. Creación de Citas**

El sistema permite agendar citas para las mascotas, validando que el cliente, la mascota y el veterinario existan, y que el veterinario esté disponible en la fecha y hora solicitadas.

**Pasos:**

1. Validar que el cliente (`id_cliente`) exista en la tabla `clientes`.
2. Validar que la mascota (`id_mascota`) exista en la tabla `mascotas` y que pertenezca al cliente.
3. Validar que el veterinario (`id_veterinario`) exista en la tabla `veterinarios`.
4. Verificar que el veterinario no tenga otra cita programada en la misma fecha y hora.
5. Insertar la cita en la tabla `citas`, incluyendo la fecha, hora y estado inicial (`pendiente`).
6. Confirmar la transacción y devolver el identificador de la cita creada.

---

#### **5. Registro de Servicios en una Cita**

Durante una cita, se pueden realizar uno o más servicios. El sistema valida que los servicios existan antes de registrarlos.

**Pasos:**

1. Validar que la cita (`id_cita`) exista en la tabla `citas`.
2. Para cada servicio solicitado:
   * Validar que el servicio (`id_servicio`) exista en la tabla `servicios`.
   * Insertar el servicio en la tabla `citas_servicios`, vinculándolo con la cita.
3. Confirmar la transacción y devolver los identificadores de los servicios registrados.

---

#### **6. Registro de Productos Consumidos en un Servicio**

Algunos servicios pueden requerir productos específicos. El sistema valida que los productos existan y que haya suficiente stock antes de registrarlos.

**Pasos:**

1. Validar que el servicio (`id_servicio`) esté vinculado a la cita en la tabla `citas_servicios`.
2. Para cada producto consumido:
   * Validar que el producto (`id_producto`) exista en la tabla `productos`.
   * Validar que el stock del producto sea suficiente para la cantidad requerida.
   * Insertar el producto en la tabla `servicios_productos`, vinculándolo con el servicio.
   * Actualizar el stock del producto en la tabla `productos`.
3. Confirmar la transacción y devolver los identificadores de los productos registrados.

---

#### **7. Generación de Facturas**

El sistema permite generar una factura para una cita, calculando el total de los servicios realizados y los productos consumidos.

**Pasos:**

1. Validar que la cita (`id_cita`) exista en la tabla `citas`.
2. Calcular el total de los servicios registrados en la tabla `citas_servicios`.
3. Insertar la factura en la tabla `facturas`, incluyendo la fecha y el total calculado.
4. Vincular la factura con los servicios registrados en la tabla `citas_servicios`.
5. Confirmar la transacción y devolver el identificador de la factura generada.

---

#### **8. Cancelación de Citas**

El sistema permite cancelar una cita, actualizando su estado y liberando los recursos asociados.

**Pasos:**

1. Validar que la cita (`id_cita`) exista en la tabla `citas`.
2. Actualizar el estado de la cita a `cancelada` en la tabla `citas`.
3. Confirmar la transacción y devolver un mensaje de éxito.

---

#### **9. Actualización de Datos**

El sistema permite actualizar los datos de clientes, mascotas, veterinarios, servicios y productos, asegurando que no se violen las restricciones de unicidad ni las relaciones existentes.

**Pasos:**

1. Validar que el registro a actualizar exista en la tabla correspondiente.
2. Validar que los nuevos datos no violen restricciones (por ejemplo, unicidad de correo o documento de identidad).
3. Actualizar los datos en la tabla correspondiente.
4. Confirmar la transacción y devolver un mensaje de éxito.

---

### Consideraciones Generales

1. **Control de Errores:** Si ocurre algún error en cualquier paso de una transacción, se cancela la operación y se revierten los cambios realizados.
2. **Seguridad:** Las contraseñas de los usuarios se almacenan encriptadas en la tabla `usuarios`.
3. **Consistencia:** Todas las operaciones están encapsuladas en transacciones para garantizar la integridad de los datos.
4. **Auditoría:** Se pueden implementar tablas de auditoría para registrar las operaciones realizadas en el sistema.
5. **Permisos:** Se asegura que los usuarios de los diferentes esquemas tengan los permisos necesarios para realizar las operaciones.
