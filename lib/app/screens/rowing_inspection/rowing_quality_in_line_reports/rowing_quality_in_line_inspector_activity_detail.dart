import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../../../app_assets/styles/my_colors.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../controllers/rowing_quality_in_line_inspector_activity_detail_controller.dart';
import '../models/rowing_quality_Inspector_Activity_Model.dart';

class InLineInspectorActivityDetail extends StatelessWidget {
  const InLineInspectorActivityDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final InLineInspectorActivityController controller = Get.put(InLineInspectorActivityController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily 7.0 InLine Inspector Activity Report"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.width > 600 ? 100.0 : 140.0,
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
                          const SizedBox(width: 6.0),
                          Expanded(
                            child:
                                TypeAheadFormField<InspectorActivityListModel>(
                              direction: AxisDirection.down,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                enabled: true,
                                keyboardType: TextInputType.number,
                                controller: controller.inspectorNameController,
                                decoration: const InputDecoration(
                                  hintText: 'Inspector',
                                  labelText: "Inspector",
                                  labelStyle: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                Set<String> uniqueWorkerIDs = {};
                                final uniqueMachine =
                                    controller.inspectorList.where((workOrder) {
                                  String workerID =
                                      workOrder.inspectername.toString();
                                  return workerID
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()) &&
                                      uniqueWorkerIDs.add(workerID);
                                }).toList();

                                return uniqueMachine;
                              },
                              itemBuilder: (context,
                                  InspectorActivityListModel suggestion) {
                                return ListTile(
                                  leading: const Icon(
                                    Icons.person_pin,
                                    size: 25.0,
                                    color: MyColors.primaryColor,
                                  ),
                                  title:
                                      Text(suggestion.inspectername.toString()),
                                );
                              },
                              onSuggestionSelected:
                                  (InspectorActivityListModel suggestion) {
                                controller.selected = suggestion;
                                controller.selectedOperator.value = suggestion;
                                controller.inspectorNameController.text =
                                    suggestion.inspectername.toString();

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
                            child:
                                TypeAheadFormField<InspectorActivityListModel>(
                              direction: AxisDirection.down,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                enabled: true,
                                keyboardType: TextInputType.number,
                                controller: controller.roundController,
                                decoration: const InputDecoration(
                                  hintText: 'Round',
                                  labelText: "Round",
                                  labelStyle: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                Set<String> uniqueWorkerIDs = {};
                                final uniqueMachine =
                                    controller.inspectorList.where((workOrder) {
                                  String workerID =
                                      workOrder.roundNo.toString();
                                  return workerID
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()) &&
                                      uniqueWorkerIDs.add(workerID);
                                }).toList();

                                return uniqueMachine;
                              },
                              itemBuilder: (context,
                                  InspectorActivityListModel suggestion) {
                                return ListTile(
                                  leading: const Icon(
                                    Icons.person_pin,
                                    size: 25.0,
                                    color: MyColors.primaryColor,
                                  ),
                                  title: Text(suggestion.roundNo.toString()),
                                );
                              },
                              onSuggestionSelected:
                                  (InspectorActivityListModel suggestion) {
                                controller.selected = suggestion;
                                controller.selectedOperator.value = suggestion;
                                controller.roundController.text =
                                    suggestion.roundNo.toString();

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
                            child: TypeAheadFormField<String>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: controller.typeAheadController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Sort By",
                                  labelStyle: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion),
                                );
                              },
                              onSuggestionSelected: (value) {
                                controller.typeAheadController.text =
                                    value ?? '';
                                controller.onSortOptionChanged(value);
                              },
                              suggestionsCallback: (pattern) {
                                return controller.sortingOptions.where(
                                    (option) => option
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()));
                              },
                            ),
                          )
                        ],
                      );
                    } else {
                      // Mobile view: 2 widgets in one row
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TypeAheadFormField<
                                    InspectorActivityListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller:
                                        controller.inspectorNameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Inspector',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueMachine = controller
                                        .inspectorList
                                        .where((workOrder) {
                                      String workerID =
                                          workOrder.inspectername.toString();
                                      return workerID.toLowerCase().contains(
                                              pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();

                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context,
                                      InspectorActivityListModel suggestion) {
                                    return ListTile(
                                      title: Text(
                                          suggestion.inspectername.toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (InspectorActivityListModel suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.inspectorNameController.text =
                                        suggestion.inspectername.toString();

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
                            height: 4,
                          ),
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
                                child: TypeAheadFormField<
                                    InspectorActivityListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller: controller.roundController,
                                    decoration: const InputDecoration(
                                      hintText: 'Round',
                                      labelText: "Round",
                                      labelStyle: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueMachine = controller
                                        .inspectorList
                                        .where((workOrder) {
                                      String workerID =
                                          workOrder.roundNo.toString();
                                      return workerID.toLowerCase().contains(
                                              pattern.toLowerCase()) &&
                                          uniqueWorkerIDs.add(workerID);
                                    }).toList();

                                    return uniqueMachine;
                                  },
                                  itemBuilder: (context,
                                      InspectorActivityListModel suggestion) {
                                    return ListTile(
                                      title:
                                          Text(suggestion.roundNo.toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (InspectorActivityListModel suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.roundController.text =
                                        suggestion.roundNo.toString();
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
                                  'Auto Filter ',
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
                              controller.getInspectorActivityDetail(
                                date: controller.dateController.text,
                                inspector:
                                    controller.inspectorNameController.text,
                                Round: int.tryParse(
                                    controller.roundController.text),
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
                                Icon(Icons.filter_alt_outlined),
                                SizedBox(
                                  width: 6,
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
                              controller.inspectorNameController.clear();
                              controller.lineNoController.clear();
                              controller.typeAheadController.clear();
                              controller.dateController.text =
                                  DateFormat('dd-MMM-yyyy')
                                      .format(DateTime.now());
                              controller.selectedLinSection.value = 'L15';
                              controller.getInspectorActivityDetail(
                                linSection: int.parse(controller
                                    .selectedLinSection.value
                                    .replaceAll(RegExp(r'[^0-9]'), '')),
                                date: controller.dateController.text,
                                inspector: null,
                                Round: null,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.filter_alt_off_outlined),
                                SizedBox(
                                  width: 6,
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
                // Add some spacing between buttons
                ElevatedButton.icon(
                  onPressed: () async {
                    final pdf = await controller.generatePdf(
                        PdfPageFormat.a4, controller.inspectorList);
                    await controller.previewPdf(pdf);
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
                // const SizedBox(width: 4.0),
                // ElevatedButton.icon(
                //   onPressed: () async {
                //     if (controller.inspectorList.isNotEmpty) {
                //       final pdfData = await controller.generatePdf(
                //           PdfPageFormat.a4, controller.inspectorList);
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
                    if (controller.inspectorList.isNotEmpty) {
                      controller.exportToExcel(controller.inspectorList,
                          'Daily 7.0 InLine Inspector Activity Report');
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
            if (controller.inspectorList.isNotEmpty &&
                !controller.isLoading.value) {
              return Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
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
                              controller.sortData('machineCode', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('machineCode', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "M/C#",
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
                              controller.sortData('woOrders', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('woOrders', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "W/O#",
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
                              controller.sortData('opsequence', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('opsequence', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Op Seq",
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
                                      "Operation Name",
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
                              controller.sortData('empOperatorCode', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('empOperatorCode', true);
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
                              controller.sortData('roundNo', ascending);
                            },
                            label: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.sortData('roundNo', true);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Round",
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
                                      "${"Insp Pcs"}/${'St Def'}/${'Other Def'} ",
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
                                      "Inspector",
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
                                      "Flag",
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
                          controller.inspectorList.length,
                          (index) {
                            InspectorActivityListModel rollsModel =
                                controller.inspectorList[index];
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
                                      controller.timeFormat.format(
                                          DateTime.parse(rollsModel
                                              .transactionDate
                                              .toString())),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                        Text(rollsModel.machineCode.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(rollsModel.woOrders.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                        Text(rollsModel.opsequence.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      rollsModel.operationname,
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
                                    child: Text(rollsModel.roundNo.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        rollsModel.inspGarmentNo.toString()),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(rollsModel.inspectername),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(rollsModel.flag),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(rollsModel.cFaults),
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
            } else if (controller.inspectorList.isEmpty &&
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
