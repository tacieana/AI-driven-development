# Projeto: [Nome] — Fullstack

> Template para projetos com backend + frontend. Remova esta linha antes de usar.

---

## Visão Geral

[O que o sistema faz, quem usa, escala aproximada.]

---

## Stack

### Backend
- **Linguagem:** [Python / Node.js / Go]
- **Framework:** [FastAPI / Express / Gin]
- **Banco:** [PostgreSQL / MySQL]
- **Cache:** [Redis]
- **Filas:** [Celery+Redis / BullMQ]

### Frontend
- **Framework:** [Next.js / React / Vue]
- **Linguagem:** TypeScript
- **Estilização:** [Tailwind / MUI / shadcn/ui]
- **Estado:** [Zustand / Redux / React Query]

### Infra
- **Deploy backend:** [AWS ECS / Railway / Fly.io]
- **Deploy frontend:** [Vercel / CloudFront]
- **CI/CD:** [GitHub Actions]

---

## Comandos Essenciais

```bash
# Backend
cd backend/
make dev          # sobe API + serviços locais
make test         # pytest com cobertura
make lint         # ruff + mypy

# Frontend
cd frontend/
npm run dev       # dev server (localhost:3000)
npm test          # jest
npm run lint      # eslint + tsc

# Fullstack
docker-compose up # sobe tudo junto
```

---

## Arquitetura

### Backend (`backend/`)
- `api/` — FastAPI routers e schemas Pydantic
- `services/` — lógica de negócio (sem acoplamento a HTTP)
- `models/` — SQLAlchemy models
- `workers/` — Celery tasks
- `tests/` — pytest (unit + integration)

### Frontend (`frontend/`)
- `app/` — Next.js App Router (pages, layouts)
- `components/` — componentes reutilizáveis
- `lib/` — utilitários e API client
- `hooks/` — React hooks customizados

---

## Convenções de Código

### Backend
- Tipos explícitos em toda assinatura pública (mypy strict)
- Services não importam de `api/` — fluxo é api → service → model
- Toda rota nova exige teste de integração

### Frontend
- Componentes com tipos explícitos (nunca `any`)
- Chamadas de API centralizadas em `lib/api.ts`
- Estado de servidor via React Query, não useState

---

## Fluxo de Dados

```
Cliente → Next.js → API FastAPI → Service → Model → PostgreSQL
                              ↓
                         Redis cache
                              ↓
                    Celery (tarefas async)
```

---

## Decisões Técnicas

- **Next.js App Router:** escolhido para RSC e streaming — não migre para Pages Router
- **Celery + Redis:** não SQS — simplifica ambiente local e testes
- **[Outra decisão]:** [Justificativa]

---

## O que NUNCA Fazer

- Não commitar `.env` — copiar de `.env.example`
- Não fazer chamadas de API diretamente nos componentes — use hooks/lib/api
- Não rodar migrations em produção sem backup
- Não usar `any` no TypeScript sem comentário explicando

---

## Setup Local

```bash
cp .env.example .env
# preencha .env com credenciais locais
docker-compose up -d  # postgres + redis
cd backend && make migrate
cd backend && make dev &
cd frontend && npm run dev
```
