import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/end_line_stitching_qa_report_controller.dart';
import '../models/rowing_quality_endline_qa_stitching_model.dart';

class EndLineStitchingQAReport extends StatelessWidget {
  const EndLineStitchingQAReport({super.key});

  @override
  Widget build(BuildContext context) {
    final EndLineStitchingQAReportController controller = Get.put(EndLineStitchingQAReportController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title:     const Text("EndLine Daily Summary Report"),
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
                                EndLineQAStitchingReportListModel>(
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
                                final uniqueWorkers = controller.stitchingQAList
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
                                  EndLineQAStitchingReportListModel
                                      suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion.woNumber.toString(),
                                  ),
                                );
                              },
                              onSuggestionSelected:
                                  (EndLineQAStitchingReportListModel
                                      suggestion) {
                                controller.selected = suggestion;
                                controller.selectedOperator.value = suggestion;
                                controller.selectedWorkOrderController.text =
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
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await controller
                                    .pickDate(controller.fromDateController);
                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter();
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: controller.fromDateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    label: Text(
                                      "From Date",
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
                          const SizedBox(
                            width: 6.0,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await controller
                                    .pickDate(controller.toDateController);
                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter();
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: controller.toDateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    label: Text(
                                      "To Date",
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
                                    controller.selectedWorkOrderController
                                        .clear();
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
                                    EndLineQAStitchingReportListModel>(
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
                                        .stitchingQAList
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
                                      EndLineQAStitchingReportListModel
                                          suggestion) {
                                    return ListTile(
                                      title: Text(
                                        suggestion.woNumber.toString(),
                                      ),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (EndLineQAStitchingReportListModel
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
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller.pickDate(
                                        controller.fromDateController);
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: controller.fromDateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        label: Text(
                                          "From Date",
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
                              const SizedBox(
                                width: 6.0,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller
                                        .pickDate(controller.toDateController);
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: controller.toDateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        label: Text(
                                          "To Date",
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
                              int selectedLine = int.parse(controller
                                  .selectedLinSection.value
                                  .replaceAll(RegExp(r'[^0-9]'), ''));
                              controller.getRowingQualityEndLineQAStitching(
                                FromDate: controller.fromDateController.text,
                                ToDate: controller.toDateController.text,
                                WorkOrder:
                                    controller.selectedWorkOrderController.text,
                                Unit: selectedLine,
                              );
                              controller.getRowingQualityDHUListSummary(
                                FromDate: controller.fromDateController.text,
                                ToDate: controller.toDateController.text,
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
                              controller.fromDateController.clear();
                              controller.toDateController.clear();
                              controller.selectedWorkOrderController.clear();
                              controller.fromDateController.text =
                                  DateFormat('dd-MMM-yyyy')
                                      .format(DateTime.now());
                              controller.selectedLinSection.value = 'L15';
                              controller.getRowingQualityEndLineQAStitching(
                                FromDate: null,
                                ToDate: null,
                                WorkOrder: null,
                                Unit: int.parse(controller
                                    .selectedLinSection.value
                                    .replaceAll(RegExp(r'[^0-9]'), '')),
                              );
                              controller.getRowingQualityDHUListSummary(
                                FromDate: controller.fromDateController.text,
                                ToDate: controller.toDateController.text,
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
                        PdfPageFormat.a4, controller.stitchingQAList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                // const SizedBox(width: 4.0),
                // ElevatedButton.icon(
                //   onPressed: () async {
                //     if (controller.stitchingQAList.isNotEmpty) {
                //       final pdfData = await controller.generatePdf(
                //           PdfPageFormat.a4, controller.stitchingQAList);
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
                    if (controller.stitchingQAList.isNotEmpty) {
                      controller.exportToExcel(controller.stitchingQAList,
                          'EndLine_Stitching_QA_Report');

                      // Handle file path as needed
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
          Obx(() {
            if (controller.stitchingQAList.isNotEmpty && !controller.isLoading.value) {
              return Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            showCheckboxColumn: false,
                            horizontalMargin: 2,
                            columnSpacing: Get.width * 0.015,
                            dataRowHeight: 40,
                            border: TableBorder.all(width: 1.0, color: Colors.black),
                            columns: [
                              DataColumn(
                                  label: Expanded(
                                      child: Text("#",
                                          style: Get.textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w600)))),
                              DataColumn(
                                onSort: (_, ascending) {
                                  controller.sortData(
                                      'transactionDate', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData(
                                          'transactionDate', true);
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
                                  controller.sortData('line', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('line', true);
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
                                  controller.sortData('woNumber', ascending);
                                },

                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('woNumber', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("W/O#",
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
                                  controller.sortData('offLinepcs', ascending);
                                },

                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('offLinepcs', true);
                                    },

                                    child: Row(
                                      children: [
                                        Text("Offline\nPcs#",
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

                              /// todo: ENdline
                              DataColumn(
                                onSort: (_, ascending) {
                                  controller.sortData('e1InspGarmentNo', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('e1InspGarmentNo', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("Checked\nPcs",
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
                                  controller.sortData('e1Faultpcs', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('e1Faultpcs', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("Def\nPcs",
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
                                  controller.sortData('e1Otherfaultpc', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('e1Otherfaultpc', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("Oth. Defect",
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
                                  controller.sortData('e1StichDhu', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('e1StichDhu', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("St. DHU %" ,
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
                                  controller.sortData('otherstch', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('otherstch', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("Oth. DHU %",
                                            style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                                        const Icon(Icons.arrow_drop_down),
                                        // Add your icon here
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// todo: For QMP
                              DataColumn(
                                onSort: (_, ascending) {
                                  controller.sortData('qMpInspGarmentNo', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qMpInspGarmentNo', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP\nChecked",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.deepOrangeAccent)),
                                        const Icon(Icons.arrow_drop_down),
                                        // Add your icon here
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                onSort: (_, ascending) {
                                  controller.sortData('qmpFaultpcs', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmpFaultpcs', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP\nDefPcs",
                                            style: Get.textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.deepOrangeAccent)),
                                        const Icon(Icons.arrow_drop_down),
                                        // Add your icon here
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                onSort: (_, ascending) {
                                  controller.sortData('qmpOtherfaultpc', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmpOtherfaultpc', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP\nOth. Def",
                                            style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.deepOrangeAccent)),
                                        const Icon(Icons.arrow_drop_down),
                                        // Add your icon here
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                onSort: (_, ascending) {
                                  controller.sortData('qmpStichDhu', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmpStichDhu', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP St.\nDHU %",
                                            style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.deepOrangeAccent)),
                                        const Icon(Icons.arrow_drop_down),
                                        // Add your icon here
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                onSort: (_, ascending) {
                                  controller.sortData('qmpOtherstch', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmpOtherstch', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP Oth.\nDHU %",
                                            style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.deepOrangeAccent)),
                                        const Icon(Icons.arrow_drop_down),
                                        // Add your icon here
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Row(
                                    children: [
                                      Text("Total Checked",
                                          style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.deepOrangeAccent)),
                                      const Icon(Icons.arrow_drop_down),
                                      // Add your icon here
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              controller.stitchingQAList.length,
                              (index) {
                                EndLineQAStitchingReportListModel bundleModel = controller.stitchingQAList[index];
                                var filteredList =  controller.dhuSummaryList.where((bundle) => bundle.woNumber == bundleModel.woNumber);
                                double totalProducedSum = filteredList.fold(0, (sum, bundle) => sum + bundle.elInspGarmentNo + bundle.qmInspGarmentNo);
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
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(serialNumber.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(controller.dateFormat.format(DateTime.parse(bundleModel.transactionDate.toString()))))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.line.toString(),))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.woNumber.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.offLinepcs.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.e2InspGarmentNo.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.e2Faultpcs.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.e2Otherfaultpc.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.e2StichDhu.toStringAsFixed(1)} %'))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.e2Otherstch.toStringAsFixed(1)} %'))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.qMpInspGarmentNo.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.qmpFaultpcs.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.qmpOtherfaultpc.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.qmpStichDhu.toStringAsFixed(1)} %'))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.qmpOtherstch.toStringAsFixed(1)} %'))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(totalProducedSum.toStringAsFixed(0)))),
                                  ],
                                );
                              },
                            ),
                          )),
                    ),
                  ),
                ),
              );
            } else if (controller.stitchingQAList.isEmpty &&
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
