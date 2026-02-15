import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorPage extends StatelessWidget {
  final String tableId;

  const QRGeneratorPage({super.key, required this.tableId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Table QR")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: tableId, // ✅ PLAIN TEXT
              size: 250,
            ),
            const SizedBox(height: 20),
            Text(
              "Scan for $tableId",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
