import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../../helpers/text_formatter.dart';
import '../../../helpers/toaster.dart';
import '../../app_widgets/custom_card.dart';
import 'medical_issuance_controllers/medical_issuance_home_controller.dart';
import 'medical_issuance_model/medical_disease_model.dart';
import 'medical_issuance_model/medicine_first_aid_box_model.dart';
import 'medical_issuance_model/medicine_stock_model.dart';

class MedicalIssuanceHome extends StatelessWidget {
  const MedicalIssuanceHome({super.key});

  @override
  Widget build(BuildContext context) {
    final MedicalIssuanceHomeController controller =
        Get.put(MedicalIssuanceHomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Issuance"),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          children: <Widget>[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: controller.pickDate,
              child: AbsorbPointer(
                child: TextFormField(
                  controller: controller.dateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: "Select Date:",
                    fillColor: Colors.white,
                    hintText: "01/30/2020",
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const SizedBox(height: 16.0),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomCard(
                      onPressed: () {
                        controller.selectOption('Employee');
                      },
                      child: Row(
                        children: [
                          Radio(
                            focusColor: Colors.white,
                            groupValue: controller.selectedRadioValue.value,
                            onChanged: (value) {
                              controller.selectOption(value.toString());
                            },
                            value: 'Employee',
                          ),
                          Text(
                            'Employee',
                            style: Get.textTheme.titleSmall!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: CustomCard(
                      onPressed: () {
                        controller.selectOption('First Aid Box');
                      },
                      child: Row(
                        children: [
                          Radio(
                            focusColor: Colors.white,
                            groupValue: controller.selectedRadioValue.value,
                            onChanged: (value) {
                              controller.selectOption(value.toString());
                            },
                            value: 'First Aid Box',
                          ),
                          Text(
                            'First Aid',
                            style: Get.textTheme.titleSmall!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomCard(
                      onPressed: () {
                        controller.selectOption('Contractor');
                      },
                      child: Row(
                        children: [
                          Radio(
                            focusColor: Colors.white,
                            groupValue: controller.selectedRadioValue.value,
                            onChanged: (value) {
                              controller.selectOption(value.toString());
                            },
                            value: 'Contractor',
                          ),
                          Text(
                            'Contractor',
                            style: Get.textTheme.titleSmall!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(() {
              final selectedValue = controller.selectedRadioValue.value;
              if (selectedValue == 'Employee') {
                return Column(
                  children: [
                    TextFormField(
                      maxLength: 8,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: controller.employeeCodeController,
                      decoration: const InputDecoration(
                        hintText: "e.g (10)",
                        labelText: 'Employee Code',
                        filled: true,
                        fillColor: Colors.white,
                        counterText: "",
                      ),
                      textInputAction: TextInputAction.next,
                      // Set textInputAction to next
                      onFieldSubmitted: (text) {
                        if (text.isNotEmpty) {
                          controller.getPatientCardNo();
                          FocusScope.of(context)
                              .nextFocus(); // Move focus to the next field
                        }
                      },
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Can't be empty";
                        } else if (!GetUtils.hasMatch(
                          text,
                          TextInputFormatterHelper.numberAndTextWithDot.pattern,
                        )) {
                          return "Employee Code ${Keys.bothTextNumber}";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20), // Add some spacing
                    Obx(() {
                      return controller.patientCardData.value != null
                          ? Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: MyColors.greenLight,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Wrap(
                                            spacing: 8.0,
                                            children: [
                                              Text(
                                                'Employee Name:',
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "${controller.patientCardData.value?.empName}",
                                                style: Get.textTheme.bodySmall!
                                                    .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                'Department:',
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "${controller.patientCardData.value?.deptName}",
                                                maxLines: 1,
                                                style: Get.textTheme.bodySmall!
                                                    .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ],
                            )
                          : const SizedBox.shrink();
                    }),
                    TypeAheadFormField<DiseaseListModel>(
                      direction: AxisDirection.down,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        enabled: true,
                        controller: controller.diagnosisController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Select Disease Name',
                          suffixIcon: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Add New Disease',
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller:
                                              controller.addMedicineController,
                                          decoration: const InputDecoration(
                                            labelText: 'Disease Name',
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                controller.saveNewDisease();
                                              },
                                              child: const Text('Add'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back(); // Close the dialog
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Add(+)"),
                            ),
                          ),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return controller.diseaseList
                            .where((medicine) => medicine.diseaseName
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder: (context, DiseaseListModel suggestion) {
                        return Obx(() {
                          final isSelected =
                              controller.selectedDiseases.contains(suggestion);

                          return ListTile(
                            title: Text(suggestion.diseaseName),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  if (value) {
                                    controller.selectedDiseases.add(suggestion);
                                  } else {
                                    controller.selectedDiseases
                                        .remove(suggestion);
                                  }
                                }
                              },
                            ),
                          );
                        });
                      },
                      onSuggestionSelected: (DiseaseListModel suggestion) {
                        if (controller.selectedDiseases.contains(suggestion)) {
                          Toaster.showToast(
                              "You've selected the same item again!");
                        } else {
                          controller.selectedDiseases.add(suggestion);
                          controller.diagnosisController.text = controller
                              .selectedDiseases
                              .map((item) => item.diseaseName)
                              .join(", ");
                        }
                      },
                    ),

                    const SizedBox(height: 14),
                    TypeAheadFormField<MedicineStockListModel>(
                      direction: AxisDirection.down,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        enabled: true,
                        controller: controller.selectedMedicineController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Select Medicine Name',
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return controller.stockMedicineList
                            .where((medicine) => medicine.itemName
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder:
                          (context, MedicineStockListModel suggestion) {
                        return ListTile(
                          title: Text(suggestion.itemName),
                          trailing: Text(
                            suggestion.stock.toString(),
                          ),
                        );
                      },
                      onSuggestionSelected:
                          (MedicineStockListModel suggestion) {
                        if (controller.selectedMedicine.value == suggestion) {
                          Toaster.showToast(
                              "You've selected the same item again!");
                        } else {
                          controller.selected =
                              suggestion; // Update the local variable
                          controller.selectedMedicine.value = suggestion;
                          controller.selectedMedicineController.text =
                              suggestion.itemName;
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: TextEditingController(text: '${controller.quantity.value}'),
                              onChanged: (value) {
                                int? intValue = int.tryParse(value);
                                if (intValue != null &&
                                    intValue >= 1 &&
                                    intValue <= 500) {
                                  controller.selectedQuantity.value = intValue;
                                  controller.quantity.value = intValue;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "e.g",
                                labelText: 'Quantity',
                                filled: true,
                                fillColor: Colors.white,
                                counterText: "",
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    if (controller.selectedQuantity.value > 1) {
                                      controller.medicineDecrement();
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (controller.selectedQuantity.value <
                                        500) {
                                      controller.medicinesIncrement();
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 47,
                            child: ElevatedButton(
                              onPressed: () {
                                if (controller.quantity.value > 0 &&
                                    controller.selected != null) {
                                  controller.addTableRow(
                                      controller.selected!.itemCode,
                                      controller.selected!.itemName,
                                      controller.quantity.value);
                                  controller.selectedMedicineController.clear();
                                } else {
                                  Toaster.showToast(
                                      "Please select a quantity.");
                                }
                              },
                              child: const Text("Add"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      maxLength: 8,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      controller: controller.diagnosisByController,
                      decoration: const InputDecoration(
                        hintText: "e.g (10)",
                        labelText: 'Dispensed By',
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
                    const SizedBox(height: 14),
                    TextFormField(
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      controller: controller.remarksController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: "e.g",
                        labelText: 'Diagnosed By & Remarks',
                        filled: true,
                        counterText: "",
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              } else if (selectedValue == 'First Aid Box') {
                return Column(
                  children: [
                    TypeAheadFormField<FirstAidBoxListModel>(
                      direction: AxisDirection.down,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        enabled: true,
                        controller: controller.boxNoController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Select Box Name',
                          suffixIcon: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Add New Box',
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: controller
                                              .addFirstAidBoxNoController,
                                          decoration: const InputDecoration(
                                            labelText: 'Box Number',
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: controller
                                              .adFirstAidBoxNameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Box Name',
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                controller.addNewFirstAidBox();
                                              },
                                              child: const Text('Add'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back(); // Close the dialog
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Add(+)"),
                            ),
                          ),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return controller.boxesList
                            .where((boxes) => boxes.firstAidBoxNamed
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder: (context, FirstAidBoxListModel suggestion) {
                        return ListTile(
                          title: Text(suggestion.firstAidBoxNamed),
                        );
                      },
                      onSuggestionSelected: (FirstAidBoxListModel suggestion) {
                        if (controller.selectedDisease.value == suggestion) {
                          Toaster.showToast(
                              "You've selected the same item again!");
                        } else {
                          controller.selectedBoxes.value = suggestion;
                          controller.boxNoController.text =
                              suggestion.firstAidBoxNamed;
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TypeAheadFormField<MedicineStockListModel>(
                      direction: AxisDirection.down,

                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        enabled: true,
                        controller: controller.selectedMedicineController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Select Medicine Name',
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return controller.stockMedicineList
                            .where((medicine) => medicine.itemName
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder:
                          (context, MedicineStockListModel suggestion) {
                        return ListTile(
                          title: Text(suggestion.itemName),
                          trailing: Text(suggestion.stock.toString()),
                        );
                      },
                      onSuggestionSelected:
                          (MedicineStockListModel suggestion) {
                        if (controller.selectedMedicine.value == suggestion) {
                          Toaster.showToast(
                              "You've selected the same item again!");
                        } else {
                          controller.selected =
                              suggestion; // Update the local variable
                          controller.selectedMedicine.value = suggestion;
                          controller.selectedMedicineController.text =
                              suggestion.itemName;
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: TextEditingController(text: '${controller.quantity.value}'),
                              onChanged: (value) {
                                int? intValue = int.tryParse(value);
                                if (intValue != null && intValue >= 1) {
                                  controller.selectedQuantity.value =
                                      intValue; // Update the selected quantity
                                  controller.quantity.value =
                                      intValue; // Update controller.quantity if needed
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "e.g",
                                labelText: 'Quantity',
                                filled: true,
                                fillColor: Colors.white,
                                counterText: "",
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    controller.medicineDecrement();
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.medicinesIncrement();
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 47,
                            child: ElevatedButton(
                              onPressed: () {
                                if (controller.quantity.value > 0 &&
                                    controller.selected != null) {
                                  controller.addTableRow(
                                      controller.selected!.itemCode,
                                      controller.selected!.itemName,
                                      controller.quantity.value);
                                  controller.selectedMedicineController.clear();
                                } else {
                                  Toaster.showToast(
                                      "Please select a quantity.");
                                }
                              },
                              child: const Text("Add"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      maxLength: 8,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: controller.diagnosisByController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(

                        hintText: "e.g (10)",
                        labelText: 'Dispense By',
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
                    const SizedBox(height: 14),
                  ],
                );
              } else if (selectedValue == 'Contractor') {
                return Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: controller.contractorNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: "e.g (10)",
                        labelText: 'Name',
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
                          return "Name ${Keys.bothTextNumber}";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: controller.contractorVisitingCardController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: "e.g (10)",
                        labelText: 'CNIC No / Passport No',
                        filled: true,
                        fillColor: Colors.white,
                        counterText: "",
                      ),
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Can't be empty";
                        } else if (!GetUtils.hasMatch(
                          text,
                          TextInputFormatterHelper.mixedPattern.pattern,
                        )) {
                          return "Name ${Keys.bothTextNumber}";
                        }
                        return null;
                      },
                    ), // Add some spacing
                    const SizedBox(height: 20),
                    TypeAheadFormField<DiseaseListModel>(
                      direction: AxisDirection.down,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        enabled: true,
                        controller: controller.diagnosisController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Select Disease Name',
                          suffixIcon: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Add New Disease',
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller:
                                              controller.addMedicineController,
                                          decoration: const InputDecoration(
                                            labelText: 'Disease Name',
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                controller.saveNewDisease();
                                              },
                                              child: const Text('Add'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back(); // Close the dialog
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Add(+)"),
                            ),
                          ),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return controller.diseaseList
                            .where((medicine) => medicine.diseaseName
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder: (context, DiseaseListModel suggestion) {
                        return Obx(() {
                          final isSelected =
                              controller.selectedDiseases.contains(suggestion);

                          return ListTile(
                            title: Text(suggestion.diseaseName),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  if (value) {
                                    controller.selectedDiseases.add(suggestion);
                                  } else {
                                    controller.selectedDiseases
                                        .remove(suggestion);
                                  }
                                }
                              },
                            ),
                          );
                        });
                      },
                      onSuggestionSelected: (DiseaseListModel suggestion) {
                        if (controller.selectedDiseases.contains(suggestion)) {
                          Toaster.showToast(
                              "You've selected the same item again!");
                        } else {
                          controller.selectedDiseases.add(suggestion);
                          controller.diagnosisController.text = controller
                              .selectedDiseases
                              .map((item) => item.diseaseName)
                              .join(", ");
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TypeAheadFormField<MedicineStockListModel>(
                      direction: AxisDirection.down,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        enabled: true,
                        controller: controller.selectedMedicineController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Select Medicine Name',
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return controller.stockMedicineList
                            .where((medicine) => medicine.itemName
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder:
                          (context, MedicineStockListModel suggestion) {
                        return ListTile(
                          title: Text(suggestion.itemName),
                          trailing: Text(
                            suggestion.stock.toString(),
                          ),
                        );
                      },
                      onSuggestionSelected:
                          (MedicineStockListModel suggestion) {
                        if (controller.selectedMedicine.value == suggestion) {
                          Toaster.showToast(
                              "You've selected the same item again!");
                        } else {
                          controller.selected =
                              suggestion; // Update the local variable
                          controller.selectedMedicine.value = suggestion;
                          controller.selectedMedicineController.text =
                              suggestion.itemName;
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: TextEditingController(text: '${controller.quantity.value}'),
                              onChanged: (value) {
                                int? intValue = int.tryParse(value);
                                if (intValue != null && intValue >= 1) {
                                  controller.selectedQuantity.value =
                                      intValue; // Update the selected quantity
                                  controller.quantity.value =
                                      intValue; // Update controller.quantity if needed
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "e.g",
                                labelText: 'Quantity',
                                filled: true,
                                fillColor: Colors.white,
                                counterText: "",
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    controller.medicineDecrement();
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.medicinesIncrement();
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 47,
                            child: ElevatedButton(
                              onPressed: () {
                                if (controller.quantity.value > 0 &&
                                    controller.selected != null) {
                                  controller.addTableRow(
                                      controller.selected!.itemCode,
                                      controller.selected!.itemName,
                                      controller.quantity.value);
                                  controller.selectedMedicineController.clear();
                                } else {
                                  Toaster.showToast(
                                      "Please select a quantity.");
                                }
                              },
                              child: const Text("Add"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      maxLength: 8,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: controller.diagnosisByController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: "e.g (10)",
                        labelText: 'Dispense By',
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
                    const SizedBox(height: 16.0),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            Obx(
              () {
                if (controller.tableDataList.isEmpty) {
                  return const SizedBox();
                } else {
                  return Center(
                    child: SizedBox(
                      height: Get.height * 0.5,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text('#',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600))),
                            DataColumn(
                                label: Text('Medicine',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600))),
                            DataColumn(
                                label: Text('Quantity',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600))),
                            DataColumn(
                                label: Text('Delete',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600))),
                          ],
                          rows: List.generate(controller.tableDataList.length,
                              (index) {
                            final rowData = controller.tableDataList[index];
                            final color = controller
                                .rowColors[index % controller.rowColors.length];
                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                  (states) => color),
                              cells: [
                                DataCell(Text((index + 1).toString())),
                                DataCell(Text(rowData.medicineName)),
                                DataCell(Text(rowData.quantity.toString())),
                                DataCell(IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        controller.onDeleteRow(rowData.id))),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 14,
            ),
            SizedBox(
              height: 47,
              child: ElevatedButton(
                onPressed: controller.buttonAction.value
                    ? () {
                  // Disable the button to prevent multiple submissions
                  controller.buttonAction.value = false;
                  controller.saveMedicineData();
                }
                    : null,
                child: const Text(
                  "Save Medicine Prescription",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
