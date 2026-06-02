# FanPass Overview

## What The Product Currently Is

FanPass is currently a role-based waitlist website for a youth sports tournament admission platform.

## Company Vision

FanPass is being built to become the standard admission, check-in, and revenue platform for youth sports tournaments.

The long-term vision is that a parent or spectator should never have to think about tournament admission logistics again. They should not have to wonder whether a tournament accepts cash, Venmo, Zelle, PayPal, Square, Apple Pay, or some other payment method. They should not have to download a new app while standing in line. They should not have to create an account at the entrance of a crowded gym with poor cell service. They should not have to repeat the same frustrating process every weekend during a travel sports season.

Instead, FanPass should make tournament admission simple and predictable.

A spectator creates one FanPass account, saves one payment method, and uses that same system across every participating tournament. Before arriving at an event, they can purchase a weekend pass, single-day pass, or other admission option directly through FanPass. When they arrive, they open their pass, show it at the gate, and receive entry through a fast, consistent check-in process.

The easiest way to understand the vision is that FanPass should do for youth sports tournament admission what EZ Pass did for toll roads. Spectators should no longer need to worry about how each individual tournament collects admission. If the tournament uses FanPass, the process is already known.

However, FanPass is not just a payment app for parents.

The larger opportunity is on the tournament operator side.

Youth sports tournament admissions are currently fragmented and poorly managed. Many tournament operators rely on a mix of cash, Venmo, Zelle, PayPal, Square, manual wristbands, paper lists, and informal gate processes. This creates inconsistent spectator experiences, slows down entry, increases cash handling, makes reconciliation harder, and gives tournament directors limited visibility into admission revenue and attendance.

FanPass should become the operating layer for tournament admissions.

For tournament directors, FanPass should provide a centralized system to create events, configure admission options, sell passes, verify entry, track revenue, and understand attendance. A tournament director should be able to create an event, set pricing for weekend passes and single-day passes, generate a registration link, send that link to coaches, and have coaches distribute it to parents, families, and spectators before the tournament begins.

Once the event is live, FanPass should give the tournament operator real-time visibility into admissions. The platform should show total revenue, revenue by day, revenue by venue, revenue by admission type, weekend pass sales, single-day pass sales, total admissions, check-ins, entry volume by hour, peak admission periods, and historical event trends.

The goal is to replace scattered, manual admission processes with one clean system.

FanPass should help tournament operators reduce cash handling, speed up gate lines, prevent admission fraud, simplify reconciliation, improve reporting, and make better operational decisions. Instead of checking multiple payment platforms and manually calculating revenue after the event, tournament directors should be able to open one dashboard and immediately understand how the event performed.

Entry verification is also a core part of the vision. FanPass needs to make it easy for gate workers to confirm that a spectator has a valid pass while making it difficult for people to share or duplicate admissions through screenshots. The final technical method may involve dynamic QR codes, time-sensitive passes, rotating validation screens, or another anti-fraud system, but the objective is clear: valid spectators should enter quickly, and invalid or duplicated passes should be easy to detect.

The company should initially focus on youth basketball tournaments because that is where the problem was first observed and where the admission experience is especially fragmented. Many families attend tournaments repeatedly throughout the season, and tournament environments are often crowded, rushed, and inconsistent. Basketball provides a focused starting niche with frequent events, repeat spectators, and clear operational pain.

Over time, FanPass could expand into other tournament-based youth sports, including volleyball, baseball, softball, soccer, wrestling, and other environments where spectators regularly pay admission. The broader market is not limited to basketball. The real target is any youth sports tournament ecosystem where admission is paid, fragmented, and manually managed.

FanPass should be positioned as:

The standard admission and check-in platform for youth sports tournaments.

The original problem was simple: parents do not know how to pay.

The larger problem is more important: tournament admissions are fragmented, inconsistent, and poorly managed.

That distinction matters because FanPass should not be built as just another payment option. It should be built as tournament admission infrastructure. Payment standardization is the wedge, but admissions management, check-in, revenue tracking, attendance analytics, and operational visibility are the larger business.

The platform creates value for spectators by giving them one consistent way to purchase and use admission across tournaments.

The platform creates value for tournament directors by giving them one system to manage admissions, collect revenue, verify entry, and understand event performance.

The ultimate vision is that FanPass becomes the default system people expect to use when attending youth sports tournaments. Parents should assume they can use FanPass before they arrive. Tournament operators should see FanPass as the simplest way to run admissions. Gate workers should have a fast and reliable way to check people in. Coaches should be able to send one clean link to families. Organizers should have better control over revenue and attendance.

FanPass is not trying to become a casual payment app.

FanPass is trying to become the standardized admission infrastructure layer for youth sports tournaments.

## What Works

- Role-first homepage with a concise hero, centered header navigation, contact email shortcut, refined audience card copy for each role, aligned card text/buttons, bold role buttons, and progressive disclosure
- Dedicated audience pages for tournament directors, parents/spectators, and coaches with role-specific benefits, mockups, and stronger signup prompts
- Coach mockup shows clearer roster states for checked in, pass-ready, and not-registered players
- Parent page stats emphasize a unified payment processor
- Parent phone mockup shows paid status, entrance info, and simple pass navigation rows
- Parent phone mockup action rows use clearer spacing below the pass details
- Parent phone mockup uses John Smith as the sample pass holder
- Waitlist forms require email, name, and organization/team, with directors using an Organization-only label
- Role-page waitlist sections keep the CTA focused by removing the extra explanatory paragraph
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
