# TourniBase Overview

Last updated and verified: July 4, 2026

## Current Product

TourniBase is currently a web-based digital gate system for youth basketball
tournaments.

The web MVP in `apps/tournibase-web-app` is the main product. It lets tournament
directors sell spectator passes, issue mobile tickets, scan guests at the gate,
block duplicate entry, recover buyers through order lookup, and review sales and
attendance.

TourniBase is validating this focused product before building a larger platform
or native app.

## Current MVP Status

| Item | Current state |
| --- | --- |
| Progress | Phases 1–17 of 19 complete |
| Current phase | Phase 17 local-only demo data complete |
| Next phase | Phase 18 quality checks, not started |
| Live web app | [tournibase-web-app.vercel.app](https://tournibase-web-app.vercel.app) |
| Payments | Stripe test mode |
| Database | Live schema matches all 11 committed migrations |
| Main launch dependency | Production receipt and pass-link email delivery |

Remaining numbered phases:

1. Phase 18: run install, lint, typecheck, and production build checks.
2. Phase 19: complete the final Git review and MVP handoff.

Before accepting real customer payments, TourniBase must also:

- Add transactional receipt and mobile pass email.
- Switch the Stripe secret key, publishable key, and production webhook to live
  mode together.
- Complete a real purchase, webhook, pass-delivery, and gate-scan test.
- Confirm live Stripe totals match TourniBase reporting.
- Define a basic tournament-day support and refund process.

This status section must be updated after every completed phase or material MVP
change so it always shows what is live and what remains.

Detailed tracker:
[`apps/tournibase-web-app/docs/implementation-roadmap.md`](apps/tournibase-web-app/docs/implementation-roadmap.md)

## What Works Now

### Tournament director

- Invite-only password login
- Protected dashboard and organization ownership
- Tournament creation with dates, venue, organizer, contact, and public slug
- Ticket type creation, editing, activation, and deactivation
- Draft and published event controls
- Temporary scanner links with permissions, expiration, and revocation
- Coach and parent sharing tools
- Printable public-checkout gate poster
- Sales, revenue, attendance, and gate-activity dashboards

### Parent or spectator

- Public tournament ticket page
- Ticket selection and buyer contact form
- Stripe-hosted test checkout
- One individual mobile pass for each purchased admission
- Branded QR code on each pass
- Event, ticket, date, buyer, venue, order, and support details

### Gate staff

- Mobile camera scanning
- Manual pass-link or token entry
- Server-authoritative pass validation
- Atomic duplicate blocking
- Reasoned duplicate overrides
- Check-in undo
- Buyer and order lookup
- Manual pass check-in
- Persisted recent scanner activity
- Optional cash, Venmo, external-card, and comp sale recording

### Director reporting

- Gross online sales and estimated payout
- Online and manual admission totals
- Revenue by ticket type and sale date
- Successful, duplicate, invalid, and wrong-day scans
- Manual check-in and override totals
- Active scanner-link and unscanned-pass totals

## Core MVP Flow

1. A director logs in and creates a tournament.
2. The director creates active ticket types and publishes the public event.
3. A parent opens the ticket page and pays through Stripe Checkout.
4. A signed Stripe success event marks the order paid and creates one pass per
   admission.
5. The buyer opens each individual mobile pass from the success page.
6. Gate staff open a temporary scanner link and scan the pass QR.
7. Postgres validates the scanner, tournament, order, pass, valid date, and
   prior admissions atomically.
8. A valid pass returns green and checks in. A second use is blocked.
9. The director reviews sales and gate activity from the dashboard.

Production pass-link email is not built yet. The payment success page is the
current automatic delivery method.

## Current Product Boundary

The MVP is digital tournament admission, not full tournament management.

Not included right now:

- Tournament scheduling or brackets
- Team registration or rosters
- Scores or standings
- Referee or gym scheduling
- Full card-terminal point of sale
- Automated refunds or dispute handling

The product should stay focused on admission until real tournament use proves
which adjacent features matter.

## Current Technology

- Next.js App Router
- TypeScript
- Tailwind CSS
- Supabase Auth, Postgres, Row Level Security, and migrations
- Stripe-hosted Checkout and signed webhooks
- Vercel hosting
- ZXing browser camera scanning

The web app uses tournament-local IANA time zones. New tournaments currently
default to `America/New_York`, and device location or VPN usage does not change
pass validity.

## Web MVP Repositories and Services

The web MVP is fully separate from the postponed waitlist website.

- Local app:
  `apps/tournibase-web-app`
- GitHub:
  [LukeShew/tournibase-web-app](https://github.com/LukeShew/tournibase-web-app)
- Vercel:
  [tournibase-web-app.vercel.app](https://tournibase-web-app.vercel.app)
- Supabase project ref:
  `khwaafsdtgiymucppkmo`

Web MVP documentation:

- [Product plan](apps/tournibase-web-app/docs/mvp-product-plan.md)
- [Architecture](apps/tournibase-web-app/docs/mvp-architecture.md)
- [Database schema](apps/tournibase-web-app/docs/database-schema.md)
- [Local demo data](apps/tournibase-web-app/docs/demo-data.md)
- [Implementation roadmap](apps/tournibase-web-app/docs/implementation-roadmap.md)
- [Setup and test guide](apps/tournibase-web-app/README.md)

## Security Status

- All 10 public web-app tables have Row Level Security enabled.
- Anonymous users can read only published tournaments and active ticket types.
- Orders, passes, scanner sessions, check-ins, and manual sales are private.
- Director data is restricted through organization ownership.
- Supabase and Stripe secret keys remain server-only.
- Scanner credentials expire, can be revoked, and are stored only as hashes.
- Gate validation functions are unavailable to browser roles.
- Stripe card details never pass through TourniBase.

## Known MVP Limitations

- Automated receipt and pass-link email is not implemented.
- Stripe is in test mode.
- Director accounts are created manually through Supabase.
- Gate-sale recording tracks external payment but does not charge a card.
- Refund and dispute workflows are not automated.
- Demo data is available only through a guarded local seed command that blocks
  hosted Supabase URLs.
- Final quality and release checks remain in Phases 18 and 19.

## Postponed Projects

### Waitlist Website

The waitlist website is postponed. It is not the current MVP and should not
drive current product decisions.

It remains separate:

- Local code: the root waitlist-site repository
- GitHub: [LukeShew/TourniBase](https://github.com/LukeShew/TourniBase)
- Vercel: [tourni-base.vercel.app](https://tourni-base.vercel.app)
- Supabase project ref: `saxkpxzqwnwjqcjypysu`

No new waitlist features are planned during the web MVP phases. Existing
waitlist code and data should remain intact for possible future marketing use.

### Native iOS App

The SwiftUI project at `apps/ios/TourniBase.xcodeproj` is a postponed product
mockup. It uses local sample data and does not connect to live Supabase,
payments, cameras, or production pass validation.

A native iOS and Android product may become the long-term direction after the
web MVP proves demand. Until then, web-first access is the better fit because
parents and gate staff do not need to install an app at a tournament.

## Long-Term Direction

The long-term goal is for TourniBase to become the standard admission and
check-in platform for youth sports tournaments.

The current wedge is deliberately narrow:

- Give parents one predictable way to buy and show admission.
- Give directors one system for sales, gate control, and reporting.
- Give gate staff a fast, reliable admission decision.

Youth basketball is the starting market. Expansion to other sports, a shared
spectator account, saved payment methods, and native apps should follow only
after the web admission workflow is validated.

## Other Project Assets

- Brand assets are in `TourniBase logos/`.
- Outreach tools are in `outreach/`.
- Do not create project folders outside this TourniBase folder unless explicitly
  approved.

## Workflow

- Update this file after every completed web MVP phase or material scope change.
- Keep the web app and waitlist repositories separate.
- Commit only the intended repository changes.
- Do not commit environment files or secrets.
- Leave local repository changes ready for the user’s one-click GitHub Desktop
  push.

## Local Web MVP

```bash
cd apps/tournibase-web-app
npm install
npm run dev
```

Open:

```text
http://localhost:3000
```
