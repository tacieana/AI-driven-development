# Projeto 05 — Agente de CI/CD com MCP e Claude Code

> Automatize um pipeline de CI/CD usando Claude Code com servidores MCP para criar um agente que valida PRs, detecta problemas e sugere correções automaticamente.

---

## Sobre o Projeto

Você vai configurar um fluxo agentic de CI/CD onde Claude Code:
1. Lê o status de PRs via MCP GitHub
2. Analisa os diffs e identifica problemas
3. Posta comentários automáticos com sugestões
4. Executa verificações de qualidade locais

Não é necessário um servidor de produção — tudo roda localmente com o Claude Code em modo headless, chamado pelo GitHub Actions.

## O que você vai praticar

- Configurar servidores MCP no Claude Code (GitHub MCP)
- Usar Claude Code em modo headless (`claude -p`)
- Criar um workflow GitHub Actions que invoca Claude Code
- Passar contexto estruturado para sessões não-interativas

## Ferramentas utilizadas

| Ferramenta | Uso |
|-----------|-----|
| Claude Code (headless) | Agente de análise de PR |
| MCP GitHub Server | Acesso a PRs, comentários, diffs |
| GitHub Actions | Trigger e execução do agente |
| Bash | Scripts de orquestração |

## Navegação

- 📋 [Enunciado completo](./enunciado.md)
- 🗺️ [Passo a passo guiado](./passo-a-passo.md)

---

**Tempo estimado:** 4–6 horas  
**Nível:** Avançado
