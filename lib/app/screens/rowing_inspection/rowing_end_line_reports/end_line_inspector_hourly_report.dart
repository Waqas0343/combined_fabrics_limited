import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/end_line_inspector_hourly_report_controller.dart';
import '../models/rowing_end_line_inspector_hourly_report_model.dart';
import '../widget/end_line_summary_report.dart';

class EndLineInspectorHourlyReport extends StatelessWidget {
  const EndLineInspectorHourlyReport({super.key});

  @override
  Widget build(BuildContext context) {
    final RowingEndLineInspectorHourlyReportController controller = Get.put(RowingEndLineInspectorHourlyReportController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title:  const Text("EndLine Inspection Hourly Reports",
        ),
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
                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              value: controller.selectedLinSection.value,
                              onChanged: (String? newValue) {
                                controller.selectedLinSection.value = newValue!;
                                controller.workOrderController.clear();
                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter();
                                }
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
                                EndLineInspectorHourlyReportListModel>(
                              direction: AxisDirection.down,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                enabled: true,
                                keyboardType: TextInputType.number,
                                controller: controller.workOrderController,
                                decoration: const InputDecoration(
                                  hintText: 'W/O #',
                                  label: Text(
                                    "W/O #",
                                    style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                Set<String> uniqueWorkerIDs = {};
                                final uniqueWorkers = controller
                                    .hourlyReportList
                                    .where((workOrder) {
                                  String workerID =
                                      workOrder.woNumber.toString();
                                  return workerID
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()) &&
                                      uniqueWorkerIDs.add(workerID);
                                }).toList();
                                return uniqueWorkers;
                              },
                              itemBuilder: (context,
                                  EndLineInspectorHourlyReportListModel
                                      suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion.woNumber.toString(),
                                  ),
                                );
                              },
                              onSuggestionSelected:
                                  (EndLineInspectorHourlyReportListModel
                                      suggestion) {
                                controller.selected = suggestion;
                                controller.selectedOperator.value = suggestion;
                                controller.workOrderController.text =
                                    suggestion.woNumber.toString();
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
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
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
                              const SizedBox(
                                width: 6.0,
                              ),
                              Expanded(
                                child: TypeAheadFormField<
                                    EndLineInspectorHourlyReportListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.workOrderController,
                                    decoration: const InputDecoration(
                                      hintText: 'W/O #',
                                      label: Text(
                                        "W/O #",
                                        style: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueWorkers = controller
                                        .hourlyReportList
                                        .where((workOrder) {
                                      String workerID =
                                          workOrder.woNumber.toString();
                                      return workerID.toLowerCase().contains(
                                              pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();
                                    return uniqueWorkers;
                                  },
                                  itemBuilder: (context,
                                      EndLineInspectorHourlyReportListModel
                                          suggestion) {
                                    return ListTile(
                                      title: Text(
                                        suggestion.woNumber.toString(),
                                      ),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (EndLineInspectorHourlyReportListModel
                                          suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.workOrderController.text =
                                        suggestion.woNumber.toString();
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
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
                                          controller.selectedEndLine.value = newValue;
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
                              controller.getRowingQualityFlagWithDhuReportList(
                                  date: controller.dateController.text,
                                  workOrder: controller.workOrderController.text,
                                  endLine: controller.endLineController.text,
                                  Unit: int.parse(controller.selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')));
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
                              controller.workOrderController.clear();
                              controller.dateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.selectedLinSection.value = 'L15';
                              controller.selectedEndLine.value = 'All';
                              controller.getRowingQualityFlagWithDhuReportList(date: controller.dateController.text,
                                  endLine: 'All',
                                  workOrder: null,
                                  Unit: int.parse(controller.selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')));
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
                        PdfPageFormat.a4, controller.hourlyReportList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                // const SizedBox(width: 4.0),
                // ElevatedButton.icon(
                //   onPressed: () async {
                //     if (controller.hourlyReportList.isNotEmpty) {
                //       final pdfData = await controller.generatePdf(
                //           PdfPageFormat.a4, controller.hourlyReportList);
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
                    if (controller.hourlyReportList.isNotEmpty) {
                      controller.exportToExcel(controller.hourlyReportList,
                          'EndLine_Inspection_Hourly_Reports');
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
                ()=> EndLineSummaryReport(
              dhuSummaryList: controller.dhuList,
              isLoading: controller.isLoading.value, dateFormat: controller.timeFormat,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: ShimmerForRollList(), // or any loading indicator
              );
            } else if (controller.hourlyReportList.isEmpty) {
              return const Center(
                child: Text("No Data Found!"),
              );
            } else {
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
                        border: TableBorder.all(width: 1.0, color: Colors.black),
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
                                    Text("Date",
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
                                    const Icon(Icons.arrow_drop_down),
                                    // Add your icon here
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('timeRound', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('timeRound', true);
                                },
                                child: Row(
                                  children: [
                                    Text("Time",
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
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
                                    Text("Line#",
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
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
                                    Text("Inspection#",
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
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
                                    Text("W/O",
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
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
                                  // controller.reverseList();
                                },
                                child: Row(
                                  children: [
                                    Text("W/O Hourly Output",
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
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
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('bundleQty', true);
                                },
                                child: Row(
                                  children: [
                                    Text("Bundle\nQTY",
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        )),
                                    const Icon(Icons.arrow_drop_down),
                                    // Add your icon here
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('checkedQty', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('checkedQty', true);
                                },
                                child: Row(
                                  children: [
                                    Text("Checked\nQTY",
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
                                    const Icon(Icons.arrow_drop_down),
                                    // Add your icon here
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('faultpcs', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('faultpcs', true);
                                },
                                child: Row(
                                  children: [
                                    Text("Fault\nPcs",
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
                                    const Icon(Icons.arrow_drop_down),
                                    // Add your icon here
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          controller.hourlyReportList.length,
                          (index) {
                            EndLineInspectorHourlyReportListModel reportModel = controller.hourlyReportList[index];
                            int serialNumber = index + 1;
                            List<Color> rowColors = [const Color(0xffe5f7f1), Colors.white];
                            controller.totalFaultSum.value = 0;
                            for (EndLineInspectorHourlyReportListModel bundleModel in controller.hourlyReportList) {
                              controller.totalFaultSum.value += bundleModel.faultpcs;
                            }
                            Color rowColor = rowColors[index % rowColors.length];
                            return DataRow(
                              color: MaterialStateColor.resolveWith((states) => rowColor),
                              cells: [
                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(serialNumber.toString()))),
                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(controller.dateFormat.format(DateTime.parse(reportModel.transDate.toString()))))),
                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.timeRound))),
                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.lineNo.toString()))),
                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.enDlineNo.toString()))),
                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.woNumber.toString()))),
                                const DataCell(Align(alignment: Alignment.centerLeft, child: Text(''))),
                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.bundleQty.toString()))),
                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.checkedQty.toString()))),
                                DataCell(Align(alignment: Alignment.centerLeft, child: Text("${reportModel.faultpcs}"))),
                              ],
                            );
                          },
                        )+
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
                                  DataCell(
                                    Container(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Total Fault Pcs: ${controller.totalFaultSum.value.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold// Set text color to contrast with background color
                                          ),
                                        ),
                                      ),
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
            }
          }),
        ],
      ),
    );
  }
}
