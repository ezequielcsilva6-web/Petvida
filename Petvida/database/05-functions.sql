USE petvida;

DELIMITER $$

CREATE FUNCTION fn_idade_animal(p_data_nascimento DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  DECLARE anos INT;
  DECLARE meses INT;

  SET anos = TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
  SET meses = TIMESTAMPDIFF(MONTH, p_data_nascimento, CURDATE()) - anos * 12;

  RETURN CONCAT(anos, ' anos e ', meses, ' meses');
END$$

CREATE FUNCTION fn_total_gasto_tutor(p_tutor_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN (
    SELECT COALESCE(SUM(c.valor), 0.00)
    FROM consultas c
    JOIN animais a ON c.animal_id = a.id
    WHERE a.tutor_id = p_tutor_id
      AND c.status <> 'cancelada'
  );
END$$

CREATE FUNCTION fn_qtd_consultas_animal(p_animal_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN (
    SELECT COUNT(*)
    FROM consultas
    WHERE animal_id = p_animal_id
  );
END$$

CREATE FUNCTION fn_status_emoji(p_status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  RETURN CASE p_status
    WHEN 'agendada' THEN '📅 Agendada'
    WHEN 'concluida' THEN '✅ Concluída'
    WHEN 'cancelada' THEN '❌ Cancelada'
    WHEN 'em_atendimento' THEN '🏥 Em Atendimento'
    ELSE '❓ Desconhecido'
  END;
END$$

CREATE FUNCTION fn_classificar_valor(p_valor DECIMAL(10,2))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  RETURN CASE
    WHEN p_valor < 100 THEN 'Consulta Simples'
    WHEN p_valor BETWEEN 100 AND 300 THEN 'Consulta Padrão'
    ELSE 'Procedimento Especial'
  END;
END$$

DELIMITER ;
