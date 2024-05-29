import 'package:combined_fabrics_limited/app/screens/fabric_inspection/shimmer/rolls_shimmer.dart';
import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/app_theme_info.dart';
import '../../routes/app_routes.dart';
import 'controllers/fabric_inspection_list_controller.dart';
import 'models/rolls_model.dart';

class FabricInspectionListScreen extends StatelessWidget {
  const FabricInspectionListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final FabricInspectionListController controller = Get.put(FabricInspectionListController());
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text("Fabric Inspection"),
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
                                    text: "${controller.table}  ",
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
                                    text: "${controller.shift}",
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
                                ],
                              ),
                            ),
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            // Adjust the height as needed
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(AppThemeInfo.borderRadius),
                  ),
                  fillColor: Colors.white,
                  isCollapsed: true,
                  hintStyle: Get.textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade400,
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                  suffixIcon: controller.hasSearchText.value
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 20.0,
                          ),
                          onPressed: () {
                            controller.searchController.clear();
                            Get.focusScope?.unfocus();
                            controller.applyFilter();
                          },
                        )
                      : null,
                ),
                onFieldSubmitted: (text) => controller.applyFilter(),
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.applyFilter,
          child: ListView(
            padding: const EdgeInsets.all(
              16.0,
            ),
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColors.greenLight,
                    width: 3.0,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: [
                            Text(
                              'Work Order:',
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              controller.workOrder.toString(),
                              style: Get.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Color:',
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              controller.colorParam.toString(),
                              maxLines: 1,
                              style: Get.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'DiaGG:',
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              controller.diaGG.toString(),
                              style: Get.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Fabric:',
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              controller.fabricParam.toString(),
                              maxLines: 1,
                              style: Get.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Total Rolls:',
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              controller.rolls.toString(),
                              style: Get.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'EcruKgs:',
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              controller.ecruKgs.toString(),
                              style: Get.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Finishing Kg:',
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              controller.kgs.toString(),
                              style: Get.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Obx(() {
                List<RollsListModel> notInspectedList = controller.rollsList.where((roll) => roll.inspStatus == 'Not Inspected').toList();
                List<RollsListModel> inspectedList = controller.rollsList.where((roll) => roll.inspStatus == 'Inspected').toList();
                if (notInspectedList.isNotEmpty || inspectedList.isNotEmpty) {
                  return Column(
                    children: [
                      if (notInspectedList.isNotEmpty)
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Not Inspected Rolls",
                                style: Get.textTheme.titleSmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              child: DataTable(
                                showCheckboxColumn: false,
                                horizontalMargin: 10,
                                columnSpacing: Get.width * 0.045,
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Serial.No.",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Rolls No",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Received Kg",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Inspection Status",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Issue Date To FID",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Issuance No",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Ecru Kg",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  notInspectedList.length,
                                  (index) {
                                    RollsListModel rollsModel = notInspectedList[index];
                                    int serialNumber = index + 1;
                                    List<Color> rowColors = [
                                      const Color(0xffe5f7f1),
                                      Colors.white
                                    ];
                                    Color rowColor = rowColors[index % rowColors.length];
                                    return DataRow(
                                      color: MaterialStateColor.resolveWith(
                                          (states) => rowColor),
                                      cells: [
                                        DataCell(
                                          Text(
                                            serialNumber.toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                           "${rollsModel.rollNo} - ${rollsModel.rollCat}",
                                            style: Get.textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: MyColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            rollsModel.kgs.toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(rollsModel.inspStatus ?? ''),
                                        ),
                                        DataCell(
                                          Text(
                                            rollsModel.issuedDateTime ?? '',
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                              rollsModel.issuanceNo.toString()),
                                        ),
                                        DataCell(
                                          Text(rollsModel.ecruKgs.toString()),
                                        ),
                                      ],
                                      onSelectChanged: (isSelected) {
                                        if (isSelected != null && isSelected) {
                                          Get.toNamed(
                                            AppRoutes.fabricInspectionFaults,
                                            arguments: {
                                              'lotNo': controller.lotNoParam,
                                              'color': controller.colorParam,
                                              'fabric': controller.fabricParam,
                                              'work order':
                                                  controller.workOrder,
                                              'rpStatus': controller.rpStatus,
                                              'DiaGG': controller.diaGG,
                                              'rolls': controller.rolls,
                                              'kg': controller.kgs,
                                              'EcruKgs': controller.ecruKgs,
                                              'model': rollsModel,
                                            },
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 5,
                              color: MyColors.yellow,
                            ),
                          ],
                        ),
                      if (inspectedList.isNotEmpty)
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Inspected Rolls",
                                style: Get.textTheme.titleSmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primaryColor,
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showCheckboxColumn: false,
                                horizontalMargin: 10,
                                columnSpacing: Get.width * 0.045,
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Serial.No.",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Rolls No",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Received Kg",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Inspection Status",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Issue Date To FID",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Issuance No",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "Inspected By",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  inspectedList.length,
                                  (index) {
                                    RollsListModel rollsModel =
                                        inspectedList[index];
                                    int serialNumber = index + 1;
                                    // Define a list of colors for each row
                                    List<Color> rowColors = [
                                      const Color(0xffe5f7f1),
                                      Colors.white
                                    ];

                                    // Get the color for the current row
                                    Color rowColor =
                                        rowColors[index % rowColors.length];
                                    return DataRow(
                                      color: MaterialStateColor.resolveWith(
                                          (states) => rowColor),
                                      cells: [
                                        DataCell(
                                          Text(
                                            serialNumber.toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${rollsModel.rollNo} - ${rollsModel.rollCat}",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: MyColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            rollsModel.kgs.toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(rollsModel.inspStatus ?? ''),
                                        ),
                                        DataCell(
                                          Text(
                                            rollsModel.issuedDateTime ?? '',
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                              rollsModel.issuanceNo.toString()),
                                        ),
                                        DataCell(
                                          Text(rollsModel.inspectedBy ?? ''),
                                        ),
                                      ],
                                      onSelectChanged: (isSelected) {
                                        if (isSelected != null && isSelected) {
                                          Get.toNamed(
                                            AppRoutes.fabricInspectionFaults,
                                            arguments: {
                                              'lotNo': controller.lotNoParam,
                                              'color': controller.colorParam,
                                              'fabric': controller.fabricParam,
                                              'work order': controller.workOrder,
                                              'rpStatus': controller.rpStatus,
                                              'model': rollsModel,
                                            },
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 5,
                            ),
                          ],
                        ),
                    ],
                  );
                }
                return const SizedBox();
              }),
              Obx(() {
                if (controller.rollsList.isEmpty &&
                    !controller.isLoading.value) {
                  return const Center(
                    child: Text(
                      'There is No Data About this Lot!',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              if (controller.rollsList.isEmpty && controller.isLoading.value)
                const ShimmerForRollList(),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      );
    });
  }
}
