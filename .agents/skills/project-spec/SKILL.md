---
name: project-spec
description: >-
  Generate a project specification (especificação do projeto) — a single pt-BR .md blueprint defining scope, requirements, and tech stack before coding starts.
---

## When to use this skill

**Trigger on ANY signal of project planning:**
"I'm going to create a project", "starting a system", "I need an app that", "I want to develop", "help me plan", "before coding", "requirements gathering", "specification", "project definition", "project spec", "I'm thinking about making a", "I need to organize my ideas", "I'm going to build a", "I want to make a system for", "project idea", "new project", "I need to define the scope", "blueprint", "pre-programming doc", "I'm going to start a project".

Also trigger when the user explains a project idea in detail — describing features, users, or stack — even without asking for a doc explicitly.

**Do NOT trigger for:** API reference docs, README, code comments, technical manuals, changelogs, contribution guides, code reviews, bug reports, or troubleshooting.

# Project Specification Skill

You help the user create a **Pre-Programming Document** — a single markdown file that acts as the blueprint for a project before implementation starts.

**Golden rule: ALWAYS produce the complete document immediately.** Never stop mid-task to ask questions. If the user didn't provide some information, infer reasonable defaults, flag them clearly in the document, and move on. The user will correct what matters.

The document must balance two audiences:

- **Humans** scan it for decisions and scope.
- **AI coding agents** parse it to understand the full context before writing code.

This means requirements must be concrete and unambiguous. "Fast" is meaningless — "page load under 2s for 90% of requests" is a requirement.

## Workflow

### 1. Extract what's available

From the user's message, extract everything you can. Map it to the structure below. Most users provide more than they realize — objective, features, users, and preferences are often all in the first message.

### 2. Infer with flags, never block

For any essential field the user didn't provide:

- **Make a reasonable inference** based on the project context.
- **Mark it clearly** in the document with a `> [!NOTE]` or `> [!INFO]` block explaining what was assumed.

Only skip a field if you genuinely cannot infer it from context. Example: if a name isn't given, derive one from the project description ("Sistema de Gerenciamento de Tarefas", "Encurtador de URLs", etc.).

### 3. Research when needed

For tech stack decisions the user is uncertain about, research using web search or documentation tools before recommending. Present:

- The recommended choice with **why** it fits this specific project.
- Trade-offs in 1-2 sentences.
- No recommendations without rationale.

### 4. Generate the document — exactly ONE file

Write **exactly one** markdown file named `<project-name>-blueprint.md`. Never split into multiple files.

Use this flexible template, reordering sections as makes sense for the project:

```markdown
# [Project Name] — Project Blueprint

> [!NOTE] Assumptions made during creation
> - [List any inferred/assumed fields]
> - [These should be reviewed and confirmed]

## 1. Descrição do Projeto
<!-- Objective + Problem Statement + Context. 2-3 paragraphs max. Keep tight. -->

## 2. Público-Alvo
<!-- Who uses this and in what context. Be specific. -->

## 3. Requisitos Funcionais
<!-- What the system MUST do. Use RF-XX identifiers. Group by module if >5. -->
- RF-01: [description]
- RF-02: [description]

## 4. Requisitos Não Funcionais
<!-- Performance, security, scalability, etc. Use RNF-XX identifiers. -->
- RNF-01: [description]

## 5. Stack Tecnológica
<!-- Table with justification column. Every choice needs a "why". -->
| Categoria | Tecnologia | Justificativa |
|-----------|-----------|---------------|

## 6. Estrutura de Diretórios (opcional)
<!-- Include only when the tech stack is clearly defined. Shows the project file layout. -->

Use the directory structure conventions from `project-architect` skill. Pick the blueprint that matches the stack:

| Stack | Blueprint |
|-------|-----------|
| Python (FastAPI, Flask, Django) | `src/` layout: `src/app/`, `src/api/`, `src/models/`, `src/services/`, `tests/` |
| Node.js / Express / Fastify | `src/` layout: `src/routes/`, `src/controllers/`, `src/services/`, `src/middleware/`, `tests/` |
| Next.js / React / Vue (framework) | Feature-driven: `src/app/`, `src/components/`, `src/features/`, `src/lib/` |
| Java Spring Boot (small) | Layered: `controller/`, `service/`, `model/`, `repository/`, `dto/` |

Include the tree as an ASCII snippet:

```text
meu-projeto/
├── src/
│   ├── api/          # Rotas / endpoints
│   ├── models/       # Definições de dados
│   ├── services/     # Lógica de negócio
│   └── main.py       # Ponto de entrada
├── tests/
└── README.md
```

Keep it compact — 10-15 lines max. Omit this section if the stack is too uncertain to map to a standard layout.

## 7. Entregas / Marcos

<!-- Optional. MVP scope, implementation phases. Include only if useful. -->

```
**Critical rules:**

| Rule | Why |
|------|-----|
| **ONE file only** | AI agents need a single entry point. Multiple files cause missed context. |
| **Assume a project name** | Derive from the user's description. Never stop to ask "what's the name?" |
| **RF-XX / RNF-XX identifiers** | These become reference anchors in code and tickets. |
| **Stack table MUST have justification** | Prevents second-guessing later. Shows why SQLite over Postgres, etc. |
| **Proportional depth** | A 5-person task board doesn't need C4 diagrams. A URL shortener study doesn't need deployment topology. Match depth to complexity. |
| **No code** | This is a spec document. No implementation code, no schemas, no API endpoints. |
| **Directory structure when useful** | Include an ASCII tree only when the stack maps clearly to a standard layout (Python src-layout, Node.js, Next.js). Omit otherwise. |
| **pt-BR** | All content in Brazilian Portuguese. |
| **No fluff** | If a sentence doesn't inform a developer or AI, delete it. |

### 5. Flag assumptions with callout blocks

Use markdown callouts for assumptions and open questions:

```markdown
> [!NOTE]
> Nome do projeto inferido a partir da descrição. O nome real pode ser diferente.

> [!INFO]
> Considere usar SQLite (via Turso) em vez de PostgreSQL — para 50-100 tarefas/mês,
> um banco serverless é gratuito e não adiciona complexidade operacional.
```

### 6. Save and confirm

Save the file in the current working directory. Inform the user that the blueprint was created, highlight any assumptions made, and offer to adjust.

## What NOT to do

- **Do NOT stop to ask questions** — always produce the full document with assumptions flagged.
- **Do NOT create multiple files** — one single `.md` file.
- **Do NOT write implementation code** — no schemas, no API endpoints, no scripts.
- **Do NOT over-engineer** — a simple CRUD app doesn't need C4 diagrams, microservices, or CI/CD pipeline specs.
- **Do NOT use English** — the document must be in pt-BR unless the user explicitly asks otherwise.
