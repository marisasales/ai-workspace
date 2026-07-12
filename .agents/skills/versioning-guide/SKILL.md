---
name: versioning-guide
description: Guides users through MAJOR.MINOR.PATCH semantic versioning decisions for their projects. Use this skill whenever anyone asks about version numbers, version bumps, release versioning, what version to use next, how to version an update, or any question involving choosing or changing a project version — even if they just mention "bump the version" or "what should the next version be?" without specifying a scheme. This skill covers the meaning of each segment (MAJOR for breaking changes, MINOR for new features, PATCH for fixes) and how to decide which to increment.
---

# Semantic Versioning Guide

This skill helps users determine the correct version number for their project updates following the MAJOR.MINOR.PATCH scheme (e.g., `2.5.0`).

## The Three Segments

### MAJOR (e.g., the `2` in `2.5.0`)
Increment this when the update introduces **breaking changes** — changes that are not backward compatible. Examples:
- Redesigned UI or layout overhaul
- File format changes that break compatibility with older versions
- Removed APIs, endpoints, or features
- Database schema migrations that require data conversion
- Changes in behavior that existing users rely on

Starting a project at `1.0.0` is the convention for the first stable release. Versions `0.x.x` indicate initial development where anything may change.

### MINOR (e.g., the `5` in `2.5.0`)
Increment this when you **add new functionality** that remains backward compatible. Examples:
- New screens, pages, or modules
- New API endpoints that don't break existing ones
- New configuration options
- New export formats or integrations
- Feature enhancements that don't change existing behavior

### PATCH (e.g., the `0` in `2.5.0`)
Increment this for **backward-compatible bug fixes** and small improvements. Examples:
- Crash fixes and error resolution
- Security vulnerability patches
- Performance optimizations with no behavior change
- Typo fixes in UI text
- Documentation corrections

## How to decide

For each update, determine what category the changes fall into, then:

1. **Any breaking change?** → Increment MAJOR, reset MINOR and PATCH to 0.
2. **No breaking changes, but new features?** → Increment MINOR, reset PATCH to 0.
3. **Only fixes and small tweaks?** → Increment PATCH.

A single release can contain multiple types of changes — always use the **highest** category present. If you have both a bug fix and a new feature, it's a MINOR bump. If you also have a breaking change, it's a MAJOR bump.

## Examples

| Current version | Changes | Next version |
|---|---|---|
| `1.3.2` | Fixed a crash on the login screen | `1.3.3` |
| `1.3.2` | Added dark mode support | `1.4.0` |
| `1.3.2` | Redesigned the entire navigation system, old saved layouts won't work | `2.0.0` |
| `0.9.5` | Added a new settings panel (pre-1.0, breaking changes allowed) | `0.10.0` |
| `2.5.0` | Security patch + new export feature + deprecated old API format | `3.0.0` |

## What to provide

When the user asks about versioning:
1. **Identify** what type of changes they're making (ask clarifying questions if needed)
2. **Explain** which segment should change and why, referencing the rules above
3. **Suggest** the exact next version number
4. **Optionally** call out edge cases (pre-release versions, `0.x.x` conventions)
