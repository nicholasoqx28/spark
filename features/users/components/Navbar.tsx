"use client";

import Link from "next/link";
import { useSession, signOut } from "next-auth/react";
import { usePathname } from "next/navigation";

const navLinks = [
  { href: "/tournaments", label: "Tournaments" },
  { href: "/shop", label: "Shop" },
  { href: "/academy", label: "Academy" },
];

export function Navbar() {
  const { data: session } = useSession();
  const pathname = usePathname();

  return (
    <nav className="bg-white border-b border-gray-200 shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
        <Link href="/" className="text-2xl font-bold text-indigo-600">
          ⚡ Spark
        </Link>

        <div className="hidden sm:flex items-center gap-6">
          {navLinks.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              className={`text-sm font-medium transition-colors ${
                pathname.startsWith(href)
                  ? "text-indigo-600"
                  : "text-gray-600 hover:text-indigo-600"
              }`}
            >
              {label}
            </Link>
          ))}
        </div>

        <div className="flex items-center gap-3">
          {session ? (
            <>
              <span className="text-sm text-gray-500">
                {session.user.name}{" "}
                <span className="text-xs text-indigo-400">({session.user.role})</span>
              </span>
              {session.user.role === "ADMIN" && (
                <Link
                  href="/admin"
                  className="text-sm px-3 py-1 rounded-md bg-gray-100 hover:bg-gray-200 text-gray-700"
                >
                  Admin
                </Link>
              )}
              <button
                onClick={() => signOut({ callbackUrl: "/" })}
                className="text-sm px-3 py-1 rounded-md bg-red-50 hover:bg-red-100 text-red-600"
              >
                Sign out
              </button>
            </>
          ) : (
            <>
              <Link
                href="/login"
                className="text-sm font-medium text-gray-600 hover:text-indigo-600"
              >
                Log in
              </Link>
              <Link
                href="/register"
                className="text-sm px-4 py-2 rounded-md bg-indigo-600 text-white hover:bg-indigo-700"
              >
                Sign up
              </Link>
            </>
          )}
        </div>
      </div>
    </nav>
  );
}
