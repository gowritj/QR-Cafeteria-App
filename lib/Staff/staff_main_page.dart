import 'package:flutter/material.dart';
import 'package:module/Screens/qr_scan_page.dart';
import 'package:module/Staff/add_product_page.dart';
import 'package:module/Staff/view_orders_page.dart';


class StaffPage extends StatelessWidget {
  const StaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Staff Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const QRScanPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _dashboardTile(
              context,
              icon: Icons.receipt_long,
              title: "View Orders",
              subtitle: "Check live customer orders",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewOrdersPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _dashboardTile(
              context,
              icon: Icons.add_box,
              title: "Add Products",
              subtitle: "Add new food items",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(18),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
