class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final int stock;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.stock,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String?,
        stock: json['stock'] as int,
        category: json['category'] as String,
      );

  bool get inStock => stock > 0;
}
