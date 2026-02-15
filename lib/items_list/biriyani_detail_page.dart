import 'package:flutter/material.dart';
import 'package:module/Screens/cart_model.dart';

class BiryaniDetailPage extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  final String description;

  const BiryaniDetailPage({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🍽 IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟢 NAME + VEG/NON-VEG
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "NON-VEG",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 💰 PRICE
                  Text(
                    price.startsWith("₹") ? price : "₹$price",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 🧾 DESCRIPTION
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 📊 INFO ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _InfoTile(Icons.timer, "25 mins"),
                      _InfoTile(Icons.local_fire_department, "450 kcal"),
                      _InfoTile(Icons.restaurant, "Ingredients"),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 🧂 INGREDIENTS
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Basmati rice, chicken, onion, yogurt, spices, herbs",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ➕ ADD TO CART BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Cart.addItem(
                          name,
                          int.parse(
                              price.replaceAll("₹", "").trim()),
                          image,
                          1,
                        );

                        // 🔙 notify previous screen
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 INFO TILE WIDGET
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoTile(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
