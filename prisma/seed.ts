/**
 * Database seed — run with: npx prisma db seed
 * Creates sample data for local development.
 */
import "dotenv/config";
import path from "node:path";
import { PrismaClient } from "../app/generated/prisma/client.js";
import { PrismaBetterSqlite3 } from "@prisma/adapter-better-sqlite3";
import bcrypt from "bcryptjs";

const dbPath = path.resolve(process.cwd(), "prisma/dev.db");
const adapter = new PrismaBetterSqlite3({ url: `file:${dbPath}` });
const db = new PrismaClient({ adapter });

async function main() {
  // --- Users ---
  const adminHash = await bcrypt.hash("admin1234", 12);
  const athleteHash = await bcrypt.hash("athlete1234", 12);

  const admin = await db.user.upsert({
    where: { email: "admin@spark.app" },
    update: {},
    create: { name: "Admin User", email: "admin@spark.app", passwordHash: adminHash, role: "ADMIN" },
  });

  const athlete = await db.user.upsert({
    where: { email: "athlete@spark.app" },
    update: {},
    create: { name: "Alex Athlete", email: "athlete@spark.app", passwordHash: athleteHash, role: "ATHLETE" },
  });

  console.log("Created users:", admin.email, athlete.email);

  // --- Tournaments ---
  const t1 = await db.tournament.upsert({
    where: { id: "seed-tournament-1" },
    update: {},
    create: {
      id: "seed-tournament-1",
      title: "Summer Football Cup",
      sport: "Football",
      description: "Annual 5-a-side summer tournament.",
      startDate: new Date("2026-07-01"),
      endDate: new Date("2026-07-05"),
      location: "City Stadium",
      maxTeams: 16,
      status: "UPCOMING",
    },
  });

  await db.tournament.upsert({
    where: { id: "seed-tournament-2" },
    update: {},
    create: {
      id: "seed-tournament-2",
      title: "Spring Basketball League",
      sport: "Basketball",
      description: "Round-robin league across 8 weeks.",
      startDate: new Date("2026-04-01"),
      endDate: new Date("2026-05-31"),
      location: "Indoor Arena",
      maxTeams: 8,
      status: "UPCOMING",
    },
  });

  console.log("Created tournaments");

  // Register athlete
  await db.tournamentRegistration.upsert({
    where: { userId_tournamentId: { userId: athlete.id, tournamentId: t1.id } },
    update: {},
    create: { userId: athlete.id, tournamentId: t1.id, teamName: "The Rockets" },
  });

  // --- Products ---
  await db.product.upsert({
    where: { id: "seed-product-1" },
    update: {},
    create: {
      id: "seed-product-1",
      name: "Pro Football Boots",
      description: "Lightweight boots for all surfaces.",
      price: 89.99,
      stock: 50,
      category: "Footwear",
    },
  });

  await db.product.upsert({
    where: { id: "seed-product-2" },
    update: {},
    create: {
      id: "seed-product-2",
      name: "Training Basketball",
      description: "Official-size indoor/outdoor basketball.",
      price: 34.99,
      stock: 30,
      category: "Equipment",
    },
  });

  await db.product.upsert({
    where: { id: "seed-product-3" },
    update: {},
    create: {
      id: "seed-product-3",
      name: "Spark Performance Tee",
      description: "Moisture-wicking athletic tee.",
      price: 24.99,
      stock: 100,
      category: "Apparel",
    },
  });

  console.log("Created products");

  // --- Courses ---
  const course = await db.course.upsert({
    where: { id: "seed-course-1" },
    update: {},
    create: {
      id: "seed-course-1",
      title: "Football Fundamentals",
      description: "Master passing, positioning, and shooting from the ground up.",
      sport: "Football",
      level: "BEGINNER",
    },
  });

  await db.lesson.upsert({
    where: { id: "seed-lesson-1" },
    update: {},
    create: {
      id: "seed-lesson-1",
      courseId: course.id,
      title: "Passing Techniques",
      content: "Learn the fundamentals of short and long passing.",
      order: 1,
    },
  });

  await db.lesson.upsert({
    where: { id: "seed-lesson-2" },
    update: {},
    create: {
      id: "seed-lesson-2",
      courseId: course.id,
      title: "Positioning & Movement",
      content: "Understand how to move off the ball effectively.",
      order: 2,
    },
  });

  await db.course.upsert({
    where: { id: "seed-course-2" },
    update: {},
    create: {
      id: "seed-course-2",
      title: "Advanced Basketball Playbook",
      description: "Tactical plays and team coordination for competitive athletes.",
      sport: "Basketball",
      level: "ADVANCED",
    },
  });

  console.log("Created courses");
}

main()
  .catch(console.error)
  .finally(() => db.$disconnect());
