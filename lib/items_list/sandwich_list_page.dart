import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:module/Screens/cart_model.dart';
import 'package:module/items_list/biriyani_list_page.dart';
import 'package:module/items_list/sandwich_detail_page.dart';

class SandwichListPage extends StatefulWidget {
  const SandwichListPage({super.key});

  @override
  State<SandwichListPage> createState() => _SandwichListPageState();
}

class _SandwichListPageState extends State<SandwichListPage> {

  /* ===============================
     STATIC ITEMS (UNCHANGED)
  ===============================*/
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

  /* ===============================
     PRODUCT CARD
  ===============================*/
  Widget productCard(Map<String, dynamic> item, bool isNetwork) {

    final qty = Cart.getQuantity(item["name"]);

    return GestureDetector(
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SandDetailPage(
              name: item["name"],
              image: item["image"],
              price: item["price"], // FIXED
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

            // IMAGE
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(18)),
              child: isNetwork
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

            // DETAILS
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

            // CART
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
                        showCartPopup(context);
                      });
                    },
                  ),
                  Text(
                    qty.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
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
  }

  /* ===============================
     UI
  ===============================*/
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

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("category", isEqualTo: "Sandwich") // FIXED
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> firebaseItems = [];

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            firebaseItems = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                "name": data["name"] ?? "Item",
                "price": data["price"] ?? 0,
                "image": data["imageUrl"] ?? "",
                "description": data["description"] ?? "",
              };
            }).toList();
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [

              // STATIC
              ...sandwiches.map((item) => productCard(item, false)),

              // FIRESTORE
              if (firebaseItems.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "New Items Added",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ...firebaseItems.map((item) => productCard(item, true)),
              ],
            ],
          );
        },
      ),
    );
  }
}