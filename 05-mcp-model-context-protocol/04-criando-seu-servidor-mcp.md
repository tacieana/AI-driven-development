# 04 — Criando seu Servidor MCP

> **Objetivo:** Implementar um servidor MCP do zero em Python ou TypeScript, expondo tools, resources e prompts customizados para suas necessidades específicas.

---

## Quando Criar seu Próprio Servidor

```markdown
✅ Crie um servidor MCP quando:
- Sua ferramenta interna não tem servidor MCP público
- Precisa de integração com API privada da empresa
- Quer padronizar como o modelo acessa seu sistema
- Deseja distribuir uma integração para seu time

❌ Não crie quando:
- Já existe um servidor MCP público para a ferramenta
- Tool use direto na API resolve o problema
- A integração é usada em um único projeto por uma pessoa
```

---

## SDK Oficial

A Anthropic mantém SDKs para Python e TypeScript:

```bash
# Python
pip install mcp

# TypeScript/Node
npm install @modelcontextprotocol/sdk
```

> 📌 **Referência:** modelcontextprotocol.io/docs/tools/sdk

---

## Servidor Mínimo em Python

```python
# mcp_server.py
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp import types

# Inicializa o servidor com um nome
app = Server("meu-servidor")

# Declara as tools disponíveis
@app.list_tools()
async def list_tools() -> list[types.Tool]:
    return [
        types.Tool(
            name="get_sprint_status",
            description=(
                "Retorna o status atual do sprint ativo: issues abertas, "
                "concluídas e bloqueadas. Use para entender o estado do time."
            ),
            inputSchema={
                "type": "object",
                "properties": {
                    "team": {
                        "type": "string",
                        "description": "Nome do time (ex: 'backend', 'frontend')"
                    }
                },
                "required": ["team"]
            }
        )
    ]

# Implementa a execução das tools
@app.call_tool()
async def call_tool(name: str, arguments: dict) -> list[types.TextContent]:
    if name == "get_sprint_status":
        team = arguments["team"]
        # Aqui vai sua lógica real: chamar Jira, Linear, etc.
        status = fetch_sprint_status(team)  # sua função
        return [types.TextContent(type="text", text=status)]

    raise ValueError(f"Tool desconhecida: {name}")

def fetch_sprint_status(team: str) -> str:
    # Simulação — substitua por chamada real à sua API
    return f"Sprint do time {team}: 12 issues abertas, 8 concluídas, 2 bloqueadas"

# Ponto de entrada: roda o servidor via stdio
if __name__ == "__main__":
    import asyncio
    asyncio.run(stdio_server(app))
```

**Executando localmente:**
```bash
python mcp_server.py
```

**Adicionando ao Claude Code:**
```bash
claude mcp add meu-servidor python /caminho/mcp_server.py
```

---

## Servidor com Resources

```python
@app.list_resources()
async def list_resources() -> list[types.Resource]:
    return [
        types.Resource(
            uri="internal://docs/api-reference",
            name="Referência da API Interna",
            description="Documentação completa da API REST interna",
            mimeType="text/markdown"
        ),
        types.Resource(
            uri="internal://docs/architecture",
            name="Arquitetura do Sistema",
            description="Diagrama e decisões de arquitetura",
            mimeType="text/markdown"
        )
    ]

@app.read_resource()
async def read_resource(uri: str) -> str:
    resources = {
        "internal://docs/api-reference": Path("docs/api-reference.md").read_text(),
        "internal://docs/architecture": Path("docs/architecture.md").read_text(),
    }
    if uri not in resources:
        raise ValueError(f"Resource não encontrada: {uri}")
    return resources[uri]
```

---

## Servidor com Prompts

```python
@app.list_prompts()
async def list_prompts() -> list[types.Prompt]:
    return [
        types.Prompt(
            name="review_migration",
            description="Revisa uma migration de banco de dados para segurança e reversibilidade",
            arguments=[
                types.PromptArgument(
                    name="migration_sql",
                    description="O conteúdo SQL da migration",
                    required=True
                ),
                types.PromptArgument(
                    name="table_size",
                    description="Tamanho estimado da tabela (ex: '10M rows')",
                    required=False
                )
            ]
        )
    ]

@app.get_prompt()
async def get_prompt(name: str, arguments: dict) -> types.GetPromptResult:
    if name == "review_migration":
        sql = arguments["migration_sql"]
        table_size = arguments.get("table_size", "desconhecido")
        return types.GetPromptResult(
            description="Revisão de migration",
            messages=[
                types.PromptMessage(
                    role="user",
                    content=types.TextContent(
                        type="text",
                        text=f"""Revise esta migration de banco de dados:

```sql
{sql}
```

Tamanho da tabela: {table_size}

Analise:
1. Segurança: a operação pode causar lock de tabela?
2. Reversibilidade: existe um rollback claro?
3. Performance: o impacto em produção é aceitável?
4. Dados: algum dado pode ser perdido permanentemente?

Para cada item, classifique como ✅ OK, ⚠️ Atenção ou 🔴 Bloqueador."""
                    )
                )
            ]
        )
    raise ValueError(f"Prompt não encontrado: {name}")
```

