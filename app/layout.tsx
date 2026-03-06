import type { Metadata } from "next";
import "./globals.css";
import { Navbar } from "@/features/users/components/Navbar";
import { SessionProvider } from "@/features/users/components/SessionProvider";

export const metadata: Metadata = {
  title: "Spark — Sports Platform",
  description:
    "Streamline activities and boost engagement with tournaments, e-commerce, and academy tools.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-gray-50 antialiased">
        <SessionProvider>
          <Navbar />
          <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">{children}</main>
        </SessionProvider>
      </body>
    </html>
  );
}
