class Product {
  final int id;
  final String name;
  final int price;
  final int stock;
  final String? image;
  final int? categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.image,
    this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
      image: json['image'],
      categoryId: json['category_id'],
    );
  }
}
