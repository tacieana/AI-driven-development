# Passo a Passo — API REST com Copilot Agent Mode

---

## Passo 1 — Configurar `.github/copilot-instructions.md`

Crie o arquivo **antes** de abrir o Agent Mode:

```markdown
# GitHub Copilot Instructions — Notes API

## Stack
- Node.js 20, TypeScript 5 (strict: true)
- Express 4, Prisma 5 com SQLite (dev) / PostgreSQL (prod)
- Autenticação: JWT com jsonwebtoken (expiração: 7 dias)
- Senhas: bcrypt com salt rounds 10
- Validação: zod
- Testes: Jest + Supertest, banco SQLite em memória

## Arquitetura (sem pular camadas)
Controllers → Services → Repositories → Prisma

## Erros customizados
Use as classes em src/errors/:
- AppError(message, statusCode)
- ValidationError(message, { field })
- NotFoundError(message)
- UnauthorizedError(message)
Nunca lance `new Error()` diretamente.

## Testes
- Testes de integração em tests/integration/ usando Supertest
- Banco de dados real (SQLite em memória via Prisma) — sem mocks de DB
- Crie um helper tests/helpers/createTestUser.ts para autenticação nos testes

## Verificações
npm run lint && npm run type-check && npm test && npm run build
```

---

## Passo 2 — Criar os agentes customizados

Crie `.github/agents/code-reviewer.agent.md` e `.github/agents/test-expert.agent.md` usando os templates do capítulo 07.

---

## Passo 3 — Scaffolding inicial via Agent Mode

Abra o VS Code na pasta do projeto. Ative Agent Mode no chat e use:

```
Inicialize o projeto Notes API conforme o copilot-instructions.md.

Crie:
1. package.json com todos os scripts necessários
2. tsconfig.json strict
3. jest.config.ts com ts-jest e suporte a SQLite em memória
4. Estrutura de diretórios: src/controllers, src/services,
   src/repositories, src/middlewares, src/errors
5. src/errors/index.ts com as classes AppError, ValidationError,
   NotFoundError, UnauthorizedError
6. prisma/schema.prisma com as models User e Note

Não implemente controllers ou services ainda.
```

---

## Passo 4 — Implementar autenticação

```
Implemente o módulo de autenticação completo:
1. src/repositories/userRepository.ts — findByEmail, create
2. src/services/authService.ts — register (bcrypt hash) e login (bcrypt compare + JWT)
3. src/controllers/authController.ts — POST /auth/register e POST /auth/login
4. src/middlewares/authMiddleware.ts — valida Bearer token e injeta req.userId
5. Validação zod para os bodies de register e login

Crie testes de integração em tests/integration/auth.test.ts
para register (sucesso, email duplicado) e login (sucesso, credenciais inválidas).
```

---

## Passo 5 — Implementar CRUD de notas

```
Implemente o módulo de notas:
1. src/repositories/notesRepository.ts — findAllByUser, findById, create, update, delete, search
2. src/services/notesService.ts — lógica de negócio + verificação de ownership
3. src/controllers/notesController.ts — todos os endpoints de /notes
4. Aplique authMiddleware em todas as rotas de /notes

Regra crítica de negócio: notesService deve verificar que note.userId === req.userId
antes de retornar, editar ou deletar. Retorne NotFoundError (não 403) para não
vazar informação sobre a existência de notas de outros usuários.

Crie tests/integration/notes.test.ts cobrindo:
- CRUD completo como usuário autenticado
- Tentativa de acessar nota de outro usuário (deve ser 404)
- Busca por termo
- Operações sem autenticação (devem ser 401)
```

---

## Passo 6 — Configurar error handler e app.ts

```
Crie src/middlewares/errorHandler.ts que:
- Trata AppError e subclasses com o statusCode correto
- Trata ZodError com status 422 e lista de campos inválidos
- Trata erros não mapeados com 500 (sem vazar stack trace em produção)

Crie src/app.ts configurando o Express com todas as rotas e middlewares.
```

---

## Passo 7 — Usar `@code-reviewer` para revisão

No chat do VS Code (modo Ask), use:

```
@code-reviewer Revise os seguintes arquivos focando em segurança:
#file:src/services/authService.ts
#file:src/middlewares/authMiddleware.ts
#file:src/services/notesService.ts
```

Aplique as correções recomendadas — especialmente as marcadas como 🔴 Crítico.

---

## Passo 8 — Verificar cobertura com `@test-expert`

```
@test-expert A cobertura atual de src/services/ está baixa.
Analise #file:src/services/notesService.ts e gere testes unitários
para os casos não cobertos pelos testes de integração existentes.
```

---

## Passo 9 — Validação final

```bash
npm run lint
npm run type-check
npm test -- --coverage
npm run build
```

Teste manualmente com `curl` ou Insomnia/Postman todos os endpoints do enunciado.
