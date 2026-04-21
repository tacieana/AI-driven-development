# Template: copilot-instructions.md — Fullstack (Next.js + Node.js)

> Template para projetos fullstack com frontend Next.js e backend Node.js/Express.
> Salve como `.github/copilot-instructions.md`.

---

```markdown
# GitHub Copilot Instructions

Este repositório é uma aplicação fullstack com frontend em Next.js e API backend em Node.js/Express com TypeScript.

---

## Stack técnica

### Frontend
- **Framework:** Next.js 14 (App Router)
- **Linguagem:** TypeScript 5.x strict mode
- **Estilo:** Tailwind CSS 3
- **Estado global:** Zustand
- **Chamadas de API:** TanStack Query (React Query)
- **Testes:** Vitest + Testing Library

### Backend
- **Runtime:** Node.js 20 LTS
- **Framework:** Express 4
- **Linguagem:** TypeScript 5.x strict mode
- **ORM:** Prisma 5 com PostgreSQL 15
- **Autenticação:** JWT com refresh tokens
- **Testes:** Jest 29 + Supertest

---

## Estrutura de diretórios

```
apps/
├── web/                    # Frontend Next.js
│   ├── app/               # Rotas (App Router)
│   ├── components/        # Componentes React
│   │   ├── ui/           # Componentes genéricos (Button, Input...)
│   │   └── features/     # Componentes de domínio
│   ├── hooks/             # Custom hooks
│   ├── stores/            # Estado Zustand
│   └── lib/               # Utilitários e configurações
│
└── api/                    # Backend Express
    ├── src/
    │   ├── controllers/   # Validação de request/response
    │   ├── services/      # Lógica de negócio
    │   ├── repositories/  # Acesso a dados via Prisma
    │   ├── middlewares/   # Auth, erros, logging
    │   └── errors/        # Classes de erro customizadas

packages/
└── shared/                # Tipos TypeScript compartilhados
```

---

## Padrões Frontend

- **Componentes:** function components com TypeScript, props tipadas com `interface`
- **Estado do servidor:** TanStack Query para dados remotos — nunca useEffect para fetch
- **Estado local:** `useState`; estado global com Zustand apenas quando necessário
- **Estilo:** Tailwind classes diretamente nos elementos — sem CSS modules
- **Formulários:** React Hook Form com validação Zod

### Nomenclatura frontend

| Item | Convenção | Exemplo |
|------|-----------|---------|
| Componentes | PascalCase | `UserCard.tsx` |
| Hooks | camelCase com prefixo `use` | `useUserData.ts` |
| Stores | camelCase com sufixo `Store` | `cartStore.ts` |
| Rotas (App Router) | kebab-case em pastas | `app/user-profile/page.tsx` |

---

## Padrões Backend

- **Controllers:** apenas validação de request/response — sem lógica de negócio
- **Services:** lógica de negócio — sem acesso direto ao Prisma
- **Repositories:** único ponto de acesso ao banco via Prisma
- **Middlewares:** autenticação, tratamento de erros, logging

### Tratamento de erros (backend)

```typescript
// ✅ Use as classes de erro em src/errors/
throw new ValidationError('CPF inválido', { field: 'cpf' });
throw new NotFoundError('Usuário não encontrado', { id });
throw new UnauthorizedError('Token expirado');

// ❌ Nunca
throw new Error('algo deu errado');
```

---

## Padrões de teste

### Frontend (Vitest + Testing Library)

```typescript
// Teste de componente
it('should display user name when data loads', async () => {
  renderWithProviders(<UserCard userId="123" />);
  expect(await screen.findByText('João Silva')).toBeInTheDocument();
});
```

### Backend (Jest + Supertest)

```typescript
// Teste de endpoint
it('should return 422 when CPF is invalid', async () => {
  const res = await request(app)
    .post('/users')
    .send({ cpf: '000.000.000-00', name: 'Test' });
  expect(res.status).toBe(422);
  expect(res.body.field).toBe('cpf');
});
```

---

## Verificações de CI

```bash
# Frontend
cd apps/web && npm run lint && npm run type-check && npm test && npm run build

# Backend
cd apps/api && npm run lint && npm run type-check && npm test && npm run build
```

---

## O que NÃO fazer

- Não use `any` — nunca em TypeScript
- Não faça fetch diretamente em useEffect — use TanStack Query
- Não acesse o Prisma fora de repositories/
- Não importe do backend dentro do frontend (e vice-versa) — use `packages/shared` para tipos
- Não adicione `console.log` — use o logger configurado em `apps/api/src/utils/logger.ts`
```
