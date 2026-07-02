import Link from "next/link";
import { ProductMockup } from "@/components/product-mockups";
import { SiteFooter, SiteHeader } from "@/components/site-shell";
import { WaitlistForm, type WaitlistRole } from "@/components/waitlist-form";

export type AudienceKey = "organizers" | "parents" | "coaches";

type AudienceContent = {
  label: string;
  ctaLabel: string;
  eyebrow: string;
  title: string;
  description: string;
  earlyAccessTitle: string;
  benefitsTitle: string;
  benefitsIntro: string;
  role: WaitlistRole;
  source: string;
  mockup: AudienceKey;
  quickBenefits: string[];
  reasons: {
    title: string;
    body: string;
  }[];
  stats: {
    value: string;
    label: string;
  }[];
};

export const audienceContent: Record<AudienceKey, AudienceContent> = {
  organizers: {
    label: "Tournament Director / Organizer",
    ctaLabel: "Join as Director",
    eyebrow: "Built for tournament directors",
    title: "Streamline admissions and boost gate revenue.",
    description:
      "TourniBase gives tournament managers one place to sell passes, check guests in, and track admission activity while the tournament is still moving.",
    earlyAccessTitle: "Get early access to a cleaner admissions workflow.",
    benefitsTitle: "Know exactly what is happening at every entrance.",
    benefitsIntro:
      "TourniBase is built to replace paper lists, scattered payment screenshots, and end-of-day revenue guesswork with a live admissions workflow.",
    role: "Tournament Director / Organizer",
    source: "website-organizers",
    mockup: "organizers",
    quickBenefits: [
      "Live gate dashboard for pass sales and check-ins",
      "Cleaner revenue totals without spreadsheet cleanup",
      "Fewer disputes over who paid or entered"
    ],
    reasons: [
      {
        title: "Reduce entry wait times",
        body: "Give gate staff a direct check-in flow so families are not stuck while someone searches for a list, receipt, or payment screenshot."
      },
      {
        title: "Get automatic revenue reports",
        body: "Track pass sales, check-ins, and gate activity in one dashboard instead of counting cash, wristbands, and notes after the tournament."
      },
      {
        title: "Settle entry questions faster",
        body: "Keep a cleaner record of who bought, who checked in, and what pass they used so staff can resolve gate disputes quickly."
      }
    ],
    stats: [
      { value: "Live", label: "admissions view" },
      { value: "Fast", label: "gate check-in" },
      { value: "Clear", label: "revenue tracking" }
    ]
  },
  parents: {
    label: "Parent / Spectator",
    ctaLabel: "Join as Parent",
    eyebrow: "Built for families",
    title: "Get through the gate faster and get back to the game.",
    description:
      "TourniBase helps families buy, save, and show passes without hunting for cash, payment screenshots, or the right person at the gate.",
    earlyAccessTitle: "Join early access for smoother tournament entry.",
    benefitsTitle: "Keep tournament entry simple for the whole family.",
    benefitsIntro:
      "Parents care about convenience, savings, and getting to the court or field on time. TourniBase keeps the pass flow easy before and during the event.",
    role: "Parent / Spectator",
    source: "website-parents",
    mockup: "parents",
    quickBenefits: [
      "Save passes in one place before arriving",
      "Avoid cash lines and payment confusion",
      "Share pass details with relatives when needed"
    ],
    reasons: [
      {
        title: "Buy once and keep the pass ready",
        body: "Store day, weekend, or family passes in one place so entry is not buried in a text thread or payment app."
      },
      {
        title: "Avoid cash lines",
        body: "Use a digital pass at the gate instead of waiting while families sort out cash, Venmo screenshots, or wristbands."
      },
      {
        title: "Make family entry easier",
        body: "Keep pass details clear for parents, grandparents, or relatives who need to enter without another back-and-forth at the gate."
      }
    ],
    stats: [
      { value: "Simple", label: "mobile pass" },
      { value: "Unified", label: "payment processor" },
      { value: "Quick", label: "entry flow" }
    ]
  },
  coaches: {
    label: "Coach",
    ctaLabel: "Join as Coach",
    eyebrow: "Built for coaches",
    title: "Organize team entry before the first whistle.",
    description:
      "TourniBase helps coaches see who is ready for event access, which families still need passes, and what needs attention before the team arrives.",
    earlyAccessTitle: "Sign up for early access to prepare families for entry.",
    benefitsTitle: "Handle pass status before it turns into gate chaos.",
    benefitsIntro:
      "Coaches should not spend tournament mornings answering the same admission questions. TourniBase gives teams a clearer way to coordinate access.",
    role: "Coach",
    source: "website-coaches",
    mockup: "coaches",
    quickBenefits: [
      "Track player, coach, and family pass status",
      "Send reminders before tournament day",
      "Coordinate faster with gate staff and organizers"
    ],
    reasons: [
      {
        title: "Reduce admin work",
        body: "Import or organize your roster, see who is ready, and spend less time chasing families for pass questions."
      },
      {
        title: "Improve family communication",
        body: "Give parents a clearer pass path and send reminders before arrival instead of answering the same admission questions all weekend."
      },
      {
        title: "Coordinate with tournament staff",
        body: "Help organizers understand team access status so gate staff can move teams through without last-minute confusion."
      }
    ],
    stats: [
      { value: "Team", label: "access status" },
      { value: "Fewer", label: "entry questions" },
      { value: "Ready", label: "for arrival" }
    ]
  }
};

