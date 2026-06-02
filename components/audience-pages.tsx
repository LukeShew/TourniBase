import Link from "next/link";
import { ProductMockup } from "@/components/product-mockups";
import { SiteFooter, SiteHeader } from "@/components/site-shell";
import { WaitlistForm, type WaitlistRole } from "@/components/waitlist-form";

export type AudienceKey = "organizers" | "parents" | "coaches";

type AudienceContent = {
  label: string;
  eyebrow: string;
  title: string;
  description: string;
  role: WaitlistRole;
  source: string;
  mockup: AudienceKey;
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
    eyebrow: "Built for tournament directors",
    title: "Run admissions without guessing what happened at the gate.",
    description:
      "FanPass gives tournament directors a cleaner way to sell passes, check people in, and see admission activity while the event is still moving.",
    role: "Tournament Director / Organizer",
    source: "website-organizers",
    mockup: "organizers",
    reasons: [
      {
        title: "See gate activity live",
        body: "Track revenue, pass sales, and check-ins from one place instead of piecing it together after the event."
      },
      {
        title: "Speed up entry",
        body: "Give staff a simple check-in flow so families are not stuck while someone sorts out payment."
      },
      {
        title: "Reduce manual cleanup",
        body: "Replace wristband counts, screenshots, and loose cash notes with a cleaner admission record."
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
    eyebrow: "Built for families",
    title: "Get through the gate faster and get back to the game.",
    description:
      "FanPass is built so parents and spectators can buy or show a pass quickly without hunting for cash, screenshots, or the right person at the gate.",
    role: "Parent / Spectator",
    source: "website-parents",
    mockup: "parents",
    reasons: [
      {
        title: "Keep passes easy to find",
        body: "Use one clear pass instead of digging through texts, payment apps, or paper wristbands."
      },
      {
        title: "Spend less time in line",
        body: "Show the pass, get checked in, and move on without a long payment conversation."
      },
      {
        title: "Know what you bought",
        body: "Weekend, day, and family passes can be shown clearly before arriving at the gate."
      }
    ],
    stats: [
      { value: "Simple", label: "mobile pass" },
      { value: "Quick", label: "entry flow" },
      { value: "Less", label: "gate confusion" }
    ]
  },
  coaches: {
    label: "Coach",
    eyebrow: "Built for coaches",
    title: "Keep team entry organized before the first whistle.",
    description:
      "FanPass helps coaches understand who is ready for event access, where passes stand, and what still needs attention before the team arrives.",
    role: "Coach",
    source: "website-coaches",
    mockup: "coaches",
    reasons: [
      {
        title: "Know who is ready",
        body: "See which players, coaches, and families have passes before the team hits the gate."
      },
      {
        title: "Cut down on back-and-forth",
        body: "Give families a cleaner pass flow instead of answering the same admission questions all weekend."
      },
      {
        title: "Coordinate with organizers",
        body: "Keep team access clearer for the people running admissions and the people arriving together."
      }
    ],
    stats: [
      { value: "Team", label: "access status" },
      { value: "Fewer", label: "entry questions" },
      { value: "Ready", label: "arrival view" }
    ]
  }
};

export function AudiencePage({ audience }: { audience: AudienceKey }) {
  const content = audienceContent[audience];

  return (
    <main className="min-h-screen bg-white">
      <SiteHeader />

      <section className="bg-fanpass-gray">
        <div className="mx-auto grid max-w-6xl gap-10 px-5 py-14 lg:grid-cols-[0.95fr_1.05fr] lg:items-center lg:py-20">
          <div>
            <p className="mb-5 inline-flex rounded-full border border-blue-100 bg-white px-3 py-1 text-sm font-semibold text-fanpass-blue">
              {content.eyebrow}
            </p>
            <h1 className="text-4xl font-bold leading-tight text-fanpass-navy sm:text-5xl lg:text-6xl">
              {content.title}
            </h1>
            <p className="mt-5 text-lg leading-8 text-slate-600">
              {content.description}
            </p>
            <div className="mt-8 flex flex-col gap-3 sm:flex-row">
              <Link
                href="#waitlist"
                className="inline-flex h-12 items-center justify-center rounded-md bg-fanpass-blue px-6 text-base font-semibold text-white transition hover:bg-blue-700"
              >
                Join as {content.label}
              </Link>
              <Link
                href="/"
                className="inline-flex h-12 items-center justify-center rounded-md border border-fanpass-border bg-white px-6 text-base font-semibold text-fanpass-navy transition hover:border-blue-200 hover:text-fanpass-blue"
              >
                View other roles
              </Link>
            </div>
          </div>

          <ProductMockup type={content.mockup} />
        </div>
      </section>

      <section className="border-y border-fanpass-border bg-white">
        <div className="mx-auto grid max-w-6xl gap-4 px-5 py-10 sm:grid-cols-3">
          {content.stats.map((stat) => (
            <div
              key={stat.label}
              className="rounded-lg border border-fanpass-border bg-white p-5"
            >
              <p className="text-2xl font-bold text-fanpass-blue">
                {stat.value}
              </p>
              <p className="mt-1 text-sm font-medium text-slate-600">
                {stat.label}
              </p>
            </div>
          ))}
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-5 py-16">
        <div className="max-w-2xl">
          <p className="text-sm font-semibold uppercase tracking-[0.18em] text-fanpass-blue">
            Why it matters
          </p>
          <h2 className="mt-3 text-3xl font-bold text-fanpass-navy">
            FanPass is shaped around this job, not a generic signup page.
          </h2>
        </div>
        <div className="mt-8 grid gap-4 md:grid-cols-3">
          {content.reasons.map((reason) => (
            <article
              key={reason.title}
              className="rounded-lg border border-fanpass-border bg-white p-5"
            >
              <h3 className="text-lg font-bold text-fanpass-navy">
                {reason.title}
              </h3>
              <p className="mt-3 leading-7 text-slate-600">{reason.body}</p>
            </article>
          ))}
        </div>
      </section>

      <section id="waitlist" className="bg-fanpass-navy px-5 py-16">
        <div className="mx-auto grid max-w-6xl gap-8 lg:grid-cols-[0.85fr_1.15fr] lg:items-start">
          <div className="text-white">
            <p className="text-sm font-semibold uppercase tracking-[0.18em] text-blue-300">
              Early access
            </p>
            <h2 className="mt-3 text-3xl font-bold">
              Join the waitlist as a {content.label}.
            </h2>
            <p className="mt-4 leading-7 text-slate-300">
              This signs you up under the right audience so FanPass can send
              updates that match how you would use the product.
            </p>
          </div>
          <WaitlistForm
            key={content.role}
            defaultRole={content.role}
            lockRole
            source={content.source}
            heading={`Join as a ${content.label}`}
          />
        </div>
      </section>

      <SiteFooter />
    </main>
  );
}
