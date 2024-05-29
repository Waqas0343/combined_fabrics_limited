import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/my_images.dart';
import '../../routes/app_routes.dart';
import 'controllers/in_line_inspection_form_controller.dart';
import 'models/rowing_quality_inline_inspection_form_model.dart';
import 'models/rowing_quality_operator_operation_model.dart';

class InLineInspection extends StatelessWidget {
  const InLineInspection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InLineInspectionFormController controller = Get.put(InLineInspectionFormController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("In Line Inspection"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: controller.formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  controller: controller.dateController,
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: "Today Date:",
                    hintText: "01/30/2020",
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),

                DropdownButtonFormField(
                  value: controller.selectedLinSection.value,
                  onChanged: (String? newValue) {
                    controller.selectedLinSection.value = newValue!;
                    controller.selectedOperatorController.clear();
                    controller.operationList.value.clear();
                    controller.getRowingQualityInlineInspectionFormList(newValue); // Pass selected value
                  },
                  hint: const Text("Select Line No"),
                  items: controller.lineSectionName.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField(
                  value: controller.selectedRound.value,
                  onChanged: (String? newValue) {
                    controller.selectedRound.value = newValue!;
                  },
                  hint: const Text("Select Round No"),
                  items: controller.rounds.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TypeAheadFormField<RowingQualityInlineInspectionFormListModel>(
                  direction: AxisDirection.down,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    enabled: true,
                    keyboardType: TextInputType.number,
                    controller: controller.selectedOperatorController,
                    decoration:  InputDecoration(
                      labelText: 'Select Machine',
                      suffixIcon: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () async {
                              var results = await  Get.toNamed(AppRoutes.rowingQualityScanNFC);
                              if (results != null) {
                                controller.selectedOperatorController.text = results;
                                controller.getRowingQualityOperationList( controller.selectedOperatorController.text);
                              }
                              controller.isLoading.value = false;
                          },
                          child: const Text("Scan Card"),
                        ),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    Set<String> uniqueWorkerIDs = {};
                    final uniqueMachine = controller.workerAndOrderList.where((workOrder) {
                      String workerID = workOrder.machineId.toString();
                      return workerID.toLowerCase().contains(pattern.toLowerCase()) && uniqueWorkerIDs.add(workerID);
                    }).toList();

                    return uniqueMachine;
                  },
                  itemBuilder: (context, RowingQualityInlineInspectionFormListModel suggestion) {
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
                  onSuggestionSelected: (RowingQualityInlineInspectionFormListModel suggestion) {
                    controller.selected = suggestion;
                    controller.selectedOperator.value = suggestion;
                    controller.selectedOperatorController.text = suggestion.machineId.toString();
                    controller.getRowingQualityOperationList(suggestion.machineId.toString());
                  },
                ),
                const SizedBox(
                  width: 8.0,
                ),
                const SizedBox(height: 14),
                Obx(() {
                  return controller.operationList.isNotEmpty && !controller.isLoading.value
                      ? Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: DataTable(
                              showCheckboxColumn: false,
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    '#',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Card No',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Name',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'W/O #',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'M/C #',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'OperationID',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Operation',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                controller.operationList.length,
                                (index) {
                                  RowingQualityOperatorOperationListModel  operationModel = controller.operationList[index];
                                  int serialNumber = index + 1;
                                  List<Color> rowColors = [
                                    const Color(0xffe5f7f1),
                                    Colors.white
                                  ];
                                  Color rowColor =
                                  rowColors[index % rowColors.length];
                                  return DataRow(
                                    color: MaterialStateColor.resolveWith((states) => rowColor),
                                    cells: <DataCell>[
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            serialNumber.toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                            operationModel.workerId.toString()),
                                      ),
                                      DataCell(
                                        Text(
                                          operationModel.workerName,
                                        ),
                                      ),
                                      DataCell(
                                        Text(operationModel.orderDescription),
                                      ),
                                      DataCell(
                                        Text(
                                          operationModel.machineId,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          operationModel.operationId,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          operationModel.operationDescription,
                                        ),
                                      ),
                                    ],
                                    onSelectChanged: (isSelected) {
                                      if (isSelected != null && isSelected) {
                                        controller.saveInspectionFormData(index);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }),
                const SizedBox(
                  height: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
