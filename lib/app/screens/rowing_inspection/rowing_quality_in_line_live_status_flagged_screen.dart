import 'dart:async';
import 'dart:io';

import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:combined_fabrics_limited/app/screens/rowing_inspection/widget/end_line_summary_report.dart';
import 'package:combined_fabrics_limited/app/screens/rowing_inspection/widget/rowing_quality_live_flag_card_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../../app_assets/styles/my_images.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../debug/debug_pointer.dart';
import '../../routes/app_routes.dart';
import '../../services/preferences.dart';
import '../fabric_inspection/shimmer/rolls_shimmer.dart';
import 'controllers/in_line_live_status_flag_controller.dart';
import 'models/rowing_quality_flag_color_model.dart';
import 'models/rowing_quality_inline_inspection_form_model.dart';

class InLineLiveFlaggedScreen extends StatelessWidget {
  const InLineLiveFlaggedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InLineLiveStatusFlagController controller = Get.put(InLineLiveStatusFlagController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Machine Live Flagged"),
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
          preferredSize: const Size.fromHeight(160.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        value: controller.selectedLinSection.value,
                        onChanged: (String? newValue) {
                          controller.selectedLinSection.value = newValue!;
                          controller.autoFilter();
                          controller.getRowingQualityInlineInspectionFormList(
                              newValue);
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
                        child: DropdownButtonFormField<FlagColorListModel>(
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
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TypeAheadFormField<
                          RowingQualityInlineInspectionFormListModel>(
                        direction: AxisDirection.down,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          enabled: true,
                          keyboardType: TextInputType.number,
                          controller: controller.selectedMachineController,
                          decoration: const InputDecoration(
                            hintText: 'M/C #',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          Set<String> uniqueWorkerIDs = {};
                          final uniqueMachine =
                              controller.workerAndOrderList.where((workOrder) {
                            String workerID = workOrder.machineId.toString();
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          enabled: true,
                          keyboardType: TextInputType.number,
                          controller: controller.selectedWorkOrderController,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          enabled: true,
                          keyboardType: TextInputType.number,
                          controller: controller.selectedEMPController,
                          decoration: const InputDecoration(
                            hintText: 'Emp Code #',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          Set<String> uniqueWorkerIDs = {};
                          final uniqueWorkers = controller.workerAndOrderList.where((workOrder) {
                            String workerID = workOrder.workerId.toString();
                            return workerID.toLowerCase().contains(pattern.toLowerCase()) && uniqueWorkerIDs.add(workerID);
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

                          if (controller.autoFilterEnabled.value) {
                            controller.autoFilter();
                          }
                        },
                      ),
                    ),
                  ],
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
                    ?
                    Expanded(
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
                                      List<String> flags = [
                                        controller.selectedFlag.value
                                                ?.colorHexCode ??
                                            ''
                                      ];
                                      int selectedLine = int.parse(controller
                                          .selectedLinSection.value
                                          .replaceAll(RegExp(r'[^0-9]'), ''));
                                      controller.getRowingQualityMachineWithFlag(
                                        linSection: selectedLine,
                                        flags: flags,
                                        date: controller.dateController.text,
                                        machine: controller
                                            .selectedMachineController.text,
                                        workOrder: controller
                                            .selectedWorkOrderController.text,
                                        empCode: int.tryParse(controller
                                            .selectedEMPController.text),
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
                                    onPressed: () async {
                                      controller.selectedFlag.value = null;
                                      controller.selectedMachineController
                                          .clear();
                                      controller.selectedWorkOrderController
                                          .clear();
                                      controller.selectedEMPController.clear();
                                      controller.dateController.text =
                                          DateFormat('dd-MMM-yyyy')
                                              .format(DateTime.now());
                                      controller.selectedLinSection.value = 'L15';
                                      await controller
                                          .getRowingQualityMachineWithFlag(
                                        linSection: int.parse(controller
                                            .selectedLinSection.value
                                            .replaceAll(RegExp(r'[^0-9]'), '')),
                                        flags: [],
                                        date: controller.dateController.text,
                                        machine: null,
                                        workOrder: null,
                                        empCode: null,
                                      );
                                      controller.getRowingQualityDHUList(
                                        date: controller.dateController.text,
                                      );
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
                        :    SingleChildScrollView(
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
                                    List<String> flags = [
                                      controller.selectedFlag.value
                                          ?.colorHexCode ??
                                          ''
                                    ];
                                    int selectedLine = int.parse(controller
                                        .selectedLinSection.value
                                        .replaceAll(RegExp(r'[^0-9]'), ''));
                                    controller.getRowingQualityMachineWithFlag(
                                      linSection: selectedLine,
                                      flags: flags,
                                      date: controller.dateController.text,
                                      machine: controller
                                          .selectedMachineController.text,
                                      workOrder: controller
                                          .selectedWorkOrderController.text,
                                      empCode: int.tryParse(controller
                                          .selectedEMPController.text),
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
                                  onPressed: () async {
                                    controller.selectedFlag.value = null;
                                    controller.selectedMachineController
                                        .clear();
                                    controller.selectedWorkOrderController
                                        .clear();
                                    controller.selectedEMPController.clear();
                                    controller.dateController.text =
                                        DateFormat('dd-MMM-yyyy')
                                            .format(DateTime.now());
                                    controller.selectedLinSection.value = 'L15';
                                    await controller
                                        .getRowingQualityMachineWithFlag(
                                      linSection: int.parse(controller
                                          .selectedLinSection.value
                                          .replaceAll(RegExp(r'[^0-9]'), '')),
                                      flags: [],
                                      date: controller.dateController.text,
                                      machine: null,
                                      workOrder: null,
                                      empCode: null,
                                    );
                                    controller.getRowingQualityDHUList(
                                      date: controller.dateController.text,
                                    );
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
          vertical: 8,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                      ()=> EndLineSummaryReport(
                    dhuSummaryList: controller.dhuList,
                    isLoading: controller.isLoading.value, dateFormat: controller.timeFormat,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Setting Icon
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
                                                  fontWeight: FontWeight.w600),
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
                                        Get.find<Preferences>().setInt(Keys.flagDashBoardTime,
                                            controller.userDashBoardValue.value);
                                        controller.timer?.cancel();
                                        controller.timer = Timer.periodic(
                                          Duration(minutes: controller.userDashBoardValue.value),
                                          (timer) {
                                            controller.timeFormat.format(DateTime.parse(controller.dateTime.toString()));
                                            controller.getRowingQualityMachineWithFlag();
                                            controller.getRowingQualityDHUList();
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
                  if (controller.inLineStatusList.isNotEmpty &&
                      !controller.isLoading.value) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _liveFlagCalculateCrossAxisCount(context),
                        mainAxisSpacing: 6.0,
                        crossAxisSpacing: 6.0,
                        childAspectRatio: _liveFlagCalculateAspectRatio(context),
                      ),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.inLineStatusList.length,
                      itemBuilder: (context, index) {
                        final machine = controller.inLineStatusList[index];
                        Widget breakWidget(String breakRange) {
                          return Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 27.0,
                                    decoration: const BoxDecoration(
                                      color: Colors.purple,
                                    ),
                                    child: RotatedBox(
                                      quarterTurns: -1,
                                      child: Column(
                                        children: [
                                          Text(
                                            ' Break ',
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                                    fontSize: 12.8,
                                                    color: MyColors
                                                        .lightBorderColor),
                                          ),
                                          Text(
                                            breakRange,
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 6.9,
                                                    color: MyColors
                                                        .lightBorderColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                left: 6,
                                child: Transform.translate(
                                  offset: const Offset(-15, 10),
                                  child: Text(
                                    breakRange.split('-').first,
                                    style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        Widget roundWidgetWithTime(
                            String colorHexCode,
                            String gradientHexCode,
                            String flagDirection,
                            String roundText) {
                          final hasColor = colorHexCode.isNotEmpty;
                          const containerSize = 30.0;
                          final fontSize = roundText == 'R4' ? 7.8 : 8.0;
                          final isR4 = roundText == 'R4';

                          return Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                        color: Colors.black87, width: 1.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Container(
                                    width: containerSize,
                                    height: containerSize,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          containerSize / 2),
                                      gradient: hasColor
                                          ? LinearGradient(
                                              colors: gradientHexCode.isEmpty
                                                  ? [
                                                      Color(int.parse('0x$colorHexCode')),
                                                      Color(int.parse('0x$colorHexCode'))
                                                    ]
                                                  : [
                                                      Color(int.parse('0x${gradientHexCode.split('-').first}')),
                                                      Color(int.parse('0x${gradientHexCode.split('-').last}'))
                                                    ],
                                              stops: const [0.5, 0.5],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            )
                                          : null,
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Text(
                                            roundText,
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                              color: hasColor
                                                  ? MyColors.lightCyan
                                                  : MyColors.shimmerBaseColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Transform.translate(
                                  offset: const Offset(-4, 10),
                                  // Adjusted offset for the last time of R4
                                  child: Row(
                                    children: [
                                      Text(
                                        flagDirection.split('-').first,
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (isR4)
                                        Transform.translate(
                                          offset: const Offset(12, 0),
                                          child: Text(
                                            flagDirection.split('-').last,
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontSize,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        }

                        return CustomCard(
                          color: machine.skillLevel == 1
                              ? Colors.brown.shade100
                              : Colors.white,
                          onPressed: () async {
                            await controller.getRowingQualityRoundDetailList(
                                machine.machineCode, 0);
                            Get.dialog(const LiveFlagInfoCard());
                          },
                          onLongPressed: () {
                            Get.toNamed(AppRoutes.otherApplication);
                          },
                          child: Stack(
                            children: [
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
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    'Op Seq: ${machine.opsequence}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              ListTile(
                                dense: true,
                                minLeadingWidth: 0,
                                contentPadding: const EdgeInsets.only(
                                    top: 22.0, left: 6.0, right: 0.0),
                                minVerticalPadding: 0,
                                horizontalTitleGap: 0,
                                title: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: ClipOval(
                                            child: SvgPicture.asset(
                                              MyImages.isMachine,
                                              height: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${machine.machineCode} ",
                                        style:
                                            Get.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: MyColors.blueAccentColor,
                                        ),
                                      ),
                                      const WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 4.0),
                                          child: Icon(
                                            Icons.person_pin,
                                            size: 20.0,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: machine.empOperatorCode,
                                        style:
                                            Get.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: MyColors.blueAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                    EdgeInsets.only(right: 4.0),
                                                child: Icon(
                                                  Icons.alarm,
                                                  size: 20.0,
                                                  color: MyColors.greenLight,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: controller.timeFormat.format(DateTime.parse(machine.flagDate)),
                                              style: Get.textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: MyColors.blueAccentColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black87,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              roundWidgetWithTime(
                                                machine.r1ColorHexCode,
                                                machine.r1Hlfclr,
                                                machine.r1FlgDrtn,
                                                'R1',
                                              ),
                                              roundWidgetWithTime(
                                                machine.r2ColorHexCode,
                                                machine.r2Hlfclr,
                                                machine.r2FlgDrtn,
                                                'R2',
                                              ),
                                              if (DateTime.parse(machine.transactionDate).isBefore(DateTime.parse('2024-03-11T00:00:00')) ||
                                                  DateTime.parse(machine.transactionDate).isAfter(DateTime.parse('2024-04-10T00:00:00')))
                                                breakWidget(machine.breakRange),
                                              /// todo: Show break before and after Ramadan
                                              roundWidgetWithTime(
                                                machine.r3ColorHexCode,
                                                machine.r3Hlfclr,
                                                machine.r3FlgDrtn,
                                                'R3',
                                              ),
                                              if (DateTime.parse(machine.transactionDate).isAfter(DateTime.parse('2024-03-11T00:00:00')) &&
                                                  DateTime.parse(machine.transactionDate).isBefore(DateTime.parse('2024-04-10T00:00:00')))
                                                breakWidget(machine.breakRange),
                                              ///todo: Show break before and after Ramadan
                                              roundWidgetWithTime(
                                                machine.r4ColorHexCode,
                                                machine.r4Hlfclr,
                                                machine.r4FlgDrtn,
                                                'R4',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 4.0),
                                                child: Icon(
                                                  Icons.work_history_outlined,
                                                  size: 20.0,
                                                  color: MyColors.greenLight,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: machine.woOrders,
                                              style: Get.textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: MyColors.blueAccentColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 4.0),
                                                child: Icon(
                                                  Icons.task_rounded,
                                                  size: 20.0,
                                                  color: MyColors.primaryColor,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: machine.operationname,
                                              style: Get.textTheme.titleSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: MyColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Text(
                                    "U:${machine.lineNo}",
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (controller.inLineStatusList.isEmpty) {
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
          ),
        ],
      ),
    );
  }
}

int _liveFlagCalculateCrossAxisCount(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth >= 960) {
    return 6;
  } else if (screenWidth >= 600) {
    return 3;
  } else {
    return 2;
  }
}

double _liveFlagCalculateAspectRatio(BuildContext context) {
  int crossAxisCount = _liveFlagCalculateCrossAxisCount(context);
  double itemWidth;
  double itemHeight;
  if (crossAxisCount == 6) {
    itemWidth = 198;
    itemHeight = 198;
  } else if (crossAxisCount == 3) {
    itemWidth = 190;
    itemHeight = 190;
  } else {
    itemWidth = 200;
    itemHeight = 200;
  }
  return MediaQuery.of(context).size.width / (crossAxisCount * itemWidth);
}
