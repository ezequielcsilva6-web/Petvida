USE petvida;

CREATE USER IF NOT EXISTS 'recepcionista'@'localhost' IDENTIFIED BY 'recep123';
CREATE USER IF NOT EXISTS 'veterinario'@'localhost' IDENTIFIED BY 'vet123';
CREATE USER IF NOT EXISTS 'gerente'@'localhost' IDENTIFIED BY 'ger123';
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin123';

-- Permissões da recepcionista
GRANT SELECT, INSERT ON petvida.tutores TO 'recepcionista'@'localhost';
GRANT SELECT, INSERT ON petvida.animais TO 'recepcionista'@'localhost';
GRANT SELECT, INSERT ON petvida.consultas TO 'recepcionista'@'localhost';
GRANT SELECT, INSERT ON petvida.especies TO 'recepcionista'@'localhost';
GRANT EXECUTE ON PROCEDURE petvida.sp_agendar_consulta TO 'recepcionista'@'localhost';
GRANT EXECUTE ON PROCEDURE petvida.sp_cadastrar_animal TO 'recepcionista'@'localhost';

-- Permissões do veterinário
GRANT SELECT ON petvida.* TO 'veterinario'@'localhost';
GRANT UPDATE (diagnostico, status) ON petvida.consultas TO 'veterinario'@'localhost';
GRANT EXECUTE ON PROCEDURE petvida.sp_concluir_consulta TO 'veterinario'@'localhost';

-- Permissões do gerente
GRANT SELECT, INSERT, UPDATE ON petvida.* TO 'gerente'@'localhost';
GRANT DELETE ON petvida.consultas TO 'gerente'@'localhost';
GRANT EXECUTE ON PROCEDURE petvida.sp_agendar_consulta TO 'gerente'@'localhost';
GRANT EXECUTE ON PROCEDURE petvida.sp_concluir_consulta TO 'gerente'@'localhost';
GRANT EXECUTE ON PROCEDURE petvida.sp_registrar_pagamento TO 'gerente'@'localhost';
GRANT EXECUTE ON PROCEDURE petvida.sp_cancelar_consulta TO 'gerente'@'localhost';
GRANT EXECUTE ON PROCEDURE petvida.sp_cadastrar_animal TO 'gerente'@'localhost';

-- Permissões do admin
GRANT ALL PRIVILEGES ON petvida.* TO 'admin'@'localhost' WITH GRANT OPTION;

-- Remove acesso da recepcionista
REVOKE SELECT, INSERT ON petvida.tutores FROM 'recepcionista'@'localhost';
REVOKE SELECT, INSERT ON petvida.animais FROM 'recepcionista'@'localhost';
REVOKE SELECT, INSERT ON petvida.consultas FROM 'recepcionista'@'localhost';
REVOKE SELECT, INSERT ON petvida.especies FROM 'recepcionista'@'localhost';
REVOKE EXECUTE ON PROCEDURE petvida.sp_agendar_consulta FROM 'recepcionista'@'localhost';
REVOKE EXECUTE ON PROCEDURE petvida.sp_cadastrar_animal FROM 'recepcionista'@'localhost';
