# Aula 05 — Integrando com o Fluxo de Desenvolvimento

## Objetivo

Usar modelos locais com as ferramentas e práticas vistas ao longo do curso — extensões de IDE, MCP e context engineering — entendendo como aplicar os mesmos princípios independentemente do backend de IA.

---

## Princípio Central

> Todos os conceitos do curso — context engineering, prompt engineering, agentes, MCP — se aplicam a modelos locais. O que muda é apenas a infraestrutura de execução.

Um bom system prompt continua sendo um bom system prompt. CoT e few-shot funcionam da mesma forma. Servidores MCP expõem ferramentas independentemente do modelo que as usa. A diferença está na capacidade do modelo — não na aplicabilidade das técnicas.

---

## Extensões de IDE Alternativas ao Copilot

Quando você usa modelos locais, não tem o GitHub Copilot disponível. Estas extensões preenchem o espaço:

| Extensão | IDE suportado | Backend | Gratuito | Completions inline |
|----------|--------------|---------|---------|-------------------|
| **Continue** | VS Code, JetBrains | Qualquer OpenAI-compat. | ✅ | ✅ |
| **Codeium** | VS Code, JetBrains, Neovim, + | Cloud próprio | ✅ (plano gratuito) | ✅ |
| **Tabby** | VS Code, plugins de IDE | Self-hosted | ✅ | ✅ |
| **Twinny** | VS Code | Ollama local | ✅ | ✅ |
| **Void** | Fork do VS Code | Qualquer OpenAI-compat. | ✅ | ✅ |

> 📌 **Referências:** continue.dev, codeium.com, github.com/TabbyML/tabby, github.com/twinnydotdev/twinny

**Recomendação:** Continue é a opção mais completa e flexível para uso com Ollama.

---

## Continue + Ollama: Configuração Prática

Continue é uma extensão open source para VS Code e JetBrains que integra completions inline, chat e comandos de slash com qualquer backend compatível com OpenAI.

### Instalação

1. Instale a extensão **Continue** no VS Code (marketplace.visualstudio.com)
2. Na primeira execução, o Continue abre o assistente de configuração
3. Selecione "Ollama" como provider

### Configuração manual

O arquivo de configuração fica em `~/.continue/config.json`:

```json
{
  "models": [
    {
      "title": "Qwen 2.5 Coder 7B",
      "provider": "ollama",
      "model": "qwen2.5-coder:7b",
      "apiBase": "http://localhost:11434"
    },
    {
      "title": "Llama 3.1 8B",
      "provider": "ollama",
      "model": "llama3.1:8b",
      "apiBase": "http://localhost:11434"
    }
  ],
  "tabAutocompleteModel": {
    "title": "Qwen 2.5 Coder 7B (Autocomplete)",
    "provider": "ollama",
    "model": "qwen2.5-coder:7b",
    "apiBase": "http://localhost:11434"
  },
  "embeddingsProvider": {
    "provider": "ollama",
    "model": "nomic-embed-text",
    "apiBase": "http://localhost:11434"
  }
}
```

**O que cada seção faz:**
- `models` — modelos disponíveis no chat do Continue (troca com Cmd/Ctrl+L)
- `tabAutocompleteModel` — modelo usado para completions inline (Tab)
- `embeddingsProvider` — modelo para embeddings do codebase (busca semântica)

> 📌 **Referência:** continue.dev/docs/setup/select-model — guia de configuração de modelos

### Uso no dia a dia

| Ação | Atalho |
|------|--------|
| Abrir chat | `Cmd/Ctrl + L` |
| Explicar seleção | Selecionar + `Cmd/Ctrl + L` |
| Aceitar completion | `Tab` |
| Rejeitar completion | `Esc` |
| Próxima sugestão | `Alt + ]` |
| Editar com instrução | `Cmd/Ctrl + I` |

---

## MCP com Modelos Locais

Servidores MCP funcionam com qualquer modelo que suporte tool use. O Continue suporta MCP nativamente — você configura servidores MCP no `config.json` e eles ficam disponíveis no chat.

```json
{
  "mcpServers": [
    {
      "name": "filesystem",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/caminho/do/projeto"]
    },
    {
      "name": "postgres",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost:5432/db"
      }
    }
  ]
}
```

```mermaid
sequenceDiagram
    participant Dev as Desenvolvedor
    participant Continue as Continue (VS Code)
    participant Ollama as Ollama API<br/>localhost:11434
    participant Model as Qwen 2.5 Coder
    participant MCP as MCP Server<br/>(filesystem, postgres...)

    Dev->>Continue: pergunta no chat
    Continue->>Ollama: mensagem + tools disponíveis
    Ollama->>Model: inferência
    Model->>Ollama: tool_call (ex: read_file)
    Ollama->>Continue: resposta com tool call
    Continue->>MCP: executa ferramenta
    MCP->>Continue: resultado da ferramenta
    Continue->>Ollama: resultado + continua
    Ollama->>Model: inferência com contexto completo
    Model->>Ollama: resposta final
    Ollama->>Continue: texto final
    Continue->>Dev: resposta no chat
```

