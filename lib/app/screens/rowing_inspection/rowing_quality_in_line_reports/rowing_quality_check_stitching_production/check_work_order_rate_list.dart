import 'package:combined_fabrics_limited/app/screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_producntion_models/check_work_order_rate_list_models.dart';
import 'package:combined_fabrics_limited/app/screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_production_controllers/check_work_order_rate_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';

import '../../../fabric_inspection/shimmer/rolls_shimmer.dart';

class CheckWorkOrderRateList extends StatelessWidget {
  const CheckWorkOrderRateList({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckWorkOrderRateListController controller = Get.put(CheckWorkOrderRateListController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Order Rate List"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final pdf = await controller.generatePdf(PdfPageFormat.a4, controller.inLineProductionRateList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Obx(() {
              if (controller.inLineProductionRateList.isNotEmpty &&
                  !controller.isLoading.value) {
                return Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          showCheckboxColumn: false,
                          horizontalMargin: 2,
                          columnSpacing: Get.width * 0.015,
                          dataRowHeight: 40,
                          columns: [
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  "#",
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('woDetails', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('woDetails', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "W/O#",
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('operationname', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('operationname', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Operation",
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('rate', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('rate', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Rate",
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('gRate', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('gRate', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "G-Rate",
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('headname', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('headname', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "HeadName",
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('department', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('department', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Department",
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('remarks', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('remarks', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Remarks",
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('status', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('status', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Status",
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('operationType', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('operationType', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Operation\nType",
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            controller.inLineProductionRateList.length,
                                (index) {
                                  CheckWorkOrderRateListModel bundleModel = controller.inLineProductionRateList[index];
                              int serialNumber = index + 1;
                              List<Color> rowColors = [
                                const Color(0xffe5f7f1),
                                Colors.white
                              ];
                              Color rowColor =
                              rowColors[index % rowColors.length];
                              return DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (states) => rowColor),
                                cells: [
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        serialNumber.toString(),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                       bundleModel.woDetails.toString(),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        bundleModel.operationname,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(bundleModel.rate.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(bundleModel.gRate.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(bundleModel.headname),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(bundleModel.department.toString()), // Display only one digit after the decimal point
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                      Text(bundleModel.remarks.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                            bundleModel.status.toString(),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                      Text(bundleModel.operationType.toString()),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (controller.inLineProductionRateList.isEmpty &&
                  controller.isLoading.value) {
                return const ShimmerForRollList();
              }
              return const Center(
                child: Text(
                  "No Data Found!",
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
