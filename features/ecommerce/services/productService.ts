import { prisma } from "@/lib/prisma";

export async function listProducts(category?: string) {
  return prisma.product.findMany({
    where: category ? { category } : undefined,
    orderBy: { name: "asc" },
  });
}

export async function getProductById(id: string) {
  return prisma.product.findUnique({ where: { id } });
}

export interface CartItem {
  productId: string;
  quantity: number;
}

export async function placeOrder(userId: string, cartItems: CartItem[]) {
  const productIds = cartItems.map((i) => i.productId);
  const products = await prisma.product.findMany({ where: { id: { in: productIds } } });

  let total = 0;
  for (const item of cartItems) {
    const product = products.find((p) => p.id === item.productId);
    if (!product) throw new Error(`Product ${item.productId} not found`);
    if (product.stock < item.quantity) throw new Error(`Insufficient stock for ${product.name}`);
    total += product.price * item.quantity;
  }

  return prisma.$transaction(async (tx) => {
    const order = await tx.order.create({
      data: {
        userId,
        total,
        items: {
          create: cartItems.map((item) => {
            const product = products.find((p) => p.id === item.productId)!;
            return { productId: item.productId, quantity: item.quantity, unitPrice: product.price };
          }),
        },
      },
      include: { items: true },
    });

    for (const item of cartItems) {
      await tx.product.update({
        where: { id: item.productId },
        data: { stock: { decrement: item.quantity } },
      });
    }

    return order;
  });
}
