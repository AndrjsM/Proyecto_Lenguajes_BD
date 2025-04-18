package com.patitas.repository;

import com.patitas.domain.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.StoredProcedureQuery;

@Repository
public interface ClienteRepository extends JpaRepository<Cliente, Long> {
    boolean existsByDidentidadCliente(String didentidadCliente);
    boolean existsByEmail(String email);

    default Long callRegistrarCliente(EntityManager entityManager, String didentidadCliente, String nombre, String apellido, String email, String telefono, String direccion, String contrasena) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("registrarCliente");
        query.registerStoredProcedureParameter("p_didentidad_cliente", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_apellido", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_email", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_telefono", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_direccion", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_contrasena", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_ID_Cliente", Long.class, ParameterMode.OUT);

        query.setParameter("p_didentidad_cliente", didentidadCliente);
        query.setParameter("p_nombre", nombre);
        query.setParameter("p_apellido", apellido);
        query.setParameter("p_email", email);
        query.setParameter("p_telefono", telefono);
        query.setParameter("p_direccion", direccion);
        query.setParameter("p_contrasena", contrasena);

        query.execute();
        return (Long) query.getOutputParameterValue("p_ID_Cliente");
    }
}