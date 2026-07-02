import Image from "next/image";
import type { ReactNode } from "react";
import tournibaseLogoLockup from "@/TourniBase logos/tournibase-transparent-logo-lockup.png";

type MockupType = "organizers" | "parents" | "coaches";

export function ProductMockup({ type }: { type: MockupType }) {
  if (type === "parents") {
    return <ParentPassMockup />;
  }

  if (type === "coaches") {
    return <CoachMockup />;
  }

  return <OrganizerDashboardMockup />;
}

function OrganizerDashboardMockup() {
  return (
    <TabletFrame>
      <div className="rounded-lg border border-tournibase-border bg-white p-4 shadow-soft">
        <div className="mb-4 flex items-center justify-between">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-tournibase-blue">
              Gate dashboard
            </p>
            <h3 className="mt-1 text-xl font-bold text-tournibase-navy">
              North Entrance
            </h3>
          </div>
          <div className="rounded-md bg-emerald-50 px-3 py-1 text-sm font-bold text-emerald-700">
            Live
          </div>
        </div>

        <div className="grid gap-3 sm:grid-cols-3">
          <Metric label="Today's revenue" value="$8,420" />
          <Metric label="Checked in" value="612" />
          <Metric label="Passes sold" value="738" />
        </div>

            <div className="mt-4 grid gap-4 md:grid-cols-[1.1fr_0.9fr]">
              <div className="rounded-lg border border-tournibase-border p-4">
                <div className="mb-3 flex items-center justify-between">
                  <p className="font-bold text-tournibase-navy">Entry pace</p>
                  <p className="text-sm font-semibold text-slate-500">
                    Last hour
                  </p>
                </div>
                <div className="flex h-36 items-end gap-2">
                  {[38, 62, 49, 84, 72, 96, 65].map((height, index) => (
                    <div
                      key={index}
                      className="flex-1 rounded-t bg-tournibase-blue"
                      style={{ height: `${height}%` }}
                    />
                  ))}
                </div>
              </div>

              <div className="rounded-lg border border-tournibase-border p-4">
                <p className="mb-3 font-bold text-tournibase-navy">Gate lanes</p>
                <CheckInRow name="North Gate" time="284 checked in" />
                <CheckInRow name="South Gate" time="196 checked in" />
                <CheckInRow name="Court 4 Entry" time="132 checked in" />
                <CheckInRow name="Manual reviews" time="8 pending" />
              </div>
            </div>

            <div className="mt-4 rounded-lg border border-tournibase-border p-4">
              <p className="mb-3 font-bold text-tournibase-navy">Recent sales</p>
              <CheckInRow name="Weekend family pass" time="$45.00" />
              <CheckInRow name="Adult day pass" time="$18.00" />
              <CheckInRow name="Team coach pass" time="$0.00" />
            </div>
      </div>
    </TabletFrame>
  );
}

