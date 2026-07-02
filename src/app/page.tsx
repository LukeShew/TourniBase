import Link from "next/link";
import { audienceContent, type AudienceKey } from "@/components/audience-pages";
import { SiteFooter, SiteHeader } from "@/components/site-shell";

const audienceOrder: AudienceKey[] = ["organizers", "parents", "coaches"];

const roleCardContent: Record<
  AudienceKey,
  {
    button: string;
    tagline: string;
    hint: string;
  }
> = {
  organizers: {
    button: "I'm a Director",
    tagline: "Sell and manage passes",
    hint: "Built for managers who need a clean dashboard to track all ticket sales and check-ins."
  },
  parents: {
    button: "I'm a Parent",
    tagline: "Buy and save passes",
    hint: "Built for families who want quicker check-in and all their payments in one place."
  },
  coaches: {
    button: "I'm a Coach",
    tagline: "Track team access",
    hint: "Built for coaches who need to know who is ready before arrival."
  }
};

export default function Home() {
  return (
    <main className="min-h-screen bg-white">
      <SiteHeader />

      <section id="choose-role" className="bg-tournibase-gray">
        <div className="mx-auto max-w-6xl px-5 py-8 lg:py-10">
          <div className="mx-auto max-w-3xl text-center">
            <h1 className="text-4xl font-bold leading-tight text-tournibase-navy lg:text-5xl">
              The unified admission system for youth tournaments.
            </h1>
            <p className="mt-4 text-lg leading-8 text-slate-600">
              TourniBase works differently depending on your role. Pick the
              position that best describes you to see how TourniBase can help.
            </p>
          </div>

          <div className="mx-auto mt-6 grid max-w-5xl gap-4 md:grid-cols-3">
            {audienceOrder.map((key) => (
              <AudienceCard key={key} audience={key} />
            ))}
          </div>
        </div>
      </section>

      <SiteFooter />
    </main>
  );
}

function AudienceCard({ audience }: { audience: AudienceKey }) {
  const content = audienceContent[audience];
  const card = roleCardContent[audience];

  return (
    <article className="flex min-h-[260px] flex-col rounded-lg border border-tournibase-border bg-white p-5 text-center shadow-soft">
      <div>
        <p className="flex min-h-10 items-center justify-center text-sm font-semibold uppercase tracking-[0.16em] text-tournibase-blue">
          {content.eyebrow}
        </p>
        <h3 className="mt-3 text-2xl font-bold text-tournibase-navy">
          {card.tagline}
        </h3>
        <p className="mx-auto mt-3 max-w-xs leading-7 text-slate-600">
          {card.hint}
        </p>
      </div>

      <div className="mt-auto pt-5">
        <Link
          href={`/${audience}`}
          className="inline-flex h-12 w-full items-center justify-center rounded-md bg-tournibase-blue px-5 text-base font-semibold text-white transition hover:bg-blue-700"
        >
          {card.button}
        </Link>
      </div>
    </article>
  );
}
