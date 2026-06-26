USE petvida;

INSERT INTO especies (nome) VALUES
('Cachorro'),
('Gato'),
('Pássaro'),
('Peixe'),
('Réptil');

INSERT INTO veterinarios (nome, crmv, especialidade, telefone) VALUES
('Ana Silva', 'CRMV-12345', 'Clínica Geral', '(11) 99999-0001'),
('Bruno Costa', 'CRMV-23456', 'Dermatologia', '(11) 99999-0002'),
('Carla Mendes', 'CRMV-34567', 'Cardiologia', '(11) 99999-0003');

INSERT INTO tutores (nome, cpf, email, telefone) VALUES
('Paulo Rocha', '123.456.789-00', 'paulo.rocha@email.com', '(11) 98888-0001'),
('Mariana Lima', '234.567.890-11', 'mariana.lima@email.com', '(11) 98888-0002'),
('Lucas Ferreira', '345.678.901-22', 'lucas.ferreira@email.com', '(11) 98888-0003'),
('Fernanda Alves', '456.789.012-33', 'fernanda.alves@email.com', '(11) 98888-0004'),
('Ricardo Santos', '567.890.123-44', 'ricardo.santos@email.com', '(11) 98888-0005'),
('Juliana Souza', '678.901.234-55', 'juliana.souza@email.com', '(11) 98888-0006'),
('Gabriel Pereira', '789.012.345-66', 'gabriel.pereira@email.com', '(11) 98888-0007'),
('Eduarda Martins', '890.123.456-77', 'eduarda.martins@email.com', '(11) 98888-0008');

INSERT INTO animais (nome, especie_id, raca, data_nascimento, tutor_id) VALUES
('Lulu', 1, 'Vira-lata', '2020-05-12', 1),
('Thor', 1, 'Pastor Alemão', '2018-10-09', 2),
('Mia', 2, 'Siamês', '2019-03-22', 3),
('Nina', 2, 'Persa', '2021-01-14', 4),
('Pipo', 3, 'Calopsita', '2022-11-03', 5),
('Lili', 3, 'Canário', '2023-02-10', 6),
('Bento', 4, 'Betta', '2024-04-28', 7),
('Duda', 4, 'Tetra', '2023-07-17', 8),
('Jade', 5, 'Tartaruga', '2017-09-05', 1),
('Boris', 1, 'Labrador', '2022-06-20', 2),
('Rex', 1, 'Bulldog', '2021-12-01', 3),
('Luna', 2, 'Maine Coon', '2020-08-30', 4),
('Zeca', 5, 'Jabuti', '2019-11-11', 5),
('Kiki', 4, 'Guppy', '2024-01-20', 6),
('Bianca', 2, 'Ragdoll', '2021-04-25', 7);

INSERT INTO consultas (animal_id, veterinario_id, data_hora, diagnostico, valor, status) VALUES
(1, 1, '2026-06-01 09:00:00', 'Consulta de rotina. Vacinas em dia.', 180.00, 'concluida'),
(2, 2, '2026-06-02 10:30:00', 'Dermatite leve nas patinhas.', 220.00, 'concluida'),
(3, 3, '2026-06-03 14:00:00', 'Rotina de saúde felina.', 150.00, 'concluida'),
(4, 1, '2026-06-04 11:00:00', 'Sessão de castração agendada.', 0.00, 'agendada'),
(5, 2, '2026-06-05 08:30:00', 'Asas danificadas. Tratamento emergencial.', 300.00, 'em_atendimento'),
(6, 3, '2026-06-05 15:00:00', 'Avaliação de canto e respiração.', 140.00, 'concluida'),
(7, 1, '2026-06-06 13:30:00', 'Troca de água e check-up.', 90.00, 'concluida'),
(8, 2, '2026-06-07 09:45:00', 'Revisão de dieta para peixes.', 120.00, 'concluida'),
(9, 3, '2026-06-07 16:00:00', 'Exame de casco e limpeza.', 200.00, 'concluida'),
(10, 1, '2026-06-08 10:00:00', 'Vacina anual e orientação.', 190.00, 'concluida'),
(11, 2, '2026-06-09 11:30:00', 'Problema de coluna. Radiografia.', 340.00, 'concluida'),
(12, 3, '2026-06-10 12:00:00', 'Consulta de alergia felina.', 210.00, 'pendente'),
(13, 1, '2026-06-11 14:15:00', 'Avaliação de crescimento de réptil.', 130.00, 'concluida'),
(14, 2, '2026-06-12 09:00:00', 'Consulta de acompanhamento.', 160.00, 'cancelada'),
(15, 3, '2026-06-12 15:30:00', 'Reforço de vacina felina.', 175.00, 'concluida'),
(1, 2, '2026-06-13 10:30:00', 'Sintomas gastrointestinais.', 210.00, 'concluida'),
(2, 3, '2026-06-14 11:45:00', 'Exame preventivo de joelho.', 230.00, 'concluida'),
(3, 1, '2026-06-15 13:00:00', 'Acompanhamento pós-cirurgia.', 180.00, 'em_atendimento'),
(4, 2, '2026-06-16 14:30:00', 'Cancelamento por motivo pessoal.', 0.00, 'cancelada'),
(5, 3, '2026-06-17 08:00:00', 'Consulta de rotina para aves.', 160.00, 'agendada');

INSERT INTO pagamentos (consulta_id, valor_pago, forma_pagamento, data_pagamento, status) VALUES
(1, 180.00, 'pix', '2026-06-01 10:00:00', 'pago'),
(2, 220.00, 'cartao', '2026-06-02 11:00:00', 'pago'),
(3, 150.00, 'dinheiro', '2026-06-03 14:30:00', 'pago'),
(4, 0.00, 'pix', '2026-06-04 11:15:00', 'pendente'),
(5, 300.00, 'convenio', '2026-06-05 09:15:00', 'pago'),
(6, 140.00, 'pix', '2026-06-05 15:30:00', 'pago'),
(7, 90.00, 'dinheiro', '2026-06-06 14:00:00', 'pago'),
(8, 120.00, 'cartao', '2026-06-07 16:00:00', 'pago'),
(9, 200.00, 'pix', '2026-06-07 16:30:00', 'pago'),
(10, 190.00, 'cartao', '2026-06-08 10:30:00', 'pago'),
(11, 340.00, 'convenio', '2026-06-09 12:00:00', 'pago'),
(12, 0.00, 'pix', '2026-06-10 12:30:00', 'pendente'),
(13, 130.00, 'dinheiro', '2026-06-11 15:00:00', 'pago'),
(14, 0.00, 'pix', '2026-06-12 09:30:00', 'cancelado'),
(15, 175.00, 'cartao', '2026-06-12 16:00:00', 'pago'),
(16, 210.00, 'pix', '2026-06-13 11:30:00', 'pago'),
(17, 230.00, 'convenio', '2026-06-14 12:30:00', 'pago'),
(18, 180.00, 'dinheiro', '2026-06-15 13:30:00', 'pago'),
(19, 0.00, 'pix', '2026-06-16 14:45:00', 'cancelado'),
(20, 160.00, 'cartao', '2026-06-17 08:30:00', 'pendente');
