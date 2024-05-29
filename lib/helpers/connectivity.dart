import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/debug/debug_pointer.dart';

class Connectivity {
  static Future<bool> isOnline() async {
    try {
      final response = await http.get(Uri.parse('http://172.16.0.11/api/'));
      return response.statusCode == 200;
    } catch (e) {
      Debug.log('not connected: $e');
      return false;
    }
  }

  static Future<void> internetNotAvailable() {
    return Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 60,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'No Network Connection',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto",
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Network access is required \nto use this feature.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 120,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
