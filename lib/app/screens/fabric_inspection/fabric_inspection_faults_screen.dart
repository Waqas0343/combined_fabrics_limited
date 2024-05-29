import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app_assets/app_theme_info.dart';
import '../../app_widgets/custom_card.dart';
import 'controllers/fabric_inspection_faults_controller.dart';
import 'models/faults_model.dart';

class FabricFaultsScreen extends StatelessWidget {
  const FabricFaultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FabricInspectionFaultsController controller = Get.put(FabricInspectionFaultsController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Row(
            children: [
              Text(
                controller.rollsModel.value?.rollNo ?? '',
              ),
              const SizedBox(
                width: 50,
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child:
                      ["M1", "M2", "M3", "M4", "M5","M6","M7","M8"].contains(controller.table)
                          ? RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "Inspection On Machine: ",
                                style: Get.textTheme.titleLarge?.copyWith(
                                  color: MyColors.shimmerHighlightColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: "${controller.table} ",
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Shift:  ",
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: MyColors.shimmerHighlightColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${controller.shift}  ",
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Roll Start Time:  ",
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: MyColors.shimmerHighlightColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: DateFormat('HH:mm:ss')
                                        .format(controller.expireDate!),
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "Inspection On Table: ",
                                style: Get.textTheme.titleLarge?.copyWith(
                                  color: MyColors.shimmerHighlightColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: "${controller.table}  ",
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: Colors.cyanAccent,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Shift:  ",
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: MyColors.shimmerHighlightColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${controller.shift}",
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: Colors.cyanAccent,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Roll Start Time:  ",
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: MyColors.shimmerHighlightColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: DateFormat('HH:mm:ss')
                                        .format(controller.expireDate!),
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: Colors.cyanAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            controller.getFaults();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 40) / 7;
              final cardHeight =
                  constraints.maxHeight / 7.8; // Adjust the value here

              return GridView.count(
                crossAxisCount: 7,
                padding: const EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: cardWidth / cardHeight,
                // Set aspect ratio for responsive card size
                children: List.generate(
                  controller.faultsList.length,
                  (index) {
                    final FaultsListModel fault = controller.faultsList[index];
                    return FractionallySizedBox(
                      widthFactor: 1,
                      child: GestureDetector(
                        onTap: () {
                          fault.faultCount.value++;
                          if (fault.faultCount.value == 1) {
                            // Do something when fault count is 1
                          }
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text(
                                      fault.faultName,
                                      style: Get.textTheme.titleSmall!.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            backgroundColor:
                                                Colors.teal.shade600,
                                            // Remove default padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            // Add border radius
                                          ),
                                          child: const Text('Back'),
                                        ),
                                        Text(
                                          '${fault.faultCount.value}',
                                          style: Get.textTheme.titleSmall!
                                              .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (fault.faultCount.value > 0) {
                                              fault.faultCount.value--;
                                              if (fault.faultCount.value == 0) {
                                                // Do something when fault count is 0
                                              }
                                            }
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            // Remove default padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            // Add border radius
                                          ),
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Obx(() {
                          return CustomCard(
                            child: Container(
                              height: cardHeight * 0.5,
                              width: cardWidth,
                              decoration: BoxDecoration(
                                color: fault.faultCount.value == 0
                                    ? Colors.teal.shade600
                                    : fault.faultCount.value < 5
                                        ? Colors.orange
                                        : MyColors.blueAccentColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    AppThemeInfo.borderRadius,
                                  ),
                                  bottomLeft: Radius.circular(
                                    AppThemeInfo.borderRadius,
                                  ),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                    text: fault.faultName,
                                    style: Get.textTheme.titleSmall!.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.shimmerHighlightColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            " (${fault.faultCount.value.toString()})",
                                        style:
                                            Get.textTheme.titleSmall!.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.shimmerHighlightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.saveFaults();
        },
        backgroundColor: MyColors.blueAccentColor, // Professional color
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}
