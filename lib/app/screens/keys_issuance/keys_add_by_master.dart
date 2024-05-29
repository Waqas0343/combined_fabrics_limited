import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../../helpers/text_formatter.dart';
import '../../../helpers/toaster.dart';
import '../../app_widgets/custom_card.dart';
import '../goods_inspections_note/goods_inspection_models/goods_inspection_other_department_model.dart';
import 'controllers/key_add_by_master_controller.dart';
import 'models/get_master_keys_model.dart';
import 'models/key_sub_department_model.dart';
import 'models/keys_concerned_person_model.dart';

class KeyAddByMaster extends StatelessWidget {
  const KeyAddByMaster({super.key});

  @override
  Widget build(BuildContext context) {
    final KeyAddByMasterController controller =
        Get.put(KeyAddByMasterController());
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.updateKeyData.value == null
            ? "Add New Key"
            : "Update Key"),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          children: <Widget>[
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.keysNoController,
                    decoration: const InputDecoration(
                      hintText: "e.g (10)",
                      labelText: 'Key No',
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
                        return "Key ${Keys.bothTextNumber}";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: controller.totalKeysNoController,
                    decoration: const InputDecoration(
                      hintText: "e.g (10)",
                      labelText: 'Total Keys',
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
                        return "Key ${Keys.bothTextNumber}";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: controller.departmentType.map((String value) {
                  Icon icon = value == 'Department'
                      ? const Icon(
                          Icons.business,
                          color: Colors.green,
                          size: 30,
                        )
                      : value == 'Car'
                          ? const Icon(
                              Icons.directions_car,
                              color: Colors.orange,
                              size: 30,
                            )
                          : const Icon(Icons.warning);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CustomCard(
                        onPressed: () {
                          controller.selectOption(value);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              icon,
                              const SizedBox(width: 8.0), // Add space here
                              Radio(
                                focusColor: Colors.white,
                                groupValue: controller.selectedRadioValue.value,
                                onChanged: (newValue) {
                                  controller.selectOption(newValue.toString());
                                },
                                value: value,
                              ),
                              Text(
                                value,
                                style: Get.textTheme.bodySmall!.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 4,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Key Description",
                hintText: "Enter Key description",
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TypeAheadFormField<
                      GoodsInspectionOtherDepartmentListModel>(
                    direction: AxisDirection.down,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      enabled: true,
                      controller: controller.keyDepartmentNameController,
                      decoration: const InputDecoration(
                        labelText: 'Department Name',
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return controller.otherDepartmentList
                          .where((shortCode) => shortCode.deptName
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context,
                        GoodsInspectionOtherDepartmentListModel suggestion) {
                      return ListTile(
                        title: Text(suggestion.deptName),
                        trailing: Obx(
                          () => Checkbox(
                            value: controller.selectedDepartments.any(
                                (department) =>
                                    department.deptCode == suggestion.deptCode),
                            onChanged: (value) {
                              if (value == true) {
                                controller.selectedDepartments.add(
                                  KeyDeparment(
                                    keyId: 0,
                                    deptCode: suggestion.deptCode,
                                    deptName: suggestion.deptName,
                                  ),
                                );
                              } else {
                                controller.selectedDepartments.removeWhere(
                                    (department) =>
                                        department.deptCode ==
                                        suggestion.deptCode);
                              }
                            },
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected:
                        (GoodsInspectionOtherDepartmentListModel selected) {
                      if (controller.selectedDepartment.value == selected) {
                        Toaster.showToast(
                            "You've selected the same item again!");
                      } else {
                        controller.selectedDepartment.value = selected;
                        controller.keyDepartmentNameController.text =
                            selected.deptName;
                        controller.keyDeptCodeController.text =
                            selected.deptCode.toString();
                        controller.getKeyConcernedPerson(
                            selected.deptCode.toString());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TypeAheadFormField<SubDepartmentListModel>(
                    direction: AxisDirection.down,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      enabled: true,
                      controller: controller.keysNewController,
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
                                        controller:
                                            controller.addSubDepNameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Sub Dept Name',
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller:
                                            controller.addSubDeptIdController,
                                        decoration: const InputDecoration(
                                          labelText: 'Sub Dept ID',
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              controller.saveNewSubDepartment();
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
                      return controller.subDepartmentList
                          .where((sub) => sub.subDeptName
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context, SubDepartmentListModel suggestion) {
                      return ListTile(
                        title: Text(suggestion.subDeptName),
                      );
                    },
                    onSuggestionSelected: (SubDepartmentListModel suggestion) {
                      controller.selectedSubDepartment.value = suggestion;
                      controller.keysNewController.text =
                          suggestion.subDeptName;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Obx(() {
              if (controller.selectedDepartments.isNotEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                            label: Text("#",
                                style: Get.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600))),
                        DataColumn(
                            label: Text('Department Name',
                                style: Get.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600))),
                        DataColumn(
                            label: Text('Department Code',
                                style: Get.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600))),
                        DataColumn(
                            label: Text('Delete',
                                style: Get.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600))),
                      ],
                      rows: controller.selectedDepartments
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        KeyDeparment department = entry.value;
                        int serialNumber = index + 1;
                        List<Color> rowColors = [
                          const Color(0xffe5f7f1),
                          Colors.white
                        ];
                        Color rowColor = rowColors[index % rowColors.length];

                        return DataRow(
                          color: MaterialStateColor.resolveWith(
                              (states) => rowColor),
                          cells: <DataCell>[
                            DataCell(Text(serialNumber.toString())),
                            DataCell(Text(department.deptName)),
                            DataCell(Text(department.deptCode.toString())),
                            DataCell(
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  controller.removeDepartment(index);
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TypeAheadFormField<KeyConcernedPersonListModel>(
                    direction: AxisDirection.down,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      enabled: true,
                      controller: controller.keyPersonController,
                      decoration: const InputDecoration(
                        labelText: 'Select Concerned Person Name',
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return controller.concernedPersonList
                          .where((shortCode) => shortCode.employeeName
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                          .toList();
                    },
                    itemBuilder:
                        (context, KeyConcernedPersonListModel suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion.employeeName,
                        ),
                      );
                    },
                    onSuggestionSelected:
                        (KeyConcernedPersonListModel selected) {
                      if (!controller.selectedPersons.contains(selected)) {
                        controller.addSelectedPersonWithLevel(
                            selected, controller.selectedLevelValue.value);
                        controller.keyPersonController.text =
                            selected.employeeName;

                        controller.selectedPersonIndex =
                            controller.selectedPersons.indexOf(selected);
                      } else {
                        Toaster.showToast(
                            "You've selected the same item again!");
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Obx(() {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                          label: Text("Select Person Level")),
                      value: controller.selectedLevelValue.value,
                      items: controller.concernedPersonLevel.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          controller.selectedLevelValue.value = newValue;
                          if (controller.selectedPersonIndex >= 0 &&
                              controller.selectedPersonIndex <
                                  controller.selectedLevels.length) {
                            controller.selectedLevels[
                                controller.selectedPersonIndex] = newValue;
                          }
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Obx(() {
              if (controller.selectedPersons.isEmpty &&
                  controller.selectedLevelValue.value != null) {
                return const SizedBox.shrink();
              }
              return Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          controller.updateKeyData.value == null
                              ? 'Serial No'
                              : 'PersonID',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Employee Name',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Employee Code',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Designation',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Level',
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
                    rows: List<DataRow>.generate(
                      controller.selectedPersons.length,
                      (index) {
                        KeyConcernedPersonListModel person =
                            controller.selectedPersons[index];
                        int serialNumber = index + 1;
                        List<Color> rowColors = [
                          const Color(0xffe5f7f1),
                          Colors.white
                        ];
                        Color rowColor = rowColors[index % rowColors.length];
                        return DataRow(
                          color: MaterialStateColor.resolveWith(
                              (states) => rowColor),
                          cells: [
                            DataCell(controller.updateKeyData.value == null
                                ? Text(serialNumber.toString())
                                : Text(person.personId.toString())),
                            DataCell(
                              Text(person.employeeName),
                            ),
                            DataCell(
                              Text(person.employeeCardNo.toString()),
                            ),
                            DataCell(
                              Text(person.designation),
                            ),
                            DataCell(
                              Text(
                                controller
                                    .getSelectedLevelForPerson(index)
                                    .toString(),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  controller.removeSelectedPerson(index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            Obx(
              () {
                final isBookStatusChecked = controller.checkKeyStatus.value;
                return Column(
                  children: [
                    CheckboxListTile(
                      title: Text(
                        'Do You Want To Add Key Time?',
                        style: Get.textTheme.bodyMedium!.copyWith(
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      value: isBookStatusChecked,
                      onChanged: (value) {
                        controller.toggleBookStatus(value ?? false);
                      },
                    ),
                    if (isBookStatusChecked)
                      Column(
                        children: [
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: controller.selectedWeekdayIndex.value,
                                  items: controller.weekdays
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    WeekdayModel weekday = entry.value;
                                    return DropdownMenuItem(
                                      value: index,
                                      child: Text(weekday.name ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: (selected) {
                                    if (selected is int) {
                                      controller.onWeekdaySelected(selected);
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Select a weekday',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller
                                        .pickTime(context, "Key IssueTime")
                                        .then((issueTime) {
                                      if (controller.issueTimeController.text
                                          .isNotEmpty) {
                                        controller
                                            .pickTime(
                                                context, "Key Return Time")
                                            .then((returnTime) {
                                          if (controller.returnTimeController
                                              .text.isNotEmpty) {
                                            controller
                                                .pickTime(
                                                    context, "Key Alarm Time")
                                                .then((alarmTime) {
                                              if (controller.alarmTimeController
                                                  .text.isNotEmpty) {
                                                final selectedWeekday =
                                                    controller.weekdays[
                                                        controller
                                                            .selectedWeekdayIndex
                                                            .value];
                                                final entry = KeyTimeTable(
                                                  timeTableId: 0,
                                                  keyId: null,
                                                  keyCode: '',
                                                  weekDay:
                                                      selectedWeekday.name ??
                                                          '',
                                                  issueTime: controller
                                                      .issueTimeController.text,
                                                  returnTime: controller
                                                      .returnTimeController
                                                      .text,
                                                  alarmTime: controller
                                                      .alarmTimeController.text,
                                                );
                                                controller.addEntry(entry);
                                              }
                                            });
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller:
                                          controller.issueTimeController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        labelText: "Issue Time",
                                        fillColor: Colors.white,
                                        hintText: "12:00 PM",
                                        suffixIcon: Icon(Icons.access_time),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.pickTime(
                                        context, "Key Return Time");
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller:
                                          controller.returnTimeController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        labelText: "Key Return Time",
                                        fillColor: Colors.white,
                                        hintText: "12:00 PM",
                                        suffixIcon: Icon(Icons.access_time),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.pickTime(
                                        context, "Key Alarm Time");
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller:
                                          controller.alarmTimeController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        labelText: "Alarm Time",
                                        fillColor: Colors.white,
                                        hintText: "12:00 PM",
                                        suffixIcon: Icon(Icons.access_time),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ],
                );
              },
            ),
            const SizedBox(height: 25),
            Obx(() {
              if (controller.dataTableEntries.isNotEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: DataTable(
                        showCheckboxColumn: false,
                        horizontalMargin: 10,
                        columnSpacing: Get.width * 0.045,
                        columns: [
                          DataColumn(
                              label: Text("#",
                                  style: Get.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600))),
                          DataColumn(
                              label: Text("Week Day",
                                  style: Get.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600))),
                          DataColumn(
                              label: Text("Issue Time",
                                  style: Get.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600))),
                          DataColumn(
                              label: Text("Return Time",
                                  style: Get.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600))),
                          DataColumn(
                              label: Text("Alarm Time",
                                  style: Get.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600))),
                          DataColumn(
                              label: Text("Check To",
                                  style: Get.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600))),
                          DataColumn(
                              label: Text("Delete",
                                  style: Get.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600))),
                        ],
                        rows: List<DataRow>.generate(
                          controller.dataTableEntries.length,
                          (index) {
                            KeyTimeTable keyModel =
                                controller.dataTableEntries[index];
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
                                DataCell(Text(serialNumber.toString())),
                                DataCell(Text(keyModel.weekDay)),
                                DataCell(Text(keyModel.issueTime)),
                                DataCell(Text(keyModel.returnTime)),
                                DataCell(Text(keyModel.alarmTime)),
                                DataCell(
                                  Obx(() {
                                    final bool isChecked = controller.selectedItems.contains(keyModel);
                                    return Checkbox(
                                      value: isChecked,
                                      onChanged: (value) {
                                        if (value == true) {
                                          controller.selectedWeekday.value
                                              .name = keyModel.weekDay;
                                          controller.issueTimeController.text =
                                              keyModel.issueTime;
                                          controller.returnTimeController.text =
                                              keyModel.returnTime;
                                          controller.alarmTimeController.text =
                                              keyModel.alarmTime;
                                        }
                                      },
                                    );
                                  }),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      controller.removeTimeTable(index);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 25),
            SizedBox(
              height: 47,
              child: ElevatedButton(
                onPressed: () {
                  controller.saveKeyData();
                },
                child: Text(controller.updateKeyData.value == null
                    ? "Save Key"
                    : "Update Key"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
