import { prisma } from "@/lib/prisma";
import type { TournamentStatus } from "@/app/generated/prisma/client";

export interface CreateTournamentInput {
  title: string;
  sport: string;
  description: string;
  startDate: Date;
  endDate: Date;
  location: string;
  maxTeams: number;
}

export async function listTournaments(status?: TournamentStatus) {
  return prisma.tournament.findMany({
    where: status ? { status } : undefined,
    orderBy: { startDate: "asc" },
    include: { _count: { select: { registrations: true } } },
  });
}

export async function createTournament(data: CreateTournamentInput) {
  return prisma.tournament.create({ data });
}

export async function registerForTournament(userId: string, tournamentId: string, teamName: string) {
  return prisma.tournamentRegistration.create({
    data: { userId, tournamentId, teamName },
  });
}
