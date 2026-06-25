# Petvida API

API Node.js para o projeto Petvida.

## Instalação

1. Navegue até a pasta do projeto:
   ```bash
   cd c:\Users\Ezequiel\Downloads\Petvida
   ```
2. Instale dependências:
   ```bash
   npm install
   ```
3. Crie um arquivo `.env` na raiz com os dados de conexão:
   ```env
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=root
   DB_PASSWORD=
   DB_NAME=petvida
   PORT=3000
   ```
4. Inicie a API:
   ```bash
   npm start
   ```

## Endpoints básicos

- `GET /` — status da API
- `GET /tutores` — lista tutores
- `GET /animais` — lista animais com tutor e espécie
- `GET /consultas` — lista consultas com animal e veterinário
- `POST /consultas` — agenda consulta
- `POST /consultas/:id/concluir` — conclui consulta
- `POST /consultas/:id/pagamento` — registra pagamento

## Endpoints de relatório

- `GET /reports/ranking-tutores`
- `GET /reports/financeiro`
