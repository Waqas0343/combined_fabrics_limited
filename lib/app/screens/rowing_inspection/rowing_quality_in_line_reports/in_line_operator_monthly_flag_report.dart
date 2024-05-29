import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../../../app_assets/styles/my_colors.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/rowing_quality_in_line_inspector_monthly_flag_report_controller.dart';
import '../models/rowing_operator_monthly_flag_report_model.dart';
import '../models/rowing_quality_flag_color_model.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';

class InLineOperatorMonthlyFlagReport extends StatelessWidget {
  const InLineOperatorMonthlyFlagReport({super.key});

  @override
  Widget build(BuildContext context) {
    final InLineInspectorMonthlyFlagReportController controller = Get.put(InLineInspectorMonthlyFlagReportController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("InLine Inspector Flag Report"),
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
                              Obx(
                                () => Expanded(
                                  child: DropdownButtonFormField<
                                      FlagColorListModel>(
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
                                      const DropdownMenuItem<
                                          FlagColorListModel>(
                                        value: null,
                                        child: Text('All'),
                                      ),
                                      ...controller.flagColorList
                                          .map((department) {
                                        return DropdownMenuItem<
                                            FlagColorListModel>(
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
                                child: TypeAheadFormField<
                                    RowingQualityInlineInspectionFormListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration: TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.operatorController,
                                    decoration: const InputDecoration(
                                      hintText: 'Operator #',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueWorkers =
                                    controller.workerAndOrderList.where((workOrder) {
                                      String workerID = workOrder.workerId.toString();
                                      return workerID
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();

                                    return uniqueWorkers;
                                  },
                                  itemBuilder: (context,
                                      RowingQualityInlineInspectionFormListModel
                                      suggestion) {
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.person_pin,
                                        size: 25.0,
                                        color: MyColors.primaryColor,
                                      ),
                                      title: Text(suggestion.workerId.toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (RowingQualityInlineInspectionFormListModel
                                  suggestion) {
                                    controller.selectedOperatorAccordingToUnit = suggestion;
                                    controller.selectOperatorAccordingToUnit.value = suggestion;
                                    controller.operatorController.text =
                                        suggestion.workerId.toString();

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
                                width: 6.0,
                              ),
                              Obx(
                                () => Expanded(
                                  child: DropdownButtonFormField<
                                      FlagColorListModel>(
                                    decoration: const InputDecoration(
                                      hintText: 'Flag',
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    value: controller.selectedFlag.value,
                                    items: [
                                      const DropdownMenuItem<FlagColorListModel>(
                                        value: null,
                                        child: Text('All'),
                                      ),
                                      ...controller.flagColorList
                                          .map((department) {
                                        return DropdownMenuItem<
                                            FlagColorListModel>(
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
                                child: TypeAheadFormField<
                                    RowingQualityInlineInspectionFormListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration: TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.operatorController,
                                    decoration: const InputDecoration(
                                      hintText: 'Operator #',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueWorkers =
                                    controller.workerAndOrderList.where((workOrder) {
                                      String workerID = workOrder.workerId.toString();
                                      return workerID
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();

                                    return uniqueWorkers;
                                  },
                                  itemBuilder: (context,
                                      RowingQualityInlineInspectionFormListModel
                                      suggestion) {
                                    return ListTile(
                                      title: Text(suggestion.workerId.toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (RowingQualityInlineInspectionFormListModel
                                  suggestion) {
                                    controller.selectedOperatorAccordingToUnit = suggestion;
                                    controller.selectOperatorAccordingToUnit.value = suggestion;
                                    controller.operatorController.text =
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
                                        labelStyle: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        hintText: "Date",
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
                          )
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
                              // Convert single string to list of strings
                              controller.getRowingQualityMonthlyFlagReport(
                                fromDate: controller.fromDateController.text,
                                toDate: controller.toDateController.text,
                                line: int.parse(controller.selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
                                flags: controller.selectedFlag.value!.shortName, // Pass the list of strings
                                operator: controller.operatorController.text,
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
                              controller.lineOrderController.clear();
                              controller.operatorController.clear();
                              controller.selectedFlag.value = null;
                              controller.fromDateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.toDateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.selectedLinSection.value = 'L15';
                              controller.getRowingQualityMonthlyFlagReport(
                                fromDate: '',
                                toDate: '',
                                line: int.parse(controller.selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
                                flags: null, // Pass an empty list for flags
                                operator: '',
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
                        PdfPageFormat.a4, controller.monthlyReportList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                // const SizedBox(width: 4.0),
                // ElevatedButton.icon(
                //   onPressed: () async {
                //     if (controller.monthlyReportList.isNotEmpty) {
                //       final pdfData = await controller.generatePdf(PdfPageFormat.a4, controller.monthlyReportList);
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
                    if (controller.monthlyReportList.isNotEmpty) {
                      controller.exportToExcel(controller.monthlyReportList,
                          'InLine Inspector Monthly Flag Detail Report');
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
            if (controller.monthlyReportList.isNotEmpty &&
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
                    child:  SingleChildScrollView(
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
                                  controller.sortData('transactionDate', true);
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
                                  'line', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('line', true);
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
                              controller.sortData(
                                  'red', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('red', true);
                                },

                                child: Row(
                                  children: [
                                    Text(
                                      "Flag",
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
                                  controller.sortData('empoperationcode', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "OperatorCode-Name",
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
                                  'operation', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('operation', true);
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
                              controller.sortData(
                                  'work-order', ascending);
                            },

                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('work-order', true);
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
                              controller.sortData(
                                  'redNoflg', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('redNoflg', true);
                                },

                                child: Row(
                                  children: [
                                    Text(
                                      "No. Red Flag",
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
                                  'yellowNoflg', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('yellowNoflg', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "No. Yellow Flag",
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
                                  'redNoflg', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('redNoflg', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Total Flag",
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
                                  'remarks', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('remarks', true);
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
                          controller.monthlyReportList.length,
                              (index) {
                            InLineInspectorMonthlyFlagReportListModel
                            bundleModel =
                            controller.monthlyReportList[index];
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
                                    child: Text(bundleModel.red.isNotEmpty ? bundleModel.red
                                        : bundleModel.yellow),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "${bundleModel.empOperatorCode} - ${bundleModel.employeeName} "),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        bundleModel.operationname.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        bundleModel.woDetails.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    Text(bundleModel.redNoflg.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        bundleModel.yellowNoflg.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text((bundleModel.redNoflg + bundleModel.yellowNoflg).toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    Text(bundleModel.remarks.toString()),
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
            } else if (controller.monthlyReportList.isEmpty &&
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
