# 10 — Slash Commands

> **Objetivo:** Dominar os slash commands nativos do Claude Code e criar comandos customizados para fluxos específicos do seu projeto.

---

## Slash Commands Nativos

Comandos que vêm pré-instalados no Claude Code:

| Comando | O que faz |
|---------|-----------|
| `/help` | Lista todos os comandos disponíveis |
| `/clear` | Limpa o histórico da sessão |
| `/compact` | Compacta o histórico (libera contexto) |
| `/init` | Gera CLAUDE.md analisando o repo |
| `/status` | Mostra uso de tokens e estado da sessão |
| `/permissions` | Gerencia permissões de ferramentas |
| `/hooks` | Gerencia hooks configurados |
| `/model` | Exibe ou muda o modelo em uso |
| `/exit` | Encerra a sessão |
| `/bug` | Reporta um bug do Claude Code |
| `/doctor` | Diagnóstico da instalação |

> 📌 **Referência:** docs.anthropic.com/en/docs/claude-code/cli-reference

---

## /compact — Gerenciando Contexto

O comando mais importante para sessões longas:

```bash
/compact
```

Compacta o histórico da sessão em um resumo, liberando espaço no contexto para continuar trabalhando. O Claude:
1. Gera um resumo das decisões e estado atual
2. Substitui o histórico completo pelo resumo
3. Continua a sessão com contexto mais limpo

**Quando usar:**
- O Claude avisar que o contexto está quase cheio
- Após uma longa fase de exploração antes de implementar
- Ao iniciar uma nova fase da mesma tarefa

---

## /model — Trocando o Modelo

```bash
/model                       # exibe modelo atual
/model claude-opus-4-7       # muda para Opus (mais poderoso)
/model claude-haiku-4-5-20251001  # muda para Haiku (mais rápido)
```

**Quando trocar:**

```markdown
→ Opus: tarefa complexa que Sonnet não está conseguindo
→ Haiku: tarefa simples onde velocidade importa mais
→ Sonnet: voltar ao padrão após usar Opus
```

---

## Slash Commands como Skills

Todo arquivo em `.claude/skills/` vira um slash command. Você os usa com `/nome-do-arquivo`:

```
.claude/skills/review.md  →  /review
.claude/skills/test.md    →  /test
.claude/skills/deploy.md  →  /deploy
```

A diferença entre slash commands nativos e Skills customizadas é apenas a origem.

---

## Criando Comandos Customizados

Exemplos de comandos úteis para criar:

### /standup — Resumo para daily

```markdown
---
name: standup
description: Gera um resumo do que foi feito para o standup
---

# Resumo para Standup

Analise o histórico git do dia de hoje:
```bash
git log --since="yesterday 18:00" --until="now" --oneline --author="$(git config user.email)"
```

Com base nos commits e nas mensagens, gere um resumo no formato:

**Ontem:**
- [bullet com o que foi feito]

**Hoje:**
- [próximos passos baseados no estado atual]

**Bloqueadores:**
- [se houver algum identificado]

Seja conciso — máximo 5 bullets por seção.
```

### /todo — Lista o que falta fazer

```markdown
---
name: todo
description: Encontra TODOs, FIXMEs e HACKs no projeto
---

# Encontrar Pendências no Código

Busque no código-fonte:
```bash
grep -rn "TODO\|FIXME\|HACK\|XXX" src/ --include="*.py" --include="*.ts" --include="*.go"
```

Organize os resultados por prioridade:
1. 🔴 FIXME e HACK — problemas conhecidos que precisam de atenção
2. 🟡 TODO com contexto claro — tarefas definidas
3. ⚪ TODO vago — itens que precisam ser clarificados

Para cada item, inclua: arquivo:linha, conteúdo, e sua avaliação de urgência.
```

### /coverage — Verifica cobertura de testes

```markdown
---
name: coverage
description: Verifica cobertura de testes e identifica o que está descoberto
---

# Análise de Cobertura de Testes

Execute os testes com cobertura:
```bash
python -m pytest --cov=src --cov-report=term-missing --cov-report=json -q
```

Analise o resultado e:
1. Liste módulos com cobertura < 70%
2. Para cada módulo descoberto, identifique as funções críticas sem teste
3. Priorize: quais são as 3 adições de teste com maior impacto?

Se o argumento `$ARGUMENTS` for fornecido, foque apenas naquele módulo.
```

---

## Passando Argumentos para Comandos

```bash
/explain src/auth/handler.py
/coverage payments
/todo src/payments/
```

No arquivo da skill, use `$ARGUMENTS` para capturar o que vem após o nome do comando.

---

## Listando Comandos Disponíveis

```bash
/help
```

Mostra todos os comandos — nativos e customizados — com suas descrições. As descrições vêm do frontmatter `description` de cada arquivo de skill.

---

## ✅ Pontos-chave do Capítulo

- Comandos nativos cobrem as operações de sessão: `/compact`, `/clear`, `/model`, `/permissions`
- `/compact` é o mais importante para sessões longas — libera contexto sem perder decisões
- Skills em `.claude/skills/` viram slash commands automaticamente com `/nome-do-arquivo`
- Use `$ARGUMENTS` para criar comandos que aceitam parâmetros
- `/help` lista todos os comandos disponíveis — nativos e customizados

---

## 🔗 Próxima Aula

👉 [11 — Fluxos Avançados](./11-fluxos-avancados.md)
