import { prisma } from "@/lib/prisma";
import { ProductCard } from "@/features/ecommerce/components/ProductCard";

export const dynamic = "force-dynamic";

export default async function ShopPage() {
  const products = await prisma.product.findMany({ orderBy: { name: "asc" } });

  const categories = [...new Set(products.map((p) => p.category))];

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Shop</h1>
        <p className="text-gray-500 mt-1">Gear up with the best sports equipment and apparel.</p>
      </div>

      {categories.length === 0 ? (
        <p className="text-gray-400 text-sm">No products yet. Check back soon!</p>
      ) : (
        categories.map((category) => (
          <section key={category}>
            <h2 className="text-xl font-semibold text-gray-800 mb-4">{category}</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
              {products
                .filter((p) => p.category === category)
                .map((p) => (
                  <ProductCard key={p.id} product={p} />
                ))}
            </div>
          </section>
        ))
      )}
    </div>
  );
}
