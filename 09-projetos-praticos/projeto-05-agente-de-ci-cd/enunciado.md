# Enunciado — Agente de CI/CD com MCP e Claude Code

## Objetivo

Criar um agente de CI/CD que roda automaticamente a cada Pull Request e:
1. Analisa o diff do PR em busca de problemas comuns
2. Verifica se testes foram adicionados para código novo
3. Detecta possíveis problemas de segurança no diff
4. Posta um comentário estruturado no PR com os resultados

---

## Comportamento Esperado

Quando um PR é aberto ou atualizado:

```
┌─ Comentário do agente no PR ──────────────────────────────┐
│ ## 🤖 Análise automática de PR — Claude Code Agent        │
│                                                           │
│ ### ✅ Verificações                                       │
│ - Build: passou                                           │
│ - Testes: passaram (cobertura: 84%)                       │
│                                                           │
│ ### 🔍 Análise do diff                                    │
│ - **src/services/user.ts**: função `createUser` não       │
│   valida o campo `email` antes de persistir               │
│ - **src/controllers/auth.ts**: token JWT está sendo       │
│   logado em `console.log` na linha 47                    │
│                                                           │
│ ### ⚠️ Cobertura de testes                               │
│ - `src/services/user.ts` tem 3 novas funções sem testes  │
│                                                           │
│ ### 💡 Sugestão                                          │
│ Adicione validação de email em `createUser` e remova o   │
│ log do token. Gere testes para as novas funções.         │
└───────────────────────────────────────────────────────────┘
```

---

## Componentes a Construir

### 1. Script de análise (`scripts/analyze-pr.sh`)

Script que recebe o número do PR como argumento e:
- Usa MCP GitHub para obter o diff
- Passa o diff para o Claude Code em modo headless
- Retorna a análise em formato JSON

### 2. Workflow GitHub Actions (`.github/workflows/pr-analysis.yml`)

Trigger: `pull_request` (opened, synchronize)
- Instala Claude Code via npm
- Configura o MCP GitHub com token de Actions
- Executa `analyze-pr.sh` com o número do PR
- Posta o resultado como comentário via GitHub API

### 3. Prompt de análise (`scripts/pr-analysis-prompt.md`)

Template de prompt que o agente usa para analisar o diff. Define:
- Estrutura da análise (seções obrigatórias)
- Severidade dos problemas (crítico, importante, sugestão)
- Formato de output (JSON para processamento)

---

## Critérios de Aceite

- [ ] Workflow dispara automaticamente em novos PRs
- [ ] O agente posta um comentário estruturado no PR
- [ ] Comentários anteriores do agente são atualizados (não duplicados)
- [ ] A análise identifica ao menos: problemas de segurança, falta de testes, code smells
- [ ] O workflow falha graciosamente se o Claude Code não consegue analisar
- [ ] Segredos (ANTHROPIC_API_KEY, GITHUB_TOKEN) nunca aparecem nos logs

---

## Limitações Conhecidas

- O agente analisa o diff, não o código completo — pode haver falsos positivos
- Em PRs muito grandes (>500 linhas de diff), a análise pode ser incompleta
- O agente não executa o código — apenas lê e analisa estaticamente

---

## Referências

> 📌 Claude Code headless: docs.anthropic.com/en/docs/claude-code/cli-reference
> 📌 MCP GitHub Server: github.com/modelcontextprotocol/servers/tree/main/src/github
> 📌 GitHub Actions: docs.github.com/en/actions
