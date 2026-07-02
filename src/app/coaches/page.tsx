import type { Metadata } from "next";
import { AudiencePage } from "@/components/audience-pages";

export const metadata: Metadata = {
  title: "TourniBase for Coaches",
  description:
    "See how TourniBase helps coaches keep team access and tournament entry organized."
};

export default function CoachesPage() {
  return <AudiencePage audience="coaches" />;
}
