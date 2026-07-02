import type { Metadata } from "next";
import { AudiencePage } from "@/components/audience-pages";

export const metadata: Metadata = {
  title: "TourniBase for Tournament Directors",
  description:
    "See how TourniBase helps tournament directors manage admission, check-ins, and gate revenue."
};

export default function OrganizersPage() {
  return <AudiencePage audience="organizers" />;
}
