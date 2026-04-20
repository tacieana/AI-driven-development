# 01 — Instalação e Configuração

> **Objetivo:** Instalar o Claude Code, autenticar e configurar o ambiente inicial para começar a usar o agente de desenvolvimento via CLI.

---

## O que é o Claude Code

Claude Code é um agente de desenvolvimento que roda no terminal. Ele tem acesso ao seu sistema de arquivos, pode executar comandos, ler e escrever código — e opera em loop até concluir as tarefas.

Diferente de um chat, ele **age**: lê arquivos, edita código, roda testes e entrega resultados.

> 📌 **Referência:** docs.anthropic.com/en/docs/claude-code/overview

---

## Requisitos

| Requisito | Versão mínima |
|-----------|:------------:|
| Node.js | 18+ |
| Sistema operacional | macOS, Linux ou Windows (WSL) |
| Conta Anthropic | Com acesso ao Claude Code |

---

## Instalação

```bash
npm install -g @anthropic-ai/claude-code
```

Verifique a instalação:
```bash
claude --version
```

---

## Autenticação

```bash
claude
```

Na primeira execução, o Claude Code abre o navegador para autenticação via conta Anthropic. Após autenticar, as credenciais ficam salvas localmente.

**Via API Key (alternativo):**
```bash
export ANTHROPIC_API_KEY=sk-ant-...
claude
```

> 📌 **Referência:** docs.anthropic.com/en/docs/claude-code/setup

---

## Primeira Sessão

Navegue até um repositório e inicie o Claude Code:

```bash
cd seu-projeto
claude
```

O Claude Code lê automaticamente o `CLAUDE.md` do diretório se existir. Para criar um:

```bash
# Dentro de uma sessão Claude Code
/init
```

O `/init` analisa o repositório e gera um `CLAUDE.md` com:
- Stack detectada
- Comandos de build e teste
- Estrutura de diretórios

---

## Modos de Execução

### Interativo (padrão)
```bash
claude
```
REPL interativo: você digita, o Claude responde e age.

### One-shot (headless)
```bash
claude -p "Explique a função authenticate em src/auth.py"
```
Executa uma única tarefa e sai. Útil para scripts e CI/CD.

### Com arquivo de entrada
```bash
claude < tarefa.txt
```

### Continuando sessão anterior
```bash
claude --continue
```

---

## Configuração Inicial Recomendada

Após instalar, configure estas preferências globais:

```bash
# Dentro do Claude Code
/config
```

Ou edite diretamente `~/.claude/settings.json`:

```json
{
  "model": "claude-sonnet-4-6",
  "theme": "dark",
  "autoUpdates": true
}
```

---

## Estrutura de Arquivos

```
~/.claude/
├── settings.json       # Configurações globais
├── CLAUDE.md           # Instruções globais (todos os projetos)
└── projects/           # Cache de sessões

seu-projeto/
├── .claude/
│   └── settings.json   # Configurações do projeto
└── CLAUDE.md           # Instruções do projeto
```

---

## Permissões e Modo de Segurança

Por padrão, ações com efeito colateral (escrita de arquivos, execução de comandos) pedem confirmação. Para ajustar:

```bash
# Ver permissões atuais
/permissions

# Modo que permite mais ações automaticamente
claude --dangerously-skip-permissions  # usar com cuidado
```

> 📌 **Referência:** docs.anthropic.com/en/docs/claude-code/settings

---

## ✅ Pontos-chave do Capítulo

- Instale via `npm install -g @anthropic-ai/claude-code` — requer Node.js 18+
- Autenticação via browser na primeira execução; depois usa as credenciais salvas
- `/init` analisa o repositório e gera um `CLAUDE.md` inicial automaticamente
- Três modos: interativo (REPL), one-shot (`-p "tarefa"`) e headless via stdin
- Configurações globais em `~/.claude/settings.json`; por projeto em `.claude/settings.json`

---

## 🔗 Próxima Aula

👉 [02 — Primeiros Passos](./02-primeiros-passos.md)
