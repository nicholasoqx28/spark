import { prisma } from "@/lib/prisma";
import type { CourseLevel } from "@/app/generated/prisma/client";

export interface CreateCourseInput {
  title: string;
  description: string;
  sport: string;
  level: CourseLevel;
  imageUrl?: string;
}

export async function listCourses() {
  return prisma.course.findMany({
    orderBy: { title: "asc" },
    include: { _count: { select: { enrollments: true, lessons: true } } },
  });
}

export async function getCourseById(id: string) {
  return prisma.course.findUnique({
    where: { id },
    include: { lessons: { orderBy: { order: "asc" } } },
  });
}

export async function createCourse(data: CreateCourseInput) {
  return prisma.course.create({ data });
}

export async function enrollUser(userId: string, courseId: string) {
  return prisma.enrollment.create({ data: { userId, courseId } });
}
