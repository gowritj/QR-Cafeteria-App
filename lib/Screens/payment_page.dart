import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:module/Screens/cart_model.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String paymentMethod = "UPI";
  final TextEditingController couponController = TextEditingController();
  bool isPaying = false;

  // 💰 PRICE CALCULATION
  int get subtotal => Cart.getTotal();
  int get gst => (subtotal * 0.05).round();
  int get platformFee => 10;
  int get discount => couponController.text == "SAVE20" ? 20 : 0;
  int get grandTotal => subtotal + gst + platformFee - discount;

  // 💳 PAY SIMULATION
  Future<void> payNow() async {
  setState(() => isPaying = true);

  await Future.delayed(const Duration(seconds: 2));

  try {
    // ✅ convert cart items to firestore format
    final orderItems = Cart.items.map((item) {
      return {
        "name": item.name,
        "price": item.price,
        "quantity": item.quantity,
      };
    }).toList();

    // ✅ save order to firestore
    await FirebaseFirestore.instance.collection("orders").add({
      "tableId": Cart.tableId,
      "items": orderItems,
      "total": grandTotal,
      "status": "Preparing",
      "createdAt": Timestamp.now(),
    });

    Cart.clear();

    setState(() => isPaying = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 70),
            SizedBox(height: 10),
            Text("Order Placed Successfully!",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  } catch (e) {
    setState(() => isPaying = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: $e")));
  }
}

  Widget sectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [

          // 🧾 ORDER SUMMARY
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Order Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                ...Cart.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${item.name} x${item.quantity}"),
                        Text("₹${item.price * item.quantity}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📍 DELIVERY ADDRESS
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Delivery Address",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("Table ${Cart.tableId} • Canteen Dining Area"),
              ],
            ),
          ),

          // 🎟 COUPON
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Apply Coupon",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: couponController,
                  decoration: InputDecoration(
                    hintText: "Enter code (SAVE20)",
                    suffixIcon: TextButton(
                      onPressed: () => setState(() {}),
                      child: const Text("Apply"),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 💳 PAYMENT METHOD
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Payment Method",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                RadioListTile(
                  value: "UPI",
                  groupValue: paymentMethod,
                  onChanged: (v) => setState(() => paymentMethod = v!),
                  title: const Text("UPI"),
                ),
                RadioListTile(
                  value: "Card",
                  groupValue: paymentMethod,
                  onChanged: (v) => setState(() => paymentMethod = v!),
                  title: const Text("Credit / Debit Card"),
                ),
                RadioListTile(
                  value: "Cash",
                  groupValue: paymentMethod,
                  onChanged: (v) => setState(() => paymentMethod = v!),
                  title: const Text("Cash on Delivery"),
                ),
              ],
            ),
          ),

          // 💰 BILL DETAILS
          sectionCard(
            child: Column(
              children: [
                _billRow("Subtotal", subtotal),
                _billRow("GST (5%)", gst),
                _billRow("Platform fee", platformFee),
                if (discount > 0)
                  _billRow("Discount", -discount, isGreen: true),
                const Divider(),
                _billRow("Total", grandTotal, isBold: true),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 💳 PAY BUTTON
          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: isPaying ? null : payNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isPaying
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Pay ₹$grandTotal",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _billRow(String label, int amount,
      {bool isBold = false, bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              )),
          Text(
            "₹$amount",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isGreen ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}
