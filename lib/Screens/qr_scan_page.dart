import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:module/Screens/menu_screen.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code"), centerTitle: true),
      body: MobileScanner(
        controller: MobileScannerController(
          facing: CameraFacing.back,
          detectionSpeed: DetectionSpeed.normal,
        ),
        onDetect: (BarcodeCapture capture) {
          if (scanned) return;

          for (final barcode in capture.barcodes) {
            final String? value = barcode.rawValue;

            // 🔍 DEBUG
            debugPrint("Scanned QR value: $value");

            if (value != null && value.isNotEmpty) {
              scanned = true;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MenuPage(tableId: value)),
              );
              break;
            }
          }
        },
      ),
    );
  }
}
