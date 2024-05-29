import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../complaint_models/complaint_status_model.dart';
import '../complaint_models/get_department_complaint_model.dart';
import '../complaint_models/get_department_model.dart';
import 'controllers/received_complaint_controller.dart';

class ReceivedComplaintScreen extends StatelessWidget {
  const ReceivedComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReceivedComplaintController controller = Get.put(ReceivedComplaintController());
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        controller.getComplaintList();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            if (controller.selectedDepartment.value != null &&
                controller.cmpType == "Launcher") {
              return Text(
                "Complaint Launch By ${controller.selectedDepartment.value?.deptName}",
              );
            }
            return const Text("Receiver Complaints");
          },
        ),actions: [
        IconButton(
          icon: const Icon(Icons.create_new_folder_rounded),
          onPressed: () {
            Get.toNamed(AppRoutes.createNewComplaint);
          },
        ),
      ],

      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16,
        ),
        child: Column(
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
                  controller.applyFilter();
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(
              () => DropdownButtonFormField<ComplaintStatusListModel>(
                decoration: const InputDecoration(
                  labelText: 'Select Status',
                ),
                value: controller.selectedStatus.value,
                items: controller.statusList.map((status) {
                  return DropdownMenuItem<ComplaintStatusListModel>(
                    value: status,
                    child: Text(status.statusName),
                  );
                }).toList(),
                onChanged: (newValue) {
                  controller.selectedStatus.value = newValue;
                  controller.applyFilter();
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(() {
              if (controller.complaintList.isNotEmpty) {
                return TextFormField(
                  textInputAction: TextInputAction.search,
                  controller: controller.complaintTextController,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    filled: true,
                    fillColor: Colors.white,
                    isCollapsed: true,
                    hintStyle: Get.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade400,
                    ),
                    contentPadding: const EdgeInsets.all(10.0),
                    suffixIcon: controller.hasSearchText.value
                        ? Container(
                            padding: const EdgeInsets.all(6.0),
                            // Add padding to the icon
                            child: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                size: 20.0,
                                color: MyColors.accentColor,
                              ),
                              onPressed: () {
                                controller.complaintTextController.clear();
                                Get.focusScope?.unfocus();
                                controller.applyFilter();
                              },
                            ),
                          )
                        : null,
                  ),
                  onFieldSubmitted: (text) => controller.applyFilter(),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            Obx(() {
              if (controller.isLoading.value &&
                  controller.complaintList.isEmpty) {
                return const SingleChildScrollView(
                  child: ShimmerForRollList(),
                );
              } else if (controller.complaintList.isEmpty) {
                return const Center(
                  child: Text(
                    'No Data Found!',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: DataTable(
                        showCheckboxColumn: false,
                        horizontalMargin: 10,
                        columnSpacing: Get.width * 0.05,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Department',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Date',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Complaint Detail',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Priority',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Complaint By',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: controller.complaintList
                            .asMap()
                            .entries
                            .map((entry) {
                          final DepartmentComplaintListModel complaint =
                              entry.value;
                          Color textColor;
                          if (complaint.priority == 'High') {
                            textColor = Colors.red;
                          } else if (complaint.priority == 'Low') {
                            textColor = Colors.yellow;
                          } else if (complaint.priority == 'Routine') {
                            textColor = Colors.blue;
                          } else {
                            textColor = Colors.black; // Default text color
                          }
                          List<Color> rowColors = [
                            const Color(0xffe5f7f1),
                            Colors.white
                          ];
                          Color rowColor =
                              rowColors[entry.key % rowColors.length];
                          return DataRow(
                            color: MaterialStateColor.resolveWith(
                                (states) => rowColor),
                            cells: [
                              DataCell(
                                Text(controller.cmpType == "Launcher"
                                    ? complaint.toDeptSn
                                    : complaint.fromDeptSn),
                              ),
                              DataCell(
                                Text(
                                  complaint.dateTime,
                                ),
                              ),
                              DataCell(
                                Container(
                                  constraints:
                                      const BoxConstraints(maxHeight: 100.0),
                                  child: SingleChildScrollView(
                                    child: ExpansionTile(
                                      title: Text(
                                        complaint.detail
                                            .split(' ')
                                            .take(2)
                                            .join(' '),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Get.textTheme.titleSmall?.copyWith(
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
                                                    'Complaint Detail'),
                                                content: SingleChildScrollView(
                                                  child: Text(complaint.detail),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: const Text('Close'),
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
                                  complaint.priority,
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                              DataCell(
                                Text(
                                  complaint.status,
                                ),
                              ),
                              DataCell(
                                Text(
                                  complaint.complaintBy,
                                ),
                              ),
                            ],
                            onSelectChanged: (isSelected) {
                              if (isSelected != null && isSelected) {
                                Get.toNamed(
                                  AppRoutes.receivedComplaintsDetailForm,
                                  arguments: {
                                    'ComplaintModel': complaint,
                                    'ComplaintDecider': controller.dashboardDepartment.value?.userType
                                  },
                                );
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    if (controller.isLoading.value && controller.hasMore.value)
                      const SingleChildScrollView(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
