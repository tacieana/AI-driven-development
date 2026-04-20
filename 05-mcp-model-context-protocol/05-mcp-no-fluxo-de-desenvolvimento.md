# 05 — MCP no Fluxo de Desenvolvimento

> **Objetivo:** Aplicar MCP em cenários reais do ciclo de desenvolvimento — integração com issue tracker, CI/CD, banco de dados e monitoramento — e entender como combinar múltiplos servidores.

---

## MCP como Camada de Integração do Dev

Com MCP configurado, o modelo passa a ser um operador capaz de agir em múltiplos sistemas simultaneamente — sem que você precise trocar de contexto.

```mermaid
flowchart LR
    DEV["👤 Dev"] --> CC["🤖 Claude Code"]
    CC <--> GH["📦 GitHub MCP\nissues, PRs, commits"]
    CC <--> DB["📦 PostgreSQL MCP\nschema, queries"]
    CC <--> FS["📦 Filesystem MCP\narquivos locais"]
    CC <--> SENTRY["📦 Sentry MCP\nerros de produção"]
```

Uma única sessão, múltiplos sistemas.

---

## Cenário 1: Issue Tracker Integrado

**Configuração:**
```bash
claude mcp add github -e GITHUB_TOKEN=$GITHUB_TOKEN -- npx -y @modelcontextprotocol/server-github
```

**Fluxos que se tornam possíveis:**

```markdown
"Leia as issues com label 'bug' abertas há mais de 7 dias e me dê um resumo de prioridade"

"Crie issues para cada TODO que você encontrar no código — use o arquivo e linha como título"

"Leia o PR #142, revise o código e poste um comentário com seus achados"

"Feche todas as issues resolvidas pelo commit que acabei de fazer e mencione o PR"
```

**Exemplo de sessão real:**
```
Você: "Analise as últimas 5 issues abertas e sugira qual implementar primeiro"

Claude: [usa list_issues] → lê as 5 issues → analisa impacto e complexidade →
        "Recomendo começar pela issue #34 (autenticação JWT) porque:
         - Bloqueia outras 3 features
         - Complexidade média estimada
         - Issue #41 e #38 dependem dela"
```

---

## Cenário 2: Banco de Dados como Contexto

**Configuração:**
```bash
claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres \
  postgresql://readonly_user:senha@localhost/production_db
```

**Fluxos que se tornam possíveis:**

```markdown
"Qual a estrutura da tabela orders? Estou escrevendo uma migration"

"Escreva a query para encontrar usuários que compraram mais de 3 vezes em novembro"

"O endpoint /api/reports está lento. Olhe o schema e sugira índices"

"Quantos usuários ativos temos? Defina ativo como login nos últimos 30 dias"
```

**Boas práticas de segurança:**
```sql
-- Crie um usuário específico para o MCP com permissões mínimas
CREATE USER mcp_reader WITH PASSWORD 'senha_forte';
GRANT CONNECT ON DATABASE production_db TO mcp_reader;
GRANT USAGE ON SCHEMA public TO mcp_reader;
-- Apenas SELECT nas tabelas necessárias
GRANT SELECT ON TABLE users, orders, products TO mcp_reader;
-- Nunca dar acesso a tabelas com credenciais ou dados financeiros brutos
```

---

## Cenário 3: Debugging com Sentry

**Configuração:**
```bash
# Servidor Sentry (exemplo de servidor da comunidade)
claude mcp add sentry \
  -e SENTRY_AUTH_TOKEN=$SENTRY_TOKEN \
  -e SENTRY_ORG=minha-org \
  -- npx -y @sentry/mcp-server
```

**Fluxos que se tornam possíveis:**

```markdown
"Liste os 5 erros mais frequentes da última semana em produção"

"O erro SentryID abc123 — leia os detalhes e encontre a linha de código responsável"

"Temos um aumento de 40% em erros hoje. O que mudou? Cruze com os deploys recentes"
```

---

## Cenário 4: Pipeline CI/CD

Para integração com GitHub Actions, o GitHub MCP já cobre muito:

```markdown
"O pipeline do PR #89 falhou — leia o log e me diga o que deu errado"

"Qual foi o último deploy bem-sucedido para produção e o que ele incluía?"

"Existe algum workflow de CI que está quebrando há mais de 3 dias?"
```

Para sistemas mais complexos, você pode criar um servidor MCP customizado que fala com sua API de CI/CD interna (Jenkins, TeamCity, etc.) — veja a aula 04.

---

## Combinando Múltiplos Servidores

O poder real do MCP está na combinação. Uma tarefa pode usar vários servidores simultaneamente:

```markdown
"Temos um bug em produção. O Sentry mostra erro NullPointerException em UserService.
 Leia o código relevante, crie uma issue no GitHub, e adicione um comentário
 na issue com sua análise inicial da causa raiz."
```

O que Claude faz internamente:
1. `sentry_get_issue(id)` → detalhes do erro com stack trace
2. `read_file("src/services/UserService.py")` → lê o código
3. Analisa o stack trace no contexto do código
4. `create_issue(title, body_com_analise, labels=["bug", "production"])` → cria issue
5. `create_comment(issue_number, analise_detalhada)` → adiciona análise

Tudo em uma única instrução, sem trocar de contexto.

---

## Configuração de Projeto: Múltiplos Servidores

```json
// .claude/settings.json — configuração de projeto
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "${GITHUB_TOKEN}" }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."],
      "env": {}
    },
    "postgres-readonly": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres",
               "postgresql://mcp_reader:${DB_PASSWORD}@localhost/app_db"],
      "env": { "DB_PASSWORD": "${DB_PASSWORD}" }
    }
  }
}
```

---

## Boas Práticas de MCP em Desenvolvimento

```markdown
✅ DO — Boas práticas:
- Configure servidores no .claude/settings.json do projeto (versionado)
- Use usuários/tokens com permissões mínimas para cada servidor
- Documente no CLAUDE.md quais servidores estão disponíveis e para quê
- Use nomes descritivos: "postgres-readonly" é melhor que "db"

❌ DON'T — Evitar:
- Credenciais hardcoded no settings.json (use ${ENV_VAR})
- Servidor com acesso de escrita ao banco de produção
- Conectar servidores que o modelo não precisa (superfície de ataque)
- Ignorar logs de chamadas MCP em ambiente sensível
```

**Documentando servidores no CLAUDE.md:**
```markdown
## Servidores MCP disponíveis neste projeto

- **github**: acesso ao repo `org/projeto` — criar issues, ler PRs
- **postgres-readonly**: leitura do banco de staging (não produção)
- **filesystem**: leitura/escrita no diretório do projeto

Para configurar: copie `.env.example` para `.env` e preencha os tokens.
```

---

## ✅ Pontos-chave do Capítulo

- MCP transforma o modelo em operador multi-sistema: uma instrução pode agir em GitHub, banco e monitoramento simultaneamente
- GitHub MCP cobre a maioria dos fluxos de issue tracker e PR
- Para banco de dados, crie um usuário read-only específico para o MCP
- Configure servidores no `.claude/settings.json` do projeto — versionado junto com o código
- Documente os servidores disponíveis no `CLAUDE.md` para que toda a equipe saiba o que está configurado

---

## 🔗 Próxima Seção

👉 [Exercícios do Capítulo 05](./06-exercicios.md)
