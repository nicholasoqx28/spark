import type { Tournament } from "@/app/generated/prisma/client";

interface Props {
  tournament: Tournament;
  registrationCount: number;
}

const statusColors: Record<string, string> = {
  UPCOMING: "bg-blue-100 text-blue-700",
  ONGOING: "bg-green-100 text-green-700",
  COMPLETED: "bg-gray-100 text-gray-600",
  CANCELLED: "bg-red-100 text-red-600",
};

export function TournamentCard({ tournament, registrationCount }: Props) {
  const { title, sport, location, startDate, endDate, maxTeams, status } = tournament;
  const start = new Date(startDate).toLocaleDateString();
  const end = new Date(endDate).toLocaleDateString();

  return (
    <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 flex flex-col gap-3 hover:shadow-md transition-shadow">
      <div className="flex items-start justify-between gap-2">
        <h2 className="font-bold text-gray-900 text-lg leading-tight">{title}</h2>
        <span className={`text-xs font-semibold px-2 py-1 rounded-full whitespace-nowrap ${statusColors[status]}`}>
          {status}
        </span>
      </div>

      <p className="text-sm text-indigo-600 font-medium">{sport}</p>
      <p className="text-sm text-gray-500">📍 {location}</p>
      <p className="text-sm text-gray-500">
        📅 {start} — {end}
      </p>
      <p className="text-sm text-gray-500">
        👥 {registrationCount} / {maxTeams} teams
      </p>
    </div>
  );
}
