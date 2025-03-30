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

-- Revisar diccionario de datos
select username, default_tablespace, temporary_tablespace
from dba_users
where username like '%TABLAS';

select  *
from dba_ts_quotas
where username like '%TABLAS';

select owner, object_name, object_type
from dba_objects
where owner like '%TABLAS';

select *
from dba_sys_privs
where grantee like '%TABLAS';

select *
from dba_tab_privs
where grantee like '%TABLAS';