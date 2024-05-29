import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/rowing_quality_inspector_summary_reports_controller.dart';
import '../models/rowing_quality_dhu_model.dart';

class EndLineInspectorSummaryReport extends StatelessWidget {
  const EndLineInspectorSummaryReport({super.key});

  @override
  Widget build(BuildContext context) {
    final EndLineInspectorSummaryReportController controller = Get.put(EndLineInspectorSummaryReportController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(

        title:  const Text("EndLine Date Wise Summary Reports"),
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
                            child: TypeAheadFormField<RowingQualityDHUListModel>(
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
                                final uniqueWorkers = controller.dhuSummaryList.where((workOrder) {
                                  String workerID = workOrder.woNumber;
                                  return workerID
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()) &&
                                      uniqueWorkerIDs.add(workerID);
                                }).toList();

                                return uniqueWorkers;
                              },
                              itemBuilder: (context,
                                  RowingQualityDHUListModel
                                  suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion.woNumber.toString(),
                                  ),
                                );
                              },
                              onSuggestionSelected: (RowingQualityDHUListModel
                              suggestion) {
                                controller.selected = suggestion;
                                controller.selectedOperator.value = suggestion;
                                controller.selectedWorkOrderController.text = suggestion.woNumber.toString();
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
                              Expanded(
                                child: TypeAheadFormField<RowingQualityDHUListModel>(
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
                                    final uniqueWorkers = controller.dhuSummaryList.where((workOrder) {
                                      String workerID =
                                      workOrder.woNumber.toString();
                                      return workerID.toLowerCase().contains(pattern.toLowerCase()) && uniqueWorkerIDs.add(workerID);
                                    }).toList();

                                    return uniqueWorkers;
                                  },
                                  itemBuilder: (context, RowingQualityDHUListModel
                                      suggestion) {
                                    return ListTile(
                                      title: Text(
                                        suggestion.woNumber.toString(),
                                      ),
                                    );
                                  },
                                  onSuggestionSelected: (RowingQualityDHUListModel suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value = suggestion;
                                    controller.selectedWorkOrderController.text = suggestion.woNumber.toString();
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
                              int selectedLine = int.parse(controller.selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
                              controller.getRowingQualityDHUListSummary(
                                FromDate: controller.fromDateController.text,
                                ToDate: controller.toDateController.text,
                                workOrder: controller.selectedWorkOrderController.text,
                                selectedLine: selectedLine,
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
                              DateTime threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
                              controller.fromDateController.text = controller.dateFormat.format(threeDaysAgo);
                              controller.toDateController.clear();
                              controller.selectedWorkOrderController.clear();
                              controller.toDateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.selectedLinSection.value = 'L15';
                              controller.getRowingQualityDHUListSummary(
                                FromDate: null,
                                ToDate: null,
                                workOrder: null,
                                selectedLine: int.parse(controller.selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
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
                    final pdf = await controller.generatePdf(PdfPageFormat.a4, controller.dhuSummaryList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                const SizedBox(width: 4.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (controller.dhuSummaryList.isNotEmpty) {
                      controller.exportToExcel(controller.dhuSummaryList, 'EndLine Date Wise Summary Reports');

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
            if (controller.dhuSummaryList.isNotEmpty && !controller.isLoading.value) {
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
                              DataColumn(label: Expanded(child: Text("#", style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)))),
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
                                  controller.sortData('elEmpid', ascending);
                                },

                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('elEmpid', true);
                                    },

                                    child: Row(
                                      children: [
                                        Text("EL EmpCode / Name",
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
                                  controller.sortData('elInspGarmentNo', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('elInspGarmentNo', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("EL Check Pcs",
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
                                        Text("EL Def Pcs",
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
                                  controller.sortData('elOtherfaultpc', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('elOtherfaultpc', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("EL S.D / S.DHU%",
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
                                  controller.sortData('elStichDhu', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('elStichDhu', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("EL O.D / O. DHU%" ,
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
                                  controller.sortData('qmInspectorName', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmInspectorName', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP Emp / Name",
                                            style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600,  color: Colors.deepOrangeAccent)),
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
                                  controller.sortData('qmInspGarmentNo', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmInspGarmentNo', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP Checked",
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
                                  controller.sortData('qmFaultpcs', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmFaultpcs', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP DefPcs",
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
                                  controller.sortData('qmStichDhu', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmStichDhu', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP S.D/S.DHU%",
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
                                  controller.sortData('qmOtherstchDhu', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmOtherstchDhu', true);
                                    },
                                    child: Row(
                                      children: [
                                        Text("QMP O.D /O.DHU%",
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
                                  controller.sortData('qmOtherstchDhu', ascending);
                                },
                                label: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.sortData('qmOtherstchDhu', true);
                                    },
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
                              ),

                            ],
                            rows: List<DataRow>.generate(
                              controller.dhuSummaryList.length,
                                  (index) {
                                RowingQualityDHUListModel bundleModel = controller.dhuSummaryList[index];
                                var filteredList =  controller.dhuSummaryList.where((bundle) => bundle.woNumber == bundleModel.woNumber);
                                double totalBundleQtySum = filteredList.fold(0, (sum, bundle) => sum + bundle.elBundleQty + bundle.qmBundleQty);
                                double totalProducedSum = filteredList.fold(0, (sum, bundle) => sum + bundle.elInspGarmentNo + bundle.qmInspGarmentNo);
                                int serialNumber = index + 1;
                                List<Color> rowColors = [
                                  const Color(0xffe5f7f1),
                                  Colors.white
                                ];
                                Color rowColor = rowColors[index % rowColors.length];
                                return DataRow(
                                  color: MaterialStateColor.resolveWith((states) => rowColor),
                                  cells: [
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(serialNumber.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.line.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.woNumber.toString(),))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.elEmpid.toString()}/${bundleModel.elInspectorName.toString()}'))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.elInspGarmentNo.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.elFaultpcs.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.elStichfaultpc.toString()}/${bundleModel.elStichDhu.toStringAsFixed(1)}%'))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.elOtherfaultpc.toString()}/${bundleModel.elOtherstchDhu..toStringAsFixed(1)}%'))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.qmEmpid.toString()}/${bundleModel.qmInspectorName.toString()}'))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.qmInspGarmentNo.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text(bundleModel.qmFaultpcs.toString()))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.qmStichfaultpc.toString()}/${bundleModel.qmStichDhu.toStringAsFixed(1)}%'))),
                                    DataCell(Align(alignment: Alignment.centerLeft, child: Text('${bundleModel.qmOtherfaultpc.toString()}/${bundleModel.qmOtherstchDhu.toStringAsFixed(1)}%'))),
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
            } else if (controller.dhuSummaryList.isEmpty &&
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
