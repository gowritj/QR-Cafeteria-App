import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:module/Screens/cart_model.dart';
import 'package:module/items_list/biriyani_detail_page.dart';

class SandwichListPage extends StatefulWidget {
  const SandwichListPage({super.key});

  @override
  State<SandwichListPage> createState() => _SandwichListPageState();
}

class _SandwichListPageState extends State<SandwichListPage> {

  // ✅ LOCAL SANDWICHES
  final List<Map<String, dynamic>> sandwiches = [
    {
      "name": "Grilled Chicken Sandwich",
      "price": 160,
      "image": "assets/images/sandwich_chicken.jpg",
      "description": "Grilled chicken with lettuce and creamy mayo.",
    },
    {
      "name": "Veg Club Sandwich",
      "price": 140,
      "image": "assets/images/sandwich_veg.jpg",
      "description": "Triple-layer sandwich with fresh vegetables.",
    },
    {
      "name": "Cheese Sandwich",
      "price": 120,
      "image": "assets/images/sandwich_cheese.jpg",
      "description": "Toasted bread filled with melted cheese.",
    },
    {
      "name": "Paneer Sandwich",
      "price": 150,
      "image": "assets/images/sandwich_paneer.jpg",
      "description": "Spicy paneer stuffing with fresh veggies.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Sandwiches"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),

      // 🔥 FIRESTORE STREAM
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("category", isEqualTo: "Sandwiches")
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🔥 Firebase products
          List<Map<String, dynamic>> firebaseItems = [];

          if (snapshot.hasData) {
            firebaseItems = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              return {
                "name": data["name"] ?? "Item",
                "price": data["price"] ?? 0,
                "image": data["imageUrl"] ?? "",
                "description": data["description"] ?? "",
                "isNetwork": true,
              };
            }).toList();
          }

          // ✅ COMBINE LOCAL + FIREBASE
          final allItems = [
            ...sandwiches.map((e) => {...e, "isNetwork": false}),
            ...firebaseItems,
          ];

          if (allItems.isEmpty) {
            return const Center(child: Text("No items available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: allItems.length,
            itemBuilder: (context, index) {

              final item = allItems[index];
              final qty = Cart.getQuantity(item["name"]);

              return GestureDetector(
                onTap: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BiryaniDetailPage(
                        name: item["name"],
                        image: item["image"],
                        price: "₹${item["price"]}",
                        description: item["description"],
                      ),
                    ),
                  );

                  if (updated == true) setState(() {});
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Row(
                    children: [

                      // 🥪 IMAGE (asset or network)
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(18),
                        ),
                        child: item["isNetwork"]
                            ? Image.network(
                                item["image"],
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image, size: 80),
                              )
                            : Image.asset(
                                item["image"],
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                      ),

                      // 📄 DETAILS
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["description"],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "₹${item["price"]}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ➕ ➖ CART
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  Cart.addItem(
                                    item["name"],
                                    item["price"],
                                    item["image"],
                                    1,
                                  );
                                });
                              },
                            ),
                            Text(
                              qty.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: qty == 0
                                  ? null
                                  : () {
                                      setState(() {
                                        Cart.removeItem(item["name"]);
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
