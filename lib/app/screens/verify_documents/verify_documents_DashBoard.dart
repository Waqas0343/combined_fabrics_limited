import 'package:combined_fabrics_limited/app/screens/verify_documents/widgets/verify_document_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/home_controller.dart';

class DyeingFinishingHome extends StatelessWidget {
  const DyeingFinishingHome({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Documents DashBoard"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Current ",
                  style: Get.textTheme.titleSmall,
                  children: [
                    TextSpan(
                      text: "User ",
                      style: Get.textTheme.titleSmall,
                    ),
                    TextSpan(
                      text: controller.employeeName,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const DocumentsAppCard(),
          ],
        ),
      ),
    );
  }
}
