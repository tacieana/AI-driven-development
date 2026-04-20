# 08 — MCP no Claude Code

> **Objetivo:** Configurar e usar servidores MCP no Claude Code, gerenciar múltiplos servidores e entender como as ferramentas MCP se integram ao fluxo de trabalho do agente.

---

## MCP no Claude Code

O Claude Code tem suporte nativo a MCP. Servidores configurados ficam disponíveis como ferramentas adicionais em toda sessão — o agente decide quando usá-los.

```mermaid
flowchart LR
    CC["🤖 Claude Code"] <--> FS["🔧 Ferramentas nativas\n(read, write, bash)"]
    CC <--> GH["📦 MCP: GitHub"]
    CC <--> DB["📦 MCP: PostgreSQL"]
    CC <--> CUSTOM["📦 MCP: API interna"]
```

> 📌 **Referência:** docs.anthropic.com/en/docs/claude-code/mcp

---

## Gerenciando Servidores MCP

```bash
# Adicionar servidor
claude mcp add <nome> [opções] -- <comando> [args]

# Listar servidores configurados
claude mcp list

# Ver detalhes de um servidor
claude mcp get <nome>

# Remover servidor
claude mcp remove <nome>

# Reiniciar servidor (se travar)
claude mcp restart <nome>
```

---

## Adicionando Servidores Comuns

```bash
# GitHub
claude mcp add github \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  -- npx -y @modelcontextprotocol/server-github

# Filesystem (diretório específico)
claude mcp add docs-fs \
  -- npx -y @modelcontextprotocol/server-filesystem ./docs

# PostgreSQL (read-only)
claude mcp add db-readonly \
  -- npx -y @modelcontextprotocol/server-postgres \
  "postgresql://mcp_reader:${DB_PASS}@localhost/app_db"

# Servidor customizado em Python
claude mcp add api-interna \
  -e API_KEY=$INTERNAL_API_KEY \
  -- python .claude/mcp/api_server.py
```

---

## Escopo de Configuração

```bash
# Escopo padrão: local (só este projeto)
claude mcp add nome -- comando

# Escopo global (todos os projetos)
claude mcp add nome --scope global -- comando

# Escopo de projeto (versionado no repo)
claude mcp add nome --scope project -- comando
```

| Escopo | Onde salva | Quem vê |
|--------|-----------|---------|
| `local` | `.claude/settings.local.json` | Só você, este projeto |
| `project` | `.claude/settings.json` | Time todo, este projeto |
| `global` | `~/.claude/settings.json` | Só você, todos os projetos |

---

## Verificando Ferramentas Disponíveis

Dentro de uma sessão, veja quais tools MCP estão disponíveis:

```
"Quais ferramentas MCP você tem disponíveis nesta sessão?"
```

O Claude lista as tools de todos os servidores conectados.

---

## Fluxo de Uso: MCP + Ferramentas Nativas

O poder do Claude Code com MCP está na combinação:

```
Você: "Tem alguma issue no GitHub relacionada ao erro de autenticação
       que aparece no arquivo src/auth/handler.py?"

Claude:
1. [MCP GitHub] list_issues(labels=["bug"], state="open")
   → encontra issue #34: "Login falha com tokens expirados"

2. [Read nativo] read_file("src/auth/handler.py")
   → lê o código

3. Analisa: issue #34 menciona expiração de token;
   handler.py tem bug na verificação de expiração na linha 47

4. Responde com análise cruzada e sugestão de fix
```

Uma instrução em linguagem natural, ferramentas nativas + MCP cooperando.

---

## Servidores MCP no settings.json

Para versionar a configuração de servidores com o projeto:

```json
// .claude/settings.json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "db-readonly": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://mcp_reader:${DB_PASS}@localhost/app_db"
      ]
    }
  }
}
```

**Variáveis de ambiente:** use `${VAR}` — o Claude Code resolve do ambiente no momento de iniciar o servidor.

---

## Documentando MCP no CLAUDE.md

Informe o agente sobre os servidores disponíveis:

```markdown
## Servidores MCP neste projeto

- **github**: Issues, PRs e arquivos do repo `org/projeto`
- **db-readonly**: Leitura do banco de staging (SELECT apenas)
- **api-interna**: Consulta a deployments e health checks

Para usar: estes servidores ficam disponíveis automaticamente.
Configure os tokens em `.env` conforme `.env.example`.
```

---

## ✅ Pontos-chave do Capítulo

- Claude Code tem suporte MCP nativo — servidores configurados viram ferramentas do agente
- `claude mcp add/list/remove` gerencia servidores; três escopos: local, project, global
- Versione servidores do time em `.claude/settings.json` usando `${ENV_VAR}` para credenciais
- Documente no `CLAUDE.md` quais servidores estão disponíveis e para quê
- A combinação de ferramentas nativas + MCP permite tarefas que cruzam múltiplos sistemas

---

## 🔗 Próxima Aula

👉 [09 — Plugins e Distribuição](./09-plugins-e-distribuicao.md)
