# TourniBase Overview

Last updated and verified: July 7, 2026

## Product Positioning

TourniBase's long-term goal is to become the go-to admissions operating system
for youth sports tournaments. The broader vision is not limited to basketball.

The current wedge is intentionally narrow: youth basketball tournament
admission control.

TourniBase is focused on solving two tournament-day problems at the gate:

- **Shorter, smoother lines:** Give spectators a cleaner way to buy, access,
  and present passes so they can enter faster with less gate friction.
- **Fraud prevention:** Give gate staff one system for validating passes and
  preventing duplicate entry, reused or shared passes, and other admission
  leakage.

The current product should not be presented as a general tournament-management
platform. It is an admission-control product for youth basketball tournaments,
with broader youth-sports admission as the long-term direction.

## Current Product

TourniBase is currently a web-based admission-control system for youth
basketball tournaments.

The web MVP in `apps/tournibase-web-app` is the main product. It lets tournament
directors sell spectator passes, issue mobile tickets, scan guests at the gate,
block duplicate entry, recover buyers through order lookup, and review sales and
attendance.

TourniBase is validating this focused admission product before expanding to
other youth sports or building native apps.

## Current MVP Status

| Item | Current state |
| --- | --- |
| Progress | All 19 numbered phases complete |
| Current phase | Phase 19 final Git review and MVP handoff complete |
| Next phase | No numbered build phase remains |
| Live web app | [tournibase.com](https://tournibase.com) |
| Payments | Stripe test mode |
| Database | Live and local histories match all 12 product migrations |
| Email | Live through Resend; first end-to-end test delivered successfully on the first attempt |
| Pass retrieval | Success page, automated email, mobile pass page, and device-save page for weak service |
| Next product priority | Verify latest deployment, complete a light redesign, then prepare Stripe live mode |
| Main launch dependency | Move Stripe to live mode and run a real low-value purchase, email, pass, refund, and gate-scan test |

No numbered phases remain. The
[Final MVP Handoff](apps/tournibase-web-app/docs/mvp-handoff.md) records routes,
environment variables, database state, local testing, limitations, and launch
work.

Before accepting real customer payments, TourniBase must also:

- Switch the Stripe secret key, publishable key, and production webhook to live
  mode together.
- Complete a real purchase, webhook, pass-delivery, and gate-scan test.
- Confirm live Stripe totals match TourniBase reporting.
- Complete the planned light redesign before the first official live test.
- Confirm the manual refund/support process works in live mode.

This status section must be updated after every completed phase or material MVP
change so it always shows what is live and what remains.

Detailed tracker:
[`apps/tournibase-web-app/docs/implementation-roadmap.md`](apps/tournibase-web-app/docs/implementation-roadmap.md)

## What Works Now

### Tournament director

- Invite-only password login
- Protected dashboard and organization ownership
- Tournament creation with dates, venue, organizer, contact, and public slug
- Event detail editing for names, dates, venue, description, organizer, and
  contact email
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
- Automated TourniBase confirmation email containing every purchased pass link
  and a device-save link
- Branded QR code on each pass
- Device-save page for saving a backup pass image to Photos or Files before
  arriving at the venue
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
5. TourniBase sends one confirmation email containing every individual pass
   link through Resend.
6. The buyer can open each mobile pass from the email or payment success page,
   or use the device-save page before arriving if venue service may be weak.
7. Gate staff open a temporary scanner link and scan the pass QR.
8. Postgres validates the scanner, tournament, order, pass, valid date, and
   prior admissions atomically.
9. A valid pass returns green and checks in. A second use is blocked.
10. The director reviews sales and gate activity from the dashboard.

The pass-email template, retry-safe delivery system, verified sender domain,
and production Resend transport are live. The first end-to-end purchase test
sent exactly one email on the first delivery attempt.

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

## Monetization Direction

TourniBase should be free for tournament directors during the initial adoption
period. The current Stripe setup does not take a TourniBase platform fee.

Later, TourniBase may use Stripe Connect to keep a platform fee from ticket
sales and may add a monthly fee for TourniBase services. Those fees should not
be activated until the product has proven its value with real tournament use.

## Current Technology

- Next.js App Router
- TypeScript
- Tailwind CSS
- Supabase Auth, Postgres, Row Level Security, and migrations
- Stripe-hosted Checkout and signed webhooks
- React Email template rendering, Resend delivery, and provider-neutral
  delivery tracking
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
  [tournibase.com](https://tournibase.com)
- Transactional email:
  Resend with the verified `tournibase.com` sender domain
- Supabase project ref:
  `khwaafsdtgiymucppkmo`

Web MVP documentation:

- [Product plan](apps/tournibase-web-app/docs/mvp-product-plan.md)
- [Architecture](apps/tournibase-web-app/docs/mvp-architecture.md)
- [Database schema](apps/tournibase-web-app/docs/database-schema.md)
- [Local demo data](apps/tournibase-web-app/docs/demo-data.md)
- [Implementation roadmap](apps/tournibase-web-app/docs/implementation-roadmap.md)
- [Transactional email](apps/tournibase-web-app/docs/transactional-email.md)
- [Final MVP handoff](apps/tournibase-web-app/docs/mvp-handoff.md)
- [Setup and test guide](apps/tournibase-web-app/README.md)

## Security Status

- All 11 public web-app tables have Row Level Security enabled.
- Anonymous users can read only published tournaments and active ticket types.
- Orders, passes, scanner sessions, check-ins, and manual sales are private.
- Director data is restricted through organization ownership.
- Supabase and Stripe secret keys remain server-only.
- Scanner credentials expire, can be revoked, and are stored only as hashes.
- Gate validation functions are unavailable to browser roles.
- Stripe card details never pass through TourniBase.

## Known MVP Limitations

- Apple Wallet and Google Wallet passes are not implemented yet. Buyers
  currently retrieve passes through the confirmation email, success page,
  mobile pass page, or device-save page.
- The scanner still needs an internet connection for authoritative validation
  and duplicate blocking. Customer-side offline pass storage does not make the
  scanner work offline.
- Stripe is in test mode.
- Director accounts are created manually through Supabase.
- Supabase leaked-password protection is unavailable on the current plan, so
  invited directors must use strong, unique passwords.
- Gate-sale recording tracks external payment but does not charge a card.
- Refund requests still require manual Stripe action. Full-refund webhook sync
  blocks refunded passes once Stripe sends the event to TourniBase.
- Demo data is available only through a guarded local seed command that blocks
  hosted Supabase URLs.
- All numbered build phases are complete.

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

The long-term goal is for TourniBase to become the go-to admissions operating
system for youth sports tournaments broadly, not just basketball.

The current wedge is deliberately narrow:

- Make entry lines shorter and smoother by giving spectators one predictable
  way to buy, access, and present passes.
- Reduce admission fraud and leakage by preventing duplicate entry and reused
  or shared passes.
- Give directors and gate staff one reliable admission-control system.

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