---

## Exemplo Completo: Servidor para API Interna

```python
# mcp_internal_api.py
import httpx
import os
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp import types

app = Server("api-interna")
API_BASE = os.environ.get("INTERNAL_API_URL", "http://localhost:8000")
API_KEY = os.environ.get("INTERNAL_API_KEY", "")

@app.list_tools()
async def list_tools() -> list[types.Tool]:
    return [
        types.Tool(
            name="list_deployments",
            description="Lista os deployments recentes do ambiente especificado",
            inputSchema={
                "type": "object",
                "properties": {
                    "environment": {
                        "type": "string",
                        "enum": ["staging", "production"],
                        "description": "Ambiente a consultar"
                    },
                    "limit": {
                        "type": "integer",
                        "description": "Número máximo de resultados (padrão: 10)",
                        "default": 10
                    }
                },
                "required": ["environment"]
            }
        ),
        types.Tool(
            name="get_service_health",
            description="Verifica saúde de um serviço específico",
            inputSchema={
                "type": "object",
                "properties": {
                    "service": {"type": "string", "description": "Nome do serviço"}
                },
                "required": ["service"]
            }
        )
    ]

@app.call_tool()
async def call_tool(name: str, arguments: dict) -> list[types.TextContent]:
    headers = {"Authorization": f"Bearer {API_KEY}"}

    async with httpx.AsyncClient() as client:
        if name == "list_deployments":
            env = arguments["environment"]
            limit = arguments.get("limit", 10)
            resp = await client.get(
                f"{API_BASE}/deployments",
                params={"environment": env, "limit": limit},
                headers=headers
            )
            resp.raise_for_status()
            return [types.TextContent(type="text", text=resp.text)]

        if name == "get_service_health":
            service = arguments["service"]
            resp = await client.get(
                f"{API_BASE}/services/{service}/health",
                headers=headers
            )
            resp.raise_for_status()
            return [types.TextContent(type="text", text=resp.text)]

    raise ValueError(f"Tool desconhecida: {name}")

if __name__ == "__main__":
    import asyncio
    asyncio.run(stdio_server(app))
```

```bash
# Adicionar ao Claude Code com variáveis de ambiente
claude mcp add api-interna \
  -e INTERNAL_API_URL=https://api.empresa.com \
  -e INTERNAL_API_KEY=secret \
  python /caminho/mcp_internal_api.py
```

---

## Estrutura de um Servidor MCP em TypeScript

```typescript
// src/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { ListToolsRequestSchema, CallToolRequestSchema } from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  { name: "meu-servidor", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "my_tool",
      description: "Descrição da ferramenta",
      inputSchema: {
        type: "object",
        properties: {
          param: { type: "string", description: "Parâmetro" }
        },
        required: ["param"]
      }
    }
  ]
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === "my_tool") {
    const { param } = request.params.arguments as { param: string };
    return { content: [{ type: "text", text: `Resultado para: ${param}` }] };
  }
  throw new Error(`Tool desconhecida: ${request.params.name}`);
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

> 📌 **Referência:** modelcontextprotocol.io/docs/tools/sdk/python

---

## ✅ Pontos-chave do Capítulo

- SDKs oficiais existem para Python (`mcp`) e TypeScript (`@modelcontextprotocol/sdk`)
- A estrutura mínima: `list_tools()` declara as tools; `call_tool()` executa quando chamadas
- Resources são para leitura de dados; use URIs semânticas (`schema://caminho/recurso`)
- Prompts são templates parametrizáveis — ótimos para fluxos padronizados do seu time
- Passe credenciais via variáveis de ambiente ao adicionar o servidor com `claude mcp add`

---

## 🔗 Próxima Aula

👉 [05 — MCP no Fluxo de Desenvolvimento](./05-mcp-no-fluxo-de-desenvolvimento.md)