**Limitação importante:** nem todos os modelos locais têm tool use confiável. Qwen 2.5 Coder e Llama 3.1 têm o melhor suporte. Modelos menores (3B e abaixo) frequentemente falham em seguir o formato de tool call.

> 📌 **Referência:** continue.dev/docs/customize/context-providers — documentação de MCP no Continue

---

## Context Engineering com Modelos Locais

Todos os princípios do capítulo 03 se aplicam. A principal diferença é a janela de contexto:

| Modelo | Contexto máximo |
|--------|----------------|
| Claude Sonnet | 200.000 tokens |
| GPT-4o | 128.000 tokens |
| Qwen 2.5 Coder 7B | 32.768 tokens |
| Llama 3.1 8B | 131.072 tokens |
| Mistral 7B | 32.768 tokens |

**Adaptações práticas para contexto menor:**

Em vez de incluir o projeto inteiro, seja cirúrgico:
```
❌ "Veja o repositório completo e me diga o que faz"

✅ "Veja os arquivos src/services/payment.ts e src/types/payment.ts
    e me explique como o processamento de pagamento funciona"
```

**System prompt como equivalente ao CLAUDE.md:**

No LM Studio, Continue e outros clientes, o system prompt pode ser configurado permanentemente — use-o como você usaria o `CLAUDE.md`:

```
Você é um assistente de desenvolvimento especializado neste projeto.

Stack: Node.js 20 + TypeScript + Prisma + PostgreSQL + Vitest
Padrões: imports ordenados, tipos explícitos, nunca use 'any'
Testes: sempre Vitest com describe/it, cobertura mínima de funções públicas
```

---

## Fluxo Híbrido: Local + Cloud

O modelo mais produtivo combina modelos locais para tarefas rotineiras com Claude/Copilot para tarefas complexas:

```mermaid
flowchart TD
    Task[Nova tarefa] --> Q1{Dados sensíveis\nou confidenciais?}
    Q1 -->|Sim| Local[Modelo Local\nQwen 2.5 Coder]
    Q1 -->|Não| Q2{Tarefa complexa?\nArquitetura, debug profundo,\ncontexto longo?}
    Q2 -->|Sim| Cloud[Claude Sonnet/Opus\nou Copilot]
    Q2 -->|Não| Q3{Alto volume?\n>1000 req/dia\nou automação CI?}
    Q3 -->|Sim| Local
    Q3 -->|Não| Either[Qualquer um —\nescolha pela conveniência]

    Local --> L1[✅ Completion inline\n✅ Chat sobre código\n✅ Documentação simples\n✅ Testes unitários]
    Cloud --> C1[✅ Arquitetura de sistema\n✅ Debugging complexo\n✅ Contexto longo >32K\n✅ Raciocínio multi-step]
```

---

## Anti-Patterns

❌ **Não usar modelos locais para tarefas que excedem sua capacidade**
Se o modelo fica "preso" em raciocínio circular ou gera código incorreto repetidamente, mude para Claude/Copilot. Insistir custa mais tempo do que o switch.

❌ **Não usar modelos locais sem system prompt em projetos específicos**
Sem system prompt com o contexto do projeto, o modelo responde de forma genérica. Configure o Modelfile ou o system prompt do Continue com as convenções do projeto.

❌ **Não confiar em tool use de modelos <7B para automações críticas**
Modelos muito pequenos frequentemente malformam tool calls. Valide sempre com modelos de pelo menos 7B para uso com MCP.

✅ **Use o modelo local para o que ele faz bem:** autocompletar, responder perguntas simples sobre código, gerar testes unitários, documentar funções específicas.

✅ **Mantenha o Copilot ou Claude Code ativo em paralelo** para tarefas que exigem mais capacidade. As ferramentas se complementam.

---

## Pontos-Chave

- **Continue + Ollama** é a combinação mais prática para integração local no VS Code — open source, configurável e compatível com MCP
- **MCP funciona com modelos locais** — o protocolo é independente do backend de IA
- **Contexto menor exige mais precisão** — seja cirúrgico ao referenciar arquivos e funções
- **Fluxo híbrido** (local para rotina, cloud para complexidade) maximiza privacidade e custo sem sacrificar qualidade quando importa

---

## Próxima Aula

👉 [Aula 06 — Privacidade, Compliance e Casos Enterprise](./06-privacidade-compliance-e-casos-enterprise.md)
