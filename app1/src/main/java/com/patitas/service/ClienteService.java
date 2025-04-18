package com.patitas.service;

import com.patitas.domain.Cliente;

public interface ClienteService {
    Long registrarCliente(Cliente cliente, String contrasena);
}