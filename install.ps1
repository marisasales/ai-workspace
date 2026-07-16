# AI Workspace -- Windows Installer (PowerShell)
# Usage: cd ai-workspace; powershell -ExecutionPolicy Bypass -File install.ps1 [-Force]
param([switch]$Force)

$ErrorActionPreference = "Stop"

$REPO_ROOT = $PSScriptRoot
$USERPROFILE = [Environment]::GetFolderPath("UserProfile")
$APPDATA = [Environment]::GetFolderPath("ApplicationData")

# --- helpers ---
function Confirm-Overwrite($label) {
    if ($Force) { return $true }
    $ans = Read-Host "  Overwrite $label? [y/N]"
    return $ans -match '^(y|yes)$'
}

function Copy-Dir($src, $dst, $name) {
    if (-not (Test-Path $src)) { Write-Warning "$name -- directory not found, skipping"; return }
    if (Test-Path $dst) {
        if (-not (Confirm-Overwrite $name)) { Write-Host "  Skipping $name" -ForegroundColor Cyan; return }
        $bkp = "$dst.bak"
        if (Test-Path $bkp) { Remove-Item -Path $bkp -Recurse -Force }
        Write-Warning "$name already exists at $dst -> backing up to $bkp"
        Move-Item -Path $dst -Destination $bkp -Force
    }
    New-Item -ItemType Directory -Path (Split-Path $dst -Parent) -Force | Out-Null
    Copy-Item -Path $src -Destination $dst -Recurse -Force
    Write-Host "[OK] $name -> $dst" -ForegroundColor Green
}

function Copy-File($src, $dst, $name) {
    if (-not (Test-Path $src)) { Write-Warning "$name not found, skipping"; return }
    New-Item -ItemType Directory -Path (Split-Path $dst -Parent) -Force | Out-Null
    if (Test-Path $dst) {
        if (-not (Confirm-Overwrite $name)) { Write-Host "  Skipping $name" -ForegroundColor Cyan; return }
        $bkp = "$dst.bak"
        Copy-Item -Path $dst -Destination $bkp -Force
        Write-Warning "$name already exists -> backed up to $(Split-Path $bkp -Leaf)"
    }
    Copy-Item -Path $src -Destination $dst -Force
    Write-Host "[OK] $name -> $dst" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== AI Workspace -- Install ===" -ForegroundColor Cyan
Write-Host ""

# 1. .agents/
Copy-Dir -src "$REPO_ROOT\.agents" -dst "$USERPROFILE\.agents" -name ".agents/"

# 2. .config/opencode/
Copy-Dir -src "$REPO_ROOT\.config\opencode" -dst "$USERPROFILE\.config\opencode" -name ".config/opencode/"

# 3. VS Code MCP config
Copy-File -src "$REPO_ROOT\.config\Code\User\mcp.json" -dst "$APPDATA\Code\User\mcp.json" -name "mcp.json"

# 3b. VS Code chat language models
Copy-File -src "$REPO_ROOT\.config\Code\User\chatLanguageModels.json" -dst "$APPDATA\Code\User\chatLanguageModels.json" -name "chatLanguageModels.json"

# 4. VS Code prompts
$vscodePrompts = "$REPO_ROOT\.config\Code\User\prompts"
$targetPrompts = "$APPDATA\Code\User\prompts"
if (Test-Path $vscodePrompts) {
    New-Item -ItemType Directory -Path $targetPrompts -Force | Out-Null
    Get-ChildItem "$vscodePrompts\*.md" | ForEach-Object {
        $fname = "prompts/$($_.Name)"
        $destPath = "$targetPrompts\$($_.Name)"
        if (-not (Test-Path $destPath) -or (Confirm-Overwrite $fname)) {
            Copy-Item -Path $_.FullName -Destination $destPath -Force
            Write-Host "[OK] $fname -> $targetPrompts" -ForegroundColor Green
        } else {
            Write-Host "  Skipping $fname" -ForegroundColor Cyan
        }
    }
} else {
    Write-Warning ".config/Code/User/prompts/ not found, skipping"
}

# 5. Opencode dependencies
$opencodePkg = "$USERPROFILE\.config\opencode\package.json"
if (Test-Path $opencodePkg) {
    Write-Host ""
    Write-Host "> Installing Opencode dependencies..." -ForegroundColor Cyan
    Push-Location "$USERPROFILE\.config\opencode"
    try {
        npm install --no-audit --no-fund
        Write-Host "[OK] npm install complete" -ForegroundColor Green
    } catch {
        Write-Warning "npm install failed: $_"
    } finally { Pop-Location }
}

Write-Host ""
Write-Host "Install complete." -ForegroundColor Cyan

