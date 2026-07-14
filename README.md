# AI Workspace Configuration

> Centralized configuration for AI coding assistants — Opencode, VS Code, GitHub Copilot, Cursor, Aider, Gemini CLI, and more.

This repository contains a portable, cross-platform configuration structure shared across multiple AI coding tools. It uses a single `.agents/` directory for skills and agent definitions, and tool-specific configs under `.config/`.

---

<details>
<summary><strong>Project Structure</strong></summary>

```
.
├── .agents/                          # Shared AI agent configuration
│   ├── .skill-lock.json              # Skill installation manifest
│   └── skills/                       # Installed skills
│       ├── api-design/              #   REST API design patterns
│       ├── backend-patterns/        #   Backend architecture patterns
│       ├── coding-standards/        #   Cross-project coding conventions
│       ├── context7-mcp/            #   Context7 documentation MCP skill
│       ├── conventional-branch/     #   Conventional Branch naming
│       ├── create-readme/           #   README generation
│       ├── docker-patterns/         #   Docker & Compose patterns
│       ├── drawio-skill/            #   Diagram generation (draw.io)
│       ├── error-handling/          #   Error handling patterns
│       ├── find-skills/             #   Skill discovery
│       ├── frontend-design/         #   UI component design
│       ├── frontend-patterns/       #   Frontend development patterns
│       ├── gitmoji-commit/          #   Gitmoji + Conventional Commits
│       ├── java-springboot/         #   Spring Boot best practices
│       ├── jpa-patterns/            #   JPA/Hibernate patterns
│       ├── mcp-builder/             #   MCP server creation guide
│       ├── postgres-patterns/       #   PostgreSQL patterns
│       ├── project-architect/       #   Project scaffolding
│       ├── project-spec/            #   Project specification (pt-BR)
│       ├── python-patterns/         #   Python best practices
│       ├── react-native-patterns/   #   React Native / Expo patterns
│       ├── react-patterns/          #   React 18/19 patterns
│       ├── security-review/         #   Security review checklist
│       ├── skill-creator/           #   Skill authoring toolkit
│       ├── springboot-patterns/     #   Spring Boot architecture
│       ├── springboot-security/     #   Spring Security best practices
│       ├── springboot-tdd/          #   Spring Boot TDD patterns
│       ├── versioning-guide/        #   Semantic versioning decisions
│       └── vite-patterns/           #   Vite build tool patterns
│
├── .config/
│   ├── Code/User/prompts/            # VS Code custom agent prompts
│   │   ├── global.instructions.md    #   Global system prompt
│   │   ├── review.agent.md           #   Code review agent
│   │   ├── ship.agent.md             #   Ship agent
│   │   └── test.agent.md             #   Test agent
│   │
│   └── opencode/                     # Opencode configuration
│       ├── opencode.jsonc            #   Main config (MCPs, plugins)
│       ├── AGENTS.md                 #   Agent behavior rules
│       ├── dcp.jsonc                 #   Dynamic Context Pruning config
│       ├── tui.json                  #   TUI plugin config
│       ├── package.json              #   Node dependencies
│       ├── requirements.txt          #   Runtime requirements reference
│       ├── .gitignore                #   Git ignore for this folder
│       ├── agents/                   #   Opencode agent definitions
│       │   ├── ask.md
│       │   ├── review.md
│       │   ├── ship.md
│       │   └── test.md
│       └── commands/                 #   Opencode command definitions
│           ├── build.md              #   Build command
│           ├── commit.md             #   Git commit command (gitmoji)
│           ├── refactor-clean.md     #   Dead code removal & consolidation
│           ├── scan-security.md      #   OWASP security review
│           └── update-docs.md        #   Documentation sync
│
├── Ignores/                          # Ignore files per AI tool
│   ├── .gitignore                    #   Git
│   ├── .agentignore                  #   Generic AI agent
│   ├── .aiderignore                  #   Aider
│   ├── .copilotignore               #   GitHub Copilot
│   ├── .cursorignore                #   Cursor IDE
│   └── .geminiignore                #   Gemini CLI
│
└── README.md                         # This file
```

</details>

---

## Quick Start

### 1. Choose the right ignore file

Each AI tool reads a specific ignore file. Pick the one you need and copy it to your project root:

| Tool              | Ignore File         |
|-------------------|---------------------|
| Git               | `.gitignore`        |
| Cursor            | `.cursorignore`     |
| GitHub Copilot    | `.copilotignore`    |
| Gemini CLI        | `.geminiignore`     |
| Aider             | `.aiderignore`      |
| Generic AI agent  | `.agentignore`      |

> **Linux/macOS:** These files start with a dot — they are hidden. Use `ls -a` in the terminal or enable **Show Hidden Files** in your file manager to see them. On Windows they are visible by default in most editors.

### 2. Install Opencode dependencies

```bash
cd .config/opencode
npm install
```

Requires **Node.js >= 18**.

---

## Platform Paths

