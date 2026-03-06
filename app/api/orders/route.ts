import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { auth } from "@/lib/auth";

// GET /api/orders — own orders (all orders for admin)
export async function GET() {
  const session = await auth();
  if (!session) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const orders = await prisma.order.findMany({
    where: session.user.role === "ADMIN" ? undefined : { userId: session.user.id },
    include: { items: { include: { product: true } } },
    orderBy: { createdAt: "desc" },
  });
  return NextResponse.json(orders);
}

// POST /api/orders — create order from cart items
export async function POST(request: NextRequest) {
  const session = await auth();
  if (!session) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { items } = await request.json() as {
    items: { productId: string; quantity: number }[];
  };

  // Verify stock and compute total
  const productIds = items.map((i) => i.productId);
  const products = await prisma.product.findMany({ where: { id: { in: productIds } } });

  let total = 0;
  for (const item of items) {
    const product = products.find((p) => p.id === item.productId);
    if (!product) return NextResponse.json({ error: `Product ${item.productId} not found` }, { status: 404 });
    if (product.stock < item.quantity) {
      return NextResponse.json({ error: `Insufficient stock for ${product.name}` }, { status: 409 });
    }
    total += product.price * item.quantity;
  }

  const order = await prisma.$transaction(async (tx) => {
    const created = await tx.order.create({
      data: {
        userId: session.user.id,
        total,
        items: {
          create: items.map((i) => {
            const product = products.find((p) => p.id === i.productId)!;
            return { productId: i.productId, quantity: i.quantity, unitPrice: product.price };
          }),
        },
      },
      include: { items: true },
    });

    // Decrement stock
    for (const item of items) {
      await tx.product.update({
        where: { id: item.productId },
        data: { stock: { decrement: item.quantity } },
      });
    }

    return created;
  });

  return NextResponse.json(order, { status: 201 });
}
