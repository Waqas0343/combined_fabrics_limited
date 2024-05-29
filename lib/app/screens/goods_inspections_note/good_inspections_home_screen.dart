import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/app_theme_info.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../routes/app_routes.dart';
import '../fabric_inspection/shimmer/rolls_shimmer.dart';
import 'goods_inspection_controllers/goods_inspection_home_controller.dart';
import 'goods_inspection_models/inpected_igps_list_model.dart';
import 'goods_inspection_models/received_igps_list_model.dart';
import 'goods_inspection_models/requested_igps_list_model.dart';

class GoodsInspectionsHomeScreen extends StatelessWidget {
  const GoodsInspectionsHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoodsInspectionHomeController controller = Get.put(GoodsInspectionHomeController());
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
            actions: [
              Row(
                children: [
                  const Text(
                    "Check History",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8.0),
                  Obx(
                    () => Checkbox(
                      value: controller.isChecked.value,
                      onChanged: (value) {
                        controller.toggle();
                        controller.getInspectedIGPList();
                      },
                    ),
                  ),
                ],
              ),
            ],
            title: const Text("Pending IGP'S Screen"),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0), // Add border radius
                color: Colors.orange, // Change indicator color
              ),
              controller: controller.tabController,
              onTap: (index) {
                controller
                    .setCurrentTabIndex(index); // Update the current tab index
              },
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  child: Text(
                    'Receive IGPs',
                    style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: MyColors.shimmerHighlightColor),
                  ),
                ),
                Tab(
                  child: Text(
                    'Pending Inspection',
                    style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: MyColors.shimmerHighlightColor),
                  ),
                ),
                Tab(
                  child: Text(
                    'Inspected IGPs',
                    style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: MyColors.shimmerHighlightColor),
                  ),
                ),
              ],
            )),
        body: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.search,
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: "Search IGP No",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppThemeInfo.borderRadius),
                    ),
                    fillColor: Colors.white,
                    isCollapsed: true,
                    hintStyle: Get.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade400,
                    ),
                    contentPadding: const EdgeInsets.all(10.0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 20.0,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        controller.searchController.clear();
                        controller
                            .applyFilter();
                      },
                    ),
                  ),
                  onFieldSubmitted: (text) {
                    if (text.isNotEmpty) {
                      controller.search(text);
                    } else {
                      controller
                          .applyFilter();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                ///todo First Index Data
                children: [
                  Obx(() {
                    if (controller.receivedIGpList.isNotEmpty && !controller.isLoading.value) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: DataTable(
                            showCheckboxColumn: false,
                            horizontalMargin: 10,
                            columnSpacing: Get.width * 0.030,
                            columns: [
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    "#",
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
                                    "IGP Date",
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
                                    "IGP NO",
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
                                    "Vendor",
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
                                    "Line Item",
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                numeric: true,
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              controller.receivedIGpList.length,
                              (index) {
                                ReceivedIGPListModel rollsModel =
                                    controller.receivedIGpList[index];
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
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          serialNumber.toString(),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          rollsModel.igpDate,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          rollsModel.igpNo.toString(),
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          rollsModel.vendor,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          rollsModel.lineItem.toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                  onSelectChanged: (isSelected) {
                                    if (isSelected != null && isSelected) {
                                      Get.toNamed(
                                        AppRoutes.goodsInspectionDetail,
                                        arguments: {
                                          'model': rollsModel,
                                        },
                                      );
                                    }
                                  },
                                  onLongPress: () {
                                    Get.defaultDialog(
                                      title: "Confirmation",
                                      textCancel: Keys.deleteDialogCancel,
                                      textConfirm: Keys.deleteDialogConfirm,
                                      middleText: Keys.reversDialogText,
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back();
                                        controller.igpReverse(rollsModel.igpNo);
                                      },
                                    );
                                    // Call igpReverse when long-pressed
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } else if (controller.receivedIGpList.isEmpty &&
                        controller.isLoading.value) {
                      return const ShimmerForRollList();
                    }
                    return const Center(
                      child: Text(
                        "No Data Found!",
                      ),
                    );
                  }),

                  ///todo Second Index Data
                  Obx(() {
                    if (controller.requestedIGpList.isNotEmpty &&
                        !controller.isLoading.value) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: DataTable(
                            showCheckboxColumn: false,
                            horizontalMargin: 10,
                            columnSpacing: Get.width * 0.030,
                            columns: [
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    "#.",
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
                                    "IGP Date",
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
                                    "IGP NO",
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
                                    "RequestedDept",
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
                                    "ItemName",
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
                                    "Pending Qty",
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
                                    "Vendor",
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
                                    "Total Item",
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                numeric: true,
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              controller.requestedIGpList.length,
                              (index) {
                                RequestedIGPSListModel requested =
                                    controller.requestedIGpList[index];
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
                                    DataCell(
                                      Text(
                                        serialNumber.toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        requested.igpDate.toString(),
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: MyColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        requested.igpNo.toString(),
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: MyColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(requested.requestedDept),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 100.0),
                                        child: SingleChildScrollView(
                                          child: ExpansionTile(
                                            title: Text(
                                              requested.itemName
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
                                                      title: const Text(
                                                          'Item Detail'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Text(
                                                            requested.itemName),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                              'Close'),
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
                                      Text(
                                        requested.pendingQty.toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 100.0),
                                        child: SingleChildScrollView(
                                          child: ExpansionTile(
                                            title: Text(
                                              requested.vendor
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
                                                      title: const Text(
                                                          'Vendor Detail'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Text(
                                                            requested.vendor),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                              'Close'),
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
                                      Text(
                                        requested.lineItem.toString(),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } else if (controller.requestedIGpList.isEmpty &&
                        controller.isLoading.value) {
                      return const ShimmerForRollList();
                    }
                    return const Center(
                      child: Text(
                        "No Data Found!",
                      ),
                    );
                  }),

                  ///todo Third Index Data
                  Obx(() {
                    if (controller.inspectedIGpList.isNotEmpty &&
                        !controller.isLoading.value) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: DataTable(
                            showCheckboxColumn: false,
                            horizontalMargin: 10,
                            columnSpacing: Get.width * 0.030,
                            columns: [
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    "#.",
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
                                    "IGP Date",
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
                                    "IGP NO",
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
                                    "Department",
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
                                    "InspectedBy",
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
                                    "ItemName",
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
                                    "Accept Qty",
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
                                    "Reject Qty",
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
                                    "Vendor",
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                numeric: true,
                              ),

                            ],
                            rows: List<DataRow>.generate(
                              controller.inspectedIGpList.length,
                              (index) {
                                InspectedIGPListModel inspected =
                                    controller.inspectedIGpList[index];
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
                                    DataCell(
                                      Text(
                                        serialNumber.toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        inspected.igpDate.toString(),
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: MyColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        inspected.igpNo.toString(),
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: MyColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(inspected.inspectedDept),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(inspected.inspectedBy),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 100.0),
                                        child: SingleChildScrollView(
                                          child: ExpansionTile(
                                            title: Text(
                                              inspected.itemName.split(' ').take(4).join(' '),
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
                                                      title: const Text(
                                                          'Item Detail'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Text(
                                                            inspected.itemName),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                              'Close'),
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
                                      Text(inspected.acceptedQty.toString()),
                                    ),
                                    DataCell(
                                      Text(inspected.rejectedQty.toString()),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 100.0),
                                        child: SingleChildScrollView(
                                          child: ExpansionTile(
                                            title: Text(
                                              inspected.vendor
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
                                                      title: const Text(
                                                          'Item Detail'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Text(
                                                            inspected.vendor),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                              'Close'),
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

                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } else if (controller.inspectedIGpList.isEmpty &&
                        controller.isLoading.value) {
                      return const ShimmerForRollList();
                    }
                    return const Center(
                      child: Text(
                        "No Data Found!",
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
