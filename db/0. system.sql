-- desde System

-- Creación del usuario Usuarios_Tablas
create user Usuarios_Tablas identified by Usuarios_Tablas
default tablespace users 
temporary tablespace temp
quota unlimited on users;

-- Otorgando privilegios de sistema
grant create session, create table to Usuarios_Tablas;

-- Creación del usuario Citas_Tablas
create user Citas_Tablas identified by Citas_Tablas
default tablespace users 
temporary tablespace temp
quota unlimited on users;

-- Otorgando privilegios de sistema
grant create session, create table to Citas_Tablas;

-- Creación del usuario Servicios_Tablas
create user Servicios_Tablas identified by Servicios_Tablas
default tablespace users 
temporary tablespace temp
quota unlimited on users;

-- Otorgando privilegios de sistema
grant create session, create table to Servicios_Tablas;


-- creación de usuario Progra.
CREATE USER progra IDENTIFIED BY progra
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- Otorgar privilegios básicos
GRANT CREATE SESSION TO progra;

-- Otorgar privilegios para crear procedimientos y triggers
GRANT CREATE PROCEDURE, CREATE TRIGGER TO progra;

-- Otorgar privilegios para consultar tablas
GRANT SELECT ON usuarios_tablas.clientes TO progra;
GRANT SELECT ON usuarios_tablas.mascotas TO progra;
GRANT SELECT ON usuarios_tablas.veterinarios TO progra;
GRANT SELECT ON servicios_tablas.servicios TO progra;
GRANT SELECT ON servicios_tablas.productos TO progra;
GRANT SELECT ON citas_tablas.citas TO progra;

-- Otorgar privilegios para insertar y actualizar registros
GRANT INSERT, UPDATE ON citas_tablas.citas TO progra;
GRANT INSERT, UPDATE ON citas_tablas.citas_servicios TO progra;
GRANT UPDATE ON servicios_tablas.productos TO progra;
GRANT INSERT ON usuarios_tablas.clientes TO progra;
GRANT INSERT ON usuarios_tablas.usuarios TO progra;
GRANT INSERT ON citas_tablas.facturas TO progra;

-- Revisar diccionario de datos
select username, default_tablespace, temporary_tablespace
from dba_users
where username like '%TABLAS';

select  *
from dba_ts_quotas
where username like '%TABLAS';

select owner, object_name, object_type
from dba_objects
where owner like '%TABLAS'
order by 1,3;

select *
from dba_sys_privs
where grantee like '%TABLAS';

select *
from dba_tab_privs
where grantee like '%TABLAS';

SELECT constraint_name, table_name, r_constraint_name
FROM user_constraints
WHERE table_name = 'CITAS_SERVICIOS' AND constraint_type = 'R';