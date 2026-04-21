# Passo a Passo — Agente de CI/CD com MCP e Claude Code

---

## Passo 1 — Configurar o MCP GitHub Server localmente

Antes de integrar com Actions, valide que o MCP funciona localmente:

```bash
# Adicionar o servidor MCP GitHub ao Claude Code
claude mcp add github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=seu_token_aqui \
  -- npx -y @modelcontextprotocol/server-github

# Verificar que está ativo
claude mcp list
```

Crie um token em `github.com/settings/tokens` com permissões:
- `repo` (leitura de PRs e criação de comentários)
- `pull_requests` (leitura de diffs)

> 📌 **Referência:** docs.anthropic.com/en/docs/claude-code/mcp

---

## Passo 2 — Testar o agente interativamente

Com o MCP GitHub ativo, teste uma análise interativa primeiro:

```bash
claude
```

```
Usando o MCP GitHub, analise o PR #42 do repositório SEU_USUARIO/SEU_REPO.

Para cada arquivo modificado no diff:
1. Identifique possíveis problemas de segurança
2. Verifique se novas funções têm testes correspondentes
3. Sinalize code smells óbvios

Retorne a análise em JSON com a estrutura:
{
  "security": [{ "file": "...", "line": N, "issue": "...", "severity": "critical|warning" }],
  "missing_tests": ["arquivo1.ts", "arquivo2.ts"],
  "code_smells": [{ "file": "...", "issue": "..." }],
  "summary": "..."
}
```

Verifique se a saída JSON é válida e coerente com o diff real.

---

## Passo 3 — Criar o prompt de análise

Crie `scripts/pr-analysis-prompt.md`:

```markdown
Você é um agente de revisão de código automatizado.

Analise o diff do PR fornecido e retorne um JSON válido com esta estrutura exata:

{
  "security": [
    { "file": "caminho/arquivo.ts", "line": 42, "issue": "descrição do problema", "severity": "critical" }
  ],
  "missing_tests": ["arquivo-sem-teste.ts"],
  "code_smells": [
    { "file": "caminho/arquivo.ts", "issue": "descrição" }
  ],
  "summary": "Resumo em 1-2 frases do estado geral do PR"
}

Regras:
- Retorne APENAS o JSON, sem texto antes ou depois
- Seja conservador: sinalize apenas problemas claros, não hipotéticos
- "critical" é para segurança e corretude; "warning" para boas práticas
- Se não há problemas em uma categoria, retorne array vazio []
- missing_tests: liste apenas arquivos com funções/classes novas sem arquivo de teste correspondente
```

---

## Passo 4 — Criar o script de análise

Crie `scripts/analyze-pr.sh`:

```bash
#!/bin/bash
set -e

PR_NUMBER=$1
REPO=$2  # formato: owner/repo

if [ -z "$PR_NUMBER" ] || [ -z "$REPO" ]; then
  echo "Uso: $0 <pr_number> <owner/repo>"
  exit 1
fi

PROMPT=$(cat scripts/pr-analysis-prompt.md)

# Executa Claude Code em modo headless com o MCP GitHub
# O agente vai usar o MCP para buscar o diff do PR automaticamente
ANALYSIS=$(claude --output-format json -p "
$PROMPT

Analise o PR #$PR_NUMBER do repositório $REPO.
Use o MCP GitHub para obter o diff completo antes de analisar.
" 2>/dev/null)

echo "$ANALYSIS"
```

Torne o script executável e teste localmente:

```bash
chmod +x scripts/analyze-pr.sh
./scripts/analyze-pr.sh 42 seu-usuario/seu-repo
```

> 📌 **Referência Claude headless:** docs.anthropic.com/en/docs/claude-code/cli-reference#non-interactive-mode

---

## Passo 5 — Criar o script de postagem de comentário

Crie `scripts/post-comment.sh`:

```bash
#!/bin/bash
set -e

PR_NUMBER=$1
REPO=$2
ANALYSIS_JSON=$3

# Formata o JSON em markdown para o comentário
BODY=$(node -e "
const a = JSON.parse(process.argv[1]);
let md = '## 🤖 Análise automática de PR — Claude Code Agent\n\n';

if (a.security.length > 0) {
  md += '### 🔴 Segurança\n';
  a.security.forEach(s =>
    md += \`- **\${s.file}** (linha \${s.line}): \${s.issue}\n\`
  );
  md += '\n';
}

if (a.missing_tests.length > 0) {
  md += '### ⚠️ Sem testes\n';
  a.missing_tests.forEach(f => md += \`- \${f}\n\`);
  md += '\n';
}

if (a.code_smells.length > 0) {
  md += '### 🟡 Code smells\n';
  a.code_smells.forEach(s => md += \`- **\${s.file}**: \${s.issue}\n\`);
  md += '\n';
}

md += '### 💬 Resumo\n' + a.summary;
console.log(md);
" "$ANALYSIS_JSON")

# Posta o comentário via GitHub CLI
gh pr comment "$PR_NUMBER" \
  --repo "$REPO" \
  --body "$BODY" \
  --edit-last 2>/dev/null || \
gh pr comment "$PR_NUMBER" \
  --repo "$REPO" \
  --body "$BODY"
```

O `--edit-last` atualiza o comentário anterior do agente em vez de criar um novo.

---

## Passo 6 — Criar o workflow do GitHub Actions

Crie `.github/workflows/pr-analysis.yml`:

```yaml
name: PR Analysis Agent

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
      contents: read

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Configure MCP GitHub
        run: |
          claude mcp add github \
            -e GITHUB_PERSONAL_ACCESS_TOKEN=${{ secrets.GITHUB_TOKEN }} \
            -- npx -y @modelcontextprotocol/server-github

      - name: Run PR Analysis
        id: analysis
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          ANALYSIS=$(./scripts/analyze-pr.sh \
            ${{ github.event.pull_request.number }} \
            ${{ github.repository }})
          echo "result=$ANALYSIS" >> $GITHUB_OUTPUT

      - name: Post Comment
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          ./scripts/post-comment.sh \
            ${{ github.event.pull_request.number }} \
            ${{ github.repository }} \
            '${{ steps.analysis.outputs.result }}'
```

---

## Passo 7 — Configurar segredos no repositório

```
GitHub repo → Settings → Secrets and variables → Actions

Adicione:
- ANTHROPIC_API_KEY: sua chave da API Anthropic
  (obtenha em: console.anthropic.com)

Nota: GITHUB_TOKEN é automático — não precisa configurar
```

---

## Passo 8 — Testar com um PR real

1. Crie um branch com alguma mudança de código
2. Abra um PR para o main
3. Verifique a aba "Actions" — o workflow deve disparar
4. Aguarde o comentário do agente no PR
5. Verifique se a análise é coerente com o código do diff

---

## Extensões Possíveis

```
Após o projeto base funcionar:

1. Adicionar análise de performance (detecção de N+1 queries)
2. Integrar com Sentry MCP para correlacionar erros em produção
3. Fazer o agente sugerir código de correção (não só identificar)
4. Adicionar threshold: workflow falha se há problemas críticos
5. Cachear análises de PRs para não reprocessar commits já analisados
```
