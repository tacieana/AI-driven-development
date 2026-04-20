# 📝 Exercícios — Capítulo 05: MCP — Model Context Protocol

> Exercícios práticos para configurar, usar e criar servidores MCP. Os exercícios progridem de consumidor a criador do protocolo.

---

## Exercício 01 — Explorando o Ecossistema

**Objetivo:** Desenvolver fluência no ecossistema de servidores MCP disponíveis.

**Tarefa:** Pesquise o repositório oficial de servidores MCP (github.com/modelcontextprotocol/servers) e responda:

1. Liste 3 servidores MCP que seriam úteis no seu contexto de trabalho atual. Para cada um:
   - Nome e URL do repositório
   - Quais tools ele expõe (pelo menos 3)
   - Um caso de uso concreto no seu dia a dia

2. Identifique uma integração que você usa frequentemente que **não** tem servidor MCP público. Descreva:
   - O sistema (ex: "nosso Jira interno", "API da plataforma X")
   - Que tools você criaria se fosse implementar o servidor

**Critério de sucesso:** 3 servidores com casos de uso realistas e 1 gap de integração identificado com tools propostas.

---

## Exercício 02 — Configurando GitHub MCP

**Objetivo:** Configurar e usar o GitHub MCP Server em uma sessão real.

**Pré-requisito:** Ter um token GitHub com permissões de leitura em pelo menos um repositório.

**Tarefa:**

1. Configure o GitHub MCP no Claude Code:
```bash
claude mcp add github \
  -e GITHUB_TOKEN=<seu_token> \
  -- npx -y @modelcontextprotocol/server-github
```

2. Verifique que está configurado:
```bash
claude mcp list
```

3. Em uma sessão do Claude Code, execute estas tarefas:
   - "Liste as 5 issues mais recentes abertas no repositório [seu-repo]"
   - "Leia a issue #[N] e me dê um resumo do que está sendo pedido"
   - "Existe alguma issue relacionada a [tema relevante para seu projeto]?"

4. Documente: o que o modelo conseguiu fazer que antes exigia abrir o GitHub manualmente?

**Critério de sucesso:** As 3 tarefas executadas com sucesso sem abrir o navegador. Documentação do que foi possível.

---

## Exercício 03 — MCP com Banco de Dados

**Objetivo:** Usar o PostgreSQL MCP Server para responder perguntas sobre dados sem escrever queries manualmente.

**Pré-requisito:** PostgreSQL local ou de desenvolvimento (nunca produção).

**Tarefa:**

1. Crie um usuário read-only para o MCP:
```sql
CREATE USER mcp_reader WITH PASSWORD 'mcp_senha_local';
GRANT CONNECT ON DATABASE seu_banco TO mcp_reader;
GRANT USAGE ON SCHEMA public TO mcp_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO mcp_reader;
```

2. Configure o servidor:
```bash
claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres \
  "postgresql://mcp_reader:mcp_senha_local@localhost/seu_banco"
```

3. Faça 5 perguntas ao Claude Code sobre seus dados, incluindo pelo menos:
   - Uma pergunta sobre o schema de uma tabela
   - Uma pergunta analítica (ex: "quantos registros foram criados este mês?")
   - Uma pergunta sobre relacionamentos (ex: "quais são as foreign keys da tabela X?")

**Critério de sucesso:** 5 respostas corretas sobre seus dados. O usuário `mcp_reader` não tem permissão de escrita — confirme tentando uma operação de escrita e verificando a negação.

---

## Exercício 04 — Servidor MCP Mínimo

**Objetivo:** Implementar e rodar seu primeiro servidor MCP customizado.

**Tarefa:** Crie um servidor MCP que expõe informações sobre o ambiente de desenvolvimento:

```typescript
// src/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { ListToolsRequestSchema, CallToolRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import { execSync } from "child_process";
import os from "os";

const server = new Server(
  { name: "dev-info", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "get_java_version",
      description: "Retorna a versão do Java instalada",
      inputSchema: { type: "object", properties: {} },
    },
    {
      name: "list_maven_dependencies",
      description: "Lista dependências Maven do projeto",
      inputSchema: {
        type: "object",
        properties: {
          filter: { type: "string", description: "Filtro opcional por nome de dependência" },
        },
      },
    },
    {
      name: "get_system_info",
      description: "Retorna informações básicas do sistema operacional",
      inputSchema: { type: "object", properties: {} },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === "get_java_version") {
    const version = execSync("java -version 2>&1").toString().trim();
    return { content: [{ type: "text", text: version }] };
  }

  if (name === "list_maven_dependencies") {
    const output = execSync("mvn dependency:list -q 2>/dev/null").toString();
    const { filter } = args as { filter?: string };
    const lines = filter
      ? output.split("\n").filter(l => l.toLowerCase().includes(filter.toLowerCase()))
      : output.split("\n");
    return { content: [{ type: "text", text: lines.join("\n") }] };
  }

  if (name === "get_system_info") {
    const info = `OS: ${os.type()} ${os.release()}\nArch: ${os.arch()}\nNode: ${process.version}`;
    return { content: [{ type: "text", text: info }] };
  }

  throw new Error(`Tool não encontrada: ${name}`);
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

1. Instale o SDK: `npm install @modelcontextprotocol/sdk`
2. Salve o código acima
3. Adicione ao Claude Code: `claude mcp add dev-info -- npx ts-node src/index.ts`
4. Em uma sessão, peça ao Claude Code: "Qual versão do Java estou usando? Tenho o junit instalado como dependência?"

**Critério de sucesso:** O Claude Code usa as tools do seu servidor para responder as perguntas.

---

## Exercício 05 — Servidor MCP com Resources

**Objetivo:** Adicionar resources ao servidor criado no exercício anterior.

**Tarefa:** Estenda o servidor `dev-info` para expor os arquivos de configuração do projeto como resources:

```typescript
import { existsSync, readFileSync } from "fs";
import { ListResourcesRequestSchema, ReadResourceRequestSchema } from "@modelcontextprotocol/sdk/types.js";

