# TourniBase Waitlist Website

TourniBase is a unified admission, check-in, and revenue platform for youth sports tournaments. This repo contains the first production-ready waitlist website for the product.

## Tech Stack

- Next.js App Router
- TypeScript
- Tailwind CSS
- Supabase
- Vercel

## Local Setup

Install dependencies:

```bash
npm install
```

Create `.env.local` from the example file:

```bash
cp .env.local.example .env.local
```

Add the public Supabase values:

```bash
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
```

Do not put service role keys in frontend environment variables.

## Supabase Setup

The waitlist table is defined in:

```bash
supabase/migrations/20260601175314_create_waitlist_signups.sql
```

The table is `public.waitlist_signups`.

It stores:

- email
- name
- role
- organization
- notes
- source
- created_at

Row Level Security is enabled. Anonymous visitors can insert waitlist signups. Public reads are not allowed.

To run the migration with the Supabase CLI after linking the project:

```bash
supabase db push
```

If you do not use the CLI, run the SQL migration in the Supabase SQL editor.

## Run Locally

```bash
npm run dev
```

Then open:

```bash
http://localhost:3000
```

## Verify A Signup

1. Add `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` to `.env.local`.
2. Run `npm run dev`.
3. Submit the waitlist form with a valid email.
4. In Supabase, open Table Editor.
5. Check `waitlist_signups` for the new row.
6. Confirm public reads are blocked by trying to read the table with the anon key.

## Vercel Deployment

Use these Vercel settings:

- Framework Preset: Next.js
- Root Directory: project root
- Build Command: `npm run build`
- Output Directory: default Next.js output

Add these Vercel environment variables:

```bash
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
```

Deploy only after the environment variables are set.

## Useful Commands

```bash
npm run lint
npm run typecheck
npm run build
npm run dev
```

## iOS Mockup

The native SwiftUI mockup is in:

```bash
apps/ios/TourniBase.xcodeproj
```

See `apps/ios/README.md` for included flows and Xcode setup instructions.
