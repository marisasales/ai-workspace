#!/usr/bin/env bash
# AI Workspace — Cross-platform installer
# Usage: cd ai-workspace && bash install.sh [-f|--force]
set -euo pipefail

FORCE=false
for arg in "$@"; do
  [ "$arg" = "-f" ] || [ "$arg" = "--force" ] && FORCE=true
done

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { printf "${CYAN}❯${NC} %s\n" "$*"; }
ok()    { printf "${GREEN}✓${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}⚠${NC} %s\n" "$*"; }
err()   { printf "${RED}✗${NC} %s\n" "$*"; }

# --- prompt before overwrite ---
confirm() {
  local label="$1"
  if [ "$FORCE" = true ]; then return 0; fi
  printf "  Overwrite ${YELLOW}%s${NC}? [y/N] " "$label"
  read -r ans
  case "$ans" in [yY]|[yY][eE][sS]) return 0;; *) return 1;; esac
}

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
    err "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

# --- helpers ---
copy_dir() {
  local src="$1" dst="$2" name="$3"
  if [ ! -d "$src" ]; then warn "$name — directory not found, skipping"; return; fi
  if [ -d "$dst" ] && ! confirm "$name"; then info "Skipping $name"; return; fi
  if [ -d "$dst" ]; then
    local bkp="${dst}.bak"
    rm -rf "$bkp"
    warn "$name already exists at $dst → backing up to $bkp"
    mv "$dst" "$bkp"
  fi
  mkdir -p "$(dirname "$dst")"
  cp -r "$src" "$dst"
  ok "$name → $dst"
}

copy_file() {
  local src="$1" dst="$2" name="$3"
  if [ ! -f "$src" ]; then warn "$name not found, skipping"; return; fi
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && ! confirm "$name"; then info "Skipping $name"; return; fi
  if [ -f "$dst" ]; then
    local bkp="${dst}.bak"
    cp "$dst" "$bkp"
    warn "$name already exists → backed up to $(basename "$bkp")"
  fi
  cp "$src" "$dst"
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
copy_file "$REPO_ROOT/.config/Code/User/mcp.json" "$TARGET_VSCODE/mcp.json" "mcp.json"

# 3b. VS Code chat language models
copy_file "$REPO_ROOT/.config/Code/User/chatLanguageModels.json" "$TARGET_VSCODE/chatLanguageModels.json" "chatLanguageModels.json"

# 4. VS Code prompts
if [ -d "$REPO_ROOT/.config/Code/User/prompts" ]; then
  mkdir -p "$TARGET_VSCODE/prompts"
  for f in "$REPO_ROOT"/.config/Code/User/prompts/*.md; do
    [ -f "$f" ] || continue
    fname="prompts/$(basename "$f")"
    if [ ! -f "$TARGET_VSCODE/prompts/$(basename "$f")" ] || confirm "$fname"; then
      cp "$f" "$TARGET_VSCODE/prompts/"
      ok "$fname → $TARGET_VSCODE/prompts/"
    else
      info "Skipping $fname"
    fi
  done
else
  warn ".config/Code/User/prompts/ not found, skipping"
fi

# 4. Opencode dependencies (if package.json was copied)
if [ -f "$TARGET_OPENCODE/package.json" ]; then
  echo ""
  info "Installing Opencode dependencies…"
  (cd "$TARGET_OPENCODE" && npm install --no-audit --no-fund) && ok "npm install complete" || warn "npm install failed"
fi

echo ""
info "Install complete. Review any warnings above."
