import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:module/Screens/cart_model.dart';
import 'package:module/Screens/cart_page.dart';
import 'package:module/items_list/biriyani_detail_page.dart';

class BiryaniListPage extends StatefulWidget {
  const BiryaniListPage({super.key});

  @override
  State<BiryaniListPage> createState() => _BiryaniListPageState();
}

class _BiryaniListPageState extends State<BiryaniListPage> {

  /* ===============================
     STATIC ITEMS (UNCHANGED)
  ===============================*/
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
            builder: (_) => BiriyaniDetailPage(
              name: item["name"],
              image: item["image"],
              price: item["price"],
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
                    Text(item["name"],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(item["description"],
                        style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Text("₹${item["price"]}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
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
        title: const Text("Biryani"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("category", isEqualTo: "Biryani")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          List<Map<String, dynamic>> firebaseItems = [];

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            firebaseItems = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                "name": data["name"],
                "price": data["price"],
                "image": data["imageUrl"],
                "description": data["description"],
              };
            }).toList();
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [

              ...biryanis.map((e) => productCard(e, false)),

              if (firebaseItems.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("New Items Added",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                ...firebaseItems.map((e) => productCard(e, true)),
              ],
            ],
          );
        },
      ),
    );
  }
}
void showCartPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 10),

            const Text(
              "Item added to cart",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                // CONTINUE SHOPPING
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Continue"),
                  ),
                ),

                const SizedBox(width: 12),

                // VIEW CART
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartPage(tableId: '1',),
                        ),
                      );
                    },
                    child: const Text("View Cart"),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}