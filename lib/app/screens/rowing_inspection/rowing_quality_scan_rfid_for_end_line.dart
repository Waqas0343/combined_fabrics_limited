import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_assets/styles/my_images.dart';
import '../../app_widgets/custom_card.dart';
import 'controllers/rowing_quality_scan_rfid_controller.dart';

class RowingQualityScanEndLineRFID extends StatelessWidget {
  const RowingQualityScanEndLineRFID({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RowingQualityScanEndLineRFIDController controller = Get.put(RowingQualityScanEndLineRFIDController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('RFID Card Reader'),
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
                  controller.isNfcAvailable.value
                      ? "RFID Available"
                      : "RFID Not Available",
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final resultValue = controller.result.value;
                if (resultValue.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CustomCard(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const ClipOval(
                              child: Icon(
                                Icons.work_history_rounded,
                                color: Colors.indigoAccent,
                              ),
                            ),
                            title: Text(
                              resultValue,
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        CustomCard(
                          color: const Color(0xffe5f7f1),
                          child: ListTile(
                            leading: const ClipOval(
                              child: Icon(
                                Icons.credit_card,
                                color: Colors.greenAccent,
                              ),
                            ),
                            title: Text(
                              controller.blockDataString.value,
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (controller
                              .operatorProductionList.isEmpty) {
                            return const Center(
                                child: Text('No data available'));
                          } else {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: controller.operatorProductionList.length,
                                itemBuilder: (context, index) {
                                  final item = controller.operatorProductionList[index];
                                  return CustomCard(
                                    onPressed: () {
                                      Get.back(result: {
                                        'bundleID': item.bundleId,
                                        'workOrder': item.orderDescription,
                                        'quantity': item.quantity,
                                      });
                                    },
                                    child: ListTile(
                                      leading: const ClipOval(
                                        child: Icon(
                                          Icons.format_list_bulleted,
                                          color: Colors.indigoAccent,
                                        ),
                                      ),
                                      title: Text(
                                        'Bundle ID: ${item.bundleId}',
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Text(
                                        'Quantity: ${item.quantity}',
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  );
                } else {
                  return const Text("Scan Bundle Card");
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
