import 'package:flutter/material.dart';
import 'package:module/Screens/cart_model.dart';
import 'package:module/items_list/biriyani_list_page.dart';

class BiriyaniDetailPage extends StatelessWidget {
  final String name;
  final String image;
  final int price;
  final String description;

  const BiriyaniDetailPage({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });

  bool isNetworkImage(String path) => path.startsWith("http");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: isNetworkImage(image)
                  ? Image.network(image,
                      width: double.infinity, height: 260, fit: BoxFit.cover)
                  : Image.asset(image,
                      width: double.infinity, height: 260, fit: BoxFit.cover),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  Text("₹ $price",
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.green,
                          fontWeight: FontWeight.bold)),

                  const SizedBox(height: 16),

                  Text(description,
                      style: TextStyle(color: Colors.grey.shade700)),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Cart.addItem(name, price, image, 1);
                        showCartPopup(context);
                      },
                      child: const Text("Add to Cart"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}