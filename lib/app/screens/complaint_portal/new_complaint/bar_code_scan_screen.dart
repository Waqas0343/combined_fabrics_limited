import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BarCodeScanner extends StatelessWidget {
  BarCodeScanner({Key? key}) : super(key: key);
  final GlobalKey qrKey = GlobalKey(debugLabel: 'Barcode'); // Use 'Barcode' as the debug label

  @override
  Widget build(BuildContext context) {
    double scanAreaWidth = MediaQuery.of(context).size.width * 0.8;
    double scanAreaHeight = scanAreaWidth / 2.0; // Adjust the aspect ratio as needed

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: scanAreaWidth,
              height: scanAreaHeight,
              child: QRView(
                key: qrKey,
                onQRViewCreated: onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 5.0,
                  borderLength: 5.0,
                  borderWidth: 5.0,
                  cutOutSize: scanAreaWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      controller.dispose();
      Get.back(result: scanData.code);
    }).onError((error) {
      Debug.log("Error while Scanning: $error");
      Get.back();
    });
  }
}
