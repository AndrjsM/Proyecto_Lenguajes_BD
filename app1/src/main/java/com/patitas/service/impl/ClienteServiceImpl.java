package com.patitas.service.impl;

import com.patitas.domain.Cliente;
import com.patitas.repository.ClienteRepository;
import com.patitas.service.ClienteService;
import jakarta.persistence.EntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ClienteServiceImpl implements ClienteService {

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private EntityManager entityManager;

    @Override
    @Transactional
    public Long registrarCliente(Cliente cliente, String contrasena) {
        return clienteRepository.callRegistrarCliente(entityManager, cliente.getDidentidadCliente(), cliente.getNombre(), cliente.getApellido(), cliente.getEmail(), cliente.getTelefono(), cliente.getDireccion(), contrasena);
    }
}