---
name: gitmoji-commit
description: >-
  Generate semantic git commits with Conventional Commits format and Gitmoji
  emojis. ACTIVATE this skill whenever the user asks to commit, "git commit",
  create a commit message, suggest a commit message, review staged changes,
  organize commits, or mentions conventional commits, commitlint, gitmoji,
  commit standardization, or semantic versioning. This skill ANALYZES the
  diff and PRODUCES the complete commit message — it does not just suggest
  formats. Use it for any git commit workflow, whether the user needs a
  message written, staged files reviewed, or help splitting changes into
  atomic commits.
license: MIT
---

# Gitmoji Commit Protocol

Generate semantic [Conventional Commits](https://www.conventionalcommits.org/) with Unicode emojis.

---

## Format

```
<emoji> <type>[optional scope]: <description>

[optional body — wrap at 72 chars]

[optional footer(s)]
```

**Rules:**
- **Description:** imperative mood, present tense, <72 chars, no period
- **Body:** wrap at 72 chars, explain the "why" and "how"
- **Footers:** `BREAKING CHANGE:`, `Closes #issue`, `Co-authored-by:`, `Reviewed-by:`

---

## Mapping — Type → Emoji → Intent

### Features
| Type | Emoji | When to use |
|------|-------|-------------|
| `feat` | ✨ | New feature |
| `feat!` | 💥 | Breaking change (requires `!` + `BREAKING CHANGE` footer) |
| `fix` | 🐛 | Bug fix |
| `fix`(hotfix) | 🚑️ | Critical production hotfix |
| `fix`(security) | 🔒️ | Security patch |

### Docs & Style
| Type | Emoji | When to use |
|------|-------|-------------|
| `docs` | 📝 | Documentation (code or user-facing) |
| `docs`(comments) | 💡 | Code comments only |
| `style` | 💄 | UI/CSS changes |
| `style`(lint) | 🎨 | Linting, formatting — no logic change |

### Refactoring & Performance
| Type | Emoji | When to use |
|------|-------|-------------|
| `refactor` | ♻️ | Code restructuring, no behavior change |
| `refactor`(arch) | 🏗️ | Significant architectural changes |
| `perf` | ⚡️ | Performance optimization |

### Tests
| Type | Emoji | When to use |
|------|-------|-------------|
| `test` | ✅ | Adding or updating tests |
| `test`(failing) | 🧪 | Adding failing tests (TDD) |

### Build & CI
| Type | Emoji | When to use |
|------|-------|-------------|
| `build` | 📦️ | Bundles, releases, version bumps |
| `build`(deps-up) | ⬆️ | Dependency upgrades |
| `build`(deps-down) | ⬇️ | Dependency downgrades |
| `ci` | 👷 | CI pipeline config (GitHub Actions, etc.) |
| `ci`(fix) | 💚 | Fixing a CI build |

### Maintenance
| Type | Emoji | When to use |
|------|-------|-------------|
| `chore` | 🔧 | Config files, tooling |
| `chore`(move) | 🚚 | Moving or renaming files |
| `chore`(add-dep) | ➕ | Adding a dependency |
| `chore`(rm-dep) | ➖ | Removing a dependency |
| `chore`(init) | 🎉 | Initial project commit |
| `chore`(revert) | ⏪️ | Reverting a previous commit |
| `chore`(wip) | 🚧 | Work in progress (avoid in final commits) |
| `chore`(release) | 🔖 | Tagging a release |

---

## When to use this skill

Trigger this skill **whenever** the user:
1. **Asks to commit:** "commit this", "make a commit", "git commit ..."
2. **Asks for a message:** "suggest a commit message", "what should I write?"
3. **Reviews staged changes:** "check what I'm committing", "review the staged diff"
4. **Mentions conventional commits or gitmoji:** "follow conventional commits", "add gitmoji"
5. **Wants standardization:** "standardize our commits", "fix the commit style"
6. **Asks about commit history:** "what did I change?", "summarize recent commits"

---

## Workflow

### 1. Analyze the Diff

Extract the changes:

```bash
git diff --staged 2>/dev/null || git diff
git status --porcelain
git log --oneline -3
```

Scan the diff to decide:
- **File types changed:** what kind of work dominates? (feature, fix, docs, chore?)
- **Existing style:** `git log -3` shows the repo's convention — match it.
- **Breaking changes:** any API or interface signature changed? → `feat!` + 💥
- **Mixed types:** if the diff blends `feat` + `fix` + `chore`, pick the most significant type (`feat` > `fix` > `refactor` > `chore`). Consider suggesting the user split into multiple commits.

### 2. Staging & Guardrails

- **Never** stage secrets (`.env`, `*.key`, `credentials.*`). If compromised, use 🔐.
- If nothing is staged, use `git add -p` for interactive staging or `git add <path>` for logical blocks.
- Commits should be **atomic** — one concept per commit. If the diff mixes purposes, guide the user to split.
- Respect `.gitignore` — do not stage ignored files.

### 3. Generate the Message

Based on your diff analysis:

1. Choose the **type** and **emoji** from the mapping table
2. Add an optional **scope** in parentheses, e.g., `(auth)`, `(api)`, `(ui)`
3. Write the **description** in imperative mood, present tense, <72 chars, no period
4. Add a **body** if the commit needs explanation (wrap at 72 chars)
5. Add **footers** as needed (`BREAKING CHANGE:`, `Closes #`, `Co-authored-by:`, etc.)

The description should answer: *"If applied, this commit will..."*

### 4. Execute

For single-line messages:

```bash
git commit -m "<emoji> <type>[scope]: <description>"
```

For multi-line messages (body + footers), prefer opening the editor:

```bash
git commit
```

Then write the message directly in the editor.

---

## Examples

**Example 1 — Simple feature:**
```
✨ feat(auth): add JWT token refresh endpoint
```

**Example 2 — Bug fix with body:**
```
🐛 fix(api): handle null pointer on empty user list

The /users endpoint crashes when the database returns an empty
result set because List.get(0) is called without .isEmpty()
check.
```

**Example 3 — Breaking change:**
```
💥 feat!(db): migrate from SQLite to PostgreSQL

BREAKING CHANGE: The database driver has changed. All existing
SQLite databases must be migrated using tools/migrate.py.
```

**Example 4 — Multiple footers:**
```
📝 docs(readme): update installation instructions

Closes #42
Co-authored-by: Maria <maria@example.com>
```

**Example 5 — Chore / deps:**
```
🔧 chore(deps): add prettier as dev dependency
```

---

## Constraints

- **Banned:** Modifying global git config (`git config --global`)
- **Banned:** Automated destructive commands (`--force`, `hard reset`, `push --force`)
- **Banned:** Force-pushing to protected branches (`main`, `master`, `production`)
- **Hook failures:** If a hook (pre-commit, lint-staged) fails, fix the code and make a fresh commit. **Never** use `--no-verify`.
- **Empty commits:** Do not create commits if there are no staged changes.
- **Generic messages:** Never use "fix stuff", "update", "changes" — descriptions must be informative.
- **Scope consistency:** If the repo already uses scopes, follow the same pattern. If not, omit scopes unless the change is large enough to warrant one.
- **Language:** Keep the commit language consistent with the existing repo history.

---

## Script: Validate Commit Message

The `scripts/validate-commit-msg` script validates commit messages against this standard. Install it as a `commit-msg` git hook:

```bash
cp scripts/validate-commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```

The script checks:
- Format matches `<emoji> <type>[scope]: <description>`
- Type is one of the valid types
- Description is <72 chars and not generic
- Breaking changes include the `BREAKING CHANGE` footer
