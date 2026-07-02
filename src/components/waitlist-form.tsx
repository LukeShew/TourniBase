"use client";

import { FormEvent, useMemo, useState } from "react";
import { hasSupabaseConfig, supabase } from "@/lib/supabase";

export const waitlistRoles = [
  "Parent / Spectator",
  "Tournament Director / Organizer",
  "Coach",
  "Other"
] as const;

export type WaitlistRole = (typeof waitlistRoles)[number];

type Status = "idle" | "loading" | "success" | "error";

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function WaitlistForm({
  defaultRole = waitlistRoles[0],
  lockRole = false,
  source = "website",
  heading = "Join the TourniBase waitlist",
  organizationLabel = "Organization or team"
}: {
  defaultRole?: WaitlistRole;
  lockRole?: boolean;
  source?: string;
  heading?: string;
  organizationLabel?: string;
}) {
  const [status, setStatus] = useState<Status>("idle");
  const [message, setMessage] = useState("");
  const [role, setRole] = useState<WaitlistRole>(defaultRole);
  const [email, setEmail] = useState("");
  const [name, setName] = useState("");
  const [organization, setOrganization] = useState("");
  const [notes, setNotes] = useState("");

  const isSubmitting = status === "loading";

  const helperText = useMemo(() => {
    if (status === "success") {
      return "You are on the TourniBase waitlist. We will reach out as the product opens up.";
    }

    if (message) {
      return message;
    }

    return "No spam. Just TourniBase updates and early access.";
  }, [message, status]);

  async function onSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setMessage("");

    const cleanEmail = email.trim().toLowerCase();

    if (!emailPattern.test(cleanEmail)) {
      setStatus("error");
      setMessage("Enter a valid email address.");
      return;
    }

    if (!role) {
      setStatus("error");
      setMessage("Choose the option that best describes you.");
      return;
    }

    if (!name.trim()) {
      setStatus("error");
      setMessage("Enter your name.");
      return;
    }

    if (!organization.trim()) {
      setStatus("error");
      setMessage(`Enter your ${organizationLabel.toLowerCase()}.`);
      return;
    }

    if (!hasSupabaseConfig || !supabase) {
      setStatus("error");
      setMessage(
        "TourniBase is not connected to Supabase yet. Add the public Supabase URL and anon key in .env.local."
      );
      return;
    }

    setStatus("loading");

    const { error } = await supabase.from("waitlist_signups").insert({
      email: cleanEmail,
      name: name.trim() || null,
      role,
      organization: organization.trim() || null,
      notes: notes.trim() || null,
      source
    });

    if (error) {
      setStatus("error");
      setMessage(
        error.code === "23505"
          ? "That email is already on the TourniBase waitlist."
          : "Something went wrong. Please try again."
      );
      return;
    }

    setStatus("success");
    setEmail("");
    setName("");
    setOrganization("");
    setNotes("");
  }

  return (
    <form
      onSubmit={onSubmit}
      className="rounded-lg border border-tournibase-border bg-white p-5 shadow-soft sm:p-6"
    >
      <div className="mb-5">
        <p className="text-sm font-semibold uppercase tracking-[0.18em] text-tournibase-blue">
          Early access
        </p>
        <h2 className="mt-2 text-2xl font-bold text-tournibase-navy">
          {heading}
        </h2>
      </div>

      {lockRole ? (
        <div className="mb-5 rounded-md border border-blue-100 bg-blue-50 px-3 py-2 text-sm font-semibold text-tournibase-blue">
          Signing up as: {role}
        </div>
      ) : (
        <fieldset className="mb-5">
          <legend className="mb-2 text-sm font-semibold text-slate-700">
            I am a
          </legend>
          <div className="grid grid-cols-1 gap-2 sm:grid-cols-2">
            {waitlistRoles.map((item) => (
              <label
                key={item}
                className={`flex cursor-pointer items-center rounded-md border px-3 py-2 text-sm font-medium transition ${
                  role === item
                    ? "border-tournibase-blue bg-blue-50 text-tournibase-blue"
                    : "border-tournibase-border bg-white text-slate-700 hover:border-blue-200"
                }`}
              >
                <input
                  type="radio"
                  name="role"
                  value={item}
                  checked={role === item}
                  onChange={() => setRole(item)}
                  className="sr-only"
                />
                {item}
              </label>
            ))}
          </div>
        </fieldset>
      )}

      <div className="grid gap-4">
        <label className="grid gap-1.5 text-sm font-medium text-slate-700">
          Email
          <input
            type="email"
            required
            value={email}
            onChange={(event) => setEmail(event.target.value)}
            placeholder="you@example.com"
            className="h-11 rounded-md border border-tournibase-border px-3 text-base text-tournibase-navy outline-none transition placeholder:text-slate-400 focus:border-tournibase-blue focus:ring-4 focus:ring-blue-100"
          />
        </label>

        <div className="grid gap-4 sm:grid-cols-2">
          <label className="grid gap-1.5 text-sm font-medium text-slate-700">
            Name
            <input
              type="text"
              required
              value={name}
              onChange={(event) => setName(event.target.value)}
              placeholder="Your name"
              className="h-11 rounded-md border border-tournibase-border px-3 text-base text-tournibase-navy outline-none transition placeholder:text-slate-400 focus:border-tournibase-blue focus:ring-4 focus:ring-blue-100"
            />
          </label>

          <label className="grid gap-1.5 text-sm font-medium text-slate-700">
            {organizationLabel}
            <input
              type="text"
              required
              value={organization}
              onChange={(event) => setOrganization(event.target.value)}
              placeholder={organizationLabel}
              className="h-11 rounded-md border border-tournibase-border px-3 text-base text-tournibase-navy outline-none transition placeholder:text-slate-400 focus:border-tournibase-blue focus:ring-4 focus:ring-blue-100"
            />
          </label>
        </div>

        <label className="grid gap-1.5 text-sm font-medium text-slate-700">
          Notes
          <textarea
            value={notes}
            onChange={(event) => setNotes(event.target.value)}
            placeholder="What should TourniBase help with?"
            rows={4}
            className="resize-none rounded-md border border-tournibase-border px-3 py-3 text-base text-tournibase-navy outline-none transition placeholder:text-slate-400 focus:border-tournibase-blue focus:ring-4 focus:ring-blue-100"
          />
        </label>
      </div>

      <button
        type="submit"
        disabled={isSubmitting}
        className="mt-5 h-12 w-full rounded-md bg-tournibase-blue px-5 text-base font-semibold text-white transition hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-blue-300"
      >
        {isSubmitting ? "Joining..." : "Join the TourniBase waitlist"}
      </button>

      <p
        className={`mt-3 text-sm ${
          status === "success"
            ? "text-emerald-700"
            : status === "error"
              ? "text-red-600"
              : "text-slate-500"
        }`}
        aria-live="polite"
      >
        {helperText}
      </p>
    </form>
  );
}
