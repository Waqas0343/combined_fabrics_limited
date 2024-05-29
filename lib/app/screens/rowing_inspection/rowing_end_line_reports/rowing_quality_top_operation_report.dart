import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/rowing_quality_top_operation_controller.dart';
import '../models/rowing_quality_top_operation_model.dart';
import '../widget/end_line_summary_report.dart';

class RowingQualityTopOperationInDayReport extends StatelessWidget {
  const RowingQualityTopOperationInDayReport({super.key});

  @override
  Widget build(BuildContext context) {
    final RowingQualityTopOperationController controller = Get.put(RowingQualityTopOperationController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(

        title:  const Text("EndLine Top Defective Operation In Day"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.width > 600 ? 110.0 : 160.0,
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
                                    controller.workOrderController.clear();
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
                                  items: controller.lineSectionName.map<DropdownMenuItem<String>>((String value) {
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
                                child: TypeAheadFormField<RowingQualityTopOperationListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    final uniqueMachine = controller.operatorProductionList.where((workOrder) {
                                      String workerID = workOrder.wo0Rder.toString();
                                      return workerID.toLowerCase().contains(pattern.toLowerCase()) && uniqueWorkerIDs.add(workerID);}).toList();
                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context, RowingQualityTopOperationListModel suggestion) {
                                    return ListTile(
                                      title: Text(
                                        suggestion.wo0Rder,
                                      ),
                                    );
                                  },
                                  onSuggestionSelected: (RowingQualityTopOperationListModel suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperation.value = suggestion;
                                    controller.workOrderController.text = suggestion.wo0Rder;
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
                                    await controller.pickDate(controller.dateController);
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
                              const SizedBox(
                                width: 6.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  controller: controller.defectiveFaultController,
                                  onFieldSubmitted: (String newValue) {
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter(); // Call your auto-filter function here
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "",
                                    labelText: 'Defect QTY',
                                    labelStyle: TextStyle(fontSize: 12, color: Colors.deepOrangeAccent),
                                    filled: true,
                                    counterText: "",
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
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller.pickDate(controller.dateController);
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
                                          "From Date",
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
                              const SizedBox(
                                width: 6.0,
                              ),
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
                                  items: controller.lineSectionName.map<DropdownMenuItem<String>>((String value) {
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
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  controller: controller.defectiveFaultController,
                                  onFieldSubmitted: (String newValue) {
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter(); // Call your auto-filter function here
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "",
                                    labelText: 'Defect QTY',
                                    labelStyle: TextStyle(fontSize: 12, color: Colors.deepOrangeAccent),
                                    filled: true,
                                    counterText: "",
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
                                child: TypeAheadFormField<RowingQualityTopOperationListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    Set<int> uniqueOrderIds = {};
                                    final uniqueOrders = controller.operatorProductionList.where((workOrder) {
                                      int orderId = int.parse(workOrder.wo0Rder);
                                      return orderId.toString().toLowerCase().contains(pattern.toLowerCase()) && uniqueOrderIds.add(orderId);
                                    }).toList();

                                    return uniqueOrders;
                                  },
                                  itemBuilder: (context, RowingQualityTopOperationListModel suggestion) {
                                    return ListTile(
                                        title: Text(suggestion.wo0Rder.toString()));
                                  },
                                  onSuggestionSelected: (RowingQualityTopOperationListModel suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperation.value = suggestion;
                                    controller.workOrderController.text = suggestion.wo0Rder.toString();
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
                                    activeColor: Colors.deepOrangeAccent, // Set the color of the checkbox
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
                              controller.getRowingQualityTopOperatorReport(
                                Date: controller.dateController.text,
                                Unit: controller.selectedLinSection.value,
                                endline: controller.selectedEndLine.value,
                                WorkOrder: controller.workOrderController.text,
                                defectiveFault: int.parse(controller.defectiveFaultController.text),
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
                                Text('Apply Filter',
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
                              controller.dateController.clear();
                              controller.selectedLinSection.value = 'L15';
                              controller.selectedEndLine.value = 'All';
                              controller.workOrderController.clear();
                              controller.defectiveFaultController.clear();
                              controller.dateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.getRowingQualityTopOperatorReport(
                                Date: controller.dateController.text,
                                Unit: 'L15',
                                endline: 'All',
                                WorkOrder: null,
                                defectiveFault: null,
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
                    final pdf = await controller.generatePdf(PdfPageFormat.a4, controller.operatorProductionList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                const SizedBox(width: 4.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (controller.operatorProductionList.isNotEmpty) {
                      controller.exportToExcel(controller.operatorProductionList, 'In_Line_Status_Reports');
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
                              controller.sortData('date', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('date', true);
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
                              controller.sortData('wo0Rder', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('wo0Rder', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "W/O",
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
                              controller.sortData('endLineNo', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('endLineNo', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "EndLine#",
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
                              controller.sortData('operationValue', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('operationValue', true);
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
                              controller.sortData('deffects', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('deffects', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Fault",
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
                              controller.sortData('oprFrequncy', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('oprFrequncy', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Frequency",
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
                          controller.operatorProductionList.length,
                              (index) {
                                RowingQualityTopOperationListModel bundleModel = controller.operatorProductionList[index];
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
                                      controller.dateFormat.format(DateTime.parse(bundleModel.date.toString())),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(bundleModel.lineNo.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(bundleModel.wo0Rder.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: bundleModel.endLineNo == 2
                                        ? const Text('EndLine')
                                        : const Text('QMP'),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(bundleModel.operationValue),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    Text(bundleModel.deffects.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(bundleModel.oprFrequncy.toString()),
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
        ],
      ),
    );
  }
}
