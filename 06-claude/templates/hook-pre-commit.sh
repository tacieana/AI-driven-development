#!/bin/bash
# Hook de exemplo: verificação pré-escrita de arquivos
#
# Configure em .claude/settings.json:
# {
#   "hooks": {
#     "PreToolUse": [{
#       "matcher": "Write",
#       "hooks": [{"type": "command", "command": "bash .claude/hooks/pre-write.sh"}]
#     }]
#   }
# }
#
# Variáveis disponíveis:
#   $CLAUDE_TOOL_NAME       — nome da ferramenta (ex: "Write")
#   $CLAUDE_TOOL_INPUT_PATH — caminho do arquivo sendo escrito
#   $CLAUDE_TOOL_INPUT      — JSON completo dos argumentos

set -e

FILE_PATH="${CLAUDE_TOOL_INPUT_PATH:-}"

if [ -z "$FILE_PATH" ]; then
    exit 0  # sem arquivo, deixa passar
fi

# ============================================================
# Regra 1: Bloquear escrita em arquivos de configuração de prod
# ============================================================
if echo "$FILE_PATH" | grep -qE "config/(production|prod)\.(json|yaml|yml|env)$"; then
    echo "❌ BLOQUEADO: não escreva em arquivos de configuração de produção" >&2
    echo "   Arquivo: $FILE_PATH" >&2
    echo "   Para modificar configs de prod, faça manualmente após revisão." >&2
    exit 1
fi

# ============================================================
# Regra 2: Bloquear arquivos de segredos
# ============================================================
if echo "$FILE_PATH" | grep -qE "\.(env|pem|key|p12|pfx)$"; then
    echo "❌ BLOQUEADO: arquivo de segredo detectado" >&2
    echo "   Arquivo: $FILE_PATH" >&2
    exit 1
fi

# ============================================================
# Regra 3: Aviso para arquivos de migration (não bloqueia)
# ============================================================
if echo "$FILE_PATH" | grep -qE "migrations?/.*\.(py|sql)$"; then
    echo "⚠️  ATENÇÃO: escrevendo arquivo de migration: $FILE_PATH" >&2
    echo "   Verifique o conteúdo cuidadosamente antes de aplicar." >&2
    # exit 0 — deixa prosseguir, só avisa
fi

exit 0
