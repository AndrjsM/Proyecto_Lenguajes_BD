package com.patitas.controller;

import com.patitas.domain.Cliente;
import com.patitas.service.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
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
                                   @RequestParam String contrasena,
                                   RedirectAttributes redirectAttributes) {
        try {
            Cliente cliente = new Cliente();
            cliente.setDidentidadCliente(didentidadCliente);
            cliente.setNombre(nombre);
            cliente.setApellido(apellido);
            cliente.setEmail(email);
            cliente.setTelefono(telefono);
            cliente.setDireccion(direccion);
            clienteService.registrarCliente(cliente, contrasena);

            redirectAttributes.addFlashAttribute("successMessage", "Usuario registrado exitosamente. Por favor, inicie sesión.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Su documento de indetidad o correo ya se encuentran registrados. Por favor, recupere su usuario y contraseña.");
        }
        return "redirect:/login";
    }
}
