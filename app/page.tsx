import Link from "next/link";

const features = [
  {
    icon: "🏆",
    title: "Tournaments",
    description: "Browse and join sports tournaments. Track brackets, standings, and registrations.",
    href: "/tournaments",
    cta: "View Tournaments",
  },
  {
    icon: "🛒",
    title: "Shop",
    description: "Equipment, apparel, and accessories — everything you need to compete.",
    href: "/shop",
    cta: "Shop Now",
  },
  {
    icon: "🎓",
    title: "Academy",
    description: "Courses and training plans built by coaches to sharpen your skills.",
    href: "/academy",
    cta: "Start Learning",
  },
];

export default function HomePage() {
  return (
    <div className="space-y-16">
      {/* Hero */}
      <section className="text-center py-16">
        <h1 className="text-5xl font-extrabold text-gray-900 mb-4">
          ⚡ <span className="text-indigo-600">Spark</span> your game
        </h1>
        <p className="text-xl text-gray-500 max-w-2xl mx-auto mb-8">
          The all-in-one sports platform for enthusiasts, athletes, and organisers. Join
          tournaments, gear up, and train smarter.
        </p>
        <div className="flex justify-center gap-4">
          <Link
            href="/register"
            className="px-6 py-3 rounded-lg bg-indigo-600 text-white font-semibold hover:bg-indigo-700 transition-colors"
          >
            Get started free
          </Link>
          <Link
            href="/tournaments"
            className="px-6 py-3 rounded-lg border border-gray-300 text-gray-700 font-semibold hover:bg-gray-100 transition-colors"
          >
            Browse tournaments
          </Link>
        </div>
      </section>

      {/* Feature cards */}
      <section className="grid grid-cols-1 sm:grid-cols-3 gap-6">
        {features.map(({ icon, title, description, href, cta }) => (
          <div
            key={title}
            className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 flex flex-col gap-4 hover:shadow-md transition-shadow"
          >
            <span className="text-4xl">{icon}</span>
            <h2 className="text-xl font-bold text-gray-900">{title}</h2>
            <p className="text-gray-500 text-sm flex-1">{description}</p>
            <Link
              href={href}
              className="inline-block text-sm font-semibold text-indigo-600 hover:underline"
            >
              {cta} →
            </Link>
          </div>
        ))}
      </section>
    </div>
  );
}
