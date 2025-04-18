package com.patitas.controller;

import com.patitas.domain.Cliente;
import com.patitas.service.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/clientes")
public class ClienteController {

    @Autowired
    private ClienteService clienteService;

    @PostMapping("/registrar")
    public String registrarCliente(@RequestParam String didentidadCliente,
                                   @RequestParam String nombre,
                                   @RequestParam String apellido,
                                   @RequestParam String email,
                                   @RequestParam String telefono,
                                   @RequestParam String direccion,
                                   @RequestParam String contrasena) {
        Cliente cliente = new Cliente();
        cliente.setDidentidadCliente(didentidadCliente);
        cliente.setNombre(nombre);
        cliente.setApellido(apellido);
        cliente.setEmail(email);
        cliente.setTelefono(telefono);
        cliente.setDireccion(direccion);
        Long idCliente = clienteService.registrarCliente(cliente, contrasena);
        return "Cliente registrado exitosamente con ID: " + idCliente;
    }
}