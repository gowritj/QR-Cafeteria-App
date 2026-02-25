class CartItem {
  final String name;
  final int price;
  final String image;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class Cart {
  static List<CartItem> items = [];
  static String tableId = "";

  static void setTable(String id) {
    tableId = id;
  }

  static void addItem(String name, int price, String image, int qty) {
    final index = items.indexWhere((item) => item.name == name);

    if (index != -1) {
      items[index].quantity += qty;
    } else {
      items.add(
        CartItem(
          name: name,
          price: price,
          image: image,
          quantity: qty,
        ),
      );
    }
  }

  static void removeItem(String name) {
    items.removeWhere((item) => item.name == name);
  }

  static int getTotal() {
    int total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  static int getQuantity(String name) {
    final index = items.indexWhere((item) => item.name == name);
    if (index == -1) return 0;
    return items[index].quantity;
  }

  static void clear() {
    items.clear();
  }
}