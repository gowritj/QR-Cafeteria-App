import 'package:flutter/material.dart';
import 'package:module/Staff/staff_main_page.dart';


class StaffLoginPage extends StatefulWidget {
  const StaffLoginPage({super.key});

  @override
  State<StaffLoginPage> createState() => _StaffLoginPageState();
}

class _StaffLoginPageState extends State<StaffLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void staffLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email == "staff@canteen.com" && password == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const StaffPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Staff Credentials")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Staff Login"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔰 LOGO
            Image.asset(
              'assets/images/scandine.png',
              width: 180,
            ),

            const SizedBox(height: 40),

            // 📧 EMAIL
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Staff Email",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔒 PASSWORD
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔘 LOGIN BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: staffLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
