import Image from "next/image";
import Link from "next/link";
import tournibaseLogo from "@/TourniBase logos/tournibase-transparent-logo-lockup.png";

export function SiteHeader() {
  return (
    <header className="border-b border-tournibase-border bg-white">
      <div className="mx-auto grid max-w-6xl grid-cols-[1fr_auto_1fr] items-center gap-4 px-5 py-4">
        <div className="justify-self-start">
          <SiteLogo priority />
        </div>
        <nav className="hidden items-center justify-self-center gap-5 text-sm font-semibold text-slate-600 md:flex">
          <Link className="hover:text-tournibase-blue" href="/organizers">
            Directors
          </Link>
          <Link className="hover:text-tournibase-blue" href="/parents">
            Parents
          </Link>
          <Link className="hover:text-tournibase-blue" href="/coaches">
            Coaches
          </Link>
        </nav>
        <a
          href="mailto:lsautomates@gmail.com"
          className="inline-flex h-11 items-center justify-center justify-self-end rounded-md border border-tournibase-border px-4 text-sm font-semibold text-tournibase-navy transition hover:border-tournibase-blue hover:text-tournibase-blue"
        >
          Contact us
        </a>
      </div>
    </header>
  );
}

export function SiteFooter() {
  return (
    <footer className="border-t border-tournibase-border bg-white">
      <div className="mx-auto flex max-w-6xl flex-col gap-4 px-5 py-8 text-sm text-slate-600 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <div className="mb-3">
            <SiteLogo size="small" />
          </div>
          <p>
            Questions? Contact the TourniBase team at{" "}
            <a
              className="font-semibold text-tournibase-blue hover:text-blue-700"
              href="mailto:lsautomates@gmail.com"
            >
              lsautomates@gmail.com
            </a>
            .
          </p>
        </div>
        <nav className="flex gap-4">
          <Link className="hover:text-tournibase-blue" href="/privacy">
            Privacy
          </Link>
          <Link className="hover:text-tournibase-blue" href="/terms">
            Terms
          </Link>
        </nav>
      </div>
    </footer>
  );
}

export function SiteLogo({
  priority = false,
  size = "default"
}: {
  priority?: boolean;
  size?: "default" | "small";
}) {
  return (
    <Link
      href="/"
      className="inline-flex items-center"
      aria-label="TourniBase home"
    >
      <Image
        src={tournibaseLogo}
        alt="TourniBase"
        priority={priority}
        className={
          size === "small"
            ? "h-12 w-auto rounded-sm"
            : "h-16 w-auto rounded-sm sm:h-20"
        }
      />
    </Link>
  );
}
