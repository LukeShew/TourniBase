import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "TourniBase | Youth Sports Tournament Admission",
  description:
    "TourniBase is building unified admission, check-in, and revenue tools for youth sports tournaments.",
  openGraph: {
    title: "TourniBase",
    description:
      "A unified admission and check-in system for youth sports tournaments.",
    type: "website"
  }
};

export default function RootLayout({
  children
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="font-sans antialiased">{children}</body>
    </html>
  );
}
