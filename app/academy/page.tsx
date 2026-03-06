import { prisma } from "@/lib/prisma";
import { CourseCard } from "@/features/academy/components/CourseCard";

export const dynamic = "force-dynamic";

export default async function AcademyPage() {
  const courses = await prisma.course.findMany({
    orderBy: { title: "asc" },
    include: { _count: { select: { enrollments: true, lessons: true } } },
  });

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Academy</h1>
        <p className="text-gray-500 mt-1">
          Structured training courses to sharpen your competitive edge.
        </p>
      </div>

      {courses.length === 0 ? (
        <p className="text-gray-400 text-sm">No courses available yet. Check back soon!</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {courses.map((course) => (
            <CourseCard
              key={course.id}
              course={course}
              lessonCount={course._count.lessons}
              enrollmentCount={course._count.enrollments}
            />
          ))}
        </div>
      )}
    </div>
  );
}
