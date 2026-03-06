import type { Course } from "@/app/generated/prisma/client";

interface Props {
  course: Course;
  lessonCount: number;
  enrollmentCount: number;
}

const levelBadge: Record<string, string> = {
  BEGINNER: "bg-green-100 text-green-700",
  INTERMEDIATE: "bg-yellow-100 text-yellow-700",
  ADVANCED: "bg-red-100 text-red-700",
};

export function CourseCard({ course, lessonCount, enrollmentCount }: Props) {
  const { title, description, sport, level } = course;

  return (
    <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 flex flex-col gap-3 hover:shadow-md transition-shadow">
      <div className="flex items-start justify-between gap-2">
        <h2 className="font-bold text-gray-900 text-lg leading-tight">{title}</h2>
        <span className={`text-xs font-semibold px-2 py-1 rounded-full whitespace-nowrap ${levelBadge[level]}`}>
          {level}
        </span>
      </div>

      <p className="text-sm text-indigo-600 font-medium">{sport}</p>
      <p className="text-sm text-gray-500 flex-1">{description}</p>

      <div className="flex gap-4 text-xs text-gray-400 mt-1">
        <span>📚 {lessonCount} lessons</span>
        <span>👥 {enrollmentCount} enrolled</span>
      </div>
    </div>
  );
}
