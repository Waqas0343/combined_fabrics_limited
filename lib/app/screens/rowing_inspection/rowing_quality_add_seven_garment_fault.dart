import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../../app_assets/styles/my_icons.dart';
import '../../app_widgets/custom_card.dart';
import '../../routes/app_routes.dart';
import '../fabric_inspection/widget/switch.dart';
import 'controllers/add_in_line_fault_controller.dart';
import 'models/rowing_quality_fault_model.dart';

class InLineInspectionFaultScreen extends StatelessWidget {
  const InLineInspectionFaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddInLineFaultsController controller = Get.put(AddInLineFaultsController());
    PageController pageController = PageController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add In Line Faults"),
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
                          'Operator Name:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.operator,
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Work Order:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.workOrder ?? '',
                          maxLines: 1,
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Machine Code:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.machineCode ?? '',
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Operation:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.operation ?? '',
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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.work_history_outlined,
                              size: 24,
                              color: MyColors.primaryColor,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: "No Work On Machine",
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: MyColors.blueAccentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Transform.scale(
                      scale: 0.6,
                      child: CustomSwitch(
                        value: controller.isNoWork.value,
                        onChanged: (bool value) {
                          if (value) {
                            controller.saveInspectionFlagColor();
                          }
                          controller.toggleSwitch(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: 80,
                child: PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    int garmentNumber = index + 1;
                    Color backgroundColor = const Color(0xffe5f7f1);
                    return CustomCard(
                      color: backgroundColor,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(

                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: MyColors.primaryColor,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors.greenLight,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                MyIcons.isGarment,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          ' $garmentNumber. Garment',
                          style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        subtitle: Text(
                          'CFL 7.0  System',
                          style:
                              Get.textTheme.titleSmall?.copyWith(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          // Ensure that the Row takes minimum space
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Fault Selection',
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TypeAheadFormField<RowingQualityFaultListModel>(
                                          direction: AxisDirection.down,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            autofocus: false,
                                            enabled: true,
                                            controller:
                                                controller.faultsController,
                                            decoration: const InputDecoration(
                                              labelText: 'Select Fault Name',
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return controller.faultsList.where((fault) => '${fault.longname} ${fault.code}'.toLowerCase().contains(pattern.toLowerCase())).toList();
                                          },
                                          itemBuilder: (context,
                                              RowingQualityFaultListModel suggestion) {
                                            return ListTile(
                                              dense: true,
                                              minLeadingWidth: 0,
                                              contentPadding: const EdgeInsets.only(top: 22.0, left: 6.0, right:  6.0),
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
                                                        controller: TextEditingController(text: '${suggestion.quantity.value}'),
                                                        onChanged: (value) {
                                                          int? intValue = int.tryParse(value);
                                                          if (intValue != null && intValue >= 1 && intValue <= 12) {
                                                            suggestion.quantity.value = intValue;
                                                            if (intValue == 1) {
                                                              // Automatically check the checkbox if quantity becomes 1
                                                              controller.toggleFaultSelection(suggestion, true);
                                                            }
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: "",
                                                          labelText: 'Faults',
                                                          labelStyle: const TextStyle(fontSize: 12),
                                                          filled: true,
                                                          counterText: "",
                                                          prefixIcon:
                                                              IconButton(
                                                                onPressed: () {
                                                                  if (suggestion.quantity.value > 0) {
                                                                    suggestion.quantity.value--;
                                                                    if (suggestion.quantity.value == 0) {
                                                                      controller.toggleFaultSelection(suggestion, false); // Uncheck checkbox when quantity is 0
                                                                    }
                                                                  }
                                                                },
                                                            icon: const Icon(
                                                              Icons.remove_circle_outline,
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
                                                      value: controller.isSelectedFault(suggestion),
                                                      onChanged: (bool? value) {
                                                        if (value != null && value) {
                                                          suggestion.quantity.value = 1;
                                                        }
                                                        controller.toggleFaultSelection(suggestion, true);

                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          onSuggestionSelected: (RowingQualityFaultListModel suggestion) {
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
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          MyColors.greenLight,
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
                                                              onChanged: (String?newValue) {
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
                                            if (controller
                                                .selectedFaults.isNotEmpty) {
                                              return SizedBox(
                                                width: 600,
                                                // Set a width that suits your layout
                                                child: Center(
                                                  child: SingleChildScrollView(
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
                                                            'Fault Type',
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
                                                      rows: List<
                                                          DataRow>.generate(
                                                        controller.selectedFaults.length,
                                                        (index) {
                                                          RowingQualityFaultListModel selectedFault = controller.selectedFaults[index];
                                                          int serialNumber = index + 1;
                                                          return DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(
                                                                Align(
                                                                  alignment:
                                                                      Alignment.centerLeft,
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
                                                                  Text(selectedFault.dftLongname)),
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
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.until((route) => Get.isDialogOpen == false);
                                              // Your existing logic after closing the dialogs
                                              controller.garmentFaults[index]['fault'] = controller.selectedFaults;
                                              int totalQuantity = controller.selectedFaults.isNotEmpty
                                                  ? controller.selectedFaults.fold<int>(0, (sum, fault) => sum + fault.quantity.value)
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
                                              List<Map<String, dynamic>>garmentFaultDetails = controller.garmentFaults.map((garment) {
                                                final dynamic faultData = garment['fault'];
                                                final List<RowingQualityFaultListModel>
                                                faultList = faultData is List<RowingQualityFaultListModel> ? faultData : [];
                                                final String faultType = garment['type'] is String ? garment['type'] : '';
                                                final int faultCount = faultList.length;
                                                final int defectCount = faultList.where((fault) => fault.dftLongname == 'Defect').length;
                                                return {
                                                  'type': faultType,
                                                  'faultCount': faultCount,
                                                  'defectCount': defectCount,
                                                };
                                              }).toList();

                                              Color flagColor = controller.calculateFlagColor(garmentFaultDetails);

                                              if (index < 6) {
                                                pageController.nextPage(duration: const Duration(milliseconds: 500),
                                                  curve: Curves.easeInOut,
                                                );
                                                controller.faultsController.clear();
                                              } else {
                                                Get.toNamed(
                                                  AppRoutes.inLineFlagScreen,
                                                  arguments: {
                                                    'color': flagColor,
                                                    'FormNo': controller.formNo,
                                                    'LineNo': controller.lineNo
                                                  },
                                                );
                                              }
                                            },
                                            child: const Text("SUBMIT"),
                                          ),
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
                                controller.garmentFaults[index]['fault'] = controller.selectedFaults;
                                int totalQuantity =
                                    controller.selectedFaults.isNotEmpty ? controller.selectedFaults.fold<int>(0, (sum, fault) => sum + fault.quantity.value)
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

                                List<Map<String, dynamic>> garmentFaultDetails = controller.garmentFaults.map((garment) {
                                  final dynamic faultData = garment['fault'];
                                  final List<RowingQualityFaultListModel>faultList = faultData is List<RowingQualityFaultListModel>
                                          ? faultData
                                          : [];
                                  final String faultType = garment['type'] is String ? garment['type'] : '';
                                  final int faultCount = faultList.length;
                                  final int defectCount = faultList.where((fault) => fault.dftLongname == 'Defect').length;
                                  return {
                                    'type': faultType,
                                    'faultCount': faultCount,
                                    'defectCount': defectCount,
                                  };
                                }).toList();

                                Color flagColor = controller.calculateFlagColor(garmentFaultDetails);

                                if (index < 6) {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                  controller.faultsController.clear();
                                } else {
                                  Get.toNamed(
                                    AppRoutes.inLineFlagScreen,
                                    arguments: {
                                      'color': flagColor,
                                      'FormNo': controller.formNo,
                                      'LineNo': controller.lineNo
                                    },
                                  );
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
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
