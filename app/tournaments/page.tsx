import { prisma } from "@/lib/prisma";
import { TournamentCard } from "@/features/tournaments/components/TournamentCard";

export const dynamic = "force-dynamic";

export default async function TournamentsPage() {
  const tournaments = await prisma.tournament.findMany({
    orderBy: { startDate: "asc" },
    include: { _count: { select: { registrations: true } } },
  });

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Tournaments</h1>
        <p className="text-gray-500 mt-1">Find and join upcoming sports tournaments.</p>
      </div>

      {tournaments.length === 0 ? (
        <p className="text-gray-400 text-sm">No tournaments available yet. Check back soon!</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {tournaments.map((t) => (
            <TournamentCard key={t.id} tournament={t} registrationCount={t._count.registrations} />
          ))}
        </div>
      )}
    </div>
  );
}
