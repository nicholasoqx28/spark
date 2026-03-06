# CLAUDE.md — Spark Project Guide

This file provides context and conventions for AI assistants (Claude Code and others) working on the **Spark** repository.

---

## Project Overview

**Spark** is a sports application designed to streamline activities and boost engagement. Core feature areas:

- **Tournaments** — Browse, join, and manage sports tournaments
- **E-commerce** — Shop for sports gear and equipment
- **Academy** — Training tools and educational resources for athletes
- **Activity Management** — Organize and participate in sports activities

### User Roles

| Role | Description |
|---|---|
| Enthusiast | Casual users browsing events and shopping |
| Athlete | Active participants joining tournaments and tracking training |
| Admin | Manages tournaments, products, users, and academy content |

---

## Repository State

> **Status: Early-stage / Pre-implementation**
>
> As of March 2026, the repository contains only a README. The technology stack, architecture, and source code have not yet been established. When implementing, choose technologies appropriate to the goals described above and document decisions here.

---

## Development Setup

_Update this section once a stack is chosen. Placeholder instructions:_

```bash
# Clone the repository
git clone <repo-url>
cd spark

# Install dependencies (update command for your package manager)
# e.g., npm install / yarn / pnpm install / pip install -r requirements.txt

# Run development server
# e.g., npm run dev

# Run tests
# e.g., npm test
```

---

## Architecture Decisions

_Document significant architecture and technology choices here as they are made._

| Decision | Choice | Rationale |
|---|---|---|
| Stack | TBD | — |
| Database | TBD | — |
| Auth | TBD | — |
| Deployment | TBD | — |

---

## Directory Structure

_Update this section as the codebase grows. Expected structure once implementation begins:_

```
spark/
├── CLAUDE.md          # This file — AI assistant guide
├── README.md          # Project overview for humans
├── src/               # Application source code
│   ├── features/      # Feature modules (tournaments, ecommerce, academy, etc.)
│   ├── shared/        # Shared utilities, components, types
│   └── ...
├── tests/             # Test files mirroring src/ structure
├── docs/              # Architecture diagrams, API docs, ADRs
└── ...                # Config files (CI, linting, formatting, etc.)
```

---

## Coding Conventions

### General

- Write clear, self-documenting code; add comments only where logic is non-obvious
- Prefer small, focused functions and modules over large monolithic ones
- Keep feature code co-located within feature directories
- No commented-out dead code — delete unused code instead

### Naming

- Use descriptive names; avoid abbreviations unless universally understood (`id`, `url`, etc.)
- File names: match the primary export (e.g., `UserProfile.tsx` exports `UserProfile`)

### Git

- Branch naming: `feature/<short-description>`, `fix/<short-description>`, `chore/<short-description>`
- Commit messages: imperative mood, ≤72 chars subject, e.g., `Add tournament bracket view`
- One logical change per commit; keep PRs focused and reviewable

### Testing

- Co-locate tests next to the code they test, or mirror the `src/` tree under `tests/`
- Aim for high coverage on business logic; unit-test pure functions, integration-test APIs
- Tests must pass before merging to `master`

---

## Feature Module Conventions

Each major domain area should be a self-contained module with the following structure:

```
features/<module-name>/
├── index.ts           # Public API / exports
├── components/        # UI components (if applicable)
├── services/          # Business logic, API calls
├── types.ts           # TypeScript types / interfaces
└── tests/             # Module-specific tests
```

**Domain modules to implement:**
- `tournaments` — event lifecycle, brackets, registration
- `ecommerce` — product catalog, cart, checkout, orders
- `academy` — courses, training plans, content management
- `activities` — scheduling, participation, tracking
- `users` — authentication, roles (enthusiast / athlete / admin), profiles

---

## Role-Based Access Control

All features must respect the three user roles. When adding any new capability:

1. Define which roles can access it
2. Enforce access at the API/service layer (not just the UI)
3. Document role requirements in the feature module's `README` or inline comments

---

## AI Assistant Instructions

When working on this codebase:

1. **Read before writing** — Always read existing files before modifying them
2. **Stay focused** — Only make changes requested or clearly necessary; avoid scope creep
3. **No over-engineering** — Prefer the simplest solution that meets the requirement
4. **Update this file** — If you make architectural decisions or establish new conventions, update CLAUDE.md
5. **Respect roles** — Any user-facing feature must account for all three roles
6. **Commit on the correct branch** — Work on `claude/claude-md-mmf2z3ddi1vuzcnq-KuKjg` unless told otherwise
7. **Tests required** — Do not mark implementation tasks complete without corresponding tests

---

## Useful Commands

_Populate this section as the project tooling is established._

```bash
# Lint
# Format
# Build
# Test
# Deploy (staging)
```

---

## Contact / Ownership

- **Repository owner:** nicholasoqx28
- **Remote:** nicholasoqx28/spark
