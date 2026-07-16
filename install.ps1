# AI Workspace — Windows Installer (PowerShell)
# Usage: cd ai-workspace; powershell -ExecutionPolicy Bypass -File install.ps1

$ErrorActionPreference = "Stop"

$REPO_ROOT = $PSScriptRoot
$USERPROFILE = [Environment]::GetFolderPath("UserProfile")
$APPDATA = [Environment]::GetFolderPath("ApplicationData")

# --- helpers ---
function Copy-Dir($src, $dst, $name) {
    if (-not (Test-Path $src)) { Write-Warning "$name — diretório não encontrado, pulando"; return }
    if (Test-Path $dst) {
        $bkp = "$dst.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Write-Warning "$name já existe em $dst → movendo para $bkp"
        Move-Item -Path $dst -Destination $bkp -Force
    }
    New-Item -ItemType Directory -Path (Split-Path $dst -Parent) -Force | Out-Null
    Copy-Item -Path $src -Destination $dst -Recurse -Force
    Write-Host "✓ $name → $dst" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== AI Workspace — Install ===" -ForegroundColor Cyan
Write-Host ""

# 1. .agents/
Copy-Dir -src "$REPO_ROOT\.agents" -dst "$USERPROFILE\.agents" -name ".agents/"

# 2. .config/opencode/
Copy-Dir -src "$REPO_ROOT\.config\opencode" -dst "$USERPROFILE\.config\opencode" -name ".config/opencode/"

# 3. VS Code MCP config
$vscodeMcp = "$REPO_ROOT\.config\Code\User\mcp.json"
$targetVSCode = "$APPDATA\Code\User"
if (Test-Path $vscodeMcp) {
    New-Item -ItemType Directory -Path $targetVSCode -Force | Out-Null
    Copy-Item -Path $vscodeMcp -Destination "$targetVSCode\mcp.json" -Force
    Write-Host "✓ mcp.json → $targetVSCode\" -ForegroundColor Green
} else {
    Write-Warning "mcp.json não encontrado, pulando"
}

# 4. VS Code prompts
$vscodePrompts = "$REPO_ROOT\.config\Code\User\prompts"
$targetPrompts = "$APPDATA\Code\User\prompts"
if (Test-Path $vscodePrompts) {
    New-Item -ItemType Directory -Path $targetPrompts -Force | Out-Null
    Get-ChildItem "$vscodePrompts\*.md" | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination "$targetPrompts\" -Force
        Write-Host "✓ prompt $($_.Name) → $targetPrompts\" -ForegroundColor Green
    }
} else {
    Write-Warning ".config/Code/User/prompts/ não encontrado, pulando"
}

# 4. Opencode dependencies
$opencodePkg = "$USERPROFILE\.config\opencode\package.json"
if (Test-Path $opencodePkg) {
    Write-Host ""
    Write-Host "❯ Instalando dependências do Opencode…" -ForegroundColor Cyan
    Push-Location "$USERPROFILE\.config\opencode"
    try {
        npm install --no-audit --no-fund
        Write-Host "✓ npm install concluído" -ForegroundColor Green
    } catch {
        Write-Warning "npm install falhou: $_"
    } finally { Pop-Location }
}

Write-Host ""
Write-Host "Instalação concluída." -ForegroundColor Cyan
