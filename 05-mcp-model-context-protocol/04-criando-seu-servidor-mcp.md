# 04 — Criando seu Servidor MCP

> **Objetivo:** Implementar um servidor MCP do zero em TypeScript, expondo tools, resources e prompts customizados para suas necessidades específicas.

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

A Anthropic mantém SDKs oficiais para Python e TypeScript. **Para os exemplos deste capítulo usamos TypeScript** — é o SDK com maior adoção na comunidade MCP e suporte completo a todos os primitivos do protocolo.

> 📌 **Nota:** Não há SDK MCP oficial para Java. Para integrar seu backend Java com Claude via MCP, crie o servidor MCP em TypeScript e exponha sua API Java internamente.

```bash
# TypeScript/Node (recomendado)
npm install @modelcontextprotocol/sdk

# Python (alternativa)
pip install mcp
```

> 📌 **Referência:** modelcontextprotocol.io/docs/tools/sdk

---

## Servidor Mínimo em TypeScript

```typescript
// src/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  ListToolsRequestSchema,
  CallToolRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  { name: "meu-servidor", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

// Declara as tools disponíveis
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "get_sprint_status",
      description:
        "Retorna o status atual do sprint ativo: issues abertas, " +
        "concluídas e bloqueadas. Use para entender o estado do time.",
      inputSchema: {
        type: "object",
        properties: {
          team: {
            type: "string",
            description: "Nome do time (ex: 'backend', 'frontend')",
          },
        },
        required: ["team"],
      },
    },
  ],
}));

// Implementa a execução das tools
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === "get_sprint_status") {
    const { team } = request.params.arguments as { team: string };
    // Aqui vai sua lógica real: chamar Jira, Linear, etc.
    const status = fetchSprintStatus(team);
    return { content: [{ type: "text", text: status }] };
  }
  throw new Error(`Tool desconhecida: ${request.params.name}`);
});

function fetchSprintStatus(team: string): string {
  // Simulação — substitua por chamada real à sua API
  return `Sprint do time ${team}: 12 issues abertas, 8 concluídas, 2 bloqueadas`;
}

// Ponto de entrada: roda o servidor via stdio
const transport = new StdioServerTransport();
await server.connect(transport);
```

**Executando localmente:**
```bash
npx ts-node src/index.ts
```

**Adicionando ao Claude Code:**
```bash
claude mcp add meu-servidor -- npx ts-node /caminho/src/index.ts
```

---

## Servidor com Resources

```typescript
import { readFileSync } from "fs";
import {
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

server.setRequestHandler(ListResourcesRequestSchema, async () => ({
  resources: [
    {
      uri: "internal://docs/api-reference",
      name: "Referência da API Interna",
      description: "Documentação completa da API REST interna",
      mimeType: "text/markdown",
    },
    {
      uri: "internal://docs/architecture",
      name: "Arquitetura do Sistema",
      description: "Diagrama e decisões de arquitetura",
      mimeType: "text/markdown",
    },
  ],
}));

server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const resources: Record<string, string> = {
    "internal://docs/api-reference": readFileSync("docs/api-reference.md", "utf-8"),
    "internal://docs/architecture":  readFileSync("docs/architecture.md",  "utf-8"),
  };
  const content = resources[request.params.uri];
  if (!content) throw new Error(`Resource não encontrada: ${request.params.uri}`);
  return { contents: [{ uri: request.params.uri, mimeType: "text/markdown", text: content }] };
});
```

---

## Servidor com Prompts

