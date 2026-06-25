USE petvida;

-- 1) Ranking de tutores que mais gastam
SELECT
  ROW_NUMBER() OVER (ORDER BY total_gasto DESC) AS posicao,
  t.nome AS tutor,
  total_gasto,
  qtd_consultas
FROM (
  SELECT
    a.tutor_id,
    SUM(c.valor) AS total_gasto,
    COUNT(c.id) AS qtd_consultas
  FROM consultas c
  JOIN animais a ON c.animal_id = a.id
  WHERE c.status <> 'cancelada'
  GROUP BY a.tutor_id
) AS gasto_tutor
JOIN tutores t ON t.id = gasto_tutor.tutor_id
ORDER BY total_gasto DESC;

-- 2) Faturamento mensal
SELECT
  YEAR(c.data_hora) AS ano,
  MONTH(c.data_hora) AS mes,
  COUNT(c.id) AS total_consultas,
  SUM(c.valor) AS faturamento_bruto,
  SUM(COALESCE(p.valor_pago, 0.00)) AS faturamento_recebido,
  SUM(CASE WHEN p.status = 'pendente' OR p.status IS NULL THEN c.valor ELSE 0 END) AS faturamento_pendente
FROM consultas c
LEFT JOIN pagamentos p ON p.consulta_id = c.id
WHERE c.status <> 'cancelada'
GROUP BY YEAR(c.data_hora), MONTH(c.data_hora)
ORDER BY ano DESC, mes DESC;

-- 3) Animais sem consulta há 6+ meses
SELECT
  a.id AS animal_id,
  a.nome AS animal,
  t.nome AS tutor,
  e.nome AS especie,
  MAX(c.data_hora) AS ultima_consulta,
  CASE
    WHEN MAX(c.data_hora) IS NULL THEN 'Nunca consultado'
    ELSE CONCAT(DATEDIFF(CURDATE(), DATE(MAX(c.data_hora))), ' dias desde última consulta')
  END AS status_consulta
FROM animais a
JOIN tutores t ON a.tutor_id = t.id
JOIN especies e ON a.especie_id = e.id
LEFT JOIN consultas c ON c.animal_id = a.id
GROUP BY a.id, a.nome, t.nome, e.nome
HAVING MAX(c.data_hora) IS NULL OR MAX(c.data_hora) <= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY ultima_consulta ASC;

-- 4) Dashboard financeiro
SELECT
  COUNT(c.id) AS total_consultas,
  SUM(c.valor) AS faturamento_bruto,
  SUM(COALESCE(p.valor_pago, 0.00)) AS faturamento_recebido,
  SUM(CASE WHEN p.status = 'pendente' OR p.status IS NULL THEN c.valor ELSE 0 END) AS faturamento_pendente,
  ROUND(
    CASE WHEN COUNT(c.id) = 0 THEN 0
      ELSE 100 * SUM(CASE WHEN (p.status = 'pendente' OR p.status IS NULL) AND c.status <> 'cancelada' THEN 1 ELSE 0 END) / COUNT(c.id)
    END,
    2
  ) AS percentual_inadimplencia
FROM consultas c
LEFT JOIN pagamentos p ON p.consulta_id = c.id
WHERE c.status <> 'cancelada';

-- 5) Veterinário do mês
SELECT
  v.nome AS veterinario,
  SUM(c.valor) AS total_faturado
FROM consultas c
JOIN veterinarios v ON c.veterinario_id = v.id
LEFT JOIN pagamentos p ON p.consulta_id = c.id
WHERE c.status <> 'cancelada'
  AND YEAR(c.data_hora) = YEAR(CURDATE())
  AND MONTH(c.data_hora) = MONTH(CURDATE())
GROUP BY v.id, v.nome
ORDER BY total_faturado DESC
LIMIT 1;

-- 6) Distribuição por espécie
SELECT
  e.nome AS especie,
  COUNT(a.id) AS qtd_animais,
  CONCAT(ROUND(100 * COUNT(a.id) / SUM(COUNT(a.id)) OVER (), 2), '%') AS percentual
FROM animais a
JOIN especies e ON a.especie_id = e.id
GROUP BY e.id, e.nome
ORDER BY percentual DESC;
