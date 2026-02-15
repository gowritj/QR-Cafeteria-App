import 'package:flutter/material.dart';

class AdminOrderPage extends StatelessWidget {
  const AdminOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Orders")),
      body: ListView(
        children: const [
          ListTile(
            title: Text("Table 3"),
            subtitle: Text("Preparing"),
            trailing: Icon(Icons.restaurant),
          ),
          ListTile(
            title: Text("Table 5"),
            subtitle: Text("Ready"),
            trailing: Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
