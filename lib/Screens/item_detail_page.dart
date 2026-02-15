import 'package:flutter/material.dart';
import 'package:module/Screens/cart_model.dart';

import 'payment_page.dart';

class ItemDetailPage extends StatefulWidget {
  final String name;
  final int price;
  final String image;

  const ItemDetailPage({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(widget.image, height: 180),
            const SizedBox(height: 20),

            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),
            Text("Price: ₹${widget.price}"),
            const SizedBox(height: 10),
            const Text("Preparation Time: 15 minutes ⏱️"),

            const SizedBox(height: 20),

            // Quantity selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() => quantity--);
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => quantity++);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            const Spacer(),

            // Add to cart
            ElevatedButton(
              onPressed: () {
                Cart.addItem(
                  widget.name,
                  widget.price,
                  widget.image,
                  quantity,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Add to Cart & Pay"),
            ),
          ],
        ),
      ),
    );
  }
}
