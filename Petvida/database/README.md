# Petvida Database Files

Esta pasta contém todos os arquivos SQL necessários para inicializar e gerenciar o banco de dados do Petvida.

## Arquivos

| Arquivo | Descrição |
|---------|-----------|
| `01-schema.sql` | Criação do banco de dados e tabelas principais |
| `02-seed.sql` | Dados iniciais para testes (tutores, animais, consultas, pagamentos) |
| `03-views.sql` | Views para relatórios e análises |
| `04-procedures.sql` | Procedures para operações complexas |
| `05-functions.sql` | Functions para cálculos e transformações de dados |
| `06-triggers.sql` | Triggers para auditoria e validações automáticas |
| `07-security.sql` | Criação de usuários e permissões de acesso |
| `08-reports.sql` | Queries para relatórios de negócio |

## Como usar

### Instalação completa (primeira vez)
Execute os arquivos nesta ordem no MySQL:

```bash
mysql -u root -p < 01-schema.sql
mysql -u root -p < 02-seed.sql
mysql -u root -p < 03-views.sql
mysql -u root -p < 04-procedures.sql
mysql -u root -p < 05-functions.sql
mysql -u root -p < 06-triggers.sql
mysql -u root -p < 07-security.sql
mysql -u root -p < 08-reports.sql
```

### Ou execute um arquivo completo
Use o arquivo `init.sql` para executar tudo de uma vez.

## Estrutura do Banco

### Tabelas
- `veterinarios` - Profissionais veterinários
- `tutores` - Proprietários dos animais
- `especies` - Tipos de animais
- `animais` - Registro de animais
- `consultas` - Histórico de atendimentos
- `pagamentos` - Transações de pagamento
- `log_auditoria` - Auditoria de mudanças

### Views
- `vw_consultas_completas` - Consultas com todos os detalhes
- `vw_agenda_hoje` - Consultas agendadas para hoje
- `vw_faturamento_mensal` - Relatório mensal por veterinário
- `vw_animais_detalhados` - Animais com histórico de consultas
- `vw_inadimplentes` - Consultas sem pagamento

### Procedures
- `sp_agendar_consulta()` - Agendar uma nova consulta
- `sp_concluir_consulta()` - Finalizar uma consulta
- `sp_registrar_pagamento()` - Registrar pagamento
- `sp_cancelar_consulta()` - Cancelar uma consulta
- `sp_cadastrar_animal()` - Cadastrar novo animal

### Functions
- `fn_idade_animal()` - Calcular idade do animal
- `fn_total_gasto_tutor()` - Soma de gastos de um tutor
- `fn_qtd_consultas_animal()` - Contar consultas de um animal
- `fn_status_emoji()` - Converter status em emoji
- `fn_classificar_valor()` - Classificar valor da consulta

## Usuários e Permissões

| Usuário | Senha | Permissões |
|---------|-------|-----------|
| `recepcionista` | `recep123` | Inserir tutores, animais, agendar consultas |
| `veterinario` | `vet123` | Ver dados, atualizar diagnósticos |
| `gerente` | `ger123` | Acesso completo com restrições |
| `admin` | `admin123` | Todos os privilégios |

## Executar Reports

Os relatórios disponíveis em `08-reports.sql`:

1. **Ranking de tutores** - Tutores que mais gastam
2. **Faturamento mensal** - Receitas por período
3. **Animais sem consulta** - Acompanhamento de saúde
4. **Dashboard financeiro** - Resumo de inadimplência
5. **Veterinário do mês** - Maior faturador do período
6. **Distribuição por espécie** - Animais por tipo

## Backup e Restauração

### Fazer backup
```bash
mysqldump -u root -p petvida > backup.sql
```

### Restaurar do backup
```bash
mysql -u root -p < backup.sql
```
