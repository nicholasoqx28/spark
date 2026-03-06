# Spark ⚡

Sports app that streamlines activities and boosts engagement with tournaments, e-commerce for gear, and academy tools. For enthusiasts, athletes, and admins, it offers seamless navigation to join events, shop, and manage training.

## Quick Start

```bash
npm install
cp .env.example .env        # set NEXTAUTH_SECRET to a random string
npx prisma migrate dev
npm run db:seed             # creates admin@spark.app and athlete@spark.app
npm run dev                 # → http://localhost:3000
```

## Stack

- **Next.js 16** (App Router) + TypeScript + Tailwind CSS
- **Prisma 7** + SQLite (better-sqlite3)
- **NextAuth v5** — JWT sessions, credentials provider

## Commands

```bash
npm run dev          # Development server
npm run build        # Production build (runs prisma generate first)
npm run lint         # ESLint
npm run db:migrate   # Run Prisma migrations
npm run db:seed      # Seed sample data
npm run db:studio    # Prisma Studio GUI
```

## Seed Accounts

| Email | Password | Role |
|---|---|---|
| admin@spark.app | admin1234 | ADMIN |
| athlete@spark.app | athlete1234 | ATHLETE |

See [CLAUDE.md](./CLAUDE.md) for full architecture and development guide.
