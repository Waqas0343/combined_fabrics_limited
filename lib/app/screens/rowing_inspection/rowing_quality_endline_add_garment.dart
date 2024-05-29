import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../../app_assets/styles/my_icons.dart';
import '../../app_widgets/custom_card.dart';
import '../../routes/app_routes.dart';
import 'controllers/rowing_quality_add_garment_controller.dart';
import 'models/rowing_quality_all_faults_model.dart';
import 'models/rowing_quality_operation_model.dart';

class AddEndLineSevenGarmentFault extends StatelessWidget {
  const AddEndLineSevenGarmentFault({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEndLineGarmentFaultController controller = Get.put(AddEndLineGarmentFaultController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("EndLine Garment Check"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const SizedBox(
            height: 10,
          ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: [
                        Text(
                          'Line No:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.lineNoController.text,
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'EndLine:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.endLineController.text,
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'W/O #:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.workOrderController.text,
                          maxLines: 1,
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Bundle #:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.bundleController.text,
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Bundle Qty:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.bundleQtyController.text,
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 120,
            child: PageView.builder(
              controller: controller.pageController,
              scrollDirection: Axis.vertical,
              itemCount: int.tryParse(controller.bundleQtyController.text),
              itemBuilder: (context, index) {
                int garmentNumber = index + 1;
                Color backgroundColor = const Color(0xffe5f7f1);
                var result =
                    int.tryParse(controller.bundleQtyController.text)! - index;
                return Column(
                  children: [
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          itemCount: controller.inspectedPcsList.length,
                          itemBuilder: (context, index) {
                            var item = controller.inspectedPcsList[index];
                            ;
                            return ListTile(
                              leading: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Balance Quantity:',
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "$result",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Today Check:',
                                          style: Get.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${item.todayTotal}",
                                          style: Get.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  // Add space between the titles
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Total Psc:',
                                          style: Get.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${item.totalGarment}",
                                          style: Get.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    CustomCard(
                      color: backgroundColor,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 16.0,
                          backgroundColor: MyColors.primaryColor,
                          child: Container(
                            decoration: const BoxDecoration(shape: BoxShape.circle,
                              color: MyColors.greenLight,
                            ),
                            child: Center(
                              child: SvgPicture.asset(MyIcons.isGarment),
                            ),
                          ),
                        ),
                        title: Text(
                          ' $garmentNumber. Garment',
                          style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        subtitle: Text(
                          'CFL QA  System',
                          style: Get.textTheme.titleSmall?.copyWith(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Fault Selection',
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TypeAheadFormField<RowingQualityAllFaultsListModel>(
                                          direction: AxisDirection.down,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          textFieldConfiguration: TextFieldConfiguration(
                                            autofocus: false,
                                            enabled: true,
                                            controller: controller.faultsController,
                                            decoration: const InputDecoration(
                                              labelText: 'Select Fault Name',
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return controller.faultsList.where((fault) => '${fault.longname} ${fault.code}'.toLowerCase().contains(pattern.toLowerCase())).toList();
                                          },
                                          itemBuilder: (context, RowingQualityAllFaultsListModel suggestion) {
                                            return ListTile(
                                              dense: true,
                                              minLeadingWidth: 0,
                                              contentPadding: const EdgeInsets.only(top: 22.0, left: 6.0, right: 0.0),
                                              minVerticalPadding: 0,
                                              horizontalTitleGap: 0,
                                              title: Text(suggestion.longname),
                                              subtitle: Text(suggestion.code.toString()),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 120,
                                                    child: Obx(
                                                      () => TextFormField(
                                                        textAlign: TextAlign.center,
                                                        keyboardType: TextInputType.number,
                                                        controller: TextEditingController(
                                                          text: '${suggestion.quantity.value}',
                                                        ),
                                                        onChanged: (value) {
                                                          int? intValue = int.tryParse(value);
                                                          if (intValue != null && intValue >= 1 && intValue <= 12) {
                                                            suggestion.quantity.value = intValue;
                                                            if (intValue == 1) {
                                                              controller.toggleFaultSelection(suggestion, true);
                                                            }
                                                          }
                                                        },
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: "",
                                                          labelText: 'Faults',
                                                          labelStyle: const TextStyle(fontSize: 12),
                                                          filled: true,
                                                          counterText: "",
                                                          prefixIcon: IconButton(
                                                            onPressed: () {
                                                              if (suggestion.quantity.value > 0) {
                                                                suggestion.quantity.value--;
                                                                if (suggestion.quantity.value ==0) {
                                                                  controller.toggleFaultSelection(suggestion, false); // Uncheck checkbox when quantity is 0
                                                                }
                                                              }
                                                            },
                                                            icon: const Icon(Icons.remove_circle_outline,
                                                              color: Colors.orange,
                                                            ),
                                                          ),
                                                          suffixIcon: IconButton(
                                                            onPressed: () {
                                                              if (suggestion.quantity.value < 12) {
                                                                suggestion.quantity.value++;
                                                                controller.toggleFaultSelection(suggestion, true); // Select checkbox when quantity is changed
                                                              }
                                                            },
                                                            icon: const Icon(
                                                              Icons.add_circle_outline,
                                                              color: Colors.redAccent,
                                                            ),
                                                          ),
                                                          contentPadding: const EdgeInsets.symmetric(
                                                            horizontal: 16.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Obx(
                                                        () => Checkbox(
                                                      value: suggestion.quantity.value > 0, // Check if the quantity is greater than 0
                                                      onChanged: (bool? value) {
                                                        if (value != null) {
                                                          // Update the quantity based on the checkbox state
                                                          suggestion.quantity.value = value ? 1 : 0;
                                                          // Toggle fault selection accordingly
                                                          controller.toggleFaultSelection(suggestion, value);
                                                        }
                                                      },
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            );
                                          },
                                          onSuggestionSelected:
                                              (RowingQualityAllFaultsListModel suggestion) {
                                            controller.selectedFaults.clear();
                                            controller.selectedFaults.add(suggestion);
                                            controller.faultsController.text = suggestion.longname;
                                          },
                                        ),
                                        Obx(
                                          () {
                                            if (controller.selectedFaults.isNotEmpty &&
                                                controller.selectedFaults[0].dftLongname == 'Both') {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 20.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: MyColors.greenLight,
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                  child: CustomCard(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: controller.faultType.map((String value) {
                                                        return Row(
                                                          children: [
                                                            Radio<String>(
                                                              value: value,
                                                              groupValue: controller.selectedFaultType.value,
                                                              onChanged: (String?
                                                              newValue) {
                                                                controller.selectedFaultType.value = newValue!;
                                                              },
                                                            ),
                                                            Text(
                                                              value,
                                                              style: Get.textTheme.titleSmall?.copyWith(
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Obx(
                                              () {
                                            if (controller.selectedFaults.isNotEmpty) {
                                              // Filter out faults with a quantity of 0
                                              List<RowingQualityAllFaultsListModel> faultsWithQuantity = controller.selectedFaults.where((fault) => fault.quantity.value > 0).toList();

                                              return SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
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
                                                        'Fault',
                                                        style: Get.textTheme.titleSmall?.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Qty',
                                                        style: Get.textTheme.titleSmall?.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  rows: List<DataRow>.generate(
                                                    faultsWithQuantity.length,
                                                        (index) {
                                                      RowingQualityAllFaultsListModel selectedFault = faultsWithQuantity[index];
                                                      int serialNumber = index + 1;
                                                      return DataRow(
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
                                                            Text(selectedFault.longname),
                                                          ),
                                                          DataCell(
                                                            // Use the quantity associated with the selected fault
                                                            Obx(
                                                                  () => Text(selectedFault.quantity.value.toString()),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),

                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Obx(() {
                                          // && controller.selectedFaults.where((fault) => fault.areaOrDept != "SEWING").isNotEmpty
                                          if (controller.selectedFaults.isNotEmpty && controller.selectedFaults.where((fault) => fault.areaOrDept == "SEWING").isNotEmpty)  {
                                            return TypeAheadFormField<RowingQualityOperationListModel>(
                                              direction: AxisDirection.up,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              textFieldConfiguration: TextFieldConfiguration(
                                                autofocus: false,
                                                enabled: true,
                                                controller: controller.operationController,
                                                decoration: const InputDecoration(
                                                  labelText: 'Select Operation',
                                                ),
                                              ),
                                              suggestionsCallback: (pattern) {
                                                return controller.operationList
                                                    .where((fault) => fault.operationname.toLowerCase().contains(pattern.toLowerCase())).toList();
                                              },
                                              itemBuilder: (context, RowingQualityOperationListModel suggestion) {
                                                return ListTile(
                                                  dense: true,
                                                  minLeadingWidth: 0,
                                                  contentPadding: const EdgeInsets.only(top: 22.0, left: 6.0, right: 0.0),
                                                  minVerticalPadding: 0,
                                                  horizontalTitleGap: 0,
                                                  title: Text(
                                                    suggestion.operationname, style: Get.textTheme.titleSmall,
                                                  ),
                                                  subtitle: Text(suggestion.operationcode.toString()),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Obx(
                                                        () => Checkbox(
                                                          value: controller.isSelectedOperation(suggestion),
                                                          onChanged: (bool? value) {
                                                            controller.toggleOperationSelection(suggestion);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              onSuggestionSelected: (RowingQualityOperationListModel suggestion) {
                                                controller.selectedOperation.clear();
                                                controller.selectedOperation.add(suggestion);
                                                controller.operationController.text = suggestion.operationname;
                                              },
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Obx(() {
                                            if (controller.selectedOperation.isNotEmpty) {
                                              return SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: DataTable(showCheckboxColumn: false,
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
                                                          'Operation',
                                                          style: Get.textTheme.titleSmall?.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    rows: List<DataRow>.generate(
                                                      controller.selectedOperation.length,
                                                      (index) {
                                                        RowingQualityOperationListModel selectedFault = controller.selectedOperation[index];
                                                        int serialNumber = index + 1;
                                                        return DataRow(
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
                                                              Text(selectedFault.operationname),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: 300,
                                            child: Obx(() {
                                              if (controller.selectedFaults.isNotEmpty || (controller.selectedFaults.every((fault) => fault.areaOrDept == "SEWING") || controller.selectedOperation.isNotEmpty)) {
                                                return ElevatedButton(
                                                  onPressed: (controller.selectedFaults.isNotEmpty) ? () {
                                                    Get.until((route) => Get.isDialogOpen == false);
                                                    controller.garmentFaults[index]['fault'] = controller.selectedFaults;
                                                    int totalQuantity = controller.selectedFaults.isNotEmpty
                                                        ? controller.selectedFaults.fold<int>(0, (sum, fault) => sum + fault.quantity.value)
                                                        : 0;
                                                    controller.garmentFaults[index]['quantity'] = totalQuantity;
                                                    controller.totalFaultsAdded += totalQuantity;
                                                    String selectedFaultType;
                                                    if (controller.selectedFaults.isNotEmpty &&
                                                        controller.selectedFaults[0].dftLongname == 'Both') {
                                                      selectedFaultType = controller.selectedFaultType.value;
                                                    } else {
                                                      selectedFaultType = controller.selectedFaults.isNotEmpty
                                                          ? controller.selectedFaults[0].dftLongname
                                                          : '';
                                                    }

                                                    controller.garmentFaults[index]['type'] = selectedFaultType;
                                                    controller.saveRowingQualityFaultDetail(index);
                                                    // Adjust the condition to check if index + 1 is less than or equal to bundleQty
                                                    if (index + 1 < int.parse(controller.bundleQtyController.text)) {
                                                      controller.pageController.nextPage(
                                                        duration: const Duration(milliseconds: 500),
                                                        curve: Curves.easeInOut,
                                                      );
                                                      controller.faultsController.clear();
                                                    } else {
                                                      Get.offAllNamed(AppRoutes.endLineInspection,
                                                          arguments: {
                                                        'W/O': controller.workOrderController.text,
                                                        'LineNo': controller.lineNoController.text,
                                                          });
                                                      Debug.log('--------------------------------------${controller.lineNoController.text}');
                                                    }
                                                  } : null,
                                                  child: const Text("SUBMIT"),
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            })
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                                // Close the first dialog
                              },
                              child: const Text(" DEFECT "),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Get.until((route) => Get.isDialogOpen == false);
                                controller.garmentFaults[index]['fault'] = controller.selectedFaults;
                                int totalQuantity = controller.selectedFaults.isNotEmpty ? controller.selectedFaults.fold<int>(0, (sum, fault) => sum + fault.quantity.value)
                                        : 0;
                                controller.garmentFaults[index]['quantity'] = totalQuantity;
                                controller.totalFaultsAdded += totalQuantity;
                                String selectedFaultType;
                                if (controller.selectedFaults.isNotEmpty && controller.selectedFaults[0].dftLongname == 'Both') {
                                  selectedFaultType = controller.selectedFaultType.value;
                                } else {
                                  selectedFaultType = controller.selectedFaults.isNotEmpty
                                      ? controller.selectedFaults[0].dftLongname
                                      : '';
                                }
                                controller.garmentFaults[index]['type'] = selectedFaultType;
                                controller.saveRowingQualityFaultDetail(index);
                                if (index + 1 < int.parse(controller.bundleQtyController.text)) {
                                  controller.pageController.nextPage(duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                  controller.faultsController.clear();
                                } else {
                                  Get.offAllNamed(AppRoutes.endLineInspection,
                                      arguments: {
                                        'W/O': controller.workOrderController.text,
                                        'LineNo': controller.lineNoController.text,
                                      });
                                  Debug.log('--------------------------------------${controller.lineNoController.text}');
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              ),
                              child: const Text(" SUBMIT "),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          SizedBox(
            height: 47,
            child: ElevatedButton(
              onPressed: () {
                controller.rowingQualitySkipInspection();
              },
              child: const Text(
                "Next Bundle",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