export function AudiencePage({ audience }: { audience: AudienceKey }) {
  const content = audienceContent[audience];
  const organizationLabel =
    audience === "organizers" ? "Organization" : "Organization or team";

  return (
    <main className="min-h-screen bg-white">
      <SiteHeader />

      <section className="bg-tournibase-gray">
        <div className="mx-auto grid max-w-6xl gap-10 px-5 pb-12 pt-8 lg:grid-cols-[0.9fr_1.1fr] lg:items-start lg:pb-16 lg:pt-10">
          <div>
            <p className="mb-5 inline-flex rounded-full border border-blue-100 bg-white px-3 py-1 text-sm font-semibold text-tournibase-blue">
              {content.eyebrow}
            </p>
            <h1 className="text-4xl font-bold leading-tight text-tournibase-navy sm:text-5xl lg:text-6xl">
              {content.title}
            </h1>
            <p className="mt-5 text-lg leading-8 text-slate-600">
              {content.description}
            </p>
            <ul className="mt-6 grid gap-2 text-sm font-semibold text-tournibase-navy">
              {content.quickBenefits.map((benefit) => (
                <li key={benefit} className="flex gap-2">
                  <span className="text-tournibase-blue">✓</span>
                  <span>{benefit}</span>
                </li>
              ))}
            </ul>
            <div className="mt-8 flex flex-col gap-3 sm:flex-row">
              <Link
                href="#waitlist"
                className="inline-flex h-12 items-center justify-center rounded-md bg-tournibase-blue px-6 text-base font-semibold text-white transition hover:bg-blue-700"
              >
                {content.ctaLabel}
              </Link>
              <Link
                href="/"
                className="inline-flex h-12 items-center justify-center rounded-md border border-tournibase-border bg-white px-6 text-base font-semibold text-tournibase-navy transition hover:border-blue-200 hover:text-tournibase-blue"
              >
                View other roles
              </Link>
            </div>
          </div>

          <ProductMockup type={content.mockup} />
        </div>
      </section>

      <section className="border-y border-tournibase-border bg-white">
        <div className="mx-auto grid max-w-6xl gap-4 px-5 py-10 sm:grid-cols-3">
          {content.stats.map((stat) => (
            <div
              key={stat.label}
              className="rounded-lg border border-tournibase-border bg-white p-5"
            >
              <p className="text-2xl font-bold text-tournibase-blue">
                {stat.value}
              </p>
              <p className="mt-1 text-sm font-medium text-slate-600">
                {stat.label}
              </p>
            </div>
          ))}
        </div>
      </section>

      <section className="bg-white px-5 py-10">
        <div className="mx-auto grid max-w-6xl gap-6 rounded-lg border border-tournibase-border bg-tournibase-gray p-6 md:grid-cols-[1fr_auto] md:items-center">
          <div>
            <p className="text-sm font-semibold uppercase tracking-[0.18em] text-tournibase-blue">
              Early access
            </p>
            <h2 className="mt-2 text-2xl font-bold text-tournibase-navy">
              {content.earlyAccessTitle}
            </h2>
            <p className="mt-3 max-w-3xl leading-7 text-slate-600">
              {content.benefitsIntro}
            </p>
          </div>
          <Link
            href="#waitlist"
            className="inline-flex h-12 items-center justify-center rounded-md bg-tournibase-blue px-6 text-base font-semibold text-white transition hover:bg-blue-700"
          >
            Join the waitlist
          </Link>
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-5 py-16">
        <div className="max-w-2xl">
          <p className="text-sm font-semibold uppercase tracking-[0.18em] text-tournibase-blue">
            Why it matters
          </p>
          <h2 className="mt-3 text-3xl font-bold text-tournibase-navy">
            {content.benefitsTitle}
          </h2>
        </div>
        <div className="mt-8 grid gap-4 md:grid-cols-3">
          {content.reasons.map((reason) => (
            <article
              key={reason.title}
              className="rounded-lg border border-tournibase-border bg-white p-5"
            >
              <h3 className="text-lg font-bold text-tournibase-navy">
                {reason.title}
              </h3>
              <p className="mt-3 leading-7 text-slate-600">{reason.body}</p>
            </article>
          ))}
        </div>
      </section>

      <section id="waitlist" className="bg-tournibase-navy px-5 py-16">
        <div className="mx-auto grid max-w-6xl gap-8 lg:grid-cols-[0.85fr_1.15fr] lg:items-start">
          <div className="text-white">
            <p className="text-sm font-semibold uppercase tracking-[0.18em] text-blue-300">
              Early access
            </p>
            <h2 className="mt-3 text-3xl font-bold">
              Join the waitlist as a {content.label}.
            </h2>
            <ul className="mt-6 grid gap-3 text-sm font-semibold text-white">
              {content.quickBenefits.map((benefit) => (
                <li key={benefit} className="flex gap-2">
                  <span className="text-blue-300">✓</span>
                  <span>{benefit}</span>
                </li>
              ))}
            </ul>
          </div>
          <WaitlistForm
            key={content.role}
            defaultRole={content.role}
            lockRole
            source={content.source}
            heading={`Join as a ${content.label}`}
            organizationLabel={organizationLabel}
          />
        </div>
      </section>

      <SiteFooter />
    </main>
  );
}
