import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/rowing_quality_end_line_bundle_inspection_reports_controller.dart';
import '../models/rowing_quality_end_line_bundle_reports.dart';
import '../widget/end_line_summary_report.dart';

class EndLineBundleInspectionReports extends StatelessWidget {
  const EndLineBundleInspectionReports({super.key});

  @override
  Widget build(BuildContext context) {
    final EndLineBundleInspectionReportsController controller = Get.put(EndLineBundleInspectionReportsController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title:  const Text("EndLine Inspection Report"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.width > 600 ? 100.0 : 160.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      // Desktop view: 4 widgets in one row
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: controller.selectedLinSection.value,
                                  onChanged: (String? newValue) {
                                    controller.selectedLinSection.value =
                                        newValue!;
                                    controller.selectedWorkOrderController
                                        .clear();
                                    controller.autoFilter();
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "Unit#",
                                    labelStyle: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              const SizedBox(
                                width: 6.0,
                              ),
                              Expanded(
                                child: TypeAheadFormField<
                                    EndLineBundleReportsListModel>(
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
                                      hintText: 'W/O#',
                                      labelText: "W/O#",
                                      labelStyle: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueMachine = controller.bundleList
                                        .where((workOrder) {
                                      String workerID =
                                          workOrder.woNumber.toString();
                                      return workerID.toLowerCase().contains(
                                              pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();
                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context,
                                      EndLineBundleReportsListModel
                                          suggestion) {
                                    return ListTile(
                                        title: Text(
                                            suggestion.woNumber.toString()));
                                  },
                                  onSuggestionSelected:
                                      (EndLineBundleReportsListModel
                                          suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.selectedWorkOrderController
                                        .text = suggestion.woNumber.toString();
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 6.0,
                              ),
                              Obx(() => Expanded(
                                    child: DropdownButtonFormField(
                                      value: controller.selectedEndLine.value,
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          if (newValue == 'All') {
                                            newValue = 'EndLine';
                                          }
                                          controller.selectedEndLine.value =
                                              newValue;
                                          controller.autoFilter();
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: "Select EndLine",
                                        labelStyle: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      items: [
                                        const DropdownMenuItem<String>(
                                          value: 'All',
                                          child: Text('All'),
                                        ),
                                        ...controller.endLineName
                                            .map<DropdownMenuItem<String>>(
                                          (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          },
                                        ).toList(),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                width: 6.0,
                              ),
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
                                        label: Text(
                                          "Date",
                                          style: TextStyle(
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        hintText: "Date",
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
                            ],
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
                                child: DropdownButtonFormField(
                                  value: controller.selectedLinSection.value,
                                  onChanged: (String? newValue) {
                                    controller.selectedLinSection.value =
                                        newValue!;
                                    controller.autoFilter();
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "Unit#",
                                    labelStyle: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              const SizedBox(
                                width: 6.0,
                              ),
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
                                        label: Text(
                                          "Date",
                                          style: TextStyle(
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        hintText: "Date",
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
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Obx(() => Expanded(
                                    child: DropdownButtonFormField(
                                      value: controller.selectedEndLine.value,
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          if (newValue == 'All') {
                                            newValue = 'EndLine';
                                          }
                                          controller.selectedEndLine.value =
                                              newValue;
                                          controller.autoFilter();
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: "Select EndLine",
                                        labelStyle: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      items: [
                                        const DropdownMenuItem<String>(
                                          value: 'All',
                                          child: Text('All'),
                                        ),
                                        ...controller.endLineName
                                            .map<DropdownMenuItem<String>>(
                                          (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          },
                                        ).toList(),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                width: 6.0,
                              ),
                              Expanded(
                                child: TypeAheadFormField<
                                    EndLineBundleReportsListModel>(
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
                                      hintText: 'W/O#',
                                      labelText: "W/O#",
                                      labelStyle: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueMachine = controller.bundleList
                                        .where((workOrder) {
                                      String workerID =
                                      workOrder.woNumber.toString();
                                      return workerID.toLowerCase().contains(
                                          pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();
                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context,
                                      EndLineBundleReportsListModel
                                      suggestion) {
                                    return ListTile(
                                        title: Text(
                                            suggestion.woNumber.toString()));
                                  },
                                  onSuggestionSelected:
                                      (EndLineBundleReportsListModel
                                  suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.selectedWorkOrderController
                                        .text = suggestion.woNumber.toString();
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
                              controller.getEndLineBundleInspection(
                                date: controller.dateController.text,
                                workOrder:
                                    controller.selectedWorkOrderController.text,
                                endLine: controller.selectedEndLine.value,
                                line: int.parse(controller
                                    .selectedLinSection.value
                                    .replaceAll(RegExp(r'[^0-9]'), '')),
                              );
                              controller.getRowingQualityDHUList(
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
                              // Clear filter values and set defaults
                              controller.selectedWorkOrderController.clear();
                              controller.dateController.text =
                                  DateFormat('dd-MMM-yyyy')
                                      .format(DateTime.now());
                              controller.selectedLinSection.value = 'L15';

                              // Set the dropdown value to 'All'
                              controller.selectedEndLine.value = 'All';

                              // Call API with updated values
                              controller.getEndLineBundleInspection(
                                date: controller.dateController.text,
                                endLine: controller.selectedEndLine.value,
                                workOrder: null,
                                line: int.parse(controller
                                    .selectedLinSection.value
                                    .replaceAll(RegExp(r'[^0-9]'), '')),
                              );
                              controller.getRowingQualityDHUList(
                                date: controller.dateController.text,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.filter_alt_off_outlined),
                                SizedBox(width: 8),
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
                        PdfPageFormat.a4, controller.bundleList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                // const SizedBox(width: 4.0),
                // ElevatedButton.icon(
                //   onPressed: () async {
                //     if (controller.bundleList.isNotEmpty) {
                //       final pdfData = await controller.generatePdf(
                //           PdfPageFormat.a4, controller.bundleList);
                //       await Printing.layoutPdf(
                //           onLayout: (format) => Future.value(pdfData));
                //     } else {
                //       Get.snackbar(
                //         "Message",
                //         'Try Again',
                //         snackPosition: SnackPosition.BOTTOM,
                //       );
                //     }
                //   },
                //   icon: const Icon(Icons.print),
                //   label: const Text('Print Report'),
                // ),
                const SizedBox(width: 4.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (controller.bundleList.isNotEmpty) {
                      controller.exportToExcel(
                          controller.bundleList, 'EndLine_Inspection_Report');
                    } else {
                      Get.snackbar(
                        "Message",
                        'No data to export',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  icon: const Icon(Icons.file_download),
                  label: const Text('Export Excel'),
                ),
              ],
            ),
          ),
          Obx(
            () => EndLineSummaryReport(
              dhuSummaryList: controller.dhuList,
              isLoading: controller.isLoading.value,
              dateFormat: controller.timeFormat,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Obx(() {
            if (controller.bundleList.isNotEmpty &&
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
                      child: DataTable(
                        showCheckboxColumn: false,
                        horizontalMargin: 2,
                        columnSpacing: Get.width * 0.015,
                        dataRowHeight: 40,
                        border:
                            TableBorder.all(width: 1.0, color: Colors.black),
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
                              controller.sortData('transDate', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('transDate', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Time",
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
                              controller.sortData('lineNo', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('lineNo', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Line#",
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
                              controller.sortData('enDlineNo', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('enDlineNo', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "EndLine/Checked By",
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
                              controller.sortData('woNumber', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('woNumber', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "W/O#",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Obx(() {
                                      return controller.isListReversed.value
                                          ? const Icon(Icons.arrow_drop_up)
                                          : const Icon(Icons.arrow_drop_down);
                                    })
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('bundleNo', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('bundleNo', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Bundle #",
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
                              controller.sortData('bundleQty', ascending);
                              controller.sortData('checkedQty', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('bundleQty', true);
                                  controller.sortData('checkedQty', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Bundle Qty/\nChecked Qty",
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
                              controller.sortData('defQty', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('defQty', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Defective\nQty",
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
                              controller.sortData('faults', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('faults', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Defect\nDetail",
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
                              controller.sortData('bundlestatus', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('bundlestatus', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Bundle\nStatus",
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
                              controller.bundleList.length,
                              (index) {
                                EndLineBundleReportsListModel bundleModel =
                                    controller.bundleList[index];
                                int serialNumber = index + 1;
                                List<Color> rowColors = [
                                  const Color(0xffe5f7f1),
                                  Colors.white
                                ];
                                controller.totalBundle.value = 0;
                                controller.totalFaultSum.value = 0;
                                controller.totalChecked.value = 0;
                                for (EndLineBundleReportsListModel bundleModel in controller.bundleList) {
                                  controller.totalFaultSum.value += bundleModel.defQty;
                                  controller.totalBundle.value += 1;
                                  controller.totalChecked.value += bundleModel.checkedQty;
                                }
                                Color rowColor = rowColors[index % rowColors.length];
                                return DataRow(
                                  color: MaterialStateColor.resolveWith(
                                      (states) => rowColor),
                                  cells: [
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(serialNumber.toString()),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.timeFormat.format(
                                              DateTime.parse(bundleModel
                                                  .transDate
                                                  .toString())),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                            Text(bundleModel.lineNo.toString()),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            "${bundleModel.enDlineNo.toString()} / ${bundleModel.employeeName.toString()}"),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          bundleModel.woNumber,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            bundleModel.bundleNo.toString()),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "${bundleModel.bundleQty.toString()} / ${bundleModel.checkedQty.toString()}"),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (bundleModel.defQty > 0) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Defect Detail"),
                                                    content: Text(bundleModel
                                                        .faults
                                                        .toString()),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text(
                                                            "Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text(
                                                            "Proceed"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {}
                                          },
                                          child: Text(
                                            bundleModel.defQty.toString(),
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: bundleModel.defQty > 0
                                                    ? Colors.blue
                                                    : Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(bundleModel.faults),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:Text(
                                          bundleModel.bundleQty.toString() == bundleModel.checkedQty.toString()
                                              ? 'Complete'
                                              : 'Skipped',
                                          style: TextStyle(
                                            color: bundleModel.bundleQty.toString() == bundleModel.checkedQty.toString()
                                                ? Colors.black // Set text color to black if complete
                                                : Colors.red,  // Set text color to red if skipped
                                          ),
                                        )

                                      ),
                                    ),
                                  ],
                                );
                              },
                            ) +
// Adding a DataRow to display the sums
                            [
                              DataRow(
                                cells: [
                                  const DataCell(Text('')),
                                  const DataCell(Text('')),
                                  const DataCell(Text('')),
                                  const DataCell(Text('')),
                                  const DataCell(Text('')),
                                  DataCell(
                                    Text(
                                      'Total Bundle:  ${controller.totalBundle.value.toString()}',
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                   DataCell(
                                     Text(
                                    'Total Checked:  ${controller.totalChecked.value.toString()}',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),),
                                  DataCell(
                                    Container(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Total Defective QTY: ${controller.totalFaultSum.value.toStringAsFixed(0)}',
                                          style: Get.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const DataCell(Text('')),
                                  const DataCell(Text('')),
                                ],
                              ),
                            ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (controller.bundleList.isEmpty &&
                controller.isLoading.value) {
              return const ShimmerForRollList();
            }
            return const Center(
              child: Text(
                "No Data Found!",
              ),
            );
          }),
        ],
      ),
    );
  }
}
