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
| ENTHUSIAST | Casual users browsing events and shopping |
| ATHLETE | Active participants joining tournaments and tracking training |
| ADMIN | Manages tournaments, products, users, and academy content |

---

## Technology Stack

| Layer | Choice | Notes |
|---|---|---|
| Framework | **Next.js 16** (App Router) | Full-stack — UI + API routes |
| Language | **TypeScript** | Strict mode |
| Styling | **Tailwind CSS v4** | Utility-first |
| ORM | **Prisma 7** | Generated client at `app/generated/prisma/client` |
| Database | **SQLite** via **better-sqlite3** | Local dev; upgrade to Postgres for production |
| Auth | **NextAuth.js v5** (beta) | JWT sessions; credentials provider |
| Password hashing | **bcryptjs** | cost factor 12 |

---

## Development Setup

```bash
# Clone the repository
git clone <repo-url>
cd spark

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env
# Edit .env — set NEXTAUTH_SECRET to a random string

# Apply database migrations
npx prisma migrate dev

# Generate Prisma client
npx prisma generate

# Seed the database with sample data
npm run db:seed
# Creates: admin@spark.app / admin1234 and athlete@spark.app / athlete1234

# Run development server
npm run dev
# → http://localhost:3000
```

---

## Environment Variables

| Variable | Description | Example |
|---|---|---|
| `DATABASE_URL` | SQLite URL (unused at runtime; used by Prisma CLI) | `file:./prisma/dev.db` |
| `DB_PATH` | Absolute path to the SQLite file (optional override) | `/path/to/dev.db` |
| `NEXTAUTH_SECRET` | JWT signing secret — **change in production** | random 32-char string |
| `NEXTAUTH_URL` | Canonical URL of the app | `http://localhost:3000` |

> **Note:** Prisma 7 with better-sqlite3 resolves the DB path from `process.cwd()/prisma/dev.db` at runtime (not from `DATABASE_URL`). `DATABASE_URL` is only used by `prisma migrate` and `prisma studio` via `prisma.config.ts`.

---

## Architecture Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Stack | Next.js App Router (full-stack) | Single repo for web + API; RSC for fast data fetching |
| Database | SQLite + better-sqlite3 | Zero-config for local dev; swap to Postgres for production |
| Prisma adapter | `@prisma/adapter-better-sqlite3` | Prisma 7 requires driver adapters instead of embedded engine |
| Auth | NextAuth v5 credentials | Simple username/password; can add OAuth providers later |
| Prisma client location | `app/generated/prisma/client` | Prisma 7 generated output — always import from this path |

---

## Directory Structure

```
spark/
├── CLAUDE.md                    # This file — AI assistant guide
├── README.md                    # Project overview
├── prisma/
│   ├── schema.prisma            # Database schema
│   ├── seed.ts                  # Sample data seeder
│   ├── migrations/              # Prisma migration history
│   └── dev.db                   # SQLite database (gitignored)
├── app/                         # Next.js App Router
│   ├── layout.tsx               # Root layout (Navbar, SessionProvider)
│   ├── page.tsx                 # Landing page
│   ├── globals.css              # Global styles
│   ├── generated/prisma/        # Prisma-generated client (do not edit)
│   ├── (auth pages)/
│   │   ├── login/page.tsx
│   │   └── register/page.tsx
│   ├── dashboard/page.tsx
│   ├── tournaments/page.tsx
│   ├── shop/page.tsx
│   ├── academy/page.tsx
│   └── api/
│       ├── auth/[...nextauth]/  # NextAuth handler
│       ├── auth/register/       # User registration
│       ├── tournaments/         # CRUD + registration
│       ├── products/            # Product catalog
│       ├── orders/              # Order management
│       ├── courses/             # Academy courses
│       └── enrollments/         # Course enrollment
├── features/                    # Domain feature modules
│   ├── users/
│   ├── tournaments/
│   ├── ecommerce/
│   └── academy/
├── lib/
│   ├── prisma.ts                # Prisma client singleton
│   └── auth.ts                  # NextAuth configuration
├── types/
│   └── next-auth.d.ts           # Session type augmentation
└── prisma.config.ts             # Prisma 7 CLI configuration
```

---

## Feature Module Conventions

Each domain module lives under `features/<module-name>/` and follows this structure:

```
features/<module-name>/
├── index.ts           # Public API — re-exports from services and components
├── components/        # React UI components
├── services/          # Business logic calling Prisma directly
└── types.ts           # TypeScript types / interfaces (if needed)
```

**Modules:**
- `users` — auth, session, profile
- `tournaments` — event lifecycle, registration
- `ecommerce` — products, orders, cart
- `academy` — courses, lessons, enrollment

---

## Coding Conventions

### General

- Write clear, self-documenting code; add comments only where logic is non-obvious
- Prefer small, focused functions and modules over large monolithic ones
- No commented-out dead code — delete unused code instead

### Imports

- Always import Prisma types from `@/app/generated/prisma/client` (not from `@/app/generated/prisma`)
- Use `@/` alias for all internal imports (configured in `tsconfig.json`)

### Naming

- Use descriptive names; avoid abbreviations unless universally understood (`id`, `url`, etc.)
- React components: PascalCase (`TournamentCard.tsx`)
- Services / utilities: camelCase (`tournamentService.ts`)

### Git

- Branch naming: `feature/<short-description>`, `fix/<short-description>`, `chore/<short-description>`
- Commit messages: imperative mood, ≤72 chars subject, e.g., `Add tournament bracket view`
- One logical change per commit; keep PRs focused and reviewable
- Work on `claude/claude-md-mmf2z3ddi1vuzcnq-KuKjg` unless told otherwise

### Testing

- Co-locate tests next to the code they test, or mirror the `src/` tree under `tests/`
- Aim for high coverage on business logic; unit-test pure functions, integration-test APIs
- Tests must pass before merging to `master`

---

## Role-Based Access Control

| Route / Action | ENTHUSIAST | ATHLETE | ADMIN |
|---|---|---|---|
| Browse tournaments | ✅ | ✅ | ✅ |
| Register for tournament | ❌ | ✅ | ✅ |
| Create tournament | ❌ | ❌ | ✅ |
| Browse products | ✅ | ✅ | ✅ |
| Place order | ✅ | ✅ | ✅ |
| Add/edit products | ❌ | ❌ | ✅ |
| Enroll in course | ✅ | ✅ | ✅ |
| Create course | ❌ | ❌ | ✅ |

**Rules:**
1. Enforce roles at the **API route layer** (not just the UI)
2. Use `const session = await auth()` in server components / route handlers
3. Return `403` for unauthorized actions

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
8. **Import from client** — Always use `@/app/generated/prisma/client` for Prisma types and client

---

## Useful Commands

```bash
npm run dev          # Start development server (http://localhost:3000)
npm run build        # Production build + type check
npm run lint         # ESLint
npm run db:migrate   # Run Prisma migrations (npx prisma migrate dev)
npm run db:seed      # Seed sample data
npm run db:studio    # Open Prisma Studio GUI
```

---

## Seed Accounts

| Email | Password | Role |
|---|---|---|
| admin@spark.app | admin1234 | ADMIN |
| athlete@spark.app | athlete1234 | ATHLETE |

---

## Contact / Ownership

- **Repository owner:** nicholasoqx28
- **Remote:** nicholasoqx28/spark
