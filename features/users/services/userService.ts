import { prisma } from "@/lib/prisma";
import bcrypt from "bcryptjs";
import type { Role } from "@/app/generated/prisma/client";

export async function createUser(name: string, email: string, password: string, role: Role) {
  const passwordHash = await bcrypt.hash(password, 12);
  return prisma.user.create({
    data: { name, email, passwordHash, role },
    select: { id: true, name: true, email: true, role: true, createdAt: true },
  });
}

export async function getUserByEmail(email: string) {
  return prisma.user.findUnique({ where: { email } });
}

export async function getUserById(id: string) {
  return prisma.user.findUnique({
    where: { id },
    select: { id: true, name: true, email: true, role: true, createdAt: true },
  });
}
