# 03 — Servidores MCP Prontos

> **Objetivo:** Conhecer os principais servidores MCP disponíveis, o que cada um oferece e como configurá-los no Claude Code para uso imediato.

---

## Como Adicionar um Servidor MCP no Claude Code

```bash
# Sintaxe básica
claude mcp add <nome> <comando> [args...]

# Com variáveis de ambiente
claude mcp add <nome> -e VAR=valor <comando>

# Escopo: projeto (padrão) ou global
claude mcp add <nome> --scope global <comando>

# Listar servidores configurados
claude mcp list

# Remover servidor
claude mcp remove <nome>
```

> 📌 **Referência:** docs.anthropic.com/en/docs/claude-code/mcp

---

## GitHub MCP Server

O servidor mais usado em desenvolvimento. Permite ao modelo operar diretamente no GitHub.

**Instalação:**
```bash
claude mcp add github -e GITHUB_TOKEN=<seu_token> -- npx -y @modelcontextprotocol/server-github
```

**Tools disponíveis (seleção):**

| Tool | O que faz |
|------|-----------|
| `create_issue` | Cria uma issue |
| `list_issues` | Lista issues com filtros |
| `create_pull_request` | Abre um PR |
| `get_pull_request` | Lê detalhes de um PR |
| `merge_pull_request` | Faz merge (cuidado: requer aprovação) |
| `search_repositories` | Busca repositórios |
| `get_file_contents` | Lê arquivo de um repo |
| `create_or_update_file` | Cria/atualiza arquivo no repo |

**Casos de uso:**
```markdown
"Crie uma issue para rastrear o bug de autenticação que encontramos"
"Liste os PRs abertos no repo org/projeto e classifique por prioridade"
"Leia o arquivo src/auth.py do branch main e identifique vulnerabilidades"
```

> 📌 **Referência:** github.com/modelcontextprotocol/servers/tree/main/src/github

---

## Filesystem MCP Server

Acesso ao sistema de arquivos local com controle de diretórios permitidos.

**Instalação:**
```bash
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /caminho/permitido
```

**Tools disponíveis:**

| Tool | O que faz |
|------|-----------|
| `read_file` | Lê conteúdo de arquivo |
| `read_multiple_files` | Lê vários arquivos de uma vez |
| `write_file` | Escreve/cria arquivo |
| `edit_file` | Edição com diff (busca e substituição) |
| `list_directory` | Lista conteúdo de diretório |
| `create_directory` | Cria diretório |
| `move_file` | Move/renomeia arquivo |
| `search_files` | Busca por nome com glob |
| `get_file_info` | Metadados do arquivo |

> 📌 **Referência:** github.com/modelcontextprotocol/servers/tree/main/src/filesystem

---

## PostgreSQL MCP Server

Acesso read-only (por padrão) ao banco de dados PostgreSQL.

**Instalação:**
```bash
claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres postgresql://usuario:senha@localhost/banco
```

**Recursos expostos:**

| Tipo | O que expõe |
|------|-------------|
| Resource | Schema de cada tabela |
| Tool `query` | Executa SQL SELECT |

**Casos de uso:**
```markdown
"Qual o schema da tabela orders?"
"Quantos usuários se cadastraram nos últimos 7 dias?"
"Escreva uma migration para adicionar índice na coluna email da tabela users"
```

> ⚠️ Configure o usuário do banco com permissões mínimas — apenas SELECT nas tabelas relevantes.

> 📌 **Referência:** github.com/modelcontextprotocol/servers/tree/main/src/postgres

---

## SQLite MCP Server

Para bancos SQLite locais. Suporta leitura e escrita (com cuidado).

**Instalação:**
```bash
claude mcp add sqlite -- npx -y @modelcontextprotocol/server-sqlite /caminho/banco.db
```

**Tools disponíveis:**

| Tool | O que faz |
|------|-----------|
| `read_query` | SELECT — somente leitura |
| `write_query` | INSERT/UPDATE/DELETE |
| `create_table` | Cria tabela |
| `list_tables` | Lista tabelas |
| `describe_table` | Schema de uma tabela |

