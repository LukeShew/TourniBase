# FanPass Overview

## What The Product Currently Is

FanPass is currently a role-based waitlist website for a youth sports tournament admission platform.

## What Works

- Role-first homepage with a concise hero, no default waitlist shortcut, refined audience card copy for each role, three aligned audience cards, bold role buttons, and progressive disclosure
- Dedicated audience pages for tournament directors, parents/spectators, and coaches
- Waitlist form with default and locked role support
- Audience-specific waitlist source values
- Email validation
- Loading, success, and error states
- Shared footer with FanPass contact email
- Supabase migration for waitlist storage
- Placeholder privacy and terms pages

## What Does Not Work Yet

- No live tournament admission
- No QR pass system
- No dashboard
- No auth
- No payment processing

## Current Tech Stack

- Next.js App Router
- TypeScript
- Tailwind CSS
- Supabase
- Vercel

## Pages And Features

- `/` role-first audience selection page with short role taglines and clear role buttons
- `/organizers` tournament director page with organizer-specific mockup and waitlist flow
- `/parents` parent/spectator page with family-specific mockup and waitlist flow
- `/coaches` coach page with team-specific mockup and waitlist flow
- `/privacy` placeholder privacy page
- `/terms` placeholder terms page

## Supabase Status

Supabase project: `saxkpxzqwnwjqcjypysu`

Migration added for `public.waitlist_signups`.

## GitHub Status

Repository: `https://github.com/LukeShew/FanPass`

Local Git remote is set to that repo. Keep work committed after changes so the GitHub push button can push `main` to `origin/main`.

## Vercel Status

The app is ready for Vercel configuration as a Next.js project. Deployment should wait until environment variables are added.

## Workflow Notes

- After each prompt that changes the project, update this overview doc unless literally nothing changed.
- Do not create folders outside this project folder unless explicitly allowed.
- Leave the local repo committed when changes are complete so pushing to GitHub is one click.
- Include the local website link at the end of every chat.

## Local Website Instructions

```bash
npm install
npm run dev
```

Open:

```bash
http://localhost:3000
```

## Live Website Link

Not deployed from this workspace yet.

## Risks And Limitations

- The waitlist form will not submit unless Supabase public env vars are configured.
- Legal pages are placeholders and should be replaced before a paid launch.

## Recommended Next Improvements

- Configure Vercel env vars.
- Deploy a Vercel preview and test the real Supabase insert path.
- Replace placeholder legal pages before launch.
