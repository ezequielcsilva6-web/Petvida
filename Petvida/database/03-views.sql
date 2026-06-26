USE petvida;

CREATE OR REPLACE VIEW vw_consultas_completas AS
SELECT
  c.data_hora,
  c.status AS status_consulta,
  c.diagnostico,
  c.valor,
  a.nome AS animal,
  e.nome AS especie,
  t.nome AS tutor,
  t.telefone AS tutor_telefone,
  v.nome AS veterinario,
  v.especialidade,
  p.forma_pagamento,
  p.status AS status_pagamento
FROM consultas c
JOIN animais a ON c.animal_id = a.id
JOIN especies e ON a.especie_id = e.id
JOIN tutores t ON a.tutor_id = t.id
JOIN veterinarios v ON c.veterinario_id = v.id
LEFT JOIN pagamentos p ON c.id = p.consulta_id;

CREATE OR REPLACE VIEW vw_agenda_hoje AS
SELECT *
FROM vw_consultas_completas
WHERE DATE(data_hora) = CURDATE()
ORDER BY data_hora;

CREATE OR REPLACE VIEW vw_faturamento_mensal AS
SELECT
  YEAR(c.data_hora) AS ano,
  MONTH(c.data_hora) AS mes,
  v.nome AS veterinario,
  COUNT(c.id) AS total_consultas,
  SUM(c.valor) AS total_valor_consultas,
  SUM(p.valor_pago) AS total_valor_pago
FROM consultas c
JOIN veterinarios v ON c.veterinario_id = v.id
LEFT JOIN pagamentos p ON c.id = p.consulta_id
GROUP BY YEAR(c.data_hora), MONTH(c.data_hora), v.id, v.nome
ORDER BY ano DESC, mes DESC, veterinario;

CREATE OR REPLACE VIEW vw_animais_detalhados AS
SELECT
  a.id AS animal_id,
  a.nome AS animal,
  e.nome AS especie,
  t.nome AS tutor,
  COUNT(c.id) AS total_consultas
FROM animais a
JOIN especies e ON a.especie_id = e.id
JOIN tutores t ON a.tutor_id = t.id
LEFT JOIN consultas c ON c.animal_id = a.id
GROUP BY a.id, a.nome, e.nome, t.nome;

CREATE OR REPLACE VIEW vw_inadimplentes AS
SELECT
  c.id AS consulta_id,
  c.data_hora,
  a.nome AS animal,
  t.nome AS tutor,
  v.nome AS veterinario,
  c.valor AS valor_consulta,
  p.valor_pago,
  p.forma_pagamento,
  COALESCE(p.status, 'sem_pagamento') AS status_pagamento
FROM consultas c
JOIN animais a ON c.animal_id = a.id
JOIN tutores t ON a.tutor_id = t.id
JOIN veterinarios v ON c.veterinario_id = v.id
LEFT JOIN pagamentos p ON c.id = p.consulta_id
WHERE c.status = 'concluida'
  AND (p.id IS NULL OR p.status = 'pendente');
