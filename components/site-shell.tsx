import Image from "next/image";
import Link from "next/link";
import fanpassLogo from "@/Refreshed logos/fanpass-full-color-horizontal-cropped.png";

export function SiteHeader({
  waitlistHref = "/organizers#waitlist",
  showWaitlistButton = true
}: {
  waitlistHref?: string;
  showWaitlistButton?: boolean;
}) {
  return (
    <header className="border-b border-fanpass-border bg-white">
      <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-5 py-4">
        <SiteLogo priority />
        <nav className="hidden items-center gap-5 text-sm font-semibold text-slate-600 md:flex">
          <Link className="hover:text-fanpass-blue" href="/organizers">
            Directors
          </Link>
          <Link className="hover:text-fanpass-blue" href="/parents">
            Parents
          </Link>
          <Link className="hover:text-fanpass-blue" href="/coaches">
            Coaches
          </Link>
        </nav>
        {showWaitlistButton ? (
          <Link
            href={waitlistHref}
            className="inline-flex h-11 items-center justify-center rounded-md border border-fanpass-border px-4 text-sm font-semibold text-fanpass-navy transition hover:border-fanpass-blue hover:text-fanpass-blue"
          >
            Join waitlist
          </Link>
        ) : null}
      </div>
    </header>
  );
}

export function SiteFooter() {
  return (
    <footer className="border-t border-fanpass-border bg-white">
      <div className="mx-auto flex max-w-6xl flex-col gap-4 px-5 py-8 text-sm text-slate-600 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <div className="mb-3">
            <SiteLogo size="small" />
          </div>
          <p>
            Questions? Contact the FanPass team at{" "}
            <a
              className="font-semibold text-fanpass-blue hover:text-blue-700"
              href="mailto:lsautomates@gmail.com"
            >
              lsautomates@gmail.com
            </a>
            .
          </p>
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
      aria-label="FanPass home"
    >
      <Image
        src={fanpassLogo}
        alt="FanPass"
        priority={priority}
        className={
          size === "small"
            ? "h-8 w-auto rounded-sm"
            : "h-10 w-auto rounded-sm sm:h-11"
        }
      />
    </Link>
  );
}