---

## Slack MCP Server

Integração com workspaces Slack para leitura e envio de mensagens.

**Instalação:**
```bash
claude mcp add slack \
  -e SLACK_BOT_TOKEN=xoxb-... \
  -e SLACK_TEAM_ID=T... \
  -- npx -y @modelcontextprotocol/server-slack
```

**Tools disponíveis (seleção):**

| Tool | O que faz |
|------|-----------|
| `slack_list_channels` | Lista canais |
| `slack_get_channel_history` | Histórico de mensagens |
| `slack_post_message` | Envia mensagem (requer aprovação) |
| `slack_reply_to_thread` | Responde em thread |
| `slack_get_users` | Lista membros |

> 📌 **Referência:** github.com/modelcontextprotocol/servers/tree/main/src/slack

---

## Brave Search MCP Server

Busca na web via Brave Search API. Útil para consultar documentação atualizada.

**Instalação:**
```bash
claude mcp add brave-search \
  -e BRAVE_API_KEY=<sua_chave> \
  -- npx -y @modelcontextprotocol/server-brave-search
```

**Tools:**
- `brave_web_search` — busca geral na web
- `brave_local_search` — busca de negócios/locais

---

## Puppeteer MCP Server

Controle de navegador para automação web e scraping.

**Instalação:**
```bash
claude mcp add puppeteer -- npx -y @modelcontextprotocol/server-puppeteer
```

**Tools:**
- `puppeteer_navigate` — navega para URL
- `puppeteer_screenshot` — captura screenshot
- `puppeteer_click` — clica em elemento
- `puppeteer_fill` — preenche formulário
- `puppeteer_evaluate` — executa JavaScript

**Casos de uso:**
```markdown
"Acesse a página de status do nosso serviço e me diga se há algum incidente"
"Faça um screenshot da nossa landing page para eu revisar"
```

> 📌 **Referência:** github.com/modelcontextprotocol/servers/tree/main/src/puppeteer

---

## Configuração via settings.json

Além do `claude mcp add`, você pode configurar servidores diretamente no `.claude/settings.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/mydb"],
      "env": {
        "PGPASSWORD": "${DB_PASSWORD}"
      }
    }
  }
}
```

> Use variáveis de ambiente (`${VAR}`) para credenciais — nunca as coloque hardcoded.

> 📌 **Referência:** docs.anthropic.com/en/docs/claude-code/mcp

---

## Tabela de Referência Rápida

| Servidor | Package npm | Requer credencial |
|----------|------------|:-----------------:|
| GitHub | `@modelcontextprotocol/server-github` | GitHub Token |
| Filesystem | `@modelcontextprotocol/server-filesystem` | Não |
| PostgreSQL | `@modelcontextprotocol/server-postgres` | Connection string |
| SQLite | `@modelcontextprotocol/server-sqlite` | Não |
| Slack | `@modelcontextprotocol/server-slack` | Bot Token + Team ID |
| Brave Search | `@modelcontextprotocol/server-brave-search` | API Key |
| Puppeteer | `@modelcontextprotocol/server-puppeteer` | Não |
| Notion | `@notionhq/notion-mcp-server` | Integration Token |
| Sentry | `@sentry/mcp-server` | Auth Token |

---

## ✅ Pontos-chave do Capítulo

- `claude mcp add` é o comando para adicionar servidores; `claude mcp list` para ver os configurados
- GitHub MCP é o mais útil para desenvolvimento: cria issues, lê PRs, manipula arquivos
- PostgreSQL MCP deve usar usuário com permissões mínimas — idealmente só SELECT
- Credenciais sempre via variáveis de ambiente, nunca hardcoded no settings.json
- A maioria dos servidores usa `npx -y` para instalação automática na primeira execução

---

## 🔗 Próxima Aula

👉 [04 — Criando seu Servidor MCP](./04-criando-seu-servidor-mcp.md)
