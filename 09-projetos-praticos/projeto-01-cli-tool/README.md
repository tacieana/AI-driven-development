# Projeto 01 — CLI Tool com Claude Code

> Construa uma ferramenta de linha de comando do zero, usando Claude Code como par de desenvolvimento, com testes e documentação.

---

## Sobre o Projeto

Você vai construir o **`taskr`** — uma CLI de gerenciamento de tarefas pessoais que opera em arquivos JSON locais. O foco não é o produto final, mas o **processo**: como usar o Claude Code de forma eficiente para ir do zero a uma ferramenta funcional e testada.

## O que você vai praticar

- Configurar `CLAUDE.md` antes de começar a implementação
- Usar Claude Code para planejar e scaffoldar o projeto
- Iterar entre implementação e testes com o agente
- Usar hooks para automatizar verificações de qualidade
- Documentar a CLI com ajuda do Claude

## Ferramentas utilizadas

| Ferramenta | Uso |
|-----------|-----|
| Claude Code | Desenvolvimento principal no terminal |
| GitHub Copilot (opcional) | Completions inline durante ajustes manuais |
| Node.js / TypeScript | Stack do projeto |
| Jest | Testes unitários e de integração |

## Estrutura esperada ao final

```
taskr/
├── src/
│   ├── commands/       # add, list, done, delete
│   ├── storage/        # leitura e escrita do JSON
│   └── utils/          # formatação, validação
├── tests/
│   ├── unit/
│   └── integration/
├── CLAUDE.md           # contexto do projeto para o Claude
├── package.json
└── README.md
```

## Navegação

- 📋 [Enunciado completo](./enunciado.md)
- 🗺️ [Passo a passo guiado](./passo-a-passo.md)
- ✅ [Solução de referência](./solucao/README.md)

---

**Tempo estimado:** 2–4 horas  
**Nível:** Iniciante–Intermediário
