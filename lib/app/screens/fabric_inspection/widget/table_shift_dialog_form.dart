import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controllers/table_shift_dialog_form_controller.dart';
import '../models/inspection_table_model.dart';

class FormDialogBox extends StatelessWidget {
  final TableShiftDialogController controller = Get.put(TableShiftDialogController());
  FormDialogBox({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth * 0.6, // Adjust width as needed
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Select Your Table and Shift',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: false,
                    controller: controller.shiftController,
                    decoration: const InputDecoration(
                      hintText: 'e.g (A)',
                      labelText: 'Inspection Shift',
                      filled: true,
                      fillColor: Colors.white,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => DropdownButtonFormField<InspectionTableList>(
                      decoration: const InputDecoration(
                        labelText: 'Inspection Table',
                      ),
                      value: controller.selectedTable.value,
                      items: controller.tableList.map((table) {
                        return DropdownMenuItem<InspectionTableList>(
                          value: table,
                          child: Text(table.display),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        controller.selectedTable.value = newValue;
                      },
                      validator: (selectedValue) {
                        if (selectedValue == null) {
                          return 'Please select an inspection table';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (controller.formKey.currentState!.validate()) {
                              // Validation successful, proceed with saving and navigation
                              await controller.saveSelectedValues(
                                controller.shiftController.text,
                                controller.selectedTable.value?.display,
                              );
                              Get.offNamed(AppRoutes.fabricInspectionHome);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(constraints.maxWidth, 0),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Submit"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
