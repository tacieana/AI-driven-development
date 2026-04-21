# 01 — Copilot CLI: Instalação e Configuração

> **Objetivo:** Instalar o GitHub Copilot no terminal via extensão do GitHub CLI e configurar a integração com o shell.

---

## O que é o Copilot CLI

O Copilot CLI é uma extensão do GitHub CLI (`gh`) que traz as capacidades do Copilot para o terminal. Oferece dois comandos principais:

| Comando | O que faz |
|---------|-----------|
| `gh copilot explain` | Explica um comando em linguagem natural |
| `gh copilot suggest` | Sugere um comando a partir de uma descrição |

É diferente do Agent Mode do IDE — opera exclusivamente no terminal e não edita arquivos.

> 📌 **Referência:** docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line

---

## Requisitos

| Requisito | Detalhe |
|-----------|---------|
| GitHub CLI (`gh`) | Versão 2.x ou superior |
| Conta GitHub | Com Copilot ativo (qualquer plano, incluindo Free) |
| Sistema Operacional | Linux, macOS, Windows (bash, zsh, fish, PowerShell) |

---

## Instalação

### 1. Instalar o GitHub CLI

**macOS:**
```bash
brew install gh
```

**Linux (Ubuntu/Debian):**
```bash
type -p curl >/dev/null || apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
  https://cli.github.com/packages stable main" | \
  tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt update && apt install gh -y
```

**Windows (via winget):**
```powershell
winget install --id GitHub.cli
```

> 📌 **Referência:** docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line#installing-github-copilot-in-the-cli

### 2. Instalar a Extensão Copilot

```bash
gh extension install github/gh-copilot
```

### 3. Autenticar

```bash
gh auth login
# Siga as instruções:
# → GitHub.com
# → HTTPS
# → Login with a web browser
```

Verificar autenticação:
```bash
gh auth status
# ✓ Logged in to github.com as SEU_USUARIO (...)
# ✓ Git operations for github.com configured to use https protocol.
# ✓ Token: gho_...
```

---

## Verificar a Instalação

```bash
gh copilot --version
# gh-copilot version X.X.X (...)

gh copilot --help
# Work seamlessly with GitHub Copilot from the command line.
#
# Usage:
#   copilot [command]
#
# Available Commands:
#   explain     Explain a given input
#   suggest     Request a suggestion based on a natural language description
```

---

## Integração com o Shell (Aliases)

O Copilot CLI oferece integração com alias para uso rápido no terminal. Configure de acordo com o seu shell:

### bash

```bash
# Adicione ao ~/.bashrc
eval "$(gh copilot alias -- bash)"

# Recarregue:
source ~/.bashrc
```

### zsh

```bash
# Adicione ao ~/.zshrc
eval "$(gh copilot alias -- zsh)"

# Recarregue:
source ~/.zshrc
```

### fish

```fish
# Adicione ao ~/.config/fish/config.fish
gh copilot alias -- fish | source
```

### PowerShell

```powershell
# Adicione ao $PROFILE
Invoke-Expression ($(gh copilot alias -- powershell) -join "`n")
```

Após configurar, dois aliases ficam disponíveis:

| Alias | Equivale a |
|-------|-----------|
| `ghcs` | `gh copilot suggest` |
| `ghce` | `gh copilot explain` |

> 📌 **Referência:** docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line#setting-up-github-copilot-in-the-cli

---

## Atualizar a Extensão

```bash
gh extension upgrade gh-copilot
```

Verifique atualizações periodicamente — novas capacidades são adicionadas com frequência.

---

## ✅ Pontos-chave do Capítulo

- O Copilot CLI é uma extensão do `gh` (GitHub CLI), instalada com `gh extension install github/gh-copilot`
- Oferece dois comandos: `gh copilot explain` e `gh copilot suggest`
- Requer `gh auth login` para autenticar com a conta GitHub que tem Copilot ativo
- Aliases (`ghcs`, `ghce`) tornam o uso mais ágil — configure via `eval "$(gh copilot alias -- SHELL)"`
- Funciona em bash, zsh, fish e PowerShell
- Atualize com `gh extension upgrade gh-copilot` para manter as capacidades mais recentes

---

## 🔗 Próxima Aula

👉 [02 — Fluxos no Terminal](./02-fluxos-no-terminal.md)
