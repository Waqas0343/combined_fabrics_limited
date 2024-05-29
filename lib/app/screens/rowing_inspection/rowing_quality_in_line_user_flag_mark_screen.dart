import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/in_line_flag_mark_controller.dart';
import 'models/rowing_quality_flag_color_model.dart';

class InLineFlagScreen extends StatelessWidget {
  const InLineFlagScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InLineFlagMarkController controller = Get.put(InLineFlagMarkController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Flag Mark Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.flagColor ?? Colors.transparent,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Mark Machine Flag!',
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  controller.formNo != null
                      ? 'All 7 garments inspected successfully!'
                      : 'Are You Sure! Machine Have No Work ? ',
                  textAlign: TextAlign.start,
                  style: Get.textTheme.titleSmall?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                                color: Colors.red),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "Major Fault Flag Color",
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                                color: Colors.yellow),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "Minor Fault Flag Color",
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                                color: Colors.green),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "No Flag Found Color",
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                                color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "No Work Flag Color",
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),

                      // Dark Silver
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.saveInspectionFlagColor();
                    },
                    child: const Text('Save Flag'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
