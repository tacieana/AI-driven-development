#!/bin/bash
# Hook de exemplo: lint automático após escrita de arquivo
#
# Configure em .claude/settings.json:
# {
#   "hooks": {
#     "PostToolUse": [{
#       "matcher": "Write",
#       "hooks": [{"type": "command", "command": "bash .claude/hooks/post-write-lint.sh"}]
#     }]
#   }
# }

set -e

FILE_PATH="${CLAUDE_TOOL_INPUT_PATH:-}"

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

# ============================================================
# Python: ruff check + fix
# ============================================================
if echo "$FILE_PATH" | grep -q "\.py$"; then
    if command -v ruff &>/dev/null; then
        echo "🔍 Rodando ruff em $FILE_PATH..."
        ruff check --fix "$FILE_PATH" 2>&1 || true
        ruff format "$FILE_PATH" 2>&1 || true
        echo "✅ ruff concluído"
    fi
    exit 0
fi

# ============================================================
# TypeScript/JavaScript: eslint + prettier
# ============================================================
if echo "$FILE_PATH" | grep -qE "\.(ts|tsx|js|jsx)$"; then
    if command -v eslint &>/dev/null; then
        echo "🔍 Rodando eslint em $FILE_PATH..."
        eslint --fix "$FILE_PATH" 2>&1 || true
        echo "✅ eslint concluído"
    fi

    if command -v prettier &>/dev/null; then
        prettier --write "$FILE_PATH" 2>&1 || true
    fi
    exit 0
fi

# ============================================================
# Go: gofmt + goimports
# ============================================================
if echo "$FILE_PATH" | grep -q "\.go$"; then
    if command -v gofmt &>/dev/null; then
        gofmt -w "$FILE_PATH" 2>&1 || true
    fi
    if command -v goimports &>/dev/null; then
        goimports -w "$FILE_PATH" 2>&1 || true
    fi
    exit 0
fi

exit 0
