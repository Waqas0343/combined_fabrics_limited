import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../../app_assets/styles/my_images.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../app_widgets/custom_card.dart';
import '../../debug/debug_pointer.dart';
import '../../routes/app_routes.dart';
import '../../services/preferences.dart';
import '../fabric_inspection/shimmer/rolls_shimmer.dart';
import 'controllers/rowing_quality_check_persong_stitch_piece_controller.dart';
import 'models/rowing_quality_employee_stitch_pcs.dart';
import 'models/rowing_quality_inline_inspection_form_model.dart';
import 'widget/line_production_status_round_summary.dart';

class LiveFlagMarkForEachRoundTime extends StatelessWidget {
  const LiveFlagMarkForEachRoundTime({super.key});

  @override
  Widget build(BuildContext context) {
    final RowingQualityCheckPersonStitchPieceController controller =
    Get.put(RowingQualityCheckPersonStitchPieceController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Line Production Status"),
            const SizedBox(
              width: 50,
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: "Date : ",
                    style: Get.textTheme.titleLarge?.copyWith(
                      color: MyColors.shimmerHighlightColor,

                    ),

                    children: [
                      TextSpan(
                        text: "${controller.dateController.text}  ",
                        style: Get.textTheme.titleLarge?.copyWith(
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              value: controller.selectedLinSection.value,
                              onChanged: (String? newValue) {
                                controller.selectedLinSection.value = newValue!;
                                controller.selectedMachineController.clear();
                                controller.selectedWorkOrderController.clear();
                                controller.selectedEMPController.clear();
                                controller
                                    .getRowingQualityInlineInspectionFormList(
                                    newValue);
                                controller.autoFilter();
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
                                RowingQualityInlineInspectionFormListModel>(
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
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                Set<int> uniqueOrderIds = {};
                                final uniqueOrders = controller
                                    .workerAndOrderList
                                    .where((workOrder) {
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
                                controller.selected = suggestion;
                                controller.selectedOperator.value = suggestion;
                                controller.selectedWorkOrderController.text =
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
                            child: TypeAheadFormField<
                                RowingQualityInlineInspectionFormListModel>(
                              direction: AxisDirection.down,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                enabled: true,
                                keyboardType: TextInputType.number,
                                controller: controller.selectedEMPController,
                                decoration: const InputDecoration(
                                  hintText: 'Emp',
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                  ),
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
                                controller.selected = suggestion;
                                controller.selectedOperator.value = suggestion;
                                controller.selectedEMPController.text =
                                    suggestion.workerId.toString();
                                controller
                                    .autoFilter(); // Call autoFilter function here
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
                                controller:
                                controller.selectedMachineController,
                                decoration: const InputDecoration(
                                  hintText: 'M/C #',
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                  ),
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
                                controller.selected = suggestion;
                                controller.selectedOperator.value = suggestion;
                                controller.selectedMachineController.text =
                                    suggestion.machineId.toString();
                                controller
                                    .autoFilter(); // Call autoFilter function here
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
                      ///todo: Mobile view: 2 widgets in one row
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
                                    controller
                                        .getRowingQualityInlineInspectionFormList(
                                        newValue);
                                    controller.autoFilter();
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
                                    RowingQualityInlineInspectionFormListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller:
                                    controller.selectedEMPController,
                                    decoration: const InputDecoration(
                                      hintText: 'Emp',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(
                                        Icons.arrow_drop_down,
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueWorkers = controller
                                        .workerAndOrderList
                                        .where((workOrder) {
                                      String workerID =
                                      workOrder.workerId.toString();
                                      return workerID.toLowerCase().contains(
                                          pattern.toLowerCase()) &&
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
                                      title:
                                      Text(suggestion.workerId.toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (RowingQualityInlineInspectionFormListModel
                                  suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.selectedEMPController.text =
                                        suggestion.workerId.toString();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TypeAheadFormField<
                                    RowingQualityInlineInspectionFormListModel>(
                                  direction: AxisDirection.down,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                    autofocus: false,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    controller:
                                    controller.selectedMachineController,
                                    decoration: const InputDecoration(
                                      hintText: 'M/C #',
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: Icon(
                                        Icons.arrow_drop_down,
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    Set<String> uniqueWorkerIDs = {};
                                    final uniqueMachine = controller
                                        .workerAndOrderList
                                        .where((workOrder) {
                                      String workerID =
                                      workOrder.machineId.toString();
                                      return workerID.toLowerCase().contains(
                                          pattern.toLowerCase()) &&
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
                                      title:
                                      Text(suggestion.machineId.toString()),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (RowingQualityInlineInspectionFormListModel
                                  suggestion) {
                                    controller.selected = suggestion;
                                    controller.selectedOperator.value =
                                        suggestion;
                                    controller.selectedMachineController.text =
                                        suggestion.machineId.toString();
                                  },
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Expanded(
                                child: GestureDetector(
                                  onTap: controller.pickFromDate,
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
                        ],
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipOval(
                              child: SvgPicture.asset(
                                MyImages.isMachine,
                                height: 20.0,
                                color: MyColors.lightBorderColor,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Obx(
                                  () => Text(
                                "M/C: ${controller.countMachines.toString()}",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: MyColors.lightBorderColor,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Icon(
                              Icons.person_pin,
                              size: 20.0,
                              color: MyColors.lightBorderColor,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Obx(
                                  () => Text(
                                "Oper: ${controller.countOperators}",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: MyColors.lightBorderColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Platform.isAndroid
                     ? Expanded(
                       child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Align(
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
                                            value: controller
                                                .autoFilterEnabled.value,
                                            onChanged: (value) {
                                              controller
                                                  .setAutoFilter(value ?? false);
                                            },
                                            activeColor: Colors
                                                .deepOrangeAccent, // Set the color of the checkbox
                                          ),
                                        ),
                                        Text(
                                          'Auto Filter',
                                          style:
                                          Get.textTheme.titleSmall?.copyWith(
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
                                      controller.getRowingQualityEmployeeStitch(
                                        line: controller.selectedLinSection.value,
                                        date: controller.dateController.text,
                                        machine: controller
                                            .selectedMachineController.text,
                                        workOrder: controller
                                            .selectedWorkOrderController.text,
                                        empCode: int.tryParse(controller
                                            .selectedEMPController.text),
                                      );
                                      controller
                                          .getRowingQualityInLineProductionList(
                                        date: controller.dateController.text,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrangeAccent,
                                    ),
                                    child: const Text(
                                      'Apply Filter',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.selectedMachineController
                                          .clear();
                                      controller.selectedEMPController.clear();
                                      controller.selectedWorkOrderController
                                          .clear();
                                      controller.dateController.text =
                                          DateFormat('dd-MMM-yyyy')
                                              .format(DateTime.now());
                                      controller.getRowingQualityEmployeeStitch(
                                        date: controller.dateController.text,
                                        line: controller
                                            .selectedLinSection.value = 'L15',
                                        machine: null,
                                        workOrder: null,
                                        empCode: null,
                                      );
                                      controller
                                          .getRowingQualityInLineProductionList(
                                          date:
                                          controller.dateController.text);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrangeAccent,
                                    ),
                                    child: const Text(
                                      'Clear Filter',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                                           ),
                     )
                        :SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Align(
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
                                          value: controller
                                              .autoFilterEnabled.value,
                                          onChanged: (value) {
                                            controller
                                                .setAutoFilter(value ?? false);
                                          },
                                          activeColor: Colors
                                              .deepOrangeAccent, // Set the color of the checkbox
                                        ),
                                      ),
                                      Text(
                                        'Auto Filter',
                                        style:
                                        Get.textTheme.titleSmall?.copyWith(
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
                                    controller.getRowingQualityEmployeeStitch(
                                      line: controller.selectedLinSection.value,
                                      date: controller.dateController.text,
                                      machine: controller
                                          .selectedMachineController.text,
                                      workOrder: controller
                                          .selectedWorkOrderController.text,
                                      empCode: int.tryParse(controller
                                          .selectedEMPController.text),
                                    );
                                    controller
                                        .getRowingQualityInLineProductionList(
                                      date: controller.dateController.text,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrangeAccent,
                                  ),
                                  child: const Text(
                                    'Apply Filter',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.selectedMachineController
                                        .clear();
                                    controller.selectedEMPController.clear();
                                    controller.selectedWorkOrderController
                                        .clear();
                                    controller.dateController.text =
                                        DateFormat('dd-MMM-yyyy')
                                            .format(DateTime.now());
                                    controller.getRowingQualityEmployeeStitch(
                                      date: controller.dateController.text,
                                      line: controller
                                          .selectedLinSection.value = 'L15',
                                      machine: null,
                                      workOrder: null,
                                      empCode: null,
                                    );
                                    controller
                                        .getRowingQualityInLineProductionList(
                                        date:
                                        controller.dateController.text);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrangeAccent,
                                  ),
                                  child: const Text(
                                    'Clear Filter',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 0,
        ),
        children: [
          Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                        () {
                      if (controller.inLineProductionHourlyList.isEmpty) {
                        return const ShimmerForRollList();
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Work Order Hourly Summary',
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                            CustomCard(
                              margin: const EdgeInsets.only(top: 10.0),
                              color: Colors.deepOrange.shade100,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  horizontalMargin: 2,
                                  columnSpacing: Get.width * 0.015,
                                  dataRowHeight: 30,
                                  border: TableBorder.all(
                                      width: 1.0, color: Colors.black),
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'Work Order',
                                        style:
                                        Get.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: MyColors.blueAccentColor,
                                        ),
                                      ),
                                    ),
                                    ...controller.inLineProductionHourlyList[0]
                                        .hourlyData.keys
                                        .map((hour) =>
                                        DataColumn(label: Text(hour)))
                                        .toList(),
                                  ],
                                  rows: controller.inLineProductionHourlyList
                                      .map((data) {
                                    List<DataCell> cells = [
                                      DataCell(
                                        Text(
                                          data.workorder,
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: MyColors.blueAccentColor,
                                          ),
                                        ),
                                      ),
                                    ];
                                    cells.addAll(
                                      data.hourlyData.values.map(
                                            (value) => DataCell(
                                          Text(
                                            value != null
                                                ? value.toString()
                                                : '0',
                                          ),
                                        ),
                                      ),
                                    );
                                    return DataRow(cells: cells);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.alarm,
                          size: 20.0,
                          color: Colors.deepOrange,
                        ),
                        Obx(
                              () => Text(
                            'Last Refreshed: ${controller.timeFormat.format(DateTime.parse(controller.dateTime.value.toString()))}',
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrange,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.deepOrange,
                          ),
                          onPressed: () async {
                            await Get.dialog(
                              AlertDialog(
                                title: Text(
                                  'Select Refresh Time',
                                  style: Get.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: Obx(
                                      () => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CheckboxListTile(
                                        title: Text(
                                          '5 minute',
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        value: controller
                                            .userDashBoardValue.value ==
                                            5,
                                        onChanged: (value) {
                                          if (value != null) {
                                            controller.userDashBoardValue
                                                .value = value ? 5 : 0;
                                          }
                                        },
                                      ),
                                      CheckboxListTile(
                                        title: Text(
                                          '10 minutes',
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        value: controller
                                            .userDashBoardValue.value ==
                                            10,
                                        onChanged: (value) {
                                          if (value != null) {
                                            controller.userDashBoardValue
                                                .value = value ? 10 : 0;
                                          }
                                        },
                                      ),
                                      CheckboxListTile(
                                        title: Text(
                                          '15 minutes',
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        value: controller
                                            .userDashBoardValue.value ==
                                            15,
                                        onChanged: (value) {
                                          if (value != null) {
                                            controller.userDashBoardValue
                                                .value = value ? 15 : 0;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      if (controller.userDashBoardValue.value >
                                          0) {
                                        Get.find<Preferences>().setInt(
                                            Keys.flagDashBoardTime,
                                            controller
                                                .userDashBoardValue.value);
                                        controller.timer?.cancel();
                                        controller.timer = Timer.periodic(
                                          Duration(
                                              minutes: controller
                                                  .userDashBoardValue.value),
                                              (timer) {
                                            controller.timeFormat.format(
                                                DateTime.parse(controller
                                                    .dateTime
                                                    .toString()));
                                            controller
                                                .getRowingQualityEmployeeStitch();
                                          },
                                        );
                                        Get.back();
                                      } else {
                                        Debug.log('No duration selected');
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('OK'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Text(
                          'DashBoard Settings',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Obx(() {
                  if (controller.stitchPcsList.isNotEmpty &&
                      !controller.isLoading.value) {
                    Map<String, List<RowingQualityEmployeeStitchPcsListModel>>
                    groupedData = {};
                    for (var stitchPcs in controller.stitchPcsList) {
                      final opSeq = stitchPcs.opsequence;
                      groupedData[opSeq.toString()] ??= [];
                      groupedData[opSeq.toString()]!.add(stitchPcs);
                    }
                    String? previousWorkOrder;
                    List<Widget> cards = [];
                    groupedData.forEach(
                          (opSeq, groupedList) {
                        int totalStitchpcs = groupedList.fold(
                            0,
                                (previousValue, element) =>
                            previousValue + element.stichpcs);
                        Set<String> uniqueWorkOrders = groupedList
                            .map((stitchPcs) => stitchPcs.workorder)
                            .toSet();
                        cards.add(
                          CustomCard(
                            margin:
                            const EdgeInsets.only(top: 8.0, bottom: 12.0),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                      color: Colors.greenAccent,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Total : $totalStitchpcs',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0)),
                                      color: Colors.orangeAccent,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Op Seq: $opSeq',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      dense: true,
                                      minLeadingWidth: 0,
                                      contentPadding: const EdgeInsets.only(
                                          top: 16.0, left: 6.0, right: 0.0),
                                      horizontalTitleGap: 0,
                                      title: Padding(
                                        padding:
                                        const EdgeInsets.only(top: 4.0),
                                        child: RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 4.0),
                                                  child: Icon(
                                                    Icons.task_rounded,
                                                    size: 20.0,
                                                    color:
                                                    MyColors.primaryColor,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: groupedList
                                                    .map((stitchPcs) => stitchPcs.oprationName.toString()).toSet().join("\n"),
                                                style: Get.textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: MyColors.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  children: [
                                                    const WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            right: 4.0),
                                                        child: Icon(
                                                          Icons
                                                              .date_range_outlined,
                                                          size: 20.0,
                                                          color: MyColors
                                                              .greenLight,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: controller
                                                          .dateFormat
                                                          .format(groupedList[0]
                                                          .tRansdate),
                                                      style: Get
                                                          .textTheme.titleMedium
                                                          ?.copyWith(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 12,
                                                        color: MyColors
                                                            .blueAccentColor,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 8.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                                        child: Text(
                                                          "W/O",
                                                          style: Get.textTheme.titleMedium?.copyWith(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 12,
                                                            color: MyColors.blueAccentColor,
                                                            decoration: TextDecoration.underline,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                                        child: ClipOval(
                                                          child: SvgPicture.asset(
                                                            MyImages.isMachine,
                                                            height: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:  EdgeInsets.symmetric(horizontal: 10),
                                                        child:  Icon(
                                                          Icons.person_pin,
                                                          size: 20.0,
                                                          color:
                                                          MyColors.primaryColor,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Text(
                                                          "Pcs",
                                                          style: Get.textTheme.titleMedium?.copyWith(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 12,
                                                            color: MyColors.blueAccentColor,
                                                            decoration: TextDecoration.underline,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Text("LPPT",
                                                            style: Get.textTheme.titleMedium?.copyWith(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 12,
                                                              color: MyColors.blueAccentColor,
                                                              decoration:
                                                              TextDecoration.underline,
                                                            )),
                                                      ),
                                                      const Padding(
                                                        padding:  EdgeInsets.symmetric(horizontal: 10),
                                                        child:  Icon(
                                                          Icons.flag_circle_outlined,
                                                          size: 20.0,
                                                          color: MyColors.primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: List.generate(groupedList.length, (index) {
                                                      bool isNewWorkOrder =index == 0 ||  groupedList[index].workorder != groupedList[index - 1] .workorder;
                                                      bool isLastEntry = index == groupedList.length - 1;
                                                      if (isNewWorkOrder) {
                                                        previousWorkOrder = groupedList[index].workorder;
                                                        final colorValue =  int.tryParse('0xFF${groupedList[index].r1Color ?? ''}');
                                                        final colorValue1 = int.tryParse('0xFF${groupedList[index].r2Color ?? ''}');
                                                        final colorValue2 = int.tryParse('0xFF${groupedList[index].r3Color ?? ''}');
                                                        final colorValue3 = int.tryParse('0xFF${groupedList[index].r4Color ?? ''}');
                                                        final colorValue4 = int.tryParse('0xFF${groupedList[index].r5Color ?? ''}');
                                                        return Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(color: Colors.black,height: 1,width: 340,),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 71,
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return AlertDialog(
                                                                            title: const Text("Choose Work Order Detail"),
                                                                            content: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Get.toNamed(AppRoutes.checkWorkOrderRateList,  arguments: {
                                                                                      'workOrder': groupedList[index].workorder,
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    "1. Check Rate List",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: Get.textTheme.titleSmall?.copyWith(
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const Divider(), // Add a divider here
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Get.toNamed(AppRoutes.checkWorkOrderStitchingSummaryReport, arguments: {
                                                                                      'workOrder':  groupedList[index].workorder,
                                                                                      'Line': groupedList[index].lineNo,
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    "2. Stitch Summary Report",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: Get.textTheme.titleSmall?.copyWith(
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const Divider(), // Add a divider here
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Get.toNamed(AppRoutes.checkWorkOrderStitchingSummaryDetailReport, arguments: {
                                                                                      'workOrder':  groupedList[index].workorder,
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    "3. Stitching Summary Detail Report",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: Get.textTheme.titleSmall?.copyWith(
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: FittedBox(child: Text(groupedList[index].workorder,style: Theme.of(context).textTheme.labelMedium,maxLines: 1,)),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                  child: Text(groupedList[index].machineName,style: Theme.of(context).textTheme.labelMedium,),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                          title: const Text("Check Operator Detail"),
                                                                          content: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Get.toNamed(
                                                                                      AppRoutes.checkOperatorQuantityReport,
                                                                                      arguments: {
                                                                                        'operator': groupedList[index].workerId,
                                                                                         'date':  controller.dateController.text,});
                                                                                },
                                                                                child: Text(
                                                                                  "1. Operator Produced Quantity Report-Today",
                                                                                  textAlign: TextAlign.left,
                                                                                  style: Get.textTheme.titleSmall?.copyWith(
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const Divider(),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Get.toNamed(AppRoutes.checkOperatorProductionReport,    arguments: {'operator': groupedList[index].workerId});
                                                                                },
                                                                                child: Text(
                                                                                  "2. Operator Produced Report-Last 3 Days",
                                                                                  textAlign: TextAlign.left,
                                                                                  style: Get.textTheme.titleSmall?.copyWith(
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    );


                                                                  },
                                                                  child: Text(groupedList[index].workerId.toString(),style: Theme.of(context).textTheme.labelMedium,),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return AlertDialog(
                                                                            title: const Text("Check Last Operation"),
                                                                            content: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    // Get.toNamed(AppRoutes.checkOperatorQuantityReport);
                                                                                  },
                                                                                  child:  Text(
                                                                                    "Check Last Operation of Order",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: Get.textTheme.titleSmall?.copyWith(
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Text(groupedList[index].stichpcs.toString(),style: Theme.of(context).textTheme.labelMedium,),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(right: 6),
                                                                  child: Text(controller.timeFormat.format(groupedList[index].tRansdate),style: Theme.of(context).textTheme.labelMedium,),
                                                                ),
                                                                if (groupedList[index].r1Color != null)
                                                                  Row(
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 1);
                                                                                Get.dialog(const LineProductionRoundSummary());
                                                                              },
                                                                              child: Container(
                                                                                width: 17.5,
                                                                                height: 17.5,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(15.0),
                                                                                  color: colorValue != null ? Color(colorValue) : null,
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'R1',
                                                                                    style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ]
                                                                  ),
                                                                Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 2);
                                                                              Get.dialog(const LineProductionRoundSummary());
                                                                            },
                                                                            child: Container(
                                                                              width: 17.5,
                                                                              height: 17.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: colorValue1 != null ? Color(colorValue1) : null,
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'R2',
                                                                                  style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ]
                                                                ),
                                                                Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 3);
                                                                              Get.dialog(const LineProductionRoundSummary());
                                                                            },
                                                                            child: Container(
                                                                              width: 17.5,
                                                                              height: 17.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: colorValue2 != null ? Color(colorValue2) : null,
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'R3',
                                                                                  style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ]
                                                                ),
                                                                Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 4);
                                                                              Get.dialog(const LineProductionRoundSummary());
                                                                            },
                                                                            child: Container(
                                                                              width: 17.5,
                                                                              height: 17.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: colorValue3 != null ? Color(colorValue3) : null,
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'R4',
                                                                                  style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ]
                                                                ),
                                                                Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 5);
                                                                              Get.dialog(const LineProductionRoundSummary());
                                                                            },
                                                                            child: Container(
                                                                              width: 17.5,
                                                                              height: 17.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: colorValue4 != null ? Color(colorValue4) : null,
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'R5',
                                                                                  style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ]
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );

                                                      }

                                                      /// todo: The code have no purpose
                                                      else if (groupedList[index] .workorder == previousWorkOrder) {
                                                        final colorValue = int.tryParse('0xFF${groupedList[index].r1Color ?? ''}');
                                                        final colorValue1 = int.tryParse('0xFF${groupedList[index].r2Color ?? ''}');
                                                        final colorValue2 = int.tryParse('0xFF${groupedList[index].r3Color ?? ''}');
                                                        final colorValue3 = int.tryParse('0xFF${groupedList[index].r4Color ?? ''}');
                                                        final colorValue4 = int.tryParse('0xFF${groupedList[index].r5Color ?? ''}');
                                                        Widget rowData = Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                const SizedBox(
                                                                  width: 86,
                                                                ),
                                                                FittedBox(child: Text(groupedList[index].machineName,style: Theme.of(context).textTheme.labelMedium)),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 13),
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return AlertDialog(
                                                                            title: const Text("Check Operator Detail"),
                                                                            content: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Get.toNamed(AppRoutes.checkOperatorQuantityReport, arguments: {'operator': groupedList[index].workerId});
                                                                                  },
                                                                                  child: Text(
                                                                                    "1. Operator Produced Quantity Report-Today",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: Get.textTheme.titleSmall?.copyWith(
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const Divider(),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Get.toNamed(AppRoutes.checkOperatorProductionReport,    arguments: {'operator': groupedList[index].workerId});
                                                                                  },
                                                                                  child: Text(
                                                                                    "2. Operator Produced Report-Last 3 Days",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: Get.textTheme.titleSmall?.copyWith(
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      );

                                                                    },
                                                                    child: FittedBox(
                                                                      child: Text(groupedList[index]
                                                                          .workerId
                                                                          .toString(),style: Theme.of(context).textTheme.labelMedium,),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return AlertDialog(
                                                                            title: const Text("Check Last Operation"),
                                                                            content: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    // Get.toNamed(AppRoutes.checkOperatorQuantityReport);
                                                                                  },
                                                                                  child:  Text(
                                                                                    "Check Last Operation of Order",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: Get.textTheme.titleSmall?.copyWith(
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Text(groupedList[index]
                                                                        .stichpcs
                                                                        .toString(),style: Theme.of(context).textTheme.labelMedium,),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(right: 6),
                                                                  child: Text(controller
                                                                      .timeFormat
                                                                      .format(groupedList[
                                                                  index]
                                                                      .tRansdate),style: Theme.of(context).textTheme.labelMedium,),
                                                                ),
                                                                Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 1);
                                                                              Get.dialog(const LineProductionRoundSummary());
                                                                            },
                                                                            child: Container(
                                                                              width: 17.5,
                                                                              height: 17.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: colorValue != null ? Color(colorValue) : null,
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'R1',
                                                                                  style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ]
                                                                ),
                                                                Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 2);
                                                                              Get.dialog(const LineProductionRoundSummary());
                                                                            },
                                                                            child: Container(
                                                                              width: 17.5,
                                                                              height: 17.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: colorValue1 != null ? Color(colorValue1) : null,
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'R2',
                                                                                  style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ]
                                                                ),
                                                                Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 3);
                                                                              Get.dialog(const LineProductionRoundSummary());
                                                                            },
                                                                            child: Container(
                                                                              width: 17.5,
                                                                              height: 17.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: colorValue2 != null ? Color(colorValue2) : null,
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'R3',
                                                                                  style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ]
                                                                ),
                                                                Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 4);
                                                                              Get.dialog(const LineProductionRoundSummary());
                                                                            },
                                                                            child: Container(
                                                                              width: 17.5,
                                                                              height: 17.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: colorValue3 != null ? Color(colorValue3) : null,
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'R4',
                                                                                  style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ]
                                                                ),
                                                                Row(
                                                                    children: [

                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await controller.getRowingQualityRoundDetailList(groupedList[index].machineName, 5);
                                                                              Get.dialog(const LineProductionRoundSummary());
                                                                            },
                                                                            child: Container(
                                                                              width: 17.5,
                                                                              height: 17.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: colorValue4 != null ? Color(colorValue4) : null,
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'R5',
                                                                                  style: Get.textTheme.titleSmall?.copyWith(color: MyColors.lightCyan, fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ]
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                        if (isLastEntry) {
                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              rowData, Container(color: Colors.black,height: 1,width: 320,),
                                                            ],
                                                          );
                                                        } else {
                                                          return rowData;
                                                        }
                                                      }
                                                      return Container();
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      trailing: Padding(
                                        padding:
                                        const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          "U:${groupedList[0].lineNo}",
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    return GridView.count(
                      crossAxisCount: _calculateCrossAxisCount(context),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 7.0,
                      childAspectRatio: _calculateAspectRatio(context),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: cards,
                    );
                  } else if (controller.stitchPcsList.isEmpty ||
                      controller.isLoading.value) {
                    return const ShimmerForRollList();
                  }
                  return const Text("Data Not Found");
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 960) {
      return 5;
    } else if (screenWidth >= 600) {
      return 3;
    } else {
      return 2;
    }
  }

  double _calculateAspectRatio(BuildContext context) {
    int crossAxisCount = _calculateCrossAxisCount(context);
    double itemWidth;
    if (crossAxisCount == 4) {
      itemWidth = 230;
    } else {
      itemWidth = 220;
    }
    return MediaQuery.of(context).size.width / (crossAxisCount * itemWidth);
  }

}



