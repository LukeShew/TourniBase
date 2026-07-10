# TourniBase Overview

Last updated and verified: July 10, 2026

## 1. What is TourniBase?

TourniBase is a web-based admissions system for youth basketball tournaments.

The current product is focused on tournament-day admission control: selling
spectator passes online, delivering mobile passes, validating entry at the gate,
blocking duplicate use, and giving directors a clear view of orders, revenue,
refunds, and gate activity.

The web MVP in `apps/tournibase-web-app` is the main product. The waitlist site
and native app ideas are postponed.

## 2. Company Vision

TourniBase’s long-term goal is to become the go-to admissions operating system
for youth sports tournaments. The broader vision is not limited to basketball.

The current wedge is intentionally narrow: youth basketball tournament admission
control.

TourniBase is focused on solving two tournament-day problems at the gate:

- **Shorter, smoother lines:** Give spectators a cleaner way to buy, access,
  and present passes so they can enter faster with less gate friction.
- **Fraud prevention:** Give gate staff one system for validating passes and
  preventing duplicate entry, reused or shared passes, refunded passes, and
  other admission leakage.

Youth basketball is the starting market. Expansion to other sports, shared
spectator accounts, saved payment methods, wallet passes, and native apps should
come only after the web admissions workflow is validated with real tournaments.

## 3. Competitive Positioning

**Market Position**

TourniBase is building toward a focused position within the youth sports software market. Its product goal is to own the spectator admissions experience—from selling admission passes through validating entry at the gate and providing admissions reporting—without replacing every other system a tournament director uses. That is the direction of the product, not a claim that TourniBase already owns this market. The current product is an early, working admissions system being prepared for its first tournament pilot.

Many competing products include admissions as one feature within a much broader tournament or event management platform. Others are general-purpose ticketing platforms designed for many types of events. TourniBase instead treats admissions as the primary product. The goal is to provide a simpler, more specialized solution for tournament directors who want reliable, efficient gate operations without adopting an entire tournament management ecosystem.

**Position Relative to Competitors**

**Exposure Events**

Exposure Events is the closest documented competitor to TourniBase. It is a comprehensive tournament operations platform that includes registration, scheduling, brackets, messaging, reporting, mobile applications, APIs, and a mature admissions workflow with QR-code validation and gate management.

For tournament directors seeking a single platform to manage nearly every aspect of an event, Exposure is a strong all-in-one solution.

TourniBase takes a different approach. Rather than competing across every aspect of tournament management, it focuses specifically on admissions. Directors who already have preferred solutions for registration, scheduling, or brackets can adopt TourniBase without replacing the rest of their tournament workflow.

**SportsEngine Tourney**

SportsEngine Tourney is a tournament management platform centered around team registration, scheduling, brackets, standings, live scoring, tournament communication, and public event information.

Based on the official documentation reviewed, spectator admissions workflows—including digital ticketing, QR-code validation, gate operations, pass management, and attendance reporting—could not be verified.

Tournament directors whose primary challenge is running tournament operations may find SportsEngine Tourney to be a strong fit. Directors whose primary challenge is managing spectator admissions may still benefit from a dedicated admissions platform.

**SportsEngine Play**

SportsEngine Play is primarily a livestreaming, video, and fan engagement platform.

Its documented capabilities focus on livestreams, highlights, replays, subscriptions, and spectator viewing rather than tournament admissions.

It should generally be viewed as complementary to TourniBase rather than as a direct competitor.

**GoFan**

GoFan is a mature digital ticketing platform with admissions software that is substantially similar to TourniBase in several areas. Its strongest established market focus is school athletics, while it also serves youth sports organizations and other live events.

Its documented capabilities include online ticket sales, on-site sales, QR-code validation, gate redemption, attendance reporting, financial reporting, reserved seating, mobile passes, fundraising, concessions, and related event commerce features.

GoFan overlaps substantially with TourniBase in the admissions layer, including ticket sales, mobile passes, validation, redemption, and reporting.

The primary distinction is the current market focus. GoFan is established mainly around schools, districts, and school athletics. TourniBase is starting with independently operated private AAU and youth basketball tournaments. TourniBase should not claim that GoFan lacks comparable software; its opportunity is to build a product and operating model specifically for private youth tournament directors and their gate teams.

**Eventbrite**

Eventbrite is a general-purpose event ticketing and registration platform.

Its documented strengths include online ticket sales, payment processing, QR-code check-in, organizer mobile tools, reporting, event discovery, marketing tools, and a mature developer platform.

The official documentation reviewed does not describe native tournament-specific functionality such as brackets, team management, tournament scheduling, or other youth sports operational workflows.

