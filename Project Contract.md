# Project Contract

## Product Name

TourniBase

## One-Sentence Description

TourniBase is a unified admission, check-in, and revenue platform for youth sports tournaments.

## Target Users

- Parents and spectators
- Tournament directors and organizers
- Coaches
- Youth sports event staff

## MVP Definition

The MVP is a role-based waitlist website that explains TourniBase clearly and captures interested users in Supabase.

## Website Scope

The website includes:

- TourniBase brand presence
- concise product explanation
- waitlist signup form
- audience selector
- parents section
- tournament directors section
- coaches section
- privacy and terms placeholder pages

## iOS App Mockup Scope

A native SwiftUI mockup now exists in `apps/ios`. It includes role-based spectator, coach, and tournament director experiences; event discovery; mock admission purchase; digital passes; team readiness; revenue and check-in dashboards; and a simulated QR scanner.

The mockup uses local sample data only. Live authentication, Supabase data, payments, camera scanning, Apple Wallet, and production pass validation are not implemented yet.

## Shared Backend Assumptions

Supabase is the shared backend. The current website only needs public anon inserts into `waitlist_signups`.

## Environment Variables

```bash
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
```

Service role keys must stay out of frontend code.

## Database Status

Migration added for `public.waitlist_signups`. RLS is enabled. Anonymous inserts are allowed. Public reads are blocked.

## Auth Status

No auth is implemented for this MVP.

## Deployment Status

The app is ready for Vercel once environment variables are configured. Production deployment should not happen without explicit approval.

## Known Limitations

- No admin dashboard yet
- No payment flow yet
- No tournament event model yet
- Privacy and terms pages are placeholders

## Next Priorities

- Rename connected service dashboards where needed
- Add the real production domain later
- Replace placeholder legal pages before paid launch
- Build admin review/export tools for waitlist signups
- Define the full tournament, pass, and check-in data model

## Decisions Made

- Build at the repo root because the repo is empty.
- Use Supabase anon client inserts from the browser.
- Keep the MVP focused on waitlist capture.

## Open Questions

- Final production domain
- Final legal copy
- First tournament director pilot group
