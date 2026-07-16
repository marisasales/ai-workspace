#!/usr/bin/env bash
# AI Workspace — Cross-platform installer
# Usage: cd ai-workspace && bash install.sh
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { printf "${CYAN}❯${NC} %s\n" "$*"; }
ok()    { printf "${GREEN}✓${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}⚠${NC} %s\n" "$*"; }
err()   { printf "${RED}✗${NC} %s\n" "$*"; }

# --- Detect OS & set target paths ---
case "$(uname -s)" in
  Linux)
    TARGET_AGENTS="$HOME/.agents"
    TARGET_OPENCODE="$HOME/.config/opencode"
    TARGET_VSCODE="$HOME/.config/Code/User"
    ;;
  Darwin)
    TARGET_AGENTS="$HOME/.agents"
    TARGET_OPENCODE="$HOME/.config/opencode"
    TARGET_VSCODE="$HOME/.config/Code/User"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    TARGET_AGENTS="$USERPROFILE/.agents"
    TARGET_OPENCODE="$USERPROFILE/.config/opencode"
    TARGET_VSCODE="$APPDATA/Code/User"
    ;;
  *)
    err "Sistema não suportado: $(uname -s)"
    exit 1
    ;;
esac

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

# --- helpers ---
copy_dir() {
  local src="$1" dst="$2" name="$3"
  if [ ! -d "$src" ]; then warn "$name — diretório não encontrado, pulando"; return; fi
  if [ -d "$dst" ]; then
    local bkp="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    warn "$name já existe em $dst → movendo para $bkp"
    mv "$dst" "$bkp"
  fi
  mkdir -p "$(dirname "$dst")"
  cp -r "$src" "$dst"
  ok "$name → $dst"
}

echo ""
info "=== AI Workspace — Install ==="
echo ""

# 1. .agents/
copy_dir "$REPO_ROOT/.agents" "$TARGET_AGENTS" ".agents/"

# 2. .config/opencode/
copy_dir "$REPO_ROOT/.config/opencode" "$TARGET_OPENCODE" ".config/opencode/"

# 3. VS Code MCP config
if [ -f "$REPO_ROOT/.config/Code/User/mcp.json" ]; then
  mkdir -p "$TARGET_VSCODE"
  cp "$REPO_ROOT/.config/Code/User/mcp.json" "$TARGET_VSCODE/mcp.json"
  ok "mcp.json → $TARGET_VSCODE/"
else
  warn "mcp.json não encontrado, pulando"
fi

# 4. VS Code prompts
if [ -d "$REPO_ROOT/.config/Code/User/prompts" ]; then
  mkdir -p "$TARGET_VSCODE/prompts"
  for f in "$REPO_ROOT"/.config/Code/User/prompts/*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$TARGET_VSCODE/prompts/"
    ok "prompt $(basename "$f") → $TARGET_VSCODE/prompts/"
  done
else
  warn ".config/Code/User/prompts/ não encontrado, pulando"
fi

# 4. Opencode dependencies (if package.json was copied)
if [ -f "$TARGET_OPENCODE/package.json" ]; then
  echo ""
  info "Instalando dependências do Opencode…"
  (cd "$TARGET_OPENCODE" && npm install --no-audit --no-fund) && ok "npm install concluído" || warn "npm install falhou"
fi

echo ""
info "Instalação concluída. Revise os warnings acima se houver."