Organizations simply looking to sell admission for an event may find Eventbrite to be an effective solution. Organizations operating recurring youth sports tournaments may benefit from an admissions platform designed specifically for that environment.

**Overall Positioning**

TourniBase is not intended to become a full tournament management platform.

Instead, its long-term goal is to become the admissions infrastructure for youth sports tournaments.

Where many competitors include admissions as one feature inside a larger platform, TourniBase focuses on making admissions itself faster, simpler, and more reliable for tournament directors, gate staff, and spectators.

Tournament directors who prefer an all-in-one tournament management platform may find products such as Exposure Events or SportsEngine Tourney to be a better fit.

Tournament directors who already have tournament operations under control—or who simply want a dedicated admissions solution—are the audience TourniBase is designed to serve.

## 4. Current Product

### How It Works

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
10. The director reviews orders, revenue, refunds, and gate activity from the
    dashboard.
11. If an order is refunded in Stripe, TourniBase syncs the latest refund
    status, emails the buyer, and fully invalidates active or checked-in passes
    on full refunds.

The pass-email template, retry-safe delivery system, verified sender domain,
and production Resend transport are live. The first end-to-end purchase test
sent exactly one email on the first delivery attempt.

### Current Capabilities

#### Tournament Director

- Invite-only password login
- Protected dashboard and organization ownership
- Tournament creation with dates, venue, organizer, contact, and public slug
- Event detail editing for names, dates, venue, description, organizer, and
  contact email
- Ticket type creation, editing, activation, and deactivation
- Draft and published event controls
- Temporary scanner links with permissions, expiration, and revocation
- Coach and parent sharing tools
- Order lookup and order details
- Stripe refund links from the order log
- Revenue, admission, refund, and gate-activity dashboards
- Profile avatar selection from preset icons and colors

#### Parent / Spectator

- Public tournament ticket page
- Ticket selection and buyer contact form
- Stripe-hosted test checkout
- One individual mobile pass for each purchased admission
- Automated TourniBase confirmation email containing every purchased pass link
  and a device-save link
- Automated TourniBase refund confirmation email after Stripe refund webhooks
- Branded QR code on each pass
- Device-save page for saving a backup pass image to Photos or Files before
  arriving at the venue
- Event, ticket, date, buyer, venue, order, and support details

#### Gate Staff

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

#### Reporting / Administration

- Gross online sales and estimated payout
- Online and manual admission totals
- Revenue by ticket type and sale date
- Successful, duplicate, invalid, refunded, and wrong-day scans
- Manual check-in and override totals
- Active scanner-link and unscanned-pass totals
- Legal/support pages for Terms, Privacy, Refund Policy, and Support

### Current Product Boundary

The MVP is digital tournament admission, not full tournament management.

Not included right now:

- Tournament scheduling or brackets
- Team registration or rosters
- Scores or standings
- Referee or gym scheduling
- Full card-terminal point of sale
- Self-serve refund portal
- Automated dispute handling
- Apple Wallet or Google Wallet passes

The product should stay focused on admission until real tournament use proves
which adjacent features matter.

## 5. Current Status

