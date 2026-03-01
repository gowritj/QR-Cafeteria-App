import 'package:flutter/material.dart';
import 'package:module/Screens/cart_model.dart';
import 'package:module/items_list/biriyani_list_page.dart';

class BreadsDetailPage extends StatelessWidget {
  final String name;
  final String image;
  final int price;
  final String description;

  const BreadsDetailPage({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });

  bool isNetworkImage(String path) {
    return path.startsWith("http");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [

                /* ================= IMAGE HEADER ================= */
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  child: isNetworkImage(image)
                      ? Image.network(
                          image,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 300,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, size: 80),
                          ),
                        )
                      : Image.asset(
                          image,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                ),

                /* ================= CONTENT CARD ================= */
                Transform.translate(
                  offset: const Offset(0, -25),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /* NAME */
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /* PRICE CHIP */
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "₹ $price",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /* DESCRIPTION */
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 15.5,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /* INFO ROW (BREAD SPECIFIC) */
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _InfoTile(Icons.bakery_dining, "Freshly Baked"),
                            _InfoTile(Icons.timer, "10 mins"),
                            _InfoTile(Icons.local_fire_department, "180 kcal"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /* ================= FLOATING ADD TO CART ================= */
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SizedBox(
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shadowColor: Colors.green.withOpacity(.4),
                  backgroundColor: const Color(0xFF27AE60),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  Cart.addItem(name, price, image, 1);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$name added to cart")),
                  );

                  showCartPopup(context);
                },
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= INFO TILE ================= */
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoTile(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF27AE60)),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}