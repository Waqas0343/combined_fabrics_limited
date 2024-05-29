import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import '../../../app_assets/app_theme_info.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../app_widgets/custom_card.dart';
import '../goods_inspections_note/igp_shimmer/igp_list_shimmer.dart';
import 'medical_issuance_controllers/view_medicine_stock_controller.dart';
import 'medical_issuance_model/medicine_stock_model.dart';

class MedicineStockScreen extends StatelessWidget {
  const MedicineStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MedicineStockController controller =
        Get.put(MedicineStockController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Check Medicine Stock"),
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
            MediaQuery.of(context).size.width > 600 ? 40.0 : 60.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Search Medicine",
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
                suffixIcon: controller.hasSearchText.value
                    ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 20.0,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: () {
                    controller.searchController.clear();
                    Get.focusScope?.unfocus();
                    controller.applyFilter();
                  },
                )
                    : null,
              ),
              onFieldSubmitted: (text) => controller.applyFilter(),
            ),
          ),
        ),
      ),
      body: Obx(
        () => Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Add some spacing between buttons
                    ElevatedButton.icon(
                      onPressed: () async {
                        final pdf = await controller.generatePdf(
                            PdfPageFormat.a4, controller.medicineList);
                        await controller.previewPdf(pdf);
                      },
                      icon: const Icon(Icons.preview),
                      label: const Text('Preview'),
                    ),
                    const SizedBox(width: 4.0),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (controller.medicineList.isNotEmpty) {
                          controller.exportToExcel(
                              controller.medicineList, 'Medicine Stock');
                        } else {
                          Get.snackbar(
                            "Message",
                            'No data to export',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      icon: const Icon(Icons.file_download),
                      label: const Text('Export Excel'),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.medicineList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  itemBuilder: (_, int index) {
                    MedicineStockListModel medicineList =
                        controller.medicineList[index];
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
                          ListTile(
                            leading: ClipOval(
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: MyColors.primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    itemIndex.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight
                                            .bold // Choose a suitable font size
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              medicineList.itemName,
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              medicineList.stock.toStringAsFixed(0),
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: controller.medicineList.length,
                ),
              ),
            if (controller.medicineList.isEmpty && controller.isLoading.value)
              const Expanded(
                child: AllNotificationsShimmer(),
              ),
            if (!controller.isLoading.value && controller.medicineList.isEmpty)
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
