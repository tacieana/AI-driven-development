# Projeto 02 — API REST com Copilot Agent Mode

> Construa uma API REST com autenticação JWT usando GitHub Copilot Agent Mode e instruções customizadas.

---

## Sobre o Projeto

Você vai construir a **API de Notas** — um backend simples de criação e gerenciamento de notas pessoais com autenticação. O foco é praticar o uso do **Copilot Agent Mode** com um `copilot-instructions.md` bem configurado para guiar a geração de código.

## O que você vai praticar

- Configurar `.github/copilot-instructions.md` antes de usar o Agent Mode
- Usar Agent Mode para implementar features end-to-end
- Delegar correções de bugs via comentários no PR (Cloud Agent)
- Criar e usar agentes customizados para revisão e testes

## Ferramentas utilizadas

| Ferramenta | Uso |
|-----------|-----|
| Copilot Agent Mode | Desenvolvimento principal no VS Code |
| Copilot Cloud Agent | Issues de correção de bug |
| `@code-reviewer` agent | Revisão do código gerado |
| `@test-expert` agent | Geração de testes de integração |
| Node.js / Express / TypeScript | Stack do projeto |

## Estrutura esperada ao final

```
notes-api/
├── src/
│   ├── controllers/    # auth, notes
│   ├── services/       # authService, notesService
│   ├── repositories/   # userRepository, notesRepository
│   ├── middlewares/    # authMiddleware, errorHandler
│   ├── errors/         # AppError, ValidationError, NotFoundError
│   └── app.ts
├── tests/
│   ├── unit/
│   └── integration/
├── .github/
│   ├── copilot-instructions.md
│   └── agents/
│       ├── code-reviewer.agent.md
│       └── test-expert.agent.md
└── prisma/
    └── schema.prisma
```

## Navegação

- 📋 [Enunciado completo](./enunciado.md)
- 🗺️ [Passo a passo guiado](./passo-a-passo.md)
- ✅ [Solução de referência](./solucao/README.md)

---

**Tempo estimado:** 3–5 horas  
**Nível:** Intermediário
