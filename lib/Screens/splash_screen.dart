import 'package:flutter/material.dart';
import 'package:module/Admin/admin_page.dart';
import 'package:module/Screens/qr_scan_page.dart';
import 'package:module/Staff/staff_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showButtons = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        showButtons = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32); // classy green
    const Color lightGreen = Color(0xFFE8F5E9);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Image.asset(
              'assets/images/scandine.png',
              width: 280,
            ),

            const SizedBox(height: 40),

            if (showButtons) ...[
              // CUSTOMER BUTTON
              _buildButton(
                text: "Customer",
                icon: Icons.qr_code_scanner,
                bgColor: primaryGreen,
                textColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QRScanPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // STAFF BUTTON
              _buildButton(
                text: "Staff Login",
                icon: Icons.restaurant,
                bgColor: lightGreen,
                textColor: primaryGreen,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StaffLoginPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // ADMIN BUTTON
              _buildButton(
                text: "Admin Login",
                icon: Icons.admin_panel_settings,
                bgColor: lightGreen,
                textColor: primaryGreen,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDashboard(),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 🔘 REUSABLE BUTTON
  Widget _buildButton({
    required String text,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 22),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
