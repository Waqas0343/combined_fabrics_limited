import 'package:combined_fabrics_limited/app/screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_producntion_models/rowing_quality_check_operator_production_report_model.dart';
import 'package:combined_fabrics_limited/app/screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_production_controllers/rowing_quality_operator_production_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../../fabric_inspection/shimmer/rolls_shimmer.dart';

class CheckOperatorQuantityReport extends StatelessWidget {
  const CheckOperatorQuantityReport({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckOperatorQuantityReportController controller =
        Get.put(CheckOperatorQuantityReportController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Operator Production & Quantity Report"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.width > 600 ? 100.0 : 100.0,
          ),
          // Adjust the height as needed
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      // Desktop view: 4 widgets in one row
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await controller.pickFromDate();
                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter();
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: controller.dateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    hintText: "Date",
                                    labelText: "Date",
                                    labelStyle: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    fillColor: Colors.white,
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Expanded(
                            child: DropdownButtonFormField(
                              value: controller.selectedLinSection.value,
                              onChanged: (String? newValue) {
                                controller.selectedLinSection.value = newValue!;
                                controller.autoFilter();
                              },
                              hint: const Text("Unit"),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors
                                    .white, // Set the background color here
                              ),
                              items: controller.lineSectionName
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Expanded(
                            child: TypeAheadFormField<
                                RowingQualityCheckOperatorProductionReportListModel>(
                              direction: AxisDirection.down,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                enabled: true,
                                keyboardType: TextInputType.number,
                                controller:
                                    controller.selectedWorkOrderController,
                                decoration: const InputDecoration(
                                  hintText: 'W/O #',
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                Set<String> uniqueOrderIds = {};
                                final uniqueOrders = controller
                                    .operatorProductionList
                                    .where((workOrder) {
                                  String orderId = workOrder.woOrders;
                                  return orderId
                                          .toString()
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()) &&
                                      uniqueOrderIds.add(orderId);
                                }).toList();

                                return uniqueOrders;
                              },
                              itemBuilder: (context,
                                  RowingQualityCheckOperatorProductionReportListModel
                                      suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion.woOrders,
                                  ),
                                );
                              },
                              onSuggestionSelected:
                                  (RowingQualityCheckOperatorProductionReportListModel
                                      suggestion) {
                                controller.selected = suggestion;
                                controller.selectedOperator.value = suggestion;
                                controller.selectedWorkOrderController.text =
                                    suggestion.woOrders.toString();

                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter();
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Mobile view: 2 widgets in one row
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller.pickFromDate();
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: controller.dateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        hintText: "Date",
                                        labelText: "Date",
                                        labelStyle: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        fillColor: Colors.white,
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: controller.selectedLinSection.value,
                                  onChanged: (String? newValue) {
                                    controller.selectedLinSection.value =
                                        newValue!;
                                    controller.autoFilter();
                                  },
                                  hint: const Text("Unit"),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors
                                        .white, // Set the background color here
                                  ),
                                  items: controller.lineSectionName
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Expanded(
                                child: TypeAheadFormField<
                                    RowingQualityCheckOperatorProductionReportListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller:
                                        controller.selectedWorkOrderController,
                                    decoration: const InputDecoration(
                                      hintText: 'W/O #',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<int> uniqueOrderIds = {};
                                    final uniqueOrders = controller
                                        .operatorProductionList
                                        .where((workOrder) {
                                      int orderId =
                                          int.parse(workOrder.woOrders);
                                      return orderId
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  pattern.toLowerCase()) &&
                                          uniqueOrderIds.add(orderId);
                                    }).toList();

                                    return uniqueOrders;
                                  },
                                  itemBuilder: (context,
                                      RowingQualityCheckOperatorProductionReportListModel
                                          suggestion) {
                                    return ListTile(
                                      title: Text(
                                        suggestion.woOrders,
                                      ),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (RowingQualityCheckOperatorProductionReportListModel
                                          suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.selectedWorkOrderController
                                        .text = suggestion.woOrders.toString();

                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepOrangeAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Obx(
                                  () => Checkbox(
                                    value: controller.autoFilterEnabled.value,
                                    onChanged: (value) {
                                      controller.setAutoFilter(value ?? false);
                                    },
                                    activeColor: Colors
                                        .deepOrangeAccent, // Set the color of the checkbox
                                  ),
                                ),
                                Text(
                                  'Auto Filter',
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              controller
                                  .getRowingQualityOperatorProductionReport(
                                date: controller.dateController.text,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.filter_alt_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Apply Filter',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.dateController.text =
                                  DateFormat('dd-MMM-yyyy')
                                      .format(DateTime.now());
                              controller
                                  .getRowingQualityOperatorProductionReport(
                                date: controller.dateController.text,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.filter_alt_off_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Clear Filter',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        PdfPageFormat.a4, controller.operatorProductionList);
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
              if (controller.operatorProductionList.isNotEmpty &&
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
                          dataRowHeight: 50,
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
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverseList();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Date#",
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
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverseList();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Line#",
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
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverseList();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "OperatorName/Code",
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
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverseList();
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
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverseList();
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
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverseList();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Produce Pcs",
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
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverseList();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Produce Mint Time",
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
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverseList();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Flags",
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
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverseList();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "EndLine\nDHU%",
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
                              label: Expanded(
                                child: Text(
                                  "Flag Reason",
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            controller.operatorProductionList.length,
                            (index) {
                              RowingQualityCheckOperatorProductionReportListModel
                                  bundleModel =
                                  controller.operatorProductionList[index];
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
                                        controller.dateFormat.format(
                                            DateTime.parse(bundleModel
                                                .transactionDate
                                                .toString())),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        bundleModel.lineNo.toString(),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          bundleModel.listOperator.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Text(bundleModel.woOrders.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(bundleModel.operationname),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          bundleModel.producepcs.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          bundleModel.ageInMinutes.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        bundleModel.flagShortName
                                            .toString()
                                            .split(',')
                                            .map((word) =>
                                                word.trim().substring(0, 1))
                                            .join('/'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          '${bundleModel.enlineDhu.toStringAsFixed(1)}%'),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black87,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // Man cell
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.black87,
                                                    width: 1.0,
                                                  ),
                                                  bottom: BorderSide(
                                                    color: Colors.black87,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  serialNumber == 1
                                                      ? Text(
                                                          "Man",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                bundleModel.flagReason ==
                                                                        "Man"
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .normal,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  if (bundleModel.flagReason ==
                                                      "Man")
                                                    const Icon(Icons.check,
                                                        color: Colors.green)
                                                  else
                                                    const Icon(Icons.close,
                                                        color: Colors.red),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Machine cell
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.black87,
                                                    width: 1.0,
                                                  ),
                                                  bottom: BorderSide(
                                                    color: Colors.black87,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  serialNumber == 1
                                                      ? Text(
                                                          "Machine",
                                                          style: TextStyle(
                                                            fontWeight: bundleModel
                                                                        .flagReason ==
                                                                    "Machine"
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  if (bundleModel.flagReason ==
                                                      "Machine")
                                                    const Icon(Icons.check,
                                                        color: Colors.green)
                                                  else
                                                    const Icon(Icons.close,
                                                        color: Colors.red),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Material cell
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.black87,
                                                    width: 1.0,
                                                  ),
                                                  bottom: BorderSide(
                                                    color: Colors.black87,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  serialNumber == 1
                                                      ? Text(
                                                          "Material",
                                                          style: TextStyle(
                                                            fontWeight: bundleModel
                                                                        .flagReason ==
                                                                    "Material"
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  if (bundleModel.flagReason ==
                                                      "Material")
                                                    const Icon(Icons.check,
                                                        color: Colors.green)
                                                  else
                                                    const Icon(Icons.close,
                                                        color: Colors.red),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Method cell
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.black87,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  serialNumber == 1
                                                      ? Text(
                                                          "Method",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                bundleModel.flagReason ==
                                                                        "Method"
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .normal,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  if (bundleModel.flagReason ==
                                                      "Method")
                                                    const Icon(Icons.check,
                                                        color: Colors.green)
                                                  else
                                                    const Icon(Icons.close,
                                                        color: Colors.red),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
              } else if (controller.operatorProductionList.isEmpty &&
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