| Item                | Linux                                        | Windows                                                |
|---------------------|----------------------------------------------|--------------------------------------------------------|
| `.agents/`          | `~/.agents/`                                 | `%USERPROFILE%\.agents\`                               |
| `.config/opencode/` | `~/.config/opencode/`                        | `%USERPROFILE%\.config\opencode\`                      |
| VS Code prompts     | `~/.config/Code/User/prompts/`               | `%APPDATA%\Code\User\prompts\`                         |

> **Note on `~/.config/opencode`:** The `node_modules/`, `package.json`, and `package-lock.json` files inside `.config/opencode/` are **local dependencies** and should **not** be committed to version control (already listed in `.config/opencode/.gitignore`). Only the configuration files (`opencode.jsonc`, `AGENTS.md`, `dcp.jsonc`, `tui.json`, `agents/`) are meant to be tracked.

---

## MCP Servers

Configured in `.config/opencode/opencode.jsonc`. Below are the defined MCP servers, their purpose, installation links, and API key setup.

### Context7 (Remote, Enabled)

Documentation retrieval for 9,000+ libraries — provides up-to-date, version-specific API docs and code examples.

- **Configuration:** Remote server at `https://mcp.context7.com/mcp`
- **Auth:** `CONTEXT7_API_KEY` header with `Bearer {env:CONTEXT7_PERSONAL_ACCESS_TOKEN}`
- **Type:** Remote

#### API Key Setup

1. Go to [context7.com/dashboard](https://context7.com/dashboard) and sign up / log in
2. Generate a personal access token from the dashboard
3. Set the environment variable:

   **Linux/macOS (add to `~/.bashrc`, `~/.zshrc`, or `~/.profile`):**
   ```bash
   export CONTEXT7_PERSONAL_ACCESS_TOKEN="ctx7_xxx..."
   ```

   **Windows PowerShell (add to `$PROFILE`):**
   ```powershell
   $env:CONTEXT7_PERSONAL_ACCESS_TOKEN = "ctx7_xxx..."
   ```

   **Windows Cmd:**
   ```cmd
   setx CONTEXT7_PERSONAL_ACCESS_TOKEN "ctx7_xxx..."
   ```

#### Installation

- GitHub: [github.com/upstash/context7](https://github.com/upstash/context7)
- Docs: [context7.com/docs](https://context7.com/docs/resources/developer)
- No local installation needed (remote server). The SDK/npx package is only needed for local/stdio usage.

---

### shadcn (Local, Enabled)

Browse, search, and install shadcn/ui components and blocks from registries using natural language.

- **Configuration:** Local via `npx shadcn@latest mcp`
- **Auth:** None
- **Type:** Local

#### Installation

- Docs: [ui.shadcn.com/docs/mcp](https://ui.shadcn.com/docs/mcp)
- No additional setup required — runs on-demand via `npx`.

---

### Playwright (Local, Disabled)

Browser automation via accessibility snapshots — navigate, click, fill forms, take screenshots.

- **Configuration:** Local via `npx @playwright/mcp@latest`
- **Auth:** None
- **Type:** Local
- **Status:** Disabled by default (set `"enabled": true` to activate)

#### Installation

- Docs: [playwright.dev/docs/getting-started-mcp](https://playwright.dev/docs/getting-started-mcp)
- GitHub: [github.com/microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp)
- Requires Playwright browsers: `npx playwright install`

---

### GitHub (Remote, Disabled)

GitHub API integration — list repos, create issues, manage PRs, search code, and more.

- **Configuration:** Remote at `https://api.githubcopilot.com/mcp/`
- **Auth:** `Authorization: Bearer {env:GITHUB_PERSONAL_ACCESS_TOKEN}`
- **Type:** Remote
- **Status:** Disabled by default (set `"enabled": true` to activate)

#### API Key Setup

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens)
2. Click **Generate new token (classic)** or **Fine-grained token**
3. Select scopes (minimum: `repo`, `read:org`, `read:user`)
4. Copy the generated token
5. Set the environment variable:

   **Linux/macOS:**
   ```bash
   export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_xxx..."
   ```

   **Windows PowerShell:**
   ```powershell
   $env:GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_xxx..."
   ```

   **Windows Cmd:**
   ```cmd
   setx GITHUB_PERSONAL_ACCESS_TOKEN "ghp_xxx..."
   ```

#### Installation

- GitHub: [github.com/github/github-mcp-server](https://github.com/github/github-mcp-server)
- Docs: [docs.github.com/en/copilot](https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp-in-your-ide/set-up-the-github-mcp-server)
- PAT setup guide: [mcpservers.com/blog/find-your-github-personal-access-token](https://mcpservers.com/blog/find-your-github-personal-access-token)

---

## Plugins

Configured in `.config/opencode/opencode.jsonc` under the `plugin` array.

### @tarquinen/opencode-dcp (Dynamic Context Pruning)

Automatically compresses conversation context to manage token usage and maintain performance during long sessions.

- **Package:** `@tarquinen/opencode-dcp@latest`
- **Config:** `.config/opencode/dcp.jsonc`

### opencode-vibeguard

Project-specific plugin for additional safeguards.

- **Package:** `opencode-vibeguard`

---

## Important Directories

| Path                        | Description                              |
|-----------------------------|------------------------------------------|
| `.agents/skills/`           | All installed AI agent skills            |
| `.config/opencode/agents/`  | Opencode agent definitions               |
| `.config/opencode/commands/`| Opencode command definitions             |
| `.config/Code/User/prompts/`| VS Code custom agent prompts             |
| `Ignores/`                  | Tool-specific ignore files               |

---

## Overview

```
.agents/       → Shared across opencode, VS Code, Cursor, Gemini CLI, Aider, etc.
.config/       → Tool-specific configurations (opencode, VS Code)
Ignores/       → Pre-made ignore files for git and AI tools
```

The `.agents/` folder is placed at the project root or user home and is consumed by multiple tools simultaneously — making skills and agent instructions reusable across your entire AI toolchain.