| Item | Current state |
| --- | --- |
| Progress | All 19 numbered phases complete |
| Current phase | Redesign refinement in progress |
| Next major launch step | Stripe live mode and controlled live transaction testing |
| Live web app | [tournibase.com](https://tournibase.com) |
| Payments | Stripe test mode |
| Database | Live and local histories match all 12 product migrations |
| Email | Live through Resend |
| Pass retrieval | Success page, automated email, mobile pass page, and device-save page |
| Refund support | Manual Stripe refunds with automatic full-refund invalidation and TourniBase refund email |
| Legal/support pages | Footer links to Terms, Privacy, Refund Policy, and Support |

Known MVP limitations:

- Stripe is still in test mode.
- Director accounts are created manually through Supabase.
- Supabase leaked-password protection is unavailable on the current plan, so
  invited directors must use strong, unique passwords.
- Gate-sale recording tracks external payment but does not charge a card.
- Refund requests still require manual Stripe action. Full-refund webhook sync
  blocks refunded passes and emails the buyer once Stripe sends the event to
  TourniBase.
- Partial refunds are tracked at the order level and send a buyer email, but
  pass-specific partial-refund handling is not automated.
- Footer legal/support pages are baseline MVP pages, not a replacement for
  legal review before higher-volume use.
- Demo data is available only through a guarded local seed command that blocks
  hosted Supabase URLs.
- Customer-side saved pass images work without buyer internet, but scanner
  devices still need internet for authoritative validation and duplicate
  blocking.
- Apple Wallet is not available yet. Apple Wallet support requires Apple
  Developer Program access and pass-certificate setup, so it is postponed.
- Google Wallet is also postponed and should be evaluated separately when wallet
  support becomes a priority.

## 6. Roadmap

### Remaining Launch Work

- Finish and verify the light redesign.
- Switch the Stripe secret key, publishable key, and production webhook to live
  mode together.
- Complete a controlled low-value live purchase.
- Confirm the live Stripe webhook marks the order paid and sends the buyer email.
- Confirm the live mobile pass opens and scans correctly.
- Confirm a live full refund sends the refund email and blocks the refunded pass.
- Confirm live Stripe totals match TourniBase reporting.
- Confirm the manual support/refund process is clear enough for the first pilot.

### Monetization Strategy

TourniBase is currently free for tournament directors during the pilot period, with no platform fee taken today.

After the product proves value through sustained real-world tournament usage, TourniBase is expected to transition to a paid model.

The current monetization direction is expected to consist of:

* A recurring subscription for tournament directors.
* A small platform fee on admission passes sold through TourniBase.
* Payment processing fees handled during checkout where appropriate.

Exact pricing has not been finalized and may evolve as the product matures. Pricing decisions will be based on customer feedback, demonstrated value, and long-term business sustainability.

The long-term objective is to align TourniBase’s revenue with the value it creates for tournament operators while keeping adoption friction low during the product’s early growth.

## 7. Tech Stack

- Next.js App Router
- TypeScript
- Tailwind CSS
- Supabase Auth, Postgres, Row Level Security, and migrations
- Stripe-hosted Checkout and signed webhooks
- Stripe refund sync into order and pass statuses
- TourniBase refund confirmation emails
- React Email template rendering, Resend delivery, and provider-neutral
  delivery tracking
- Vercel hosting
- ZXing browser camera scanning
- Server Components and Server Actions for protected data and mutations
- Temporary scanner credentials stored only as SHA-256 hashes
- Individual pass UUIDs resolved only through server-controlled pass and scanner
  flows

The web app uses tournament-local IANA time zones. New tournaments currently
default to `America/New_York`, and device location or VPN usage does not change
pass validity.

## 8. Developer Reference

### Web MVP Repositories and Services

The web MVP is fully separate from the postponed waitlist website.

- Local app: `apps/tournibase-web-app`
- GitHub: [LukeShew/tournibase-web-app](https://github.com/LukeShew/tournibase-web-app)
- Production app: [tournibase.com](https://tournibase.com)
- Transactional email: Resend with the verified `tournibase.com` sender domain
- Supabase project ref: `khwaafsdtgiymucppkmo`

Web MVP documentation:

- [Product plan](apps/tournibase-web-app/docs/mvp-product-plan.md)
- [Architecture](apps/tournibase-web-app/docs/mvp-architecture.md)
- [Database schema](apps/tournibase-web-app/docs/database-schema.md)
- [Local demo data](apps/tournibase-web-app/docs/demo-data.md)
- [Implementation roadmap](apps/tournibase-web-app/docs/implementation-roadmap.md)
- [Transactional email](apps/tournibase-web-app/docs/transactional-email.md)
- [Final MVP handoff](apps/tournibase-web-app/docs/mvp-handoff.md)
- [Setup and test guide](apps/tournibase-web-app/README.md)

### Security Architecture

- All 11 public web-app tables have Row Level Security enabled.
- Anonymous users can read only published tournaments and active ticket types.
- Orders, passes, scanner sessions, check-ins, and manual sales are private.
- Director data is restricted through organization ownership.
- Supabase and Stripe secret keys remain server-only.
- Scanner credentials expire, can be revoked, and are stored only as hashes.
- Gate validation functions are unavailable to browser roles.
- Stripe card details never pass through TourniBase.

### Local Web MVP

```bash
cd apps/tournibase-web-app
npm install
npm run dev
```

Open:

```text
http://localhost:3000
```

### Workflow

- Update this file after every completed web MVP phase or material scope change.
- Keep the web app and waitlist repositories separate.
- Commit only the intended repository changes.
- Do not commit environment files or secrets.
- Leave local web-app repository changes ready for the user’s GitHub Desktop
  push unless the user explicitly asks otherwise.
- The root TourniBase repository may be committed/pushed by Codex only when the
  change is limited to this overview document and the user has allowed it.
- Do not create project folders outside this TourniBase folder unless explicitly
  approved.

## 9. Deferred / Postponed Work

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

### Wallet Passes

Apple Wallet and Google Wallet passes are postponed.

Apple Wallet is not possible in the product right now because TourniBase still
needs Apple Developer Program access and Apple pass-certificate setup. It is a
good future feature, but the current MVP uses email pass links, mobile pass
pages, and device-save backup images instead.

### Other Project Assets

- Brand assets are in `TourniBase logos/`.
- Outreach tools are in `outreach/`.
