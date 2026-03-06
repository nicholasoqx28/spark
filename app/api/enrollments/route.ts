import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";

// GET /api/enrollments — own enrollments
export async function GET() {
  const session = await auth();
  if (!session) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const enrollments = await prisma.enrollment.findMany({
    where: { userId: session.user.id },
    include: { course: true },
    orderBy: { enrolledAt: "desc" },
  });
  return NextResponse.json(enrollments);
}

// POST /api/enrollments — enroll in a course
export async function POST(request: NextRequest) {
  const session = await auth();
  if (!session) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { courseId } = await request.json();

  const course = await prisma.course.findUnique({ where: { id: courseId } });
  if (!course) return NextResponse.json({ error: "Course not found" }, { status: 404 });

  try {
    const enrollment = await prisma.enrollment.create({
      data: { userId: session.user.id, courseId },
    });
    return NextResponse.json(enrollment, { status: 201 });
  } catch {
    return NextResponse.json({ error: "Already enrolled in this course." }, { status: 409 });
  }
}
