# Template: copilot-instructions.md — Base

> Salve como `.github/copilot-instructions.md` na raiz do repositório.
> Preencha os campos entre `[colchetes]` com as informações do seu projeto.

---

```markdown
# GitHub Copilot Instructions

Este repositório é [BREVE DESCRIÇÃO DO PROJETO — ex: "uma API REST de gerenciamento de pedidos em Node.js"].

---

## Stack técnica

- **Linguagem:** [ex: TypeScript 5.x com strict: true]
- **Runtime:** [ex: Node.js 20 LTS]
- **Framework:** [ex: Fastify 4 / Express 4 / NestJS 10]
- **Banco de dados:** [ex: PostgreSQL 15 via Prisma ORM]
- **Testes:** [ex: Jest 29 com ts-jest]
- **Linting:** [ex: ESLint + Prettier]

---

## Estrutura de diretórios

```
src/
├── [pasta]/   # [responsabilidade]
├── [pasta]/   # [responsabilidade]
└── [pasta]/   # [responsabilidade]

tests/
├── unit/      # Testes unitários
└── integration/ # Testes de integração
```

---

## Padrões de código

- [Padrão 1 — ex: "Use arrow functions para funções simples, function declarations para funções nomeadas no topo do módulo"]
- [Padrão 2 — ex: "Imports: bibliotecas externas primeiro, módulos internos depois, separados por linha em branco"]
- [Padrão 3 — ex: "Nunca use `any` no TypeScript — use `unknown` com type guard quando o tipo for incerto"]

---

## Padrões de teste

- Framework: [ex: Jest com describe/it]
- Nomeação: `it('should [comportamento] when [condição]', ...)`
- Factories: [ex: `tests/factories/` para criar entidades de teste]
- Mocks: [ex: `tests/mocks/` para dependências externas]
- Cobertura mínima: [ex: 80% de lines coverage]

---

## Tratamento de erros

- [ex: "Use a classe `AppError` em `src/errors/AppError.ts` para erros de domínio"]
- [ex: "Nunca lance `new Error()` diretamente — use as classes de erro customizadas"]
- [ex: "Erros inesperados devem ser logados com `logger.error()` antes de relançar"]

---

## Verificações de CI (rode antes de criar PR)

```bash
[ex: npm run lint]
[ex: npm run type-check]
[ex: npm test]
[ex: npm run build]
```

---

## O que NÃO fazer

- [Anti-pattern 1 — ex: "Não adicione `console.log` — use `src/utils/logger.ts`"]
- [Anti-pattern 2 — ex: "Não instale dependências sem justificar na descrição do PR"]
- [Anti-pattern 3 — ex: "Não desabilite regras do ESLint sem comentário explicando o motivo"]
```
