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

```python
# dev_info_mcp.py
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp import types
import subprocess
import sys
import platform

app = Server("dev-info")

@app.list_tools()
async def list_tools() -> list[types.Tool]:
    return [
        types.Tool(
            name="get_python_version",
            description="Retorna a versão do Python instalada",
            inputSchema={"type": "object", "properties": {}}
        ),
        types.Tool(
            name="list_installed_packages",
            description="Lista pacotes Python instalados com suas versões",
            inputSchema={
                "type": "object",
                "properties": {
                    "filter": {
                        "type": "string",
                        "description": "Filtro opcional por nome de pacote"
                    }
                }
            }
        ),
        types.Tool(
            name="get_system_info",
            description="Retorna informações básicas do sistema operacional",
            inputSchema={"type": "object", "properties": {}}
        )
    ]

@app.call_tool()
async def call_tool(name: str, arguments: dict) -> list[types.TextContent]:
    if name == "get_python_version":
        version = sys.version
        return [types.TextContent(type="text", text=f"Python {version}")]

    if name == "list_installed_packages":
        result = subprocess.run(
            [sys.executable, "-m", "pip", "list"],
            capture_output=True, text=True
        )
        output = result.stdout
        if filter_str := arguments.get("filter"):
            lines = [l for l in output.split("\n") if filter_str.lower() in l.lower()]
            output = "\n".join(lines)
        return [types.TextContent(type="text", text=output)]

    if name == "get_system_info":
        info = f"OS: {platform.system()} {platform.release()}\nArch: {platform.machine()}"
        return [types.TextContent(type="text", text=info)]

    raise ValueError(f"Tool não encontrada: {name}")

if __name__ == "__main__":
    import asyncio
    asyncio.run(stdio_server(app))
```

1. Instale o SDK: `pip install mcp`
2. Salve o código acima
3. Adicione ao Claude Code: `claude mcp add dev-info python dev_info_mcp.py`
4. Em uma sessão, peça ao Claude Code: "Qual versão do Python estou usando? Tenho o pytest instalado?"

**Critério de sucesso:** O Claude Code usa as tools do seu servidor para responder as perguntas.

---

## Exercício 05 — Servidor MCP com Resources

**Objetivo:** Adicionar resources ao servidor criado no exercício anterior.

**Tarefa:** Estenda o `dev_info_mcp.py` para expor os arquivos de configuração do projeto como resources:

```python
import os
from pathlib import Path

@app.list_resources()
async def list_resources() -> list[types.Resource]:
    config_files = []
    config_patterns = [
        "pyproject.toml", "setup.py", "requirements.txt",
        "package.json", ".env.example", "Makefile"
    ]
    for pattern in config_patterns:
        if Path(pattern).exists():
            config_files.append(
                types.Resource(
                    uri=f"project://config/{pattern}",
                    name=pattern,
                    description=f"Arquivo de configuração: {pattern}",
                    mimeType="text/plain"
                )
            )
    return config_files

@app.read_resource()
async def read_resource(uri: str) -> str:
    filename = uri.replace("project://config/", "")
    path = Path(filename)
    if not path.exists():
        raise ValueError(f"Arquivo não encontrado: {filename}")
    return path.read_text()
```

Teste pedindo ao Claude Code: "Leia o requirements.txt e me diga se estou usando versões fixas ou ranges para as dependências."

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
