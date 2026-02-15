import 'package:flutter/material.dart';
import 'package:module/Screens/cart_model.dart';


class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Confirmed")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle,
                color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Order Placed Successfully!",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text("Table ID: ${Cart.tableId}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Cart.clear();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Back to Menu"),
            ),
          ],
        ),
      ),
    );
  }
}
