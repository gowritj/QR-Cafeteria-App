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
  static String tableId = "";
  static List<CartItem> items = [];

  // ➕ ADD ITEM
  static void addItem(String name, int price, String image, int qty) {
    for (var item in items) {
      if (item.name == name) {
        item.quantity += qty;
        return;
      }
    }
    items.add(
      CartItem(
        name: name,
        price: price,
        image: image,
        quantity: qty,
      ),
    );
  }

  // ➖ REMOVE / DECREASE ITEM
  static void removeItem(String name) {
    for (var item in items) {
      if (item.name == name) {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          items.remove(item);
        }
        return;
      }
    }
  }

  // 🔢 GET QUANTITY
  static int getQuantity(String name) {
    for (var item in items) {
      if (item.name == name) {
        return item.quantity;
      }
    }
    return 0;
  }

  // 💰 TOTAL PRICE
  static int getTotal() {
    return items.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  // 🧹 CLEAR CART
  static void clear() {
    items.clear();
  }
}
