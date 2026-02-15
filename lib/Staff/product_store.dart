import 'dart:io';

class Product {
  final String category;
  final String name;
  final int price;
  final String description;
  final File image;

  Product({
    required this.category,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });
}

class ProductStore {
  static List<Product> products = [];

  static void addProduct(Product product) {
    products.add(product);
  }

  static List<Product> getByCategory(String category) {
    return products
        .where((p) =>
            p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
