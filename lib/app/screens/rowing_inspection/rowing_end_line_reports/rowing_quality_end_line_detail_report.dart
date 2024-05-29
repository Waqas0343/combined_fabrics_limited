import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/end_line_detail_report_controller.dart';
import '../models/rowing_quality_end_line_report_detail_model.dart';
import '../widget/end_line_summary_report.dart';

class EndLineDetailReport extends StatelessWidget {
  const EndLineDetailReport({super.key});

  @override
  Widget build(BuildContext context) {
    final EndLineDetailReportController controller = Get.put(EndLineDetailReportController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("End Line Detail Report"),
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
                                    controller.selectedLinSection.value =
                                        newValue!;
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
                                    RowingQualityReportDetailListModel>(
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
                                    final uniqueMachine = controller.reportList
                                        .where((workOrder) {
                                      String workerID =
                                          workOrder.wo0Rder.toString();
                                      return workerID.toLowerCase().contains(
                                              pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();
                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context,
                                      RowingQualityReportDetailListModel
                                          suggestion) {
                                    return ListTile(
                                      title: Text(
                                        suggestion.wo0Rder,
                                      ),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (RowingQualityReportDetailListModel
                                          suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.workOrderController.text =
                                        suggestion.wo0Rder;
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
                                    await controller
                                        .pickDate(controller.dateController);
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
                                  controller:
                                      controller.defectiveFaultController,
                                  decoration: InputDecoration(
                                    hintText: "",
                                    labelText: 'Defective QTy',
                                    labelStyle: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.deepOrangeAccent),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    counterText: "",
                                    suffixIcon: SizedBox(
                                      height: 45,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Obx(
                                          () => DropdownButton<String>(
                                            value: controller
                                                .selectedComparisonOperator
                                                .value,
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                controller
                                                    .setSelectedComparisonOperator(
                                                        newValue);
                                                controller
                                                    .autoFilter(); // Call autoFilter function after selecting a new value
                                              }
                                            },
                                            iconSize: 24,
                                            iconEnabledColor: Colors.red,
                                            underline: const SizedBox(),
                                            items: <String>[
                                              '>',
                                              '<',
                                              '=',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              IconData icon;
                                              switch (value) {
                                                case '>':
                                                  icon =
                                                      Icons.chevron_right_sharp;
                                                  break;
                                                case '<':
                                                  icon =
                                                      Icons.chevron_left_sharp;
                                                  break;
                                                case '=':
                                                  icon =
                                                      Icons.drag_handle_rounded;
                                                  break;
                                                default:
                                                  icon = Icons.error;
                                              }
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Row(
                                                  children: [
                                                    Icon(icon,
                                                        color: Colors.red),
                                                    // Add icon before text
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
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
                                width: 4.0,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller
                                        .pickDate(controller.dateController);
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
                                width: 4.0,
                              ),
                              Expanded(
                                child: TypeAheadFormField<
                                    RowingQualityReportDetailListModel>(
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
                                    Set<int> uniqueOrderIds = {};
                                    final uniqueOrders = controller.reportList
                                        .where((workOrder) {
                                      int orderId =
                                      int.parse(workOrder.wo0Rder);
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
                                      RowingQualityReportDetailListModel
                                      suggestion) {
                                    return ListTile(
                                        title: Text(
                                            suggestion.wo0Rder.toString()));
                                  },
                                  onSuggestionSelected:
                                      (RowingQualityReportDetailListModel
                                  suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.workOrderController.text =
                                        suggestion.wo0Rder.toString();
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
                                width: 4.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  controller:
                                  controller.defectiveFaultController,
                                  decoration: InputDecoration(
                                    hintText: "",
                                    labelText: 'Defective QTy',
                                    labelStyle: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.deepOrangeAccent),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    counterText: "",
                                    suffixIcon: SizedBox(
                                      height: 45,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(right: 8.0),
                                        child: Obx(
                                              () => DropdownButton<String>(
                                            value: controller
                                                .selectedComparisonOperator
                                                .value,
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                controller
                                                    .setSelectedComparisonOperator(
                                                    newValue);
                                                controller
                                                    .autoFilter(); // Call autoFilter function after selecting a new value
                                              }
                                            },
                                            iconSize: 24,
                                            iconEnabledColor: Colors.red,
                                            underline: const SizedBox(),
                                            items: <String>[
                                              '>',
                                              '<',
                                              '=',
                                            ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  IconData icon;
                                                  switch (value) {
                                                    case '>':
                                                      icon =
                                                          Icons.chevron_right_sharp;
                                                      break;
                                                    case '<':
                                                      icon =
                                                          Icons.chevron_left_sharp;
                                                      break;
                                                    case '=':
                                                      icon =
                                                          Icons.drag_handle_rounded;
                                                      break;
                                                    default:
                                                      icon = Icons.error;
                                                  }
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Row(
                                                      children: [
                                                        Icon(icon,
                                                            color: Colors.red),
                                                        // Add icon before text
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                        ),
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
                              controller.getRowingQualityEndLineDetailList(
                                Date: controller.dateController.text,
                                Unit: controller.selectedLinSection.value,
                                endline: controller.selectedEndLine.value,
                                WorkOrder: controller.workOrderController.text,
                                defectiveFault:
                                    controller.defectiveFaultController.text,
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
                              controller.dateController.clear();
                              controller.selectedLinSection.value = 'L15';
                              controller.selectedEndLine.value = 'All';
                              controller.workOrderController.clear();
                              controller.defectiveFaultController.clear();
                              controller.dateController.text =
                                  DateFormat('dd-MMM-yyyy')
                                      .format(DateTime.now());
                              controller.getRowingQualityEndLineDetailList(
                                Date: controller.dateController.text,
                                Unit: 'L15',
                                endline: 'All',
                                WorkOrder: null,
                                defectiveFault: null,
                              );
                              controller.getRowingQualityDHUListSummary(
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
                    final pdf = await controller.generatePdf(PdfPageFormat.a4, controller.reportList, controller.dhuSummaryList);

                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                const SizedBox(width: 4.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (controller.reportList.isNotEmpty) {
                      controller.exportToExcel(
                          controller.reportList, 'End_Line_Detail_Report');
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
              dhuSummaryList: controller.dhuSummaryList,
              isLoading: controller.isLoading.value,
              dateFormat: controller.timeFormat,
            ),
          ),
          Obx(() {
            if (controller.reportList.isEmpty && controller.isLoading.value) {
              return const Center(
                child: ShimmerForRollList(),
              );
            } else if (controller.reportList.isEmpty && !controller.isLoading.value) {
              return const Center(
                child: Text("No Data Found!"),
              );
            } else {
              return Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
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
                                controller.sortData('transactionDate', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('transactionDate', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Date Time",
                                        textAlign: TextAlign.right,
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
                                        "Inspection#",
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
                                controller.sortData('woorder', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('woorder', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "W/O",
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
                              label: Expanded(
                                child: Text(
                                  "Bundle# / Pcs /Checked",
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              onSort: (_, ascending) {
                                controller.sortData('faultpc', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('faultpc', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Def Pcs",
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
                                        "Def Detail",
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
                                controller.sortData('opretor', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('opretor', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Operator",
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
                                controller.sortData('machine', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('machine', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Machine",
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
                                controller.sortData('inspecter', ascending);
                              },
                              label: Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sortData('inspecter', true);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Insp Name",
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
                                controller.reportList.length,
                                (index) {
                                  RowingQualityReportDetailListModel reportModel = controller.reportList[index];
                                  int serialNumber = index + 1;
                                  List<Color> rowColors = [
                                    const Color(0xffe5f7f1),
                                    Colors.white
                                  ];
                                  Color rowColor = rowColors[index % rowColors.length];
                                  controller.totalFaultSum.value = 0;
                                  controller.totalBundle.value = 0;
                                  controller.totalChecked.value = 0;

                                  for (RowingQualityReportDetailListModel bundleModel in controller.reportList) {
                                    controller.totalFaultSum.value += bundleModel.faultpc;
                                    controller.totalBundle.value += 1;
                                    controller.totalChecked.value += bundleModel.checkpc;
                                  }


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
                                          child: Text("${controller.dateFormat.format(DateTime.parse(reportModel.transactionDate.toString()))}\t\t\t ${controller.timeFormat.format(DateTime.parse(reportModel.transactionDate.toString()))}",
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(reportModel.endLineNo.toString()),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(reportModel.wo0Rder.toString()),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("${reportModel.bundleNo.toString()} / ${reportModel.totalpcs} / ${reportModel.checkpc}"),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(reportModel.faultpc.toString()),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 250, // Set the desired width here
                                          child: GestureDetector(
                                            onTap: () {
                                              if (reportModel.faults.isNotEmpty) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text('Fault Detail'),
                                                      content: SingleChildScrollView(
                                                        child: Text(reportModel.faults.toString()),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child:
                                                              const Text('Close'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Container(
                                              constraints: const BoxConstraints(maxHeight: 100.0),
                                              child: SingleChildScrollView(
                                                child: ExpansionTile(
                                                  title: Text(
                                                    reportModel.faults.split(' ').take(2).join(' '),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Get.textTheme.titleSmall?.copyWith(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  onExpansionChanged: (expanded) {
                                                    if (expanded) {
                                                      if (reportModel.faults.isNotEmpty) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Fault Detail'),
                                                              content: SingleChildScrollView(
                                                                child: Text(reportModel.faults.toString()),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Get.back();
                                                                  },
                                                                  child: const Text('Close'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(reportModel.operationValue.toString()),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(reportModel.opretor.toString()),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(reportModel.machine.toString()),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(reportModel.inspecter.split('-').last),
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
                                    DataCell(
                                      Text(
                                        'Bundle / Checked:  ${controller.totalBundle.value.toString()} / ${controller.totalChecked.value.toString()}',
                                        style: Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Total Def Pcs: ${controller.totalFaultSum.value.toStringAsFixed(0)}',
                                          style: Get.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                  ],
                                ),
                              ],
                        ),
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
