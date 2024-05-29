import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../app_widgets/custom_card.dart';
import '../goods_inspections_note/igp_shimmer/igp_list_shimmer.dart';
import 'medical_issuance_controllers/first_aid_box_issuace_controller.dart';
import 'medical_issuance_model/medicine_first_aid_box_issuance.dart';

class FirstAidBoxIssuance extends StatelessWidget {
  const FirstAidBoxIssuance({super.key});

  @override
  Widget build(BuildContext context) {
    final FirstAidBoxIssuanceController controller =
        Get.put(FirstAidBoxIssuanceController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("First Aid Box Medicine"),
            const SizedBox(
              width: 50,
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: "Date : ",
                    style: Get.textTheme.titleLarge?.copyWith(
                      color: MyColors.shimmerHighlightColor,
                    ),
                    children: [
                      TextSpan(
                        text: "${controller.dateController.text}  ",
                        style: Get.textTheme.titleLarge?.copyWith(
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.width > 600 ? 100.0 : 100.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.boxNoController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onFieldSubmitted: (String newValue) {
                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter(); // Call your auto-filter function here
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "e.g (10)",
                                labelText: 'First Aid Box No',
                                labelStyle: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                counterText: "",
                              ),
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await controller.pickFromDate();
                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter();
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: controller.fromDateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    label: Text(
                                      "From Date",
                                      style: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    hintText: "From Date",
                                    labelStyle: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    fillColor: Colors.white,
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 6.0,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await controller.pickFromDate();
                                if (controller.autoFilterEnabled.value) {
                                  controller.autoFilter();
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: controller.toDateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    label: Text(
                                      "From Date",
                                      style: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    hintText: "From Date",
                                    labelStyle: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    fillColor: Colors.white,
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Mobile view: 2 widgets in one row
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller.boxNoController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onFieldSubmitted: (String newValue) {
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter(); // Call your auto-filter function here
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "e.g (10)",
                                    labelText: 'First Aid Box No',
                                    filled: true,
                                    fillColor: Colors.white,
                                    counterText: "",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6.0,
                              ),
                              Expanded(
                                child:  GestureDetector(
                                  onTap: () async {
                                    await controller.pickFromDate();
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: controller.fromDateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        label: Text(
                                          "From Date",
                                          style: TextStyle(
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        hintText: "From Date",
                                        labelStyle: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        fillColor: Colors.white,
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6.0,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller.pickFromDate();
                                    if (controller.autoFilterEnabled.value) {
                                      controller.autoFilter();
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: controller.toDateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        label: Text(
                                          "From Date",
                                          style: TextStyle(
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        hintText: "From Date",
                                        labelStyle: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        fillColor: Colors.white,
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepOrangeAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Obx(
                                      () => Checkbox(
                                    value: controller.autoFilterEnabled.value,
                                    onChanged: (value) {
                                      controller.setAutoFilter(value ?? false);
                                    },
                                    activeColor: Colors
                                        .deepOrangeAccent, // Set the color of the checkbox
                                  ),
                                ),
                                Text(
                                  'Auto Filter ',
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              controller.getFirstAidMedicineList(
                                  fromData: controller.fromDateController.text,
                                  toDate: controller.toDateController.text,
                                  boxNo: controller.boxNoController.text
                             );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.filter_alt_outlined),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Apply Filter',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.fromDateController.clear();
                              controller.toDateController.clear();
                              controller.boxNoController.clear();
                              controller.fromDateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.toDateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                              controller.getFirstAidMedicineList(
                                fromData: controller.fromDateController.text,
                                toDate: controller.toDateController.text,
                                boxNo: null,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.filter_alt_off_outlined),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Clear Filter',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
      body: Obx(
        () => Column(
          children: [
            if (controller.firstAidList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  itemBuilder: (_, int index) {
                    FirstAidBoxMedicineIssuanceListModel medicineList = controller.firstAidList[index];
                    int itemIndex = index + 1;
                    Color backgroundColor = index % 2 == 0
                        ? Colors.white
                        : const Color(
                            0xffe5f7f1,
                          );

                    return CustomCard(
                      color: backgroundColor,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            leading: ClipOval(
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: MyColors.primaryColor,
                                ),
                                child:  Center(
                                  child: Text(
                                    itemIndex.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold// Choose a suitable font size
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: medicineList.patientCardNo != null
                                ? Text(
                                    medicineList.patientCardNo.toString(),
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : Text(
                                    medicineList.patiantName,
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            subtitle: Text(
                              "Date: ${medicineList.date}",
                            ),
                            trailing: Column(
                              children: [
                                medicineList.patientCardNo != null
                                    ? Text(
                                        "Box No: ${medicineList.patientCardNo.toString()}",
                                      )
                                    : Text(
                                        "PRP: ${medicineList.purpose}",
                                      ),
                                Text(
                                  "No: ${medicineList.issuanceNo.toString()}",
                                ),
                              ],
                            ),
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(),
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  horizontalMargin: 10,
                                  columnSpacing: Get.width * 0.045,
                                  columns: [
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          "#.",
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      numeric: true,
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          "Medicine Name",
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      numeric: true,
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          "Quantity",
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      numeric: true,
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          "Unit",
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      numeric: true,
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(
                                    medicineList.medicine.length,
                                    (index) {
                                      FirstAidMedicineList medicine =
                                          medicineList.medicine[index];
                                      int serialNumber = index + 1;

                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              serialNumber.toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                medicine.medicine,
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
                                                medicine.qty.toString(),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                medicine.unit.toString(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: controller.firstAidList.length,
                ),
              ),
            if (controller.firstAidList.isEmpty && controller.isLoading.value)
              const Expanded(
                child: AllNotificationsShimmer(),
              ),
            if (!controller.isLoading.value && controller.firstAidList.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("No Data Found..."),
                ),
              )
          ],
        ),
      ),
    );
  }
}
