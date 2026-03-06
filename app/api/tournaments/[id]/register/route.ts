import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";

// POST /api/tournaments/[id]/register — athlete only
export async function POST(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  const session = await auth();
  if (!session) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  if (session.user.role === "ENTHUSIAST") {
    return NextResponse.json({ error: "Only athletes can register for tournaments." }, { status: 403 });
  }

  const { id } = await params;
  const { teamName } = await request.json();

  const tournament = await prisma.tournament.findUnique({ where: { id } });
  if (!tournament) return NextResponse.json({ error: "Tournament not found" }, { status: 404 });

  try {
    const registration = await prisma.tournamentRegistration.create({
      data: { userId: session.user.id, tournamentId: id, teamName },
    });
    return NextResponse.json(registration, { status: 201 });
  } catch {
    return NextResponse.json({ error: "Already registered for this tournament." }, { status: 409 });
  }
}