```typescript
import {
  ListPromptsRequestSchema,
  GetPromptRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

server.setRequestHandler(ListPromptsRequestSchema, async () => ({
  prompts: [
    {
      name: "review_migration",
      description: "Revisa uma migration de banco de dados para segurança e reversibilidade",
      arguments: [
        { name: "migration_sql", description: "O conteúdo SQL da migration",          required: true  },
        { name: "table_size",    description: "Tamanho estimado da tabela (ex: '10M rows')", required: false },
      ],
    },
  ],
}));

server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  if (request.params.name === "review_migration") {
    const { migration_sql, table_size = "desconhecido" } = request.params.arguments as {
      migration_sql: string;
      table_size?: string;
    };
    return {
      description: "Revisão de migration",
      messages: [
        {
          role: "user",
          content: {
            type: "text",
            text: `Revise esta migration de banco de dados:

\`\`\`sql
${migration_sql}
\`\`\`

Tamanho da tabela: ${table_size}

Analise:
1. Segurança: a operação pode causar lock de tabela?
2. Reversibilidade: existe um rollback claro?
3. Performance: o impacto em produção é aceitável?
4. Dados: algum dado pode ser perdido permanentemente?

Para cada item, classifique como ✅ OK, ⚠️ Atenção ou 🔴 Bloqueador.`,
          },
        },
      ],
    };
  }
  throw new Error(`Prompt não encontrado: ${request.params.name}`);
});
```

---

## Exemplo Completo: Servidor para API Interna

```typescript
// src/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { ListToolsRequestSchema, CallToolRequestSchema } from "@modelcontextprotocol/sdk/types.js";

const API_BASE = process.env.INTERNAL_API_URL ?? "http://localhost:8000";
const API_KEY  = process.env.INTERNAL_API_KEY  ?? "";

const server = new Server(
  { name: "api-interna", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "list_deployments",
      description: "Lista os deployments recentes do ambiente especificado",
      inputSchema: {
        type: "object",
        properties: {
          environment: { type: "string", enum: ["staging", "production"], description: "Ambiente a consultar" },
          limit:       { type: "integer", description: "Número máximo de resultados (padrão: 10)", default: 10 },
        },
        required: ["environment"],
      },
    },
    {
      name: "get_service_health",
      description: "Verifica saúde de um serviço específico",
      inputSchema: {
        type: "object",
        properties: {
          service: { type: "string", description: "Nome do serviço" },
        },
        required: ["service"],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const headers = { Authorization: `Bearer ${API_KEY}` };
  const { name, arguments: args } = request.params;

  if (name === "list_deployments") {
    const { environment, limit = 10 } = args as { environment: string; limit?: number };
    const url = `${API_BASE}/deployments?environment=${environment}&limit=${limit}`;
    const resp = await fetch(url, { headers });
    if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
    return { content: [{ type: "text", text: await resp.text() }] };
  }

  if (name === "get_service_health") {
    const { service } = args as { service: string };
    const resp = await fetch(`${API_BASE}/services/${service}/health`, { headers });
    if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
    return { content: [{ type: "text", text: await resp.text() }] };
  }

  throw new Error(`Tool desconhecida: ${name}`);
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

```bash
# Adicionar ao Claude Code com variáveis de ambiente
claude mcp add api-interna \
  -e INTERNAL_API_URL=https://api.empresa.com \
  -e INTERNAL_API_KEY=secret \
  -- npx ts-node /caminho/src/index.ts
```

---

> 📌 **Referência:** modelcontextprotocol.io/docs/tools/sdk

---

## ✅ Pontos-chave do Capítulo

- SDKs oficiais existem para TypeScript (`@modelcontextprotocol/sdk`) e Python (`mcp`) — use TypeScript
- A estrutura mínima: `ListToolsRequestSchema` declara as tools; `CallToolRequestSchema` executa quando chamadas
- Resources são para leitura de dados; use URIs semânticas (`schema://caminho/recurso`)
- Prompts são templates parametrizáveis — ótimos para fluxos padronizados do seu time
- Passe credenciais via variáveis de ambiente ao adicionar o servidor com `claude mcp add`

---

## 🔗 Próxima Aula

👉 [05 — MCP no Fluxo de Desenvolvimento](./05-mcp-no-fluxo-de-desenvolvimento.md)
