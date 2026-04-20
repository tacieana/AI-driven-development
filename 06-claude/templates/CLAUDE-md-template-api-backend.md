# Projeto: [Nome] — API Backend

> Template para APIs REST/GraphQL backend. Remova esta linha antes de usar.

---

## Visão Geral

[O que a API faz. Quem são os consumidores (frontend, mobile, third-party). Escala e criticidade.]

---

## Stack

- **Linguagem:** [Python 3.11 / Node.js 20 / Go 1.22]
- **Framework:** [FastAPI / Express / Gin / NestJS]
- **Banco principal:** [PostgreSQL 15]
- **Cache:** [Redis 7]
- **Fila:** [Celery / BullMQ / Kafka]
- **Auth:** [JWT / OAuth2 / API Keys]
- **Deploy:** [AWS ECS / GCP / Railway]

---

## Comandos Essenciais

```bash
make dev          # inicia servidor de desenvolvimento
make test         # suite completa de testes
make test-unit    # apenas testes unitários
make test-int     # apenas testes de integração
make lint         # linting + type check
make format       # formata código
make migrate      # aplica migrations pendentes
make migration m="descrição"  # cria nova migration
make shell        # abre shell interativo com contexto da app
```

---

## Estrutura de Endpoints

[Liste os grupos de endpoints principais e suas responsabilidades]:
- `POST/GET /auth/*` — autenticação e autorização
- `GET/POST/PUT/DELETE /users/*` — gestão de usuários
- `[outros grupos]`

---

## Arquitetura

```
request → Router → Handler/Controller
                      ↓
                   Service (lógica de negócio)
                      ↓
                Repository/Model (acesso a dados)
                      ↓
                  PostgreSQL / Redis
```

- `src/routes/` ou `api/` — definição de endpoints e validação de input
- `src/services/` — lógica de negócio (testável, sem HTTP)
- `src/repositories/` — acesso a dados (ORM ou queries)
- `src/models/` — entidades e schemas
- `src/middleware/` — auth, logging, rate limiting
- `tests/` — testes organizados por camada

---

## Convenções de API

- Respostas de erro: `{"error": {"code": "ERR_CODE", "message": "..."}}`
- Paginação: `{"data": [...], "pagination": {"page", "per_page", "total"}}`
- Timestamps: ISO 8601 UTC
- IDs: UUID v4 (nunca IDs incrementais expostos)
- Versioning: `/api/v1/`

---

## Convenções de Código

- [Convenção específica da linguagem/framework]
- Toda rota pública tem teste de integração
- Validação de input na camada de route, não no service
- Logs estruturados (JSON) — nunca f-strings com dados sensíveis
- Transações de banco explícitas para operações múltiplas

---

## Autenticação e Autorização

- [Mecanismo: JWT Bearer / API Key / OAuth2]
- [Onde validar: middleware / decorator / dependency]
- [Escopos ou roles disponíveis]

---

## Decisões Técnicas

- **[ORM vs SQL direto]:** [Justificativa]
- **[Framework de testes]:** [Justificativa]
- **[Estratégia de migrations]:** [Justificativa]

---

## O que NUNCA Fazer

- Não logar dados sensíveis (PII, tokens, senhas)
- Não retornar stack traces em respostas de produção
- Não usar IDs incrementais em URLs públicas
- Não commitar `.env` — usar Secrets Manager em produção
- Não fazer operações de banco fora de transação quando há múltiplas escritas

---

## Variáveis de Ambiente

| Variável | Obrigatória | Descrição |
|----------|:-----------:|-----------|
| `DATABASE_URL` | ✅ | Connection string do PostgreSQL |
| `REDIS_URL` | ✅ | URL do Redis |
| `SECRET_KEY` | ✅ | Chave para JWT/sessions |
| `[OUTRA_VAR]` | ✅/❌ | [Descrição] |
