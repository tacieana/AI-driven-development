# 📝 Exercícios — Claude Code

> Exercícios práticos para dominar o Claude Code — da instalação ao uso avançado com hooks, skills e CI/CD.

---

## Exercício 01 — Instalação e Primeiro /init

**Objetivo:** Configurar o Claude Code e gerar o primeiro CLAUDE.md.

**Tarefa:**

1. Instale o Claude Code: `npm install -g @anthropic-ai/claude-code`
2. Autentique: `claude`
3. Navegue até um repositório seu (ou clone um open-source)
4. Execute `/init` dentro de uma sessão
5. Leia o CLAUDE.md gerado e avalie:
   - O que está correto?
   - O que está faltando?
   - O que precisa ser corrigido?
6. Edite o CLAUDE.md para adicionar pelo menos: stack completa, 3 convenções de código, 2 decisões técnicas

**Critério de sucesso:** CLAUDE.md existente com conteúdo que um dev novo usaria para entender o projeto.

---

## Exercício 02 — Fluxo Básico de Debugging

**Objetivo:** Usar o Claude Code para diagnosticar e corrigir um bug real.

**Tarefa:**

1. Encontre um bug real no seu projeto (ou introduza um intencionalmente)
2. Abra uma sessão Claude Code no projeto
3. Descreva o bug com contexto: "Estou recebendo [erro] quando [ação]. Aqui está o stack trace: [stack trace]"
4. Siga o fluxo do Claude: observe quais arquivos ele lê, quais mudanças propõe
5. **Antes de aprovar qualquer escrita**, revise o que ele vai modificar
6. Após a correção, execute os testes manualmente

**Critério de sucesso:** Bug corrigido, testes passando, e você consegue explicar o que o Claude fez e por quê está correto.

---

## Exercício 03 — Criando uma Skill de Code Review

**Objetivo:** Criar uma skill de code review personalizada para seu projeto.

**Tarefa:** Crie `.claude/skills/review.md` com:
- Frontmatter com `name: review` e `description`
- As categorias de review relevantes para seu stack (ex: segurança JWT, queries N+1, etc.)
- Formato de output estruturado (severidade, arquivo:linha, descrição, sugestão)
- O que ignorar (estilo pessoal, comentários triviais)

Teste com:
```bash
git checkout -b test-review
# faça algumas mudanças no código
/review
```

Avalie: o review encontrou problemas reais? O formato é útil?

**Critério de sucesso:** A skill produz reviews acionáveis, no formato esperado, sem falsos positivos óbvios.

---

## Exercício 04 — Hooks de Automação

**Objetivo:** Configurar hooks que automatizem verificações sem intervenção manual.

**Tarefa:** Configure em `.claude/settings.json`:

1. **Hook de lint automático:** roda `ruff check --fix` (Python) ou `eslint --fix` (JS/TS) sempre que um arquivo do tipo certo for escrito

2. **Hook de notificação:** ao terminar uma tarefa (`Stop`), exibe o número de arquivos modificados na sessão:
```bash
git diff --name-only | wc -l
```

3. Teste ambos os hooks em uma sessão real.

**Critério de sucesso:** Os hooks disparam corretamente, são rápidos (< 2s) e não bloqueiam o fluxo para os casos de sucesso.

---

## Exercício 05 — Sessão com Múltiplos MCP

**Objetivo:** Executar uma tarefa que requer ferramentas nativas do Claude Code + pelo menos um servidor MCP.

**Pré-requisito:** GitHub MCP configurado (ou qualquer servidor MCP do capítulo 05).

**Tarefa:** Execute esta instrução (adapte para seu contexto):

```
"Verifique se existe alguma issue no GitHub relacionada a qualquer TODO
que você encontrar no código. Para cada TODO:
1. Leia o contexto do código ao redor
2. Busque issues com título semelhante
3. Se não existir issue, crie uma com o arquivo:linha e descrição do problema"
```

**Critério de sucesso:** O Claude usa grep/read (ferramentas nativas) + GitHub MCP para cruzar informações e criar issues relevantes.

---

## Exercício 06 — CLAUDE.md Completo para Projeto Real

**Objetivo:** Criar um CLAUDE.md de produção que você vai usar de fato.

