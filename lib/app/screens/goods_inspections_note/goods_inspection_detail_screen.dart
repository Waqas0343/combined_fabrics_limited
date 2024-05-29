import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../fabric_inspection/shimmer/rolls_shimmer.dart';
import 'goods_inspection_controllers/goods_inspection_detail_controller.dart';
import 'goods_inspection_models/goods_inspection_other_department_model.dart';
import 'goods_inspection_models/igps_detail_model.dart';

class GoodsInspectionDetailScreen extends StatelessWidget {
  const GoodsInspectionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GoodsInspectionDetailController controller = Get.put(GoodsInspectionDetailController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Goods Inspection Detail',
        ),
        actions: [
          Row(
            children: [
              Text(
                "Select All",
                style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
              Obx(
                () => Checkbox(
                  value: controller.isSelectAllChecked.value,
                  onChanged: (value) {
                    controller.toggleSelectAll();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: [
                        Text(
                          'Date:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${controller.igpModel.value?.igpDate}",
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'IGP No:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${controller.igpModel.value?.igpNo}",
                          style: Get.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Vendor:',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${controller.igpModel.value?.vendor}",
                          maxLines: 1,
                          style: Get.textTheme.bodySmall!.copyWith(
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
          Obx(() {
            if (controller.iGpDetailList.isNotEmpty) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Requested Intimation",
                      style: Get.textTheme.titleSmall!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  if (controller.iGpDetailList.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                            label: Text(
                              "#",
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Item Name",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Dept Name",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "IGP QTY",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Other Dept",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          const DataColumn(
                            label: Text(
                              "Select",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          controller.iGpDetailList.length,
                          (index) {
                            IGPDetailListModel lotDetailModel =
                                controller.iGpDetailList[index];
                            List<Color> rowColors = [
                              const Color(0xffe5f7f1),
                              Colors.white
                            ];
                            Color rowColor =
                                rowColors[index % rowColors.length];
                            bool isSelected = controller.selectedItems
                                .contains(lotDetailModel);
                            Color backgroundColor = isSelected ? Colors.orange : rowColor;
                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                  (states) => backgroundColor),
                              onSelectChanged: (selected) {
                                controller.toggleSelect(lotDetailModel);
                              },
                              cells: [
                                DataCell(
                                  Text(
                                    lotDetailModel.igpSrNo.toString(),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxHeight: 100.0),
                                    child: SingleChildScrollView(
                                      child: ExpansionTile(
                                        title: Text(
                                          lotDetailModel.itemName
                                              .split(' ')
                                              .take(4)
                                              .join(' '),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        onExpansionChanged: (expanded) {
                                          if (expanded) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Item Detail'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Text(lotDetailModel
                                                        .itemName),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      lotDetailModel.deptName,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    lotDetailModel.igpQty.toString(),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 300, // Set the desired width
                                    child: TypeAheadFormField<
                                        GoodsInspectionOtherDepartmentListModel>(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: TextEditingController(
                                          text: lotDetailModel
                                                  .selectedDepartment
                                                  ?.deptName ??
                                              '',
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          suffixIcon:
                                              Icon(Icons.arrow_drop_down),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return controller.otherDepartmentList
                                            .where((item) => item.deptName
                                                .toLowerCase()
                                                .contains(
                                                    pattern.toLowerCase()))
                                            .toList();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(suggestion.deptName),
                                        );
                                      },
                                      onSuggestionSelected: (selected) {
                                        lotDetailModel.selectedDepartment =
                                            selected;
                                        controller.selectedShortTextController
                                            .text = selected.deptName;
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Obx(
                                    () => Checkbox(
                                      value: controller.selectedItems.contains(lotDetailModel),
                                      onChanged: (value) {
                                        controller.toggleSelect(lotDetailModel);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            }
            return const ShimmerForRollList();
          }),
          Obx(() {
            if (controller.iGpDetailList.isEmpty &&
                !controller.isLoading.value) {
              return const Center(
                child: Text(
                  'There is No Data About IGPS List!',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          Obx(() {
            if (controller.iGpDetailList.isEmpty &&
                controller.isLoading.value) {
              return const ShimmerForRollList();
            }
            return const SizedBox.shrink();
          }),
        ],
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
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(constraints.maxWidth, 0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Send Request',
                    style: Get.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: MyColors.shimmerHighlightColor,
                    ),
                  ),
                  onPressed: () {
                    controller.saveIGPsData();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
