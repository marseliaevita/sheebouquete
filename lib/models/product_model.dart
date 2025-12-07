class Product {
  final int productId; 
  final String name;
  final int price;
  final String image;
  final int stock;

  Product({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.stock,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['product_id'],
      name: map['name'],
      price: map['price'],
      image: map['image'] ?? '',
      stock: map['stock'] ?? 0,
    );
  }
}
