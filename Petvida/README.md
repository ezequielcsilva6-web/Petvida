# Petvida - Sistema de Clínica Veterinária

Projeto completo com separação de Backend, Frontend e Database.

## 📁 Estrutura de Pastas

```
Petvida/
├── backend/                 # API Node.js/Express
│   ├── app.js             # Servidor e rotas
│   ├── db.js              # Conexão MySQL
│   ├── package.json       # Dependências
│   ├── .env               # Variáveis de ambiente
│   └── node_modules/
│
├── frontend/              # Interface Web
│   ├── server.js          # Servidor Express
│   ├── package.json       # Dependências
│   └── public/
│       └── index.html     # Aplicação completa
│
└── database/              # Scripts SQL
    ├── 01-schema.sql      # Estrutura
    ├── 02-seed.sql        # Dados iniciais
    ├── 03-views.sql       # Views
    ├── 04-procedures.sql  # Procedures
    ├── 05-functions.sql   # Functions
    ├── 06-triggers.sql    # Triggers
    ├── 07-security.sql    # Usuários
    ├── 08-reports.sql     # Relatórios
    └── README.md          # Documentação

```

## 🚀 Inicialização Rápida

### Backend
```bash
cd backend
npm install
npm run dev        # http://localhost:3000
```

### Frontend
```bash
cd frontend
npm install
npm run dev        # http://localhost:3001
```

### Database
```bash
mysql -u root -p < database/01-schema.sql
mysql -u root -p < database/02-seed.sql
mysql -u root -p < database/03-views.sql
# ... continue com os demais arquivos
```

## 📡 Endpoints da API

- `GET /tutores` - Listar tutores
- `POST /tutores` - Criar tutor
- `GET /animais` - Listar animais
- `POST /animais` - Criar animal
- `GET /consultas` - Listar consultas
- `POST /consultas` - Agendar consulta
- `POST /consultas/:id/concluir` - Concluir consulta
- `POST /consultas/:id/pagamento` - Registrar pagamento
- `GET /pagamentos` - Listar pagamentos
- `GET /reports/ranking-tutores` - Ranking
- `GET /reports/financeiro` - Financeiro

## 🔧 Tecnologias

- **Backend**: Node.js + Express
- **Frontend**: HTML5 + CSS3 + JavaScript
- **Database**: MySQL 8.0+
- **DevTools**: Nodemon, Cors

## 📝 Funcionalidades

✅ Gestão de tutores e animais
✅ Agendamento de consultas
✅ Registro de pagamentos
✅ Relatórios de negócio
✅ Auditoria de operações
✅ Controle de permissões
