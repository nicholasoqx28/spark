import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";

// GET /api/tournaments — public list
export async function GET() {
  const tournaments = await prisma.tournament.findMany({
    orderBy: { startDate: "asc" },
    include: { _count: { select: { registrations: true } } },
  });
  return NextResponse.json(tournaments);
}

// POST /api/tournaments — admin only
export async function POST(request: NextRequest) {
  const session = await auth();
  if (!session || session.user.role !== "ADMIN") {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  const body = await request.json();
  const tournament = await prisma.tournament.create({ data: body });
  return NextResponse.json(tournament, { status: 201 });
}
