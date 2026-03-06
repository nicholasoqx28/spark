import { auth } from "@/lib/auth";
import { redirect } from "next/navigation";
import Link from "next/link";

export default async function DashboardPage() {
  const session = await auth();
  if (!session) redirect("/login");

  const { name, role } = session.user;

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Welcome, {name}</h1>
        <p className="text-gray-500 mt-1">
          You are signed in as <span className="font-medium">{role}</span>.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
        <DashCard
          icon="🏆"
          title="Tournaments"
          description="Browse upcoming events and manage your registrations."
          href="/tournaments"
        />
        <DashCard
          icon="🛒"
          title="Shop"
          description="Explore gear and track your orders."
          href="/shop"
        />
        <DashCard
          icon="🎓"
          title="Academy"
          description="Continue your training courses."
          href="/academy"
        />
        {role === "ADMIN" && (
          <DashCard
            icon="⚙️"
            title="Admin"
            description="Manage tournaments, products, and users."
            href="/admin"
          />
        )}
      </div>
    </div>
  );
}

function DashCard({
  icon,
  title,
  description,
  href,
}: {
  icon: string;
  title: string;
  description: string;
  href: string;
}) {
  return (
    <Link
      href={href}
      className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 flex flex-col gap-3 hover:shadow-md transition-shadow"
    >
      <span className="text-3xl">{icon}</span>
      <h2 className="font-bold text-gray-900">{title}</h2>
      <p className="text-sm text-gray-500">{description}</p>
    </Link>
  );
}
