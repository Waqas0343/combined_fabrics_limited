import 'package:combined_fabrics_limited/app/screens/rowing_inspection/widget/rowing_quality_report_summary_card_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../../../app_assets/styles/my_colors.dart';
import '../../../../app_assets/styles/my_images.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/in_line_status_report_controller.dart';
import '../models/rowing_quality_flag_color_model.dart';
import '../models/rowing_quality_in_line_status_report_model.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';

class InLineStatusReportsScreen extends StatelessWidget {
  const InLineStatusReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InLineStatusReportsController controller = Get.put(InLineStatusReportsController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily 7.0 Rounds & Flag Report"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.width > 600 ? 100.0 : 140.0,
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
                            child: DropdownButtonFormField(
                              value: controller.selectedLinSection.value,
                              onChanged: (String? newValue) {
                                controller.selectedLinSection.value = newValue!;
                                controller.autoFilter();
                                controller
                                    .getRowingQualityInlineInspectionFormList(
                                        newValue);
                              },
                              hint: const Text("Unit"),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white, // Set the background color here
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
                          Obx(
                            () => Expanded(
                              child:
                                  DropdownButtonFormField<FlagColorListModel>(
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
                          const SizedBox(width: 6.0),
                          Expanded(
                            child: TypeAheadFormField<
                                RowingQualityInlineInspectionFormListModel>(
                              direction: AxisDirection.down,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                enabled: true,
                                keyboardType: TextInputType.number,
                                controller: controller.machineController,
                                decoration: const InputDecoration(
                                  hintText: 'M/C #',
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                Set<String> uniqueWorkerIDs = {};
                                final uniqueMachine = controller
                                    .workerAndOrderList
                                    .where((workOrder) {
                                  String workerID =
                                      workOrder.machineId.toString();
                                  return workerID
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()) &&
                                      uniqueWorkerIDs.add(workerID);
                                }).toList();
                                return uniqueMachine;
                              },
                              itemBuilder: (context,
                                  RowingQualityInlineInspectionFormListModel
                                      suggestion) {
                                return ListTile(
                                  leading: ClipOval(
                                    child: SvgPicture.asset(
                                      MyImages.isMachine,
                                      height: 25.0,
                                    ),
                                  ),
                                  title: Text(suggestion.machineId.toString()),
                                );
                              },
                              onSuggestionSelected:
                                  (RowingQualityInlineInspectionFormListModel
                                      suggestion) {
                                controller.selectedOperatorAccordingToUnit =
                                    suggestion;
                                controller.selectOperatorAccordingToUnit.value =
                                    suggestion;
                                controller.machineController.text =
                                    suggestion.machineId.toString();

                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Expanded(
                            child: TypeAheadFormField<
                                RowingQualityInlineInspectionFormListModel>(
                              direction: AxisDirection.down,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                enabled: true,
                                keyboardType: TextInputType.number,
                                controller: controller.operatorController,
                                decoration: const InputDecoration(
                                  hintText: 'Emp Code #',
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                Set<String> uniqueWorkerIDs = {};
                                final uniqueWorkers = controller
                                    .workerAndOrderList
                                    .where((workOrder) {
                                  String workerID =
                                      workOrder.workerId.toString();
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
                                controller.selectedOperatorAccordingToUnit =
                                    suggestion;
                                controller.selectOperatorAccordingToUnit.value =
                                    suggestion;
                                controller.operatorController.text =
                                    suggestion.workerId.toString();

                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 6.0),
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
                                    controller
                                        .getRowingQualityInlineInspectionFormList(
                                            newValue);
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
                                    InLineStatusReportListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.machineController,
                                    decoration: const InputDecoration(
                                      hintText: 'M/C #',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueMachine = controller
                                        .inLineStatusList
                                        .where((workOrder) {
                                      String workerID =
                                          workOrder.machineCode.toString();
                                      return workerID.toLowerCase().contains(
                                              pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();

                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context,
                                      InLineStatusReportListModel suggestion) {
                                    return ListTile(
                                      leading: ClipOval(
                                        child: SvgPicture.asset(
                                          MyImages.isMachine,
                                          height: 25.0,
                                        ),
                                      ),
                                      title: Text(
                                          suggestion.machineCode.toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (InLineStatusReportListModel suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.machineController.text =
                                        suggestion.machineCode.toString();

                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4,),
                          Row(
                            children: [
                              Expanded(
                                child: TypeAheadFormField<
                                    InLineStatusReportListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.operatorController,
                                    decoration: const InputDecoration(
                                      hintText: 'EMP#',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueMachine = controller
                                        .inLineStatusList
                                        .where((workOrder) {
                                      String workerID =
                                          workOrder.empOperatorCode.toString();
                                      return workerID.toLowerCase().contains(
                                              pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();

                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context,
                                      InLineStatusReportListModel suggestion) {
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.person_pin,
                                        size: 25.0,
                                        color: MyColors.primaryColor,
                                      ),
                                      title: Text(suggestion.empOperatorCode
                                          .toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (InLineStatusReportListModel suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.operatorController.text =
                                        suggestion.empOperatorCode.toString();

                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 6.0),
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
                              List<String> flags = [
                                controller.selectedFlag.value?.colorHexCode ??
                                    ''
                              ];
                              controller.getRowingQualityMachineWithFlag(
                                linSection: int.parse(controller
                                    .selectedLinSection.value
                                    .replaceAll(RegExp(r'[^0-9]'), '')),
                                date: controller.dateController.text,
                                flags: flags,
                                machine: controller.machineController.text,
                                empCode: controller.operatorController.text,
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
                              controller.dateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.machineController.clear();
                              controller.operatorController.clear();
                              controller.selectedFlag.value = null;
                              controller.selectedLinSection.value = 'L15';
                              controller.getRowingQualityMachineWithFlag(
                                date: controller.dateController.text,
                                machine: null,
                                flags: [],
                                empCode: null,
                                linSection: int.parse(controller
                                    .selectedLinSection.value
                                    .replaceAll(RegExp(r'[^0-9]'), '')),
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
          vertical: 4,
        ),
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final pdf = await controller.generatePdf(PdfPageFormat.a4, controller.inLineStatusList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                const SizedBox(width: 4.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (controller.inLineStatusList.isNotEmpty) {
                      controller.exportToExcel(controller.inLineStatusList,
                          'In_Line_Status_Reports');
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
            if (controller.inLineStatusList.isNotEmpty) {
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
                              controller.sortData('transaction', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('transaction', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Date",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData(
                                  'employeoperatorcode', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData(
                                      'employeoperatorcode', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Oper\nCode",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('work_order', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('work_order', true);
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('sequence', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('sequence', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Op\nSeq",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('operation', ascending);
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
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('machine-code', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('machine-code', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "MC#",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
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
                                    Text(
                                      "Line",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
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
                                    Text(
                                      "Produce / Checked",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('flag-date', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('flag-date', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "EndLine\nStitching\nDHU %",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            onSort: (_, ascending) {
                              controller.sortData('flag-date', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('flag-date', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Last\nFlag\nTime",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Rounds 1, 2, 3, 4, 5",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          controller.inLineStatusList.length,
                          (index) {
                            InLineStatusReportListModel rollsModel =
                                controller.inLineStatusList[index];
                            int serialNumber = index + 1;
                            List<Color> rowColors = [
                              const Color(0xffe5f7f1),
                              Colors.white
                            ];
                            Color rowColor =
                                rowColors[index % rowColors.length];
                            Widget buildDataRow(
                                String machineCode,
                                String colorHexCode,
                                String hlfclr,
                                String flagName,
                                dynamic faultCount,
                                int round) {
                              final hasColor = colorHexCode.isNotEmpty;
                              return Container(
                                width: 50.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black87,
                                    width: 1.0,
                                  ),
                                  gradient: hasColor
                                      ? LinearGradient(
                                          colors: hlfclr.isEmpty
                                              ? [
                                                  Color(int.parse(
                                                      '0x$colorHexCode')),
                                                  Color(int.parse(
                                                      '0x$colorHexCode'))
                                                ]
                                              : [
                                                  Color(int.parse(
                                                      '0x${hlfclr.split('-').first}')),
                                                  Color(int.parse(
                                                      '0x${hlfclr.split('-').last}'))
                                                ],
                                          stops: const [0.5, 0.5],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )
                                      : null,
                                ),
                                child: hasColor
                                    ? GestureDetector(
                                        // Only make non-empty rounds clickable
                                        onTap: () async {
                                          await controller
                                              .getRowingQualityRoundDetailList(
                                                  machineCode, round);
                                          Get.dialog(
                                              const LiveReportInfoCard());
                                        },
                                        child: Center(
                                          child: Text(
                                            flagName,
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          'R$round',
                                        ),
                                      ),
                              );
                            }

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
                                          DateTime.parse(
                                              rollsModel.transactionDate)),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        rollsModel.empOperatorCode.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(rollsModel.woOrders),
                                  ),
                                ),
                                DataCell(
                                  Text(rollsModel.opsequence.toString()),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      rollsModel.operationname.toString(),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(rollsModel.machineCode),
                                  ),
                                ),

                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      rollsModel.lineNo.toString(),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                     '${rollsModel.prodpcs} / ${rollsModel.inspectgarmets.toStringAsFixed(0)}',
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('${rollsModel.dhuRoundwise.toString()} %'),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      controller.timeFormat.format(
                                          DateTime.parse(rollsModel.flagDate)),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      buildDataRow(
                                          rollsModel.machineCode,
                                          rollsModel.r1ColorHexCode,
                                          rollsModel.r1Hlfclr,
                                          rollsModel.r1FlagName,
                                          rollsModel.round1Faultccount,
                                          1),
                                      buildDataRow(
                                          rollsModel.machineCode,
                                          rollsModel.r2ColorHexCode,
                                          rollsModel.r2Hlfclr,
                                          rollsModel.r2FlagName,
                                          rollsModel.round2Faultccount,
                                          2),
                                      buildDataRow(
                                          rollsModel.machineCode,
                                          rollsModel.r3ColorHexCode,
                                          rollsModel.r3Hlfclr,
                                          rollsModel.r3FlagName,
                                          rollsModel.round3Faultccount,
                                          3),
                                      buildDataRow(
                                          rollsModel.machineCode,
                                          rollsModel.r4ColorHexCode,
                                          rollsModel.r4Hlfclr,
                                          rollsModel.r4FlagName,
                                          rollsModel.round4Faultccount,
                                          4),
                                      buildDataRow(
                                          rollsModel.machineCode,
                                          rollsModel.r5ColorHexCode,
                                          rollsModel.r5Hlfclr,
                                          rollsModel.r5FlagName,
                                          rollsModel.round5Faultccount,
                                          5),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (controller.inLineStatusList.isEmpty &&
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
