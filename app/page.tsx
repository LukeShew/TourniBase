import Image from "next/image";
import Link from "next/link";
import { WaitlistForm } from "@/components/waitlist-form";
import fanpassLogo from "@/Refreshed logos/fanpass-full-color-horizontal.png";

const problemCards = [
  {
    title: "Cash slows the gate down",
    body: "Long lines, unclear totals, and last-minute payment issues make tournament entry harder than it needs to be."
  },
  {
    title: "Wristbands are hard to track",
    body: "Organizers need a cleaner way to know who paid, who checked in, and what happened at each entrance."
  },
  {
    title: "Revenue needs one source of truth",
    body: "FanPass is built to help directors see admission activity without digging through screenshots and spreadsheets."
  }
];

export default function Home() {
  return (
    <main className="min-h-screen bg-white">
      <header className="border-b border-fanpass-border bg-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-5 py-4">
          <Logo priority />
          <a
            href="#waitlist"
            className="rounded-md border border-fanpass-border px-4 py-2 text-sm font-semibold text-fanpass-navy transition hover:border-fanpass-blue hover:text-fanpass-blue"
          >
            Join waitlist
          </a>
        </div>
      </header>

      <section className="bg-fanpass-gray">
        <div className="mx-auto grid max-w-6xl gap-10 px-5 py-14 lg:grid-cols-[1.05fr_0.95fr] lg:items-center lg:py-20">
          <div>
            <div className="mb-6 inline-flex items-center rounded-full border border-blue-100 bg-white px-3 py-1 text-sm font-semibold text-fanpass-blue">
              Built for youth sports tournaments
            </div>
            <h1 className="max-w-3xl text-4xl font-bold leading-tight text-fanpass-navy sm:text-5xl lg:text-6xl">
              Tournament admission should not be a guessing game.
            </h1>
            <p className="mt-5 max-w-2xl text-lg leading-8 text-slate-600">
              FanPass is building a unified admission and check-in system for
              youth sports tournaments, helping families enter faster and
              helping organizers manage gate revenue with less chaos.
            </p>
            <div className="mt-8 flex flex-col gap-3 sm:flex-row">
              <a
                href="#waitlist"
                className="inline-flex h-12 items-center justify-center rounded-md bg-fanpass-blue px-6 text-base font-semibold text-white transition hover:bg-blue-700"
              >
                Join the waitlist
              </a>
              <a
                href="#directors"
                className="inline-flex h-12 items-center justify-center rounded-md border border-fanpass-border bg-white px-6 text-base font-semibold text-fanpass-navy transition hover:border-blue-200 hover:text-fanpass-blue"
              >
                For organizers
              </a>
            </div>
          </div>

          <div id="waitlist">
            <WaitlistForm />
          </div>
        </div>
      </section>

      <section className="border-y border-fanpass-border bg-white">
        <div className="mx-auto grid max-w-6xl gap-4 px-5 py-10 sm:grid-cols-3">
          <Stat value="Faster" label="entry at the gate" />
          <Stat value="Cleaner" label="check-in flow" />
          <Stat value="Clearer" label="revenue visibility" />
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-5 py-16">
        <div className="max-w-2xl">
          <p className="text-sm font-semibold uppercase tracking-[0.18em] text-fanpass-blue">
            The problem
          </p>
          <h2 className="mt-3 text-3xl font-bold text-fanpass-navy">
            Tournament gates are still running on too many loose parts.
          </h2>
        </div>
        <div className="mt-8 grid gap-4 md:grid-cols-3">
          {problemCards.map((card) => (
            <article
              key={card.title}
              className="rounded-lg border border-fanpass-border bg-white p-5"
            >
              <h3 className="text-lg font-bold text-fanpass-navy">
                {card.title}
              </h3>
              <p className="mt-3 leading-7 text-slate-600">{card.body}</p>
            </article>
          ))}
        </div>
      </section>

      <section className="bg-fanpass-navy text-white">
        <div className="mx-auto grid max-w-6xl gap-8 px-5 py-16 md:grid-cols-2">
          <article id="parents" className="rounded-lg border border-white/10 p-6">
            <p className="text-sm font-semibold uppercase tracking-[0.18em] text-blue-300">
              For parents
            </p>
            <h2 className="mt-3 text-3xl font-bold">Get in and get to the game.</h2>
            <p className="mt-4 leading-7 text-slate-300">
              FanPass is being built so families can buy or show a pass, check
              in faster, and spend less time sorting out payment at the gate.
            </p>
          </article>

          <article
            id="directors"
            className="rounded-lg border border-white/10 p-6"
          >
            <p className="text-sm font-semibold uppercase tracking-[0.18em] text-blue-300">
              For tournament directors
            </p>
            <h2 className="mt-3 text-3xl font-bold">Know what happened at the gate.</h2>
            <p className="mt-4 leading-7 text-slate-300">
              FanPass will help organizers replace cash piles, Venmo checks,
              wristband counts, and manual spreadsheets with one admission flow.
            </p>
          </article>
        </div>
      </section>

      <footer className="bg-white">
        <div className="mx-auto flex max-w-6xl flex-col gap-4 px-5 py-8 text-sm text-slate-600 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <div className="mb-3">
              <Logo size="small" />
            </div>
            <p>Questions? Contact the FanPass team.</p>
          </div>
          <nav className="flex gap-4">
            <Link className="hover:text-fanpass-blue" href="/privacy">
              Privacy
            </Link>
            <Link className="hover:text-fanpass-blue" href="/terms">
              Terms
            </Link>
          </nav>
        </div>
      </footer>
    </main>
  );
}

function Logo({
  priority = false,
  size = "default"
}: {
  priority?: boolean;
  size?: "default" | "small";
}) {
  return (
    <div className="flex items-center gap-2.5" aria-label="FanPass">
      <Image
        src={fanpassLogo}
        alt="FanPass"
        priority={priority}
        className={size === "small" ? "h-8 w-auto" : "h-10 w-auto"}
      />
    </div>
  );
}

function Stat({ value, label }: { value: string; label: string }) {
  return (
    <div className="rounded-lg border border-fanpass-border bg-white p-5">
      <p className="text-2xl font-bold text-fanpass-blue">{value}</p>
      <p className="mt-1 text-sm font-medium text-slate-600">{label}</p>
    </div>
  );
}
