import 'package:combined_fabrics_limited/app/screens/fabric_inspection/widget/switch.dart';
import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../../helpers/text_formatter.dart';
import 'controllers/fabric_inspection_fault_form_controller.dart';
import 'models/get_detail_by_roll_model.dart';
import 'models/quality_status_model.dart';
import 'models/roll_marking_model.dart';

class FabricFaultFormScreen extends StatelessWidget {
  const FabricFaultFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FabricInspectionFormController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Fabric Inspection"),
            const SizedBox(
              width: 50,
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: ["M1", "M2", "M3", "M4", "M5","M6","M7","M8"].contains(controller.table)
                    ? RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: "Inspection On Machine: ",
                          style: Get.textTheme.titleLarge?.copyWith(
                            color: MyColors.shimmerHighlightColor,
                          ),
                          children: [
                            TextSpan(
                              text: "${controller.table}  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: Colors.orangeAccent,
                              ),
                            ),
                            TextSpan(
                              text: "Shift:  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: MyColors.shimmerHighlightColor,
                              ),
                            ),
                            TextSpan(
                              text: "${controller.shift}",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: Colors.orangeAccent,
                              ),
                            ),
                            TextSpan(
                              text: "Roll Start Time:  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: MyColors.shimmerHighlightColor,
                              ),
                            ),
                            TextSpan(
                              text: controller.startController.text,
                              style: Get.textTheme.titleMedium?.copyWith(
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: "Inspection On Table: ",
                          style: Get.textTheme.titleLarge?.copyWith(
                            color: MyColors.shimmerHighlightColor,
                          ),
                          children: [
                            TextSpan(
                              text: "${controller.table}  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: Colors.cyanAccent,
                              ),
                            ),
                            TextSpan(
                              text: "Shift:  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: MyColors.shimmerHighlightColor,
                              ),
                            ),
                            TextSpan(
                              text: "${controller.shift}",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: Colors.cyanAccent,
                              ),
                            ),
                            TextSpan(
                              text: "Roll Start Time:  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: MyColors.shimmerHighlightColor,
                              ),
                            ),
                            TextSpan(
                              text: controller.startController.text,
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
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: 8,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: controller.measurementController,
                    decoration: const InputDecoration(
                      hintText: "30",
                      labelText: 'Enter Width',
                      filled: true,
                      fillColor: Colors.white,
                      counterText: "",
                    ),
                    onFieldSubmitted: (text) {
                      if (text.isNotEmpty) {
                        double width = double.parse(text);
                        controller.measurementList.add(width);

                        if (controller.measurementList.length == 4) {
                          controller.minValue = controller.measurementList
                              .reduce((value, element) =>
                                  value < element ? value : element);
                          controller.maxValue = controller.measurementList
                              .reduce((value, element) =>
                                  value > element ? value : element);
                        }

                        // Clear the field after adding the measurement
                        controller.measurementController.clear();
                      }
                    },
                  ),
                ),
                Obx(
                  () {
                    if (controller.measurementList.isEmpty) {
                      return const SizedBox(); // Return an empty SizedBox if the list is empty
                    } else {
                      return Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: DataTable(
                              columns: List<DataColumn>.generate(
                                controller.measurementList.length,
                                (index) => DataColumn(
                                  label: Text(
                                    'Width ${index + 1}',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // Set a specific color for the DataColumn
                                ),
                              ),
                              rows: [
                                DataRow(
                                  cells: List<DataCell>.generate(
                                    controller.measurementList.length,
                                    (index) => DataCell(
                                      Text(
                                        controller.measurementList[index]
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: 8,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: controller.meterController,
                    decoration: const InputDecoration(
                      hintText: "e.g (10)",
                      labelText: 'Meter ',
                      filled: true,
                      fillColor: Colors.white,
                      counterText: "",
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    maxLength: 8,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: controller.weightController,
                    decoration: const InputDecoration(
                      hintText: "e.g (10)",
                      labelText: 'Weight',
                      filled: true,
                      fillColor: Colors.white,
                      counterText: "",
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Can't be empty";
                      } else if (!GetUtils.hasMatch(
                        text,
                        TextInputFormatterHelper.numberAndTextWithDot.pattern,
                      )) {
                        return "Weight ${Keys.bothTextNumber}";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () {
                      final RollDetailModelData? rollsModel =
                          controller.rollDetail.value;
                      final bool isModelValueAvailable = rollsModel != null &&
                          rollsModel.rollMarkingStatus.isNotEmpty;
                      return Row(
                        children: [
                          Text(
                            'Roll Marking Status:',
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children:
                                  controller.rollStatusList.map((rollStatus) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<RollMarkingStatusList>(
                                      value: rollStatus,
                                      groupValue:
                                          controller.selectedMarkingRoll.value,
                                      onChanged: (newValue) {
                                        controller.selectedMarkingRoll.value =
                                            newValue;
                                        if (isModelValueAvailable) {
                                          rollsModel.rollMarkingStatus =
                                              newValue!.display;
                                        }
                                      },
                                      activeColor: MyColors
                                          .primaryColor, // Set the desired color here
                                    ),
                                    Text(rollStatus.display),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Obx(
                    () {
                      final RollDetailModelData? rollsModel = controller.rollDetail.value;
                      final bool isModelValueAvailable = rollsModel != null && rollsModel.qualityStatus.isNotEmpty;
                      return Row(
                        children: [
                          Text(
                            'Quality Status:',
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: controller.qualityList.map((quality) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<QualityListModel>(
                                      value: quality,
                                      groupValue: controller.selectedQuality.value,
                                      onChanged: (newValue) {
                                        controller.selectedQuality.value = newValue;
                                        if (isModelValueAvailable) {
                                          rollsModel.qualityStatus = newValue!.display;
                                        }
                                      },
                                      activeColor: MyColors.primaryColor,
                                    ),
                                    Text(quality.display),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controller.gsmController,
                    decoration: const InputDecoration(
                      hintText: "Enter Your GSM",
                      labelText: 'GSM',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                if (["M1", "M2", "M3", "M4", "M5","M6","M7","M8"].contains(controller.table))
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLength: 5,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                controller: controller.elonLengthController,
                                decoration: InputDecoration(
                                  hintText: "e.g",
                                  labelText: 'Elong Length',
                                  filled: true,
                                  fillColor: Colors.white,
                                  counterText: "",
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      double currentValue = double.tryParse(
                                              controller
                                                  .elonLengthController.text) ??
                                          0.0;
                                      if (currentValue > 5.0) {
                                        return;
                                      }
                                      currentValue -= 0.1;
                                      controller.elonLengthController.text =
                                          currentValue.toStringAsFixed(1);
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      double currentValue = double.tryParse(
                                              controller
                                                  .elonLengthController.text) ??
                                          0.0;
                                      if (currentValue >= 5.0) {
                                        return;
                                      }
                                      currentValue += 0.1;
                                      controller.elonLengthController.text =
                                          currentValue.toStringAsFixed(1);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: TextFormField(
                                maxLength: 5,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                controller: controller.elonWidthController,
                                decoration: InputDecoration(
                                  hintText: "e.g",
                                  labelText: 'Elong Width',
                                  filled: true,
                                  fillColor: Colors.white,
                                  counterText: "",
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      double currentValue = double.tryParse(
                                              controller
                                                  .elonWidthController.text) ??
                                          0.0;
                                      if (currentValue > 5.0) {
                                        return;
                                      }
                                      currentValue -= 0.1;
                                      controller.elonWidthController.text =
                                          currentValue.toStringAsFixed(1);
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      double currentValue = double.tryParse(
                                              controller
                                                  .elonWidthController.text) ??
                                          0.0;
                                      if (currentValue >= 5.0) {
                                        return;
                                      }
                                      currentValue += 0.1;
                                      controller.elonWidthController.text =
                                          currentValue.toStringAsFixed(1);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Text(
                  'Shrinkage piece cutting:',
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => CustomSwitch(
                    value: controller.isYesChecked.value,
                    onChanged: controller.toggleSwitch,
                  ),
                ),
                const SizedBox(width: 30),
                Text(
                  'Shade continuity:',
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => CustomSwitch(
                    value: controller.isShadeChecked.value,
                    onChanged: controller.toggleShade,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: controller.remarksController,
              decoration: const InputDecoration(
                hintText: "e.g",
                labelText: 'Remarks',
                filled: true,
                counterText: "",
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            const SizedBox(
              height: 14,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
          child: ElevatedButton(
            onPressed: () {
              controller.saveFormData();
            },
            child: const Text(
              "Save ",
            ),
          ),
        ),
      ),
    );
  }
}
