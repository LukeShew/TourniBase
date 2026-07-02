import type { Metadata } from "next";
import { AudiencePage } from "@/components/audience-pages";

export const metadata: Metadata = {
  title: "TourniBase for Parents and Spectators",
  description:
    "See how TourniBase helps parents and spectators get through tournament admission faster."
};

export default function ParentsPage() {
  return <AudiencePage audience="parents" />;
}
