import type { Product } from "@/app/generated/prisma/client";

interface Props {
  product: Product;
}

export function ProductCard({ product }: Props) {
  const { name, description, price, stock, imageUrl } = product;
  const inStock = stock > 0;

  return (
    <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden flex flex-col hover:shadow-md transition-shadow">
      <div className="bg-gray-100 h-40 flex items-center justify-center text-5xl">
        {imageUrl ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={imageUrl} alt={name} className="h-full w-full object-cover" />
        ) : (
          "🏅"
        )}
      </div>
      <div className="p-4 flex flex-col gap-2 flex-1">
        <h3 className="font-semibold text-gray-900 text-sm leading-tight">{name}</h3>
        <p className="text-xs text-gray-500 flex-1">{description}</p>
        <div className="flex items-center justify-between mt-2">
          <span className="text-indigo-600 font-bold">${price.toFixed(2)}</span>
          <span className={`text-xs font-medium ${inStock ? "text-green-600" : "text-red-500"}`}>
            {inStock ? `${stock} in stock` : "Out of stock"}
          </span>
        </div>
      </div>
    </div>
  );
}
