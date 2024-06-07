import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app_assets/styles/my_colors.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../helpers/text_formatter.dart';
import '../complaint_models/complaint_assignee_model.dart';
import '../complaint_models/get_demand_model.dart';
import '../complaint_models/get_employee_by_department_model.dart';
import '../complaint_models/get_to_department_model.dart';
import 'controllers/received_complaint_detail_form_controller.dart';

class ReceivedComplaintDetailForm extends StatelessWidget {
  const ReceivedComplaintDetailForm({super.key});

  @override
  Widget build(BuildContext context) {
    final ReceivedComplaintDetailFormController controller =
    Get.put(ReceivedComplaintDetailFormController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaint Detail"),
      ),
      body: RefreshIndicator(
        onRefresh: controller.getComplaintByCMNO,
        child: ListView(
          padding: const EdgeInsets.all(
            8.0,
          ),
          children: [
            Obx(() {
              return CustomCard(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Date:  ${controller.complaintData.value?.dateTime ?? ''}",
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Date text color
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildRow(
                        'Tracking Id:',
                        controller.complaintData.value?.complaintId
                            .toString() ??
                            '',
                      ),
                      const Divider(height: 0),
                      buildRow(
                        'Complaint By:',
                        controller.complaintData.value?.userId ?? ' ',
                      ),
                      const Divider(height: 0),
                      buildRow(
                        'From Dept:',
                        controller.complaintData.value?.fromDepartment ?? ' ',
                      ),
                      const Divider(height: 0),
                      buildRow(
                        'To Dept:',
                        controller.complaintData.value?.toDepartment ?? ' ',
                      ),
                      const Divider(height: 0),
                      buildRow(
                        'Actual Date:',
                        "${controller.complaintData.value?.actualStartDate ?? ' '} - ${controller.complaintData.value?.actualEndDate ?? ' '}",
                      ),
                      const Divider(height: 0),
                      buildRow(
                          'Priority:',
                          controller.complaintData.value?.complaintPriority ??
                              " "),
                      const Divider(height: 0),
                      buildRow(
                        'Status:',
                        controller.complaintData.value?.complaintStatus ?? " ",
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 16.0,
            ),
            controller.cmpType == "Reciever"
                ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Actual Start Date Field
                      TextFormField(
                        controller: controller.actualStartDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Actual Start Date',
                          suffixIcon: IconButton(
                            onPressed: () => controller.selectDate(
                                context,
                                controller.actualStartDateController),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Actual End Date Field
                      TextFormField(
                        controller: controller.actualEndDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Actual End Date',
                          suffixIcon: IconButton(
                            onPressed: () => controller.selectDate(
                                context,
                                controller.actualEndDateController),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.setActualDate();
                          },
                          child: const Text('Set Actual Date'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Obx(
                          () => Expanded(
                        child: DropdownButtonFormField<
                            EmployeeByDepartmentListModel>(
                          decoration: const InputDecoration(
                            labelText: 'Select Assignee Person',
                          ),
                          value: controller.selectEmp.value,
                          items:
                          controller.employeeList.map((toDepartment) {
                            return DropdownMenuItem<
                                EmployeeByDepartmentListModel>(
                              value: toDepartment,
                              child: Text(toDepartment.employeeName),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              controller.selectEmp.value = newValue;
                              controller.addAssignee(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Obx(
                          () => Expanded(
                        child: DropdownButtonFormField<
                            ToDepartmentListModel>(
                          decoration: const InputDecoration(
                            labelText: 'Change Department',
                          ),
                          value: controller.selectedToDepartment.value,
                          items: controller.toDepartmentList
                              .map((toDepartment) {
                            return DropdownMenuItem<
                                ToDepartmentListModel>(
                              value: toDepartment,
                              child: Text(toDepartment.departmentName),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              controller.selectedToDepartment.value =
                                  newValue;
                              controller.changeDepartment(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 16.0,
            ),
            controller.cmpType == "Reciever"
                ? Obx(
                  () {
                if (controller.assigneePerson.isNotEmpty) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(
                          label: Text(
                            "#",
                            style: Get.textTheme.titleSmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            "Name",
                            style: Get.textTheme.titleSmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            'Card',
                            style: Get.textTheme.titleSmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Delete',
                            style: Get.textTheme.titleSmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        controller.assigneePerson.length,
                            (index) {
                          ComplaintAssigneeListModel demandModel = controller.assigneePerson[index];
                          int serialNumber = index + 1;
                          List<Color> rowColors = [
                            const Color(0xffe5f7f1),
                            Colors.white
                          ];
                          Color rowColor = rowColors[index % rowColors.length];
                          return DataRow(
                            color: MaterialStateColor.resolveWith((states) => rowColor),
                            cells: [
                              DataCell(Text(serialNumber.toString())),
                              DataCell(Text(demandModel.employeeName)),
                              DataCell(Text(demandModel.employeeCode.toString())),
                              DataCell(
                                GestureDetector(
                                  onTap: () => controller.removeAssignee(demandModel),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 16.0,
            ),
            controller.cmpType == "Reciever" && controller.demandList.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Change Complaint Status By Demand",
                  style: Get.textTheme.titleSmall?.copyWith(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller.demandNoController,
                        decoration: const InputDecoration(
                          hintText: "Enter Demand No",
                          labelText: 'Demand No',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller.demandSerialTextController,
                        decoration: InputDecoration(
                          hintText: "Enter Demand SrNo",
                          labelText: 'Demand SrNo',
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: ElevatedButton(
                            onPressed: () {
                              controller.applyFilter();
                            },
                            child: const Text("Search"),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 16.0,
            ),
            controller.cmpType == "Reciever"
                ? Column(
              children: [
                Obx(
                      () {
                    if (controller.demandList.isNotEmpty) {
                      return Table(
                        border: TableBorder.all(color: Colors.black87),
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(
                                color: Color(0xffe5f7f1)),
                            children: [
                              TableCell(
                                child: Center(
                                  child: Text('Demand NO',
                                      style: Get.textTheme.titleSmall),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text('SrNo',
                                      style: Get.textTheme.titleSmall),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text('Item',
                                      style: Get.textTheme.titleSmall),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text('Unit',
                                      style: Get.textTheme.titleSmall),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text('Stock',
                                      style: Get.textTheme.titleSmall),
                                ),
                              ),
                            ],
                          ),
                          for (var demandModel in controller.demandList)
                            TableRow(
                              decoration: const BoxDecoration(
                                  color: Colors.white),
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      demandModel.demandNo.toString(),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      demandModel.srNo.toString(),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      demandModel.item,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      demandModel.unit,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      demandModel.stock,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 16.0,
            ),
            controller.cmpType == "Reciever"
                ? Obx(
                  () {
                if (controller.demandList.isNotEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Demand",
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              "PR",
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              'PO',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'IGP',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'GRN',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Issue/Transfer',
                              style: Get.textTheme.titleSmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          controller.demandList.length,
                              (index) {
                            DemandListModel demandModel = controller.demandList[index];

                            List<Color> rowColors = [
                              const Color(0xffe5f7f1),
                              Colors.white
                            ];
                            Color rowColor = rowColors[index % rowColors.length];
                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                      (states) => rowColor),
                              cells: [
                                DataCell(Text(demandModel.demandNo.toString())),
                                DataCell(Text(demandModel.pr)),
                                DataCell(Text(demandModel.po)),
                                DataCell(Text(demandModel.igp)),
                                DataCell(Text(demandModel.grn)),
                                DataCell(Text(demandModel.issueNo)),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              enabled: false,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              controller: controller.textarea,
              decoration: InputDecoration(
                hintText: "",
                labelText: 'Complaint Detail',
                filled: true,
                fillColor: Colors.grey.shade100,
                counterText: "",
              ),
              validator: (text) {
                if (text!.isEmpty) {
                  return "Can't be empty";
                } else if (!GetUtils.hasMatch(text,
                    TextInputFormatterHelper.numberAndTextWithDot.pattern)) {
                  return "Complaint Detail ${Keys.bothTextNumber}";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() {
                return Column(
                  children: [
                    if (controller.isClose?.value == true)
                      SizedBox(
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return OutlinedButton(
                              onPressed: () async {
                                controller.closeComplaint();
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(constraints.maxWidth, 0),
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                "Complaint Closed",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (controller.isResolved?.value == true)
                      SizedBox(
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return SizedBox(
                              width: Get.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(constraints.maxWidth, 0),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(
                                  'Complaint Resolved',
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.shimmerHighlightColor,
                                  ),
                                ),
                                onPressed: () {
                                  controller.resolveComplaint();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    if (controller.isRejected?.value == true)
                      SizedBox(
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(constraints.maxWidth, 0),
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () async {
                                controller.complaintReject();
                              },
                              child: Text(
                                "Reject Complaint",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (controller.isVerified?.value == true)
                      SizedBox(
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(constraints.maxWidth, 0),
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                'Complaint Verify',
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.shimmerHighlightColor,
                                ),
                              ),
                              onPressed: () {
                                controller.complaintVerified();
                              },
                            );
                          },
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Get.textTheme.titleSmall
                ?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: Get.textTheme.titleSmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