function ParentPassMockup() {
  return (
    <div className="rounded-lg border border-tournibase-border bg-white px-4 py-6 shadow-soft">
      <div className="relative mx-auto w-full max-w-[330px]">
        <div className="absolute -left-1.5 top-28 h-12 w-1 rounded-l bg-slate-500" />
        <div className="absolute -left-1.5 top-44 h-12 w-1 rounded-l bg-slate-500" />
        <div className="absolute -right-1.5 top-36 h-20 w-1 rounded-r bg-slate-500" />

        <div className="rounded-[46px] border-[7px] border-slate-950 bg-slate-950 p-2 shadow-[0_30px_90px_rgba(15,23,42,0.18)]">
          <div className="relative overflow-hidden rounded-[36px] bg-white">
            <div className="absolute left-1/2 top-2 z-20 h-8 w-28 -translate-x-1/2 rounded-full bg-black">
              <div className="absolute right-5 top-2.5 h-2.5 w-2.5 rounded-full bg-slate-800 ring-1 ring-slate-700" />
            </div>

            <div className="flex h-[660px] flex-col bg-white px-5 pb-5 pt-4">
              <div className="mb-4 grid grid-cols-[1fr_112px_1fr] items-center text-xs font-bold text-tournibase-navy">
                <span className="-translate-x-1 justify-self-center text-sm">
                  9:41
                </span>
                <span aria-hidden="true" />
                <div className="flex items-center gap-1.5 justify-self-center">
                  <div className="flex h-3.5 w-[18px] items-end gap-0.5">
                    <span className="h-1.5 w-1 rounded-[1px] bg-tournibase-navy" />
                    <span className="h-2 w-1 rounded-[1px] bg-tournibase-navy" />
                    <span className="h-2.5 w-1 rounded-[1px] bg-tournibase-navy" />
                    <span className="h-3 w-1 rounded-[1px] bg-tournibase-navy" />
                  </div>
                  <div className="flex translate-x-0.5 translate-y-px items-center">
                    <div className="h-2.5 w-[18px] rounded-[3px] border border-tournibase-navy p-px">
                      <div className="h-full w-full rounded-[1.5px] bg-tournibase-navy" />
                    </div>
                    <span className="h-1.5 w-0.5 rounded-r-sm bg-tournibase-navy" />
                  </div>
                </div>
              </div>

              <div className="mb-3 flex items-center justify-between">
                <div className="relative -ml-3 h-12 w-48">
                  <Image
                    src={tournibaseLogoLockup}
                    alt="TourniBase"
                    fill
                    sizes="192px"
                    className="scale-[1.35] object-contain"
                  />
                </div>

                <div
                  className="grid h-9 w-9 place-items-center rounded-full text-tournibase-navy"
                  aria-hidden="true"
                >
                  <svg
                    aria-hidden="true"
                    className="h-5 w-5"
                    fill="none"
                    viewBox="0 0 24 24"
                  >
                    <path
                      d="M18 8.6a6 6 0 0 0-12 0c0 7.1-2.4 7.8-2.4 7.8h16.8S18 15.7 18 8.6Z"
                      stroke="currentColor"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                    />
                    <path
                      d="M14 20a2.3 2.3 0 0 1-4 0"
                      stroke="currentColor"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                    />
                  </svg>
                </div>
              </div>

              <div className="rounded-2xl bg-tournibase-blue p-5 text-white shadow-[0_18px_45px_rgba(37,99,235,0.28)]">
                <p className="text-2xl font-bold leading-none">Weekend Pass</p>
                <p className="mt-2 text-sm font-semibold text-blue-100">
                  June 14 - June 16, 2026
                </p>

                <div className="mx-auto mt-5 grid aspect-square w-40 grid-cols-7 gap-1 rounded-xl bg-white p-3 shadow-inner">
                  {[
                    1, 1, 0, 1, 0, 1, 1,
                    0, 1, 1, 0, 1, 1, 0,
                    1, 0, 1, 1, 1, 0, 1,
                    1, 1, 0, 1, 0, 1, 0,
                    0, 1, 1, 1, 0, 0, 1,
                    1, 0, 0, 1, 1, 0, 1,
                    1, 1, 0, 0, 1, 1, 0
                  ].map((filled, index) => (
                    <span
                      key={index}
                      className={
                        filled
                          ? "rounded-sm bg-tournibase-navy"
                          : "rounded-sm bg-white"
                      }
                    />
                  ))}
                </div>

                <div className="mt-5 text-center">
                  <h3 className="text-2xl font-bold">John Smith</h3>
                  <p className="mt-1 text-xs font-semibold text-blue-100">
                    Pass ID: 7F34-A2B9-8C1D
                  </p>
                </div>
              </div>

              <div className="mt-3 grid grid-cols-2 gap-3">
                <PhoneInfoTile label="Status" value="Paid" />
                <PhoneInfoTile label="Entrance" value="South doors" />
              </div>

              <div className="mt-3 rounded-xl border border-tournibase-border bg-white shadow-sm">
                <PassActionRow label="Next pass" />
              </div>

              <div
                className="mx-auto mt-auto mb-0.5 h-1.5 w-28 translate-y-2 rounded-full bg-slate-400/45"
                aria-hidden="true"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function PhoneInfoTile({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-xl border border-tournibase-border bg-white p-3">
      <p className="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-500">
        {label}
      </p>
      <p className="mt-1 text-lg font-bold leading-tight text-tournibase-navy">
        {value}
      </p>
    </div>
  );
}

function PassActionRow({ label }: { label: string }) {
  return (
    <div className="flex items-center justify-between px-4 py-3.5">
      <p className="text-sm font-semibold text-tournibase-navy">{label}</p>
      <span aria-hidden="true" className="text-sm font-bold text-slate-400">
        ›
      </span>
    </div>
  );
}

function CoachMockup() {
  return (
    <TabletFrame>
      <div className="rounded-lg border border-tournibase-border bg-white p-4 shadow-soft">
        <div className="mb-4 flex items-center justify-between">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-tournibase-blue">
              Team access
            </p>
            <h3 className="mt-1 text-xl font-bold text-tournibase-navy">
              14U Blue Roster
            </h3>
          </div>
          <div className="rounded-md bg-blue-50 px-3 py-1 text-sm font-bold text-tournibase-blue">
            2 checked in
          </div>
        </div>

            <div className="grid gap-3 sm:grid-cols-3">
              <Metric label="Players" value="12" />
              <Metric label="Coaches" value="3" />
              <Metric label="Families" value="18" />
            </div>

            <div className="mt-4 rounded-lg border border-tournibase-border p-4">
              <p className="mb-3 font-bold text-tournibase-navy">
                Arrival status
              </p>
              <TeamRow name="M. Carter" status="Checked in" statusColor="green" />
              <TeamRow
                name="A. Johnson"
                status="Checked in"
                statusColor="green"
              />
              <TeamRow
                name="T. Williams"
                status="Has pass, not checked in"
                statusColor="yellow"
              />
              <TeamRow
                name="R. Davis"
                status="Has not registered"
                statusColor="red"
              />
            </div>
            <div className="mt-4 grid gap-3 sm:grid-cols-2">
              <div className="rounded-lg border border-blue-100 bg-blue-50 p-3">
                <p className="text-sm font-bold text-tournibase-blue">
                  Next action
                </p>
                <p className="mt-1 text-sm leading-6 text-slate-600">
                  Send reminders to 4 families before arrival.
                </p>
              </div>
              <div className="rounded-lg border border-emerald-100 bg-emerald-50 p-3">
                <p className="text-sm font-bold text-emerald-700">
                  Organizer view
                </p>
                <p className="mt-1 text-sm leading-6 text-slate-600">
                  Team access status is visible at the gate.
                </p>
              </div>
            </div>
      </div>
    </TabletFrame>
  );
}

function TabletFrame({ children }: { children: ReactNode }) {
  return (
    <div className="relative mx-auto w-full max-w-[680px]">
      <div
        className="absolute right-9 -top-1.5 h-1 w-10 rounded-t bg-slate-500"
        aria-hidden="true"
      />
      <div
        className="absolute -right-1.5 top-16 h-12 w-1 rounded-r bg-slate-500"
        aria-hidden="true"
      />
      <div
        className="absolute -right-1.5 top-32 h-12 w-1 rounded-r bg-slate-500"
        aria-hidden="true"
      />
      <div className="rounded-[34px] border-[9px] border-slate-950 bg-slate-950 p-2 shadow-[0_30px_90px_rgba(15,23,42,0.18)]">
        <div className="relative flex min-h-[520px] flex-col overflow-hidden rounded-[24px] bg-white p-4">
          {children}
          <div
            className="mx-auto mt-4 h-1.5 w-32 rounded-full bg-slate-400/45"
            aria-hidden="true"
          />
        </div>
      </div>
    </div>
  );
}

function Metric({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-lg border border-tournibase-border bg-white p-3">
      <p className="text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">
        {label}
      </p>
      <p className="mt-1 text-xl font-bold text-tournibase-navy">{value}</p>
    </div>
  );
}

function CheckInRow({ name, time }: { name: string; time: string }) {
  return (
    <div className="flex items-center justify-between border-t border-tournibase-border py-2 first:border-t-0 first:pt-0">
      <p className="text-sm font-semibold text-tournibase-navy">{name}</p>
      <p className="text-xs font-medium text-slate-500">{time}</p>
    </div>
  );
}

function TeamRow({
  name,
  status,
  statusColor
}: {
  name: string;
  status: string;
  statusColor: "green" | "yellow" | "red";
}) {
  const dotColor = {
    green: "bg-emerald-500",
    yellow: "bg-amber-400",
    red: "bg-red-500"
  }[statusColor];

  return (
    <div className="flex items-center justify-between border-t border-tournibase-border py-3 first:border-t-0 first:pt-0">
      <div>
        <p className="font-semibold text-tournibase-navy">{name}</p>
        <p className="text-sm text-slate-500">{status}</p>
      </div>
      <div
        className={`h-3 w-3 rounded-full ${dotColor}`}
      />
    </div>
  );
}
