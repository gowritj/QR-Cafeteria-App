import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text(name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Add to Cart"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
