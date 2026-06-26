USE petvida;

DELIMITER $$

CREATE PROCEDURE sp_agendar_consulta(
  IN p_animal_id INT,
  IN p_vet_id INT,
  IN p_data_hora DATETIME,
  IN p_valor DECIMAL(10,2)
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM animais WHERE id = p_animal_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Animal não encontrado';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM veterinarios WHERE id = p_vet_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Veterinário não encontrado';
  END IF;
  IF EXISTS (
    SELECT 1 FROM consultas
    WHERE veterinario_id = p_vet_id
      AND data_hora = p_data_hora
      AND status <> 'cancelada'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Horário do veterinário ocupado';
  END IF;

  START TRANSACTION;
    INSERT INTO consultas (animal_id, veterinario_id, data_hora, diagnostico, valor, status)
    VALUES (p_animal_id, p_vet_id, p_data_hora, NULL, p_valor, 'agendada');

    INSERT INTO pagamentos (consulta_id, valor_pago, forma_pagamento, data_pagamento, status)
    VALUES (LAST_INSERT_ID(), 0.00, 'pix', NOW(), 'pendente');
  COMMIT;
END$$

CREATE PROCEDURE sp_concluir_consulta(
  IN p_consulta_id INT,
  IN p_diagnostico TEXT
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM consultas WHERE id = p_consulta_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Consulta não encontrada';
  END IF;

  UPDATE consultas
  SET status = 'concluida', diagnostico = p_diagnostico
  WHERE id = p_consulta_id;
END$$

CREATE PROCEDURE sp_registrar_pagamento(
  IN p_consulta_id INT,
  IN p_forma VARCHAR(20)
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM consultas WHERE id = p_consulta_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Consulta não encontrada';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pagamentos WHERE consulta_id = p_consulta_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pagamento não encontrado para esta consulta';
  END IF;
  IF EXISTS (
    SELECT 1 FROM pagamentos
    WHERE consulta_id = p_consulta_id
      AND status = 'pago'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pagamento já está quitado';
  END IF;

  UPDATE pagamentos p
  JOIN consultas c ON c.id = p.consulta_id
  SET p.forma_pagamento = p_forma,
      p.valor_pago = c.valor,
      p.data_pagamento = NOW(),
      p.status = 'pago'
  WHERE p.consulta_id = p_consulta_id;
END$$

CREATE PROCEDURE sp_cancelar_consulta(
  IN p_consulta_id INT
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM consultas WHERE id = p_consulta_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Consulta não encontrada';
  END IF;

  START TRANSACTION;
    UPDATE consultas
    SET status = 'cancelada'
    WHERE id = p_consulta_id;

    UPDATE pagamentos
    SET status = 'cancelado'
    WHERE consulta_id = p_consulta_id;
  COMMIT;
END$$

CREATE PROCEDURE sp_cadastrar_animal(
  IN p_nome VARCHAR(100),
  IN p_especie_id INT,
  IN p_raca VARCHAR(80),
  IN p_nascimento DATE,
  IN p_tutor_id INT
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM especies WHERE id = p_especie_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Espécie não encontrada';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM tutores WHERE id = p_tutor_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tutor não encontrado';
  END IF;

  INSERT INTO animais (nome, especie_id, raca, data_nascimento, tutor_id)
  VALUES (p_nome, p_especie_id, p_raca, p_nascimento, p_tutor_id);

  SELECT LAST_INSERT_ID() AS animal_id;
END$$

DELIMITER ;
