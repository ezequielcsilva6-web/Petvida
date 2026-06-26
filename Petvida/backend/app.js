const express = require('express');
const cors = require('cors');
const pool = require('./db');

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ service: 'Petvida API', status: 'ok' });
});

app.get('/tutores', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM tutores');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/tutores', async (req, res) => {
  const { nome, cpf, email, telefone } = req.body;
  try {
    const [result] = await pool.execute(
      'INSERT INTO tutores (nome, cpf, email, telefone) VALUES (?, ?, ?, ?)',
      [nome, cpf, email, telefone]
    );
    res.status(201).json({ id: result.insertId, nome, cpf, email, telefone });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.get('/veterinarios', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM veterinarios');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/especies', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM especies');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/animais', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT a.*, e.nome AS especie, t.nome AS tutor
       FROM animais a
       JOIN especies e ON a.especie_id = e.id
       JOIN tutores t ON a.tutor_id = t.id`
    );
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/animais', async (req, res) => {
  const { nome, especie_id, raca, data_nascimento, tutor_id } = req.body;
  try {
    const [result] = await pool.execute(
      'INSERT INTO animais (nome, especie_id, raca, data_nascimento, tutor_id) VALUES (?, ?, ?, ?, ?)',
      [nome, especie_id, raca, data_nascimento, tutor_id]
    );
    res.status(201).json({ id: result.insertId, nome, especie_id, raca, data_nascimento, tutor_id });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.get('/consultas', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT c.*, a.nome AS animal, v.nome AS veterinario
       FROM consultas c
       JOIN animais a ON c.animal_id = a.id
       JOIN veterinarios v ON c.veterinario_id = v.id`
    );
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/consultas', async (req, res) => {
  const { animal_id, veterinario_id, data_hora, diagnostico = null, valor, status = 'agendada' } = req.body;
  try {
    const [result] = await pool.execute(
      'INSERT INTO consultas (animal_id, veterinario_id, data_hora, diagnostico, valor, status) VALUES (?, ?, ?, ?, ?, ?)',
      [animal_id, veterinario_id, data_hora, diagnostico, valor, status]
    );
    res.status(201).json({ id: result.insertId, animal_id, veterinario_id, data_hora, diagnostico, valor, status });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.post('/consultas/:id/concluir', async (req, res) => {
  const consultaId = Number(req.params.id);
  const { diagnostico } = req.body;

  try {
    const [result] = await pool.execute(
      'UPDATE consultas SET status = ?, diagnostico = ? WHERE id = ? AND status <> ?',
      ['concluida', diagnostico || null, consultaId, 'cancelada']
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Consulta não encontrada ou já cancelada' });
    }
    res.json({ message: 'Consulta concluída com sucesso' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.post('/consultas/:id/pagamento', async (req, res) => {
  const consultaId = Number(req.params.id);
  const { forma_pagamento, valor_pago, data_pagamento = new Date() } = req.body;

  try {
    const [consultas] = await pool.query('SELECT valor FROM consultas WHERE id = ?', [consultaId]);
    if (consultas.length === 0) {
      return res.status(404).json({ error: 'Consulta não encontrada' });
    }

    const pagamentoValor = valor_pago != null ? valor_pago : consultas[0].valor;
    const status = pagamentoValor > 0 ? 'pago' : 'pendente';

    const [result] = await pool.execute(
      'INSERT INTO pagamentos (consulta_id, valor_pago, forma_pagamento, data_pagamento, status) VALUES (?, ?, ?, ?, ?)',
      [consultaId, pagamentoValor, forma_pagamento, data_pagamento, status]
    );
    res.status(201).json({ id: result.insertId, consulta_id: consultaId, valor_pago: pagamentoValor, forma_pagamento, data_pagamento, status });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.get('/pagamentos', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT p.*, c.data_hora AS consulta_data, c.valor AS consulta_valor
       FROM pagamentos p
       JOIN consultas c ON p.consulta_id = c.id`
    );
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/reports/ranking-tutores', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT
         ROW_NUMBER() OVER (ORDER BY total_gasto DESC) AS posicao,
         t.nome AS tutor,
         total_gasto,
         qtd_consultas
       FROM (
         SELECT a.tutor_id, SUM(c.valor) AS total_gasto, COUNT(c.id) AS qtd_consultas
         FROM consultas c
         JOIN animais a ON c.animal_id = a.id
         WHERE c.status <> 'cancelada'
         GROUP BY a.tutor_id
       ) gasto_tutor
       JOIN tutores t ON t.id = gasto_tutor.tutor_id
       ORDER BY total_gasto DESC`
    );
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/reports/financeiro', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT
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
       WHERE c.status <> 'cancelada'`
    );
    res.json(rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint não encontrado' });
});

app.listen(port, () => {
  console.log(`Petvida API rodando em http://localhost:${port}`);
});
