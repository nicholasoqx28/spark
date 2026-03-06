import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";

// GET /api/courses — public
export async function GET() {
  const courses = await prisma.course.findMany({
    orderBy: { title: "asc" },
    include: { _count: { select: { enrollments: true, lessons: true } } },
  });
  return NextResponse.json(courses);
}

// POST /api/courses — admin only
export async function POST(request: NextRequest) {
  const session = await auth();
  if (!session || session.user.role !== "ADMIN") {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  const body = await request.json();
  const course = await prisma.course.create({ data: body });
  return NextResponse.json(course, { status: 201 });
}
