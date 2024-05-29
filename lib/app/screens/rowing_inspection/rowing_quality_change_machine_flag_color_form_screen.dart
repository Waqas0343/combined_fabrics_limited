import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../helpers/toaster.dart';
import 'controllers/change_machine_flag_controller.dart';
import 'models/rowing_quality_change_flag_model.dart';
import 'models/rowing_quality_flag_color_model.dart';

class RowingQualityMachineFlagColor extends StatelessWidget {
  const RowingQualityMachineFlagColor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChangeMachineFlagController controller =
    Get.put(ChangeMachineFlagController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Machine Flag Color"),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          children: <Widget>[
            const SizedBox(
              height: 8.0,
            ),
            Obx(
                  () => DropdownButtonFormField<FlagColorListModel>(
                decoration: const InputDecoration(
                  labelText: 'Select Flag Color',
                ),
                value: controller.selectedFlag.value,
                items: controller.flagColorList.map((department) {
                  return DropdownMenuItem<FlagColorListModel>(
                    value: department,
                    child: Text(department.shortName),
                  );
                }).toList(),
                onChanged: (newValue) {
                  controller.selectedFlag.value = newValue;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Flag color is required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 14),
            TypeAheadFormField<ChangeFlagReasonListModel>(
              direction: AxisDirection.down,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                enabled: true,
                controller: controller.reasonController,
                decoration: const InputDecoration(
                  labelText: 'Select Reason',
                ),
              ),
              suggestionsCallback: (pattern) {
                return controller.reasonList
                    .where((reason) => reason.reasons
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, ChangeFlagReasonListModel suggestion) {
                return Obx(() {
                  final isSelected =
                  controller.selectedReason.contains(suggestion);
                  return ListTile(
                    title: Text(suggestion.reasons),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value != null) {
                          if (value) {
                            controller.selectedReason.add(suggestion);
                          } else {
                            controller.selectedReason.remove(suggestion);
                          }
                        }
                      },
                    ),
                  );
                });
              },
              onSuggestionSelected: (ChangeFlagReasonListModel suggestion) {
                if (controller.selectedReason.contains(suggestion)) {
                  Toaster.showToast(
                      "You've selected the same item again!");
                } else {
                  controller.selectedReason.add(suggestion);
                  controller.reasonController.text = controller.selectedReason
                      .map((item) => item.reasons)
                      .join(", ");
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Reason is required';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 14,
            ),
            SizedBox(
              height: 47,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.rowingQualityMachineFlagUpdate();
                  }
                },
                child: const Text(
                  "Submit Flag",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
