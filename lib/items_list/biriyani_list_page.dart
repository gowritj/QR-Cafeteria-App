import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:module/Screens/cart_model.dart';
import 'package:module/items_list/biriyani_detail_page.dart';

class BiryaniListPage extends StatefulWidget {
  const BiryaniListPage({super.key});

  @override
  State<BiryaniListPage> createState() => _BiryaniListPageState();
}

class _BiryaniListPageState extends State<BiryaniListPage> {

  // ✅ EXISTING STATIC ITEMS
  final List<Map<String, dynamic>> biryanis = [
    {
      "name": "Chicken Biryani",
      "price": 180,
      "image": "assets/images/chicken_biryani.jpg",
      "description": "Aromatic basmati rice with spicy chicken.",
    },
    {
      "name": "Mutton Biryani",
      "price": 250,
      "image": "assets/images/mutton_biryani.jpg",
      "description": "Slow-cooked tender mutton with rich spices.",
    },
    {
      "name": "Veg Biryani",
      "price": 150,
      "image": "assets/images/veg_biryani.jpg",
      "description": "Fresh vegetables cooked with fragrant rice.",
    },
    {
      "name": "Beef Biryani",
      "price": 250,
      "image": "assets/images/beef_biryani.jpg",
      "description": "Tender beef cooked with aromatic spices.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Biryani"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),

      // 🔥 FIRESTORE STREAM
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("category", isEqualTo: "Biryani")
            .snapshots(),
        builder: (context, snapshot) {

          // ⏳ loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🔥 firebase items
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

          // ✅ combine local + firebase
          final allItems = [
            ...biryanis.map((e) => {...e, "isNetwork": false}),
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

                      // 🖼 IMAGE
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
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "₹${item["price"]}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ➕ ➖ CART
                      Column(
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
                          Text(qty.toString()),
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
