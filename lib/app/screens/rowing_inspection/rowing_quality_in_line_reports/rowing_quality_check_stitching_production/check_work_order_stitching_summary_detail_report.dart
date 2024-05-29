import 'package:combined_fabrics_limited/app/screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_production_controllers/check_work_order_stitching_production_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';

import '../../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../../models/get_rowing_quality_work_order_stitching_dhu_model.dart';

class CheckWorkOrderStitchingSummaryDetailReport extends StatelessWidget {
  const CheckWorkOrderStitchingSummaryDetailReport({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckWorkOrderStitchingSummaryDetailReportController controller =
        Get.put(CheckWorkOrderStitchingSummaryDetailReportController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Order Summary Detail Report"),
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
                    final pdf = await controller.generatePdf(
                        PdfPageFormat.a4, controller.workOrderSummaryList);
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
              if (controller.workOrderSummaryList.isNotEmpty &&
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
                              onSort: (_, ascending) {
                                controller.sortData('time', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('time', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Date",
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
                                controller.sortData('unitNo', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('unitNo', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Line",
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
                                controller.sortData('issuedpcs', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('issuedpcs', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Color",
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
                                controller.sortData('issuedpcs', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('issuedpcs', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Induction",
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
                                controller.sortData('stichOut', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('stichOut', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "induct\nOut",
                                        style: Get.textTheme.titleSmall?.copyWith(
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
                                controller.sortData('checkedPcs', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('checkedPcs', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "EndLine QMP\nCheck Pcs",
                                        style: Get.textTheme.titleSmall?.copyWith(
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
                                controller.sortData('stichDhu', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('stichDhu', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "EL/QMP\nSt.DHU %",
                                        style: Get.textTheme.titleSmall?.copyWith(
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
                                controller.sortData('otherDhu', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('otherDhu', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "EndLine\nOther\nDHU %",
                                        style: Get.textTheme.titleSmall?.copyWith(
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
                                controller.workOrderSummaryList.length,
                                (index) {
                                  WorkOrderProductionStitchingListModel bundleModel = controller.workOrderSummaryList[index];
                                  List<Color> rowColors = [const Color(0xffe5f7f1), Colors.white];
                                  controller.stichDhuSum.value = 0;
                                  controller.otherDhuSum.value = 0;
                                  for (WorkOrderProductionStitchingListModel bundleModel in controller.workOrderSummaryList) {
                                    controller.stichDhuSum.value += bundleModel.stichDhu;
                                    controller.otherDhuSum.value += bundleModel.otherDhu;
                                  }
                                  Color rowColor = rowColors[index % rowColors.length];
                                  return DataRow(
                                    color: MaterialStateColor.resolveWith(
                                        (states) => rowColor),
                                    cells: [
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(controller.dateFormat
                                              .format(DateTime.parse(bundleModel
                                                  .time
                                                  .toString()))),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            bundleModel.unitNo
                                                .toStringAsFixed(0),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            bundleModel.colour
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(bundleModel.issuedpcs
                                              .toStringAsFixed(0)),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              bundleModel.stichOut.toString()),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child:
                                              Text('${bundleModel.checkedPcs}'),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              '${bundleModel.stichDhu.toStringAsFixed(1)} %'),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              '${bundleModel.otherDhu.toStringAsFixed(1)} %'),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ) +
                              [
                                DataRow(
                                  cells: [
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            'Total: ${controller.stichDhuSum.value.toStringAsFixed(1)}%'),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            'Total: ${controller.otherDhuSum.value.toStringAsFixed(1)}%'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (controller.workOrderSummaryList.isEmpty &&
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
