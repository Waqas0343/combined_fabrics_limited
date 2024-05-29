import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app_assets/styles/my_images.dart';
import '../../app_widgets/custom_card.dart';
import 'controllers/rowing_quality_nfc_controller.dart';

class RowingQualityScanNFC extends StatelessWidget {
  const RowingQualityScanNFC({super.key});

  @override
  Widget build(BuildContext context) {
    final RowingQualityNFCController controller = Get.put(RowingQualityNFCController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Card Reader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              MyImages.isNfc,
              fit: BoxFit.contain,
              width: 200,
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
              controller.isNfcAvailable.value ? "NFC Available" : "NFC Not Available",
              style: Get.textTheme.titleSmall,
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.dataList.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                    itemCount: controller.dataList.length,
                    itemBuilder: (context, index) {
                      Color backgroundColor = index % 2 == 0 ? Colors.white : const Color(0xffe5f7f1);
                      return GestureDetector(
                        onTap: () {
                          Get.back(result: controller.dataList[index]);
                        },
                        child: CustomCard(
                          color: backgroundColor,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: ClipOval(
                              child: SvgPicture.asset(
                                MyImages.isMachine,
                                height: 20.0,
                              ),
                            ),
                            title: Text(controller.dataList[index]),
                            trailing: const Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text("Scan Machine NFC Card");
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