server.setRequestHandler(ListResourcesRequestSchema, async () => {
  const configFiles = ["pom.xml", "build.gradle", "package.json", ".env.example", "Makefile"];
  const resources = configFiles
    .filter(f => existsSync(f))
    .map(f => ({
      uri: `project://config/${f}`,
      name: f,
      description: `Arquivo de configuração: ${f}`,
      mimeType: "text/plain",
    }));
  return { resources };
});

server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const filename = request.params.uri.replace("project://config/", "");
  if (!existsSync(filename)) throw new Error(`Arquivo não encontrado: ${filename}`);
  const text = readFileSync(filename, "utf-8");
  return { contents: [{ uri: request.params.uri, mimeType: "text/plain", text }] };
});
```

Teste pedindo ao Claude Code: "Leia o pom.xml e me diga quais são as versões das minhas dependências principais."

**Critério de sucesso:** O Claude Code acessa o resource, lê o arquivo e responde com base no conteúdo real.

---

## Exercício 06 — Fluxo Multi-Servidor

**Objetivo:** Executar uma tarefa que requer múltiplos servidores MCP cooperando.

**Pré-requisito:** GitHub MCP e pelo menos um dos servidores do exercício 04/05 configurados.

**Tarefa:** Execute a seguinte sessão com o Claude Code:

```
"Quero entender o estado atual do projeto. Por favor:
1. Liste as 3 issues abertas mais recentes no GitHub
2. Leia o arquivo README.md do projeto
3. Com base nas issues e no README, me diga:
   - O que o projeto faz
   - Quais são as prioridades atuais
   - Existe alguma inconsistência entre o que o README promete e o que as issues indicam"
```

Documente:
- Quantas chamadas a ferramentas diferentes o Claude fez?
- O resultado final foi útil? O que ele descobriu?
- Qual parte da tarefa teria sido mais trabalhosa sem o MCP?

**Critério de sucesso:** O Claude completa a tarefa cruzando informações de pelo menos 2 fontes diferentes (GitHub + filesystem ou GitHub + seu servidor customizado).

---

## Exercício 07 (Desafio Integrador) — Servidor MCP de Projeto Real

**Objetivo:** Criar um servidor MCP útil para o seu contexto de trabalho real.

**Tarefa:** Identifique um sistema que você acessa regularmente durante o desenvolvimento e crie um servidor MCP para ele. Exemplos:

- API REST interna da empresa
- Sistema de gerenciamento de issues próprio
- Serviço de configuração de feature flags
- API de logs centralizada
- Sistema de documentação interno

**Requisitos do servidor:**
- [ ] Pelo menos 3 tools com descrições claras
- [ ] Pelo menos 1 resource
- [ ] Tratamento de erro adequado (o que acontece se a API estiver fora?)
- [ ] Credenciais via variáveis de ambiente
- [ ] README.md explicando como instalar e usar

**Requisitos de uso:**
- [ ] Configurado e funcionando no Claude Code
- [ ] Documentado no CLAUDE.md do projeto
- [ ] Testado com pelo menos 5 perguntas/tarefas reais

**Entregável:** O código do servidor em um repositório (pode ser privado) e um relatório de 1 página sobre o que ele permite fazer que antes era manual.

**Critério de sucesso:** Um colega consegue configurar e usar o servidor seguindo apenas o README, sem precisar perguntar nada.

---

## ✅ Auto-Avaliação do Capítulo

- [ ] Sei explicar o que é MCP e por que ele resolve o problema N×M de integrações
- [ ] Conheço os papéis de host, client e server na arquitetura MCP
- [ ] Configurei pelo menos um servidor MCP real (GitHub, PostgreSQL ou outro)
- [ ] Implementei um servidor MCP mínimo com tools funcionais
- [ ] Sei expor resources além de tools em um servidor MCP
- [ ] Executei uma tarefa que usa múltiplos servidores MCP simultaneamente
- [ ] Conheço as boas práticas de segurança: menor privilégio, credenciais via env vars

---

## 🔗 Próximo Capítulo

👉 [Capítulo 06 — Claude](../06-claude/01-visao-geral-e-modelos.md)
