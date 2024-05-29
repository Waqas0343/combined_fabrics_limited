import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../../../app_assets/styles/my_colors.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/in_line_flag_report_controller.dart';
import '../models/rowing_quality_flag_color_model.dart';
import '../models/rowing_quality_in_line_flag_with_dhu_report.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';

class InLineFlagReport extends StatelessWidget {
  const InLineFlagReport({super.key});

  @override
  Widget build(BuildContext context) {
    final InLineFlagReportsController controller = Get.put(InLineFlagReportsController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title:   const Text("Daily 7.0 Flag Report Detail"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.width > 600 ? 160.0 : 160.0,
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
                                    controller.selectedLinSection.value = newValue!;
                                    controller.autoFilter();
                                    controller.getRowingQualityInlineInspectionFormList(newValue);
                                  },
                                  hint: const Text("Unit"),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor:
                                    Colors.white, // Set the background color here
                                  ),
                                  items: controller.lineSectionName
                                      .map<DropdownMenuItem<String>>((String value) {
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
                                child: TypeAheadFormField<RowingQualityInlineInspectionFormListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration: TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.workOrderController,
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
                                    controller.selectedOperatorAccordingToUnit = suggestion;
                                    controller.selectOperatorAccordingToUnit.value = suggestion;
                                    controller.workOrderController.text =
                                        suggestion.orderDescription.toString();

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
                                child: TypeAheadFormField<RowingQualityInlineInspectionFormListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.empCodeController,
                                    decoration: const InputDecoration(
                                      hintText: 'EMP#',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueMachine = controller.workerAndOrderList.where((workOrder) {
                                      String workerID =
                                      workOrder.workerId.toString();
                                      return workerID.toLowerCase().contains(
                                          pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();

                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context,
                                      RowingQualityInlineInspectionFormListModel suggestion) {
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.person_pin,
                                        size: 25.0,
                                        color: MyColors.primaryColor,
                                      ),
                                      title: Text(suggestion.workerId
                                          .toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (RowingQualityInlineInspectionFormListModel suggestion) {
                                    controller.selectedOperatorAccordingToUnit = suggestion;
                                    controller.selectOperatorAccordingToUnit.value = suggestion;
                                    controller.empCodeController.text =
                                        suggestion.workerId.toString();

                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6.0,
                          ),
                          Row(
                            children: [
                              Obx(
                                    () => Expanded(
                                  child: DropdownButtonFormField<FlagColorListModel>(
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Flag",
                                      labelStyle: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: controller.selectedFlag.value,
                                    items: [
                                      const DropdownMenuItem<FlagColorListModel>(
                                        value: null,
                                        child: Text('All'),
                                      ),
                                      ...controller.flagColorList.map((department) {
                                        return DropdownMenuItem<FlagColorListModel>(
                                          value: department,
                                          child: Text(department.shortName),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: (newValue) {
                                      controller.selectedFlag.value = newValue;
                                      if (controller.autoFilterEnabled.value) {
                                        controller.autoFilter();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6.0,
                              ),
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
                                        hintText: "From Date",
                                        labelText: "From Date",
                                        labelStyle: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
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
                                        hintText: "To Date",
                                        labelText: "To Date",
                                        labelStyle: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
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
                                    controller.selectedLinSection.value = newValue!;
                                    controller.autoFilter();
                                    controller.getRowingQualityInlineInspectionFormList(newValue);
                                  },
                                  hint: const Text("Unit"),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor:
                                    Colors.white, // Set the background color here
                                  ),
                                  items: controller.lineSectionName
                                      .map<DropdownMenuItem<String>>((String value) {
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
                                child: TypeAheadFormField<RowingQualityInlineInspectionFormListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration: TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.workOrderController,
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
                                    controller.selectedOperatorAccordingToUnit = suggestion;
                                    controller.selectOperatorAccordingToUnit.value = suggestion;
                                    controller.workOrderController.text =
                                        suggestion.orderDescription.toString();

                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(
                                width: 4.0,
                              ),
                              Expanded(
                                child: TypeAheadFormField<RowingQualityInlineInspectionFormListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.empCodeController,
                                    decoration: const InputDecoration(
                                      hintText: 'EMP#',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueMachine = controller.workerAndOrderList.where((workOrder) {
                                      String workerID =
                                      workOrder.workerId.toString();
                                      return workerID.toLowerCase().contains(
                                          pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();

                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context,
                                      RowingQualityInlineInspectionFormListModel suggestion) {
                                    return ListTile(

                                      title: Text(suggestion.workerId
                                          .toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (RowingQualityInlineInspectionFormListModel suggestion) {
                                    controller.selectedOperatorAccordingToUnit = suggestion;
                                    controller.selectOperatorAccordingToUnit.value = suggestion;
                                    controller.empCodeController.text =
                                        suggestion.workerId.toString();

                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6.0,
                          ),
                          Row(
                            children: [
                              Obx(
                                    () => Expanded(
                                  child: DropdownButtonFormField<FlagColorListModel>(
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Flag",
                                      labelStyle: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: controller.selectedFlag.value,
                                    items: [
                                       DropdownMenuItem<FlagColorListModel>(
                                        value: null,
                                        child: Text('All',style: Get.textTheme.titleSmall),
                                      ),
                                      ...controller.flagColorList.map((department) {
                                        return DropdownMenuItem<FlagColorListModel>(
                                          value: department,
                                          child: Text(department.shortName),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: (newValue) {
                                      controller.selectedFlag.value = newValue;
                                      if (controller.autoFilterEnabled.value) {
                                        controller.autoFilter();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
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
                                width: 4.0,
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
                                    activeColor: Colors.deepOrangeAccent,
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
                                fromDate: controller.fromDateController.text,
                                todate: controller.toDateController.text,
                                empcode: controller.empCodeController.text,
                                opration: controller.operationController.text,
                                flags: controller.selectedFlag.value!.shortName,
                                linSection: int.parse(controller.selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
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
                              controller.empCodeController.clear();
                              controller.operationController.clear();
                              controller.workOrderController.clear();
                              controller.flagController.clear();
                              controller.selectedFlag.value = null;
                              controller.fromDateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.toDateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.selectedLinSection.value = 'L15';
                              controller.getRowingQualityFlagWithDhuReportList(
                                fromDate: controller.fromDateController.text,
                                todate: controller.fromDateController.text,
                                linSection: int.parse(controller.selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
                                flags: null,
                                empcode: null,
                                opration: null,
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
                    final pdf = await controller.generatePdf(PdfPageFormat.a4, controller.reportsFlagList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                // const SizedBox(width: 4.0),
                // ElevatedButton.icon(
                //   onPressed: () async {
                //     if (controller.reportsFlagList.isNotEmpty) {
                //       final pdfData = await controller.generatePdf(PdfPageFormat.a4, controller.reportsFlagList);
                //       await Printing.layoutPdf(onLayout: (format) => Future.value(pdfData));
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
                    if (controller.reportsFlagList.isNotEmpty) {
                      controller.exportToExcel(
                          controller.reportsFlagList, 'In_Line_Flag_Reports');
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
            if (controller.reportsFlagList.isNotEmpty && !controller.isLoading.value) {
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
                              controller.sortData(
                                  'lineNo', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData(
                                      'lineNo', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Unit#",
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
                              controller.sortData(
                                  'empoperationcode', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData(
                                      'empoperationcode', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Operator",
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
                              controller.sortData('inspectername', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('inspectername', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Emp Name",
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
                              controller.sortData('workorder', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('workorder', true);
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
                              controller.sortData('flag', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('flag', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Tag Type",
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
                              controller.sortData('inspGarmentNo', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('inspGarmentNo', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Total\nChecked",
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
                              controller.sortData('faultpices', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('faultpices', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Total\nFaults",
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
                              controller.sortData('dhu', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('dhu', true);
                                },

                                child: Row(
                                  children: [
                                    Text(
                                      "DHU%",
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
                              controller.sortData('cFaults', ascending);
                            },

                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('cFaults', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Faults",
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
                              controller.sortData('reasons', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('reasons', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Reason",
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
                          controller.reportsFlagList.length,
                              (index) {
                            RowingQualityInLineFlagWithDHUListModel
                            bundleModel =
                            controller.reportsFlagList[index];
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
                                      bundleModel.empOperatorCode.toString(),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(bundleModel.inspectername),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      bundleModel.woOrders,
                                    ),
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
                                      bundleModel.flag.toString().replaceAll('Red & Yellow', 'R/Y'),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        bundleModel.inspGarmentNo.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    Text(bundleModel.faultpcs.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('${bundleModel.dhu.toStringAsFixed(1)}%'),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 250, // Set the desired width here
                                    child: GestureDetector(
                                      onTap: () {
                                        if (bundleModel.cFaults.isNotEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Fault Detail'),
                                                content: SingleChildScrollView(
                                                  child: Text(bundleModel.cFaults.toString()),
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
                                      },
                                      child: Container(
                                        constraints: const BoxConstraints(maxHeight: 100.0),
                                        child: SingleChildScrollView(
                                          child: ExpansionTile(
                                            title: Text(
                                              bundleModel.cFaults.split(' ').take(2).join(' '),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Get.textTheme.titleSmall?.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                            onExpansionChanged: (expanded) {
                                              if (expanded) {
                                                if (bundleModel.cFaults.isNotEmpty) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text('Fault Detail'),
                                                        content: SingleChildScrollView(
                                                          child: Text(bundleModel.cFaults.toString()),
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
                                  SizedBox(
                                    width: 250, // Set the desired width here
                                    child: GestureDetector(
                                      onTap: () {
                                        if (bundleModel.reasons.isNotEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Fault Detail'),
                                                content: SingleChildScrollView(
                                                  child: Text(bundleModel.reasons.toString()),
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
                                      },
                                      child: Container(
                                        constraints: const BoxConstraints(maxHeight: 100.0),
                                        child: SingleChildScrollView(
                                          child: ExpansionTile(
                                            title: Text(
                                              bundleModel.reasons.split(' ').take(2).join(' '),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Get.textTheme.titleSmall?.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                            onExpansionChanged: (expanded) {
                                              if (expanded) {
                                                if (bundleModel.reasons.isNotEmpty) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text('Fault Detail'),
                                                        content: SingleChildScrollView(
                                                          child: Text(bundleModel.reasons.toString()),
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
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (controller.reportsFlagList.isEmpty &&
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