**Tarefa:** Para o projeto mais importante que você trabalha atualmente, crie um `CLAUDE.md` completo com:

- [ ] Visão geral (2-3 frases)
- [ ] Stack completa com versões
- [ ] Arquitetura (módulos e responsabilidades)
- [ ] Todos os comandos necessários (dev, test, lint, migrate, deploy)
- [ ] Pelo menos 5 convenções de código
- [ ] Pelo menos 3 decisões técnicas com justificativa
- [ ] Lista de "nunca fazer" (pelo menos 5 itens)
- [ ] Dependências externas e como configurar localmente

**Validação:** Mostre o arquivo para um colega. Ele consegue iniciar desenvolvimento no projeto usando apenas o CLAUDE.md?

**Critério de sucesso:** Um dev novo (ou o Claude em sessão nova) não faz perguntas básicas sobre o projeto.

---

## Exercício 07 — Headless em Script de CI

**Objetivo:** Integrar o Claude Code em um pipeline como verificador automático.

**Tarefa:** Crie `scripts/ai-check.sh` que:

1. Analisa o diff do PR atual (ou últimos commits)
2. Identifica possíveis problemas de segurança
3. Retorna exit code 0 se OK, 1 se encontrar algo crítico
4. Posta um resumo no stdout

```bash
#!/bin/bash
set -e

DIFF=$(git diff origin/main...HEAD -- "*.py" "*.ts" "*.go" 2>/dev/null || git diff HEAD~1 HEAD)

if [ -z "$DIFF" ]; then
    echo "Nenhuma mudança para analisar"
    exit 0
fi

OUTPUT=$(claude --dangerously-skip-permissions \
               --no-ansi \
               --max-turns 3 \
               -p "Analise este diff por problemas de segurança.
                   Retorne APENAS no formato:
                   STATUS: OK ou CRÍTICO
                   PROBLEMAS: (lista, ou 'nenhum')
                   
                   Diff:
                   $DIFF")

echo "$OUTPUT"

if echo "$OUTPUT" | grep -q "STATUS: CRÍTICO"; then
    exit 1
fi
exit 0
```

Teste em um PR ou branch com mudanças reais.

**Critério de sucesso:** O script roda em < 60s, retorna exit codes corretos e produz output legível para logs de CI.

---

## Exercício 08 (Desafio Integrador) — Setup Completo para um Projeto

**Objetivo:** Configurar um ambiente Claude Code completo e produtivo para um projeto real.

**Entregáveis:**

1. **CLAUDE.md** — briefing completo do projeto (Exercício 06)

2. **`.claude/settings.json`** — configurações do time:
   - Permissões adequadas (allow/deny)
   - Servidores MCP relevantes

3. **Skills customizadas** (pelo menos 3):
   - `/review` — code review específico para o projeto
   - Uma skill de processo do seu time (migration, deploy, standup…)
   - Uma skill de diagnóstico (coverage, todo, security…)

4. **Hooks** (pelo menos 2):
   - Hook de qualidade após escrita de arquivos
   - Hook de notificação ao terminar

5. **`scripts/ai-check.sh`** — verificação automática headless

6. **Documentação** no CLAUDE.md: como usar as skills, quais hooks estão configurados, como instalar

**Critério de sucesso:**
- [ ] Um dev novo consegue configurar tudo seguindo apenas o README/CLAUDE.md
- [ ] As 3 skills funcionam e produzem output útil
- [ ] Os hooks disparam sem erros
- [ ] O script headless funciona no CI

---

## ✅ Auto-Avaliação do Claude Code

- [ ] Instalei e autentiquei o Claude Code
- [ ] Tenho um CLAUDE.md funcional em pelo menos um projeto
- [ ] Criei pelo menos uma skill customizada e uso regularmente
- [ ] Configurei pelo menos um hook de qualidade
- [ ] Sei usar /compact quando o contexto está cheio
- [ ] Sei configurar permissões (allow/deny) no settings.json
- [ ] Tenho pelo menos um servidor MCP configurado no Claude Code
- [ ] Executei o Claude Code em modo headless (mesmo que para testar)

---

## 🔗 Próximo Capítulo

👉 [Capítulo 07 — GitHub Copilot](../../07-github-copilot/01-visao-geral-e-planos.md)
