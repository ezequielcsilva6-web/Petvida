USE petvida;

CREATE TABLE IF NOT EXISTS log_auditoria (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tabela_afetada VARCHAR(100) NOT NULL,
  acao VARCHAR(50) NOT NULL,
  registro_id INT NOT NULL,
  detalhes TEXT,
  data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

DELIMITER $$

CREATE TRIGGER trg_after_insert_consulta
AFTER INSERT ON consultas
FOR EACH ROW
BEGIN
  INSERT INTO log_auditoria (tabela_afetada, acao, registro_id, detalhes)
  VALUES ('consultas', 'INSERT', NEW.id,
    CONCAT('animal_id=', NEW.animal_id, ', veterinario_id=', NEW.veterinario_id, ', data_hora=', NEW.data_hora, ', valor=', NEW.valor));
END$$

CREATE TRIGGER trg_after_update_consulta_status
AFTER UPDATE ON consultas
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO log_auditoria (tabela_afetada, acao, registro_id, detalhes)
    VALUES ('consultas', 'UPDATE_STATUS', NEW.id,
      CONCAT('de ', OLD.status, ' para ', NEW.status));
  END IF;
END$$

CREATE TRIGGER trg_before_delete_consulta
BEFORE DELETE ON consultas
FOR EACH ROW
BEGIN
  DECLARE pagamento_status VARCHAR(20);

  SELECT status INTO pagamento_status
  FROM pagamentos
  WHERE consulta_id = OLD.id
  LIMIT 1;

  IF pagamento_status = 'pago' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é permitido excluir consulta com pagamento pago';
  END IF;
END$$

CREATE TRIGGER trg_after_insert_animal
AFTER INSERT ON animais
FOR EACH ROW
BEGIN
  INSERT INTO log_auditoria (tabela_afetada, acao, registro_id, detalhes)
  VALUES ('animais', 'INSERT', NEW.id,
    CONCAT('nome=', NEW.nome, ', especie_id=', NEW.especie_id, ', tutor_id=', NEW.tutor_id));
END$$

CREATE TRIGGER trg_before_update_pagamento
BEFORE UPDATE ON pagamentos
FOR EACH ROW
BEGIN
  IF OLD.status <> 'pago' AND NEW.status = 'pago' THEN
    SET NEW.data_pagamento = CAST(CURDATE() AS DATETIME);
  END IF;
END$$

DELIMITER ;

INSERT INTO consultas (animal_id, veterinario_id, data_hora, diagnostico, valor, status)
VALUES (1, 1, '2026-07-02 09:00:00', 'Teste de trigger insert', 200.00, 'agendada');
SELECT * FROM log_auditoria WHERE tabela_afetada = 'consultas' AND acao = 'INSERT' ORDER BY data_hora DESC LIMIT 1;

UPDATE consultas SET status = 'concluida' WHERE id = LAST_INSERT_ID();
SELECT * FROM log_auditoria WHERE tabela_afetada = 'consultas' AND acao = 'UPDATE_STATUS' ORDER BY data_hora DESC LIMIT 1;

UPDATE pagamentos SET status = 'pago', data_pagamento = NOW() WHERE consulta_id = LAST_INSERT_ID();
DELETE FROM consultas WHERE id = LAST_INSERT_ID();

UPDATE pagamentos SET status = 'pago' WHERE consulta_id = 1 AND status <> 'pago';
SELECT consulta_id, status, data_pagamento FROM pagamentos WHERE consulta_id = 1;
