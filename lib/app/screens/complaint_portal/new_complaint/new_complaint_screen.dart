import 'package:combined_fabrics_limited/helpers/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app_assets/styles/my_colors.dart';
import '../../../app_widgets/custom_card.dart';
import '../../../debug/debug_pointer.dart';
import '../complaint_models/get_department_model.dart';
import '../complaint_models/get_long_name_model.dart';
import '../complaint_models/get_short_name_assetcode_model.dart';
import '../complaint_models/get_to_department_model.dart';
import 'controllers/new_complaint_controller.dart';

class
NewComplaintScreen extends StatelessWidget {
  const NewComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewComplaintController controller = Get.put(NewComplaintController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Complaint Form",
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 16,
          ),
          children: [
            Obx(
              () => DropdownButtonFormField<DepartmentListModel>(
                decoration: const InputDecoration(
                  labelText: 'Get Department',
                ),
                value: controller.selectedDepartment.value,
                items: controller.departmentList.map((department) {
                  return DropdownMenuItem<DepartmentListModel>(
                    value: department,
                    child: Text(department.deptName),
                  );
                }).toList(),
                onChanged: (newValue) {
                  controller.selectedDepartment.value = newValue;
                  controller.getShortNameAssetCode(newValue?.deptCode);
                  controller.getLongNameAssetCode(newValue?.deptCode);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(
              () => DropdownButtonFormField<ToDepartmentListModel>(
                decoration: const InputDecoration(
                  labelText: 'Get To Department',
                ),
                value: controller.selectedToDepartment.value,
                items: controller.toDepartmentList.map((toDepartment) {
                  return DropdownMenuItem<ToDepartmentListModel>(
                    value: toDepartment,
                    child: Text(toDepartment.departmentName),
                  );
                }).toList(),
                onChanged: (newValue) {
                  controller.selectedToDepartment.value = newValue;
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              "Select Machine Issue:",
              style: Get.textTheme.titleSmall!.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomCard(
                      onPressed: () {
                        controller.selectOption('Yes');
                      },
                      child: Row(
                        children: [
                          Radio(
                            focusColor: Colors.white,
                            groupValue: controller.selectedRadioValue.value,
                            onChanged: (value) {
                              controller.selectOption(value.toString());
                            },
                            value: 'Yes',
                          ),
                          Text(
                            'Yes',
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 14,
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
                        controller.selectOption('No');
                      },
                      child: Row(
                        children: [
                          Radio(
                            focusColor: Colors.white,
                            groupValue: controller.selectedRadioValue.value,
                            onChanged: (value) {
                              controller.selectOption(value.toString());
                            },
                            value: 'No',
                          ),
                          Text(
                            'No',
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(
              thickness: 5,
              color: MyColors.yellow,
            ),
            const SizedBox(height: 16.0),
            Obx(
              () {
                final selectedValue = controller.selectedRadioValue.value;
                if (selectedValue == 'Yes') {
                  return Column(
                    children: [
                      TypeAheadFormField<ShortNameAssetCodeListModel>(
                        direction: AxisDirection.down,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          enabled: true,
                          controller: controller.selectedShortTextController,
                          decoration: const InputDecoration(
                            labelText: 'Select Short Name',
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return controller.shortNameList
                              .where((shortCode) => shortCode.shortName
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, ShortNameAssetCodeListModel suggestion) {
                          return ListTile(
                            title: Text(suggestion.shortName),
                          );
                        },
                        onSuggestionSelected: (ShortNameAssetCodeListModel selected) {
                          if (controller.selectedShort.value == selected) {
                            Toaster.showToast(
                                "You've selected the same item again!");
                          } else {
                            controller.selectedShort.value = selected;
                            controller.selectedShortTextController.text = selected.shortName; // Set the selected text in the text field
                            controller.addTableRow(selected.assetCode);
                            Debug.log("Selected item: ${selected.shortName}");
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TypeAheadFormField<LongNameModelList>(
                        direction: AxisDirection.down,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          enabled: true,
                          controller: controller.selectedLongTextController,
                          decoration: const InputDecoration(
                            labelText: 'Select Long Name',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return controller.longNameList
                              .where((longName) => longName.longName
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, LongNameModelList suggestion) {
                          return ListTile(
                            title: Text(suggestion.longName),
                          );
                        },
                        onSuggestionSelected: (LongNameModelList selected) {
                          if (controller.selectedLong.value == selected) {
                            Toaster.showToast(
                                "You've selected the same item again!");
                          } else {
                            controller.selectedLong.value = selected;
                            controller.selectedLongTextController.text = selected
                                .longName; // Set the selected text in the text field
                            controller.addTableRow(selected.assetCode);
                            Debug.log("Selected item: ${selected.longName}");
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.assetCodeController,
                              decoration: const InputDecoration(
                                hintText: "FA-12027",
                                labelText: 'Enter Asset Code',
                                filled: true,
                                fillColor: Colors.white,
                                counterText: "",
                              ),
                              onChanged: (text) {
                                controller.debounce(() {
                                  controller.getAssetCodeByShortLongName(text);
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 50, // Set the desired height
                              child: OutlinedButton(
                                onPressed: () {
                                  controller.getQRCode();
                                },
                                child: const Text('Scan Barcode'),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Obx(
                        () {
                          if (controller.tableDataList.isEmpty) {
                            return const SizedBox();
                          } else {
                            return TextFormField(
                              maxLines: 4,
                              controller: controller.textarea,
                              decoration: const InputDecoration(
                                hintText: "",
                                labelText: 'Type Complaint Detail',
                                filled: true,
                                fillColor: Colors.white,
                                counterText: "",
                              ),
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Can't be empty";
                                }
                                return null;
                              },
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Obx(
                        () {
                          if (controller.tableDataList.isEmpty) {
                            return const SizedBox();
                          } else {
                            return SizedBox(
                              height: Get.height * 0.3,
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Sr.Number',
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Asset Code',
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Delete',
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                    controller.tableDataList.length, (index) {
                                  final rowData =
                                      controller.tableDataList[index];
                                  final color = controller.rowColors[
                                      index % controller.rowColors.length];
                                  return DataRow(
                                    color: MaterialStateColor.resolveWith(
                                        (states) => color),
                                    cells: [
                                      DataCell(
                                        Text((index + 1).toString()),
                                      ),
                                      DataCell(
                                        Text(rowData.assetCode),
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => controller
                                              .onDeleteRow(rowData.id),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            );
                          }
                        },
                      ),
                      Column(
                        children: <Widget>[
                          Visibility(
                            visible: controller.selectedImage.value != null,
                            child: SizedBox(
                              height: Get.size.height * 0.22,
                              child: Obx(() {
                                final selectedImage = controller.selectedImage.value;
                                return selectedImage != null
                                    ? Image.file(selectedImage, fit: BoxFit.cover)
                                    : const Text('No Image Selected');
                              }),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.attach_file,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Choose Files',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.photo,
                                        color: Colors.white,
                                      ), // Icon to display
                                      onPressed: () {
                                        controller.getImage(ImageSource.gallery);
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.photo_camera,
                                        color: Colors.white,
                                      ),
                                      // Icon to display
                                      onPressed: () {
                                        controller.getImage(ImageSource.camera);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                } else if (selectedValue == 'No') {
                  return Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        controller: controller.textarea,
                        decoration: const InputDecoration(
                          hintText: "",
                          labelText: 'Type Complaint Detail',
                          filled: true,
                          fillColor: Colors.white,
                          counterText: "",
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Can't be empty";
                          }
                          return null;
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
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
          child: SizedBox(
            width: double.infinity,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ElevatedButton(
                  onPressed: () {
                    controller.saveComplainData();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(constraints.maxWidth, 0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Submit Complaint",
                    style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: MyColors.shimmerHighlightColor),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
