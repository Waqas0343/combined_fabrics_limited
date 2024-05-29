import 'package:combined_fabrics_limited/app/screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_producntion_models/rowing_quality_work_order_summary_report_model.dart';
import 'package:combined_fabrics_limited/app/screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_production_controllers/check_work_order_stitching_summary_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';

import '../../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../../models/rowing_quality_inline_inspection_form_model.dart';

class CheckWorkOrderStitchingSummaryReport extends StatelessWidget {
  const CheckWorkOrderStitchingSummaryReport({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckWorkOrderWorkOrderSummaryController controller =
        Get.put(CheckWorkOrderWorkOrderSummaryController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Order Summary Report"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TypeAheadFormField<
                          RowingQualityInlineInspectionFormListModel>(
                        direction: AxisDirection.down,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          enabled: true,
                          keyboardType: TextInputType.number,
                          controller: controller.selectedWorkOrderController,
                          decoration: const InputDecoration(
                            hintText: 'W/O #',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          Set<int> uniqueOrderIds = {};
                          final uniqueOrders =
                              controller.workerAndOrderList.where((workOrder) {
                            int orderId = workOrder.orderId;
                            return orderId
                                    .toString()
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()) &&
                                uniqueOrderIds.add(orderId);
                          }).toList();

                          return uniqueOrders;
                        },
                        itemBuilder: (context,
                            RowingQualityInlineInspectionFormListModel
                                suggestion) {
                          return ListTile(
                            title: Text(
                              suggestion.orderDescription.toString(),
                            ),
                          );
                        },
                        onSuggestionSelected:
                            (RowingQualityInlineInspectionFormListModel
                                suggestion) {
                          controller.selected = suggestion;
                          controller.selectedOperator.value = suggestion;
                          controller.selectedWorkOrderController.text =
                              suggestion.orderDescription.toString();
                          if (controller.autoFilterEnabled.value) {
                            controller.autoFilter();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
              if (controller.workOrderSummaryList.isNotEmpty) {
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
                        child: Column(
                          children: [
                            DataTable(
                              showCheckboxColumn: false,
                              horizontalMargin: 2,
                              columnSpacing: Get.width * 0.015,
                              dataRowHeight: 40,
                              columns: [
                                DataColumn(
                                  onSort: (_, ascending) {
                                    controller.sortData('woOrder', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData('woOrder', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "W/O#",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData('color', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData('color', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Color",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData('okPcs', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData('okPcs', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Ok Cut Pcs",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData(
                                        'inductStock', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData(
                                            'inductStock', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "ind\nstore",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData('printpcs', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData('printpcs', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "@Print/Emb",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData('lineId', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData('lineId', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Line",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData('lineId', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData('lineId', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Stitch Start Date",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData('lineId', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData('lineId', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Stitch End Date",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                            "Induction In",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData(
                                        'stichOutpcs', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData(
                                            'stichOutpcs', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Out",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData('wip', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData('wip', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "WIP",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                    controller.sortData(
                                        'checkedpcs', ascending);
                                  },
                                  label: Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sortData('checkedpcs', true);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Checked Pcs",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                            "EndLine\nSt.DHU%",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                            "Oth.\nDHU%",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
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
                                      RowingQualityWorkOrderSummaryListModel bundleModel = controller.workOrderSummaryList[index];
                                      List<Color> rowColors = [
                                        const Color(0xffe5f7f1),
                                        Colors.white
                                      ];
                                      controller.stitchDhuSum += bundleModel.stichDhu;
                                      controller.otherDhuSum += bundleModel.otherDhu;
                                      Color rowColor = rowColors[index % rowColors.length];
                                      return DataRow(
                                        color: MaterialStateColor.resolveWith(
                                            (states) => rowColor),
                                        cells: [
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                bundleModel.woOrder.toString(),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                bundleModel.color,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(bundleModel.okPcs
                                                  .toStringAsFixed(0)),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(bundleModel
                                                  .inductStock
                                                  .toStringAsFixed(0)),
                                            ),
                                          ),

                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  '${bundleModel.printpcs.toStringAsFixed(0)}/ ${bundleModel.emboridrypcs.toStringAsFixed(0)}'),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(bundleModel.lineId
                                                  .toString()),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.dateFormat.format(DateTime.parse(bundleModel.starttime.toString())),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.dateFormat.format(DateTime.parse(bundleModel.laststitchpctime.toString())),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(bundleModel.issuedpcs.toStringAsFixed(0)),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(bundleModel.stichOutpcs.toString()),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(bundleModel.wip.toStringAsFixed(0)),
                                            ),
                                          ),
                                          DataCell(
                                              Align(
                                                alignment:
                                                Alignment.centerLeft,
                                                child: Text(bundleModel.checkedpcs.toStringAsFixed(0)),
                                              )
                                          ),
                                          DataCell(
                                              Align(
                                                alignment:
                                                Alignment.centerLeft,
                                                child: Text('${bundleModel.stichDhu.toStringAsFixed(1)}%'),
                                              )
                                              ),
                                          DataCell(
                                              Align(
                                                alignment:
                                                Alignment.centerLeft,
                                                child: Text('${bundleModel.otherDhu.toStringAsFixed(1)}%'),
                                              )
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
                                                  '${controller.stitchDhuSum.toStringAsFixed(1)}%'),
                                            )
                                        ),
                                        DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  '${controller.otherDhuSum.toStringAsFixed(1)}%'),
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (controller.workOrderSummaryList.isEmpty && controller.isLoading.value) {
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
