# 02 — Custom Agents com .agent.md

> **Objetivo:** Criar agentes customizados para o Copilot Chat usando arquivos `.agent.md` — especialistas em tarefas específicas do seu projeto.

---

## O que são Custom Agents

Custom Agents são agentes especializados criados por você (ou seu time) que aparecem como participantes no Copilot Chat, invocáveis via `@nome-do-agente`. Diferente das instruções genéricas do `copilot-instructions.md`, cada agente tem:

- Um conjunto focado de instruções para uma tarefa específica
- Ferramentas definidas explicitamente (o que pode e não pode fazer)
- Um modelo de IA preferencial
- Comportamento determinístico e reutilizável

> 📌 **Referência:** docs.github.com/en/copilot/customizing-copilot/using-github-copilot-extensions-with-agent-mode

---

## Estrutura de um Arquivo `.agent.md`

Os arquivos `.agent.md` ficam em `.github/agents/` e têm frontmatter YAML seguido de instruções em markdown:

```markdown
---
name: code-reviewer
description: Revisa código focando em segurança, performance e manutenibilidade
model: claude-sonnet-3-7
tools:
  - codebase
  - problems
---

Você é um revisor de código sênior especializado neste projeto.

## Seu foco
Ao revisar código, sempre verifique:
1. **Segurança**: SQL injection, XSS, dados sensíveis expostos, validação de input
2. **Performance**: N+1 queries, loops desnecessários, alocações excessivas
3. **Manutenibilidade**: nomes descritivos, responsabilidade única, acoplamento

## Formato de resposta
Para cada problema encontrado, use:
- **Severidade**: 🔴 Crítico | 🟡 Importante | 🟢 Sugestão
- **Localização**: arquivo:linha
- **Problema**: descrição clara
- **Solução**: código de exemplo corrigido

Sempre termine com um resumo: "X críticos, Y importantes, Z sugestões".
```

> 📌 **Referência:** docs.github.com/en/copilot/customizing-copilot/using-github-copilot-extensions-with-agent-mode#creating-custom-agents

---

## Frontmatter: Campos Disponíveis

| Campo | Obrigatório | Valores | Descrição |
|-------|:-----------:|---------|-----------|
| `name` | ✅ | string | Nome do agente (usado no `@nome`) |
| `description` | ✅ | string | Descrição exibida no seletor de chat |
| `model` | ❌ | `gpt-4o`, `claude-sonnet-3-7`, etc. | Modelo padrão para o agente |
| `tools` | ❌ | lista de tools | Ferramentas que o agente pode usar |

### Tools disponíveis no frontmatter

| Tool | O que permite |
|------|--------------|
| `codebase` | Busca semântica no workspace |
| `problems` | Acesso a erros de compilação/linting |
| `terminal` | Executar comandos no terminal |
| `file_search` | Buscar arquivos por nome |
| `run_tests` | Executar suite de testes |

---

## Exemplos de Agentes por Caso de Uso

### Agente: Especialista em Testes

```markdown
---
name: test-expert
description: Gera e melhora testes com alta cobertura e qualidade
model: claude-sonnet-3-7
tools:
  - codebase
  - run_tests
  - problems
---

Você é um especialista em testes para este projeto.

## Stack de testes
- Framework: Jest 29
- Factories em: tests/factories/
- Mocks em: tests/mocks/

## O que você sempre faz
- Cobre o happy path e os principais edge cases
- Testa comportamento, não implementação
- Usa describe aninhado para organizar contextos
- Nomeia tests no padrão: "should [comportamento esperado] when [condição]"

## O que você nunca faz
- Não cria testes que testam apenas que uma função foi chamada
- Não usa snapshots para lógica de negócio
- Não deixa testes sem assertion
```

### Agente: Especialista em Documentação

```markdown
---
name: doc-writer
description: Gera e atualiza documentação técnica do projeto
model: gpt-4o
tools:
  - codebase
  - file_search
---

Você é um technical writer especializado em documentação de código.

## Estilo de documentação
- Linguagem: português do Brasil
- Tom: técnico mas acessível
- Formato: markdown com exemplos de código

## O que você documenta
- Funções públicas: JSDoc/TSDoc com @param, @returns, @throws, @example
- Módulos: header explicando responsabilidade e quando usar
- APIs: parâmetros, exemplos de request/response, erros possíveis
```

---

## Localização dos Arquivos `.agent.md`

```
repositório/
└── .github/
    └── agents/
        ├── code-reviewer.agent.md
        ├── test-expert.agent.md
        ├── doc-writer.agent.md
        └── security-auditor.agent.md
```

**Nomes de arquivo:** Use o padrão `nome-do-agente.agent.md`. O nome no frontmatter deve corresponder.

---

## Usar um Custom Agent no Chat

```
1. Abra o Copilot Chat (Ctrl+Alt+I)
2. No campo de mensagem, digite @
3. Selecione o agente na lista de sugestões
4. Escreva sua solicitação

Exemplo:
@code-reviewer Revise #selection — foque em segurança e performance
@test-expert Gere testes para #file:paymentService.ts
@doc-writer Documente todas as funções públicas de #file:userService.ts
```

---

## Diferença entre `.agent.md` e `copilot-instructions.md`

| Aspecto | `copilot-instructions.md` | `.agent.md` |
|---------|:------------------------:|:-----------:|
| Escopo | Todas as interações do repo | Invocação explícita via `@nome` |
| Especialização | Geral | Focada em uma tarefa |
| Modelo configurável | ❌ | ✅ |
| Ferramentas configuráveis | ❌ | ✅ |
| Reutilização | Automática | Manual (você invoca) |
| Múltiplos por repo | 1 por nível | Quantos quiser |

---

## ✅ Pontos-chave do Capítulo

- Arquivos `.agent.md` em `.github/agents/` criam agentes especializados invocáveis via `@nome`
- O frontmatter YAML define nome, descrição, modelo e ferramentas permitidas
- Cada agente pode ter um modelo diferente — use Claude Opus para revisão complexa, GPT-4o para geração rápida
- Custom agents são mais precisos que o Copilot genérico em tarefas repetitivas e bem definidas
- Um agente focado (test-expert, code-reviewer) produz resultados mais consistentes que um prompt longo no chat geral
- Armazene no repositório para que todo o time tenha acesso ao mesmo conjunto de agentes

---

## 🔗 Próxima Aula

👉 [03 — Copilot Spaces](./03-copilot-spaces.md)
