import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/app_theme_info.dart';
import '../../app_widgets/custom_card.dart';
import '../../routes/app_routes.dart';
import 'goods_inspection_controllers/goods_inspection_notification_controller.dart';
import 'goods_inspection_models/goods_inspection_notification_model.dart';
import 'igp_shimmer/igp_list_shimmer.dart';

class GoodInspectionNotificationScreen extends StatelessWidget {
  const GoodInspectionNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoodsInspectionNotificationController controller =
        Get.put(GoodsInspectionNotificationController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Goods Inspection Notification"),
      ),
      body: Obx(
        () => Column(
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
            if (controller.notificationList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  itemBuilder: (_, int index) {
                    NotificationListModel lotDetailModel = controller.notificationList[index];
                    return CustomCard(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.goodsInspectionForm,
                          arguments: {
                            'model': lotDetailModel,
                          },
                        );
                      },
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 20.0,
                          backgroundColor: MyColors.primaryColor,
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white, // Set the color of the icon
                          ),
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lotDetailModel.igpNo.toString(),
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "IGP Qty: ${lotDetailModel.igpQty.toString()}",
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lotDetailModel.itemDetail,
                            ),
                            Text(
                              lotDetailModel.requestDateTime,
                              style: Get.textTheme.titleSmall?.copyWith(),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          // Ensure that the Row takes minimum space
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                controller.saveInspectionFormData(index);
                              },
                              child: const Text("Accept"),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Get.toNamed(
                                  AppRoutes.goodsInspectionForm,
                                  arguments: {
                                    'model': lotDetailModel,
                                    'action': 'reject',
                                  },
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              child: const Text("Reject"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: controller.notificationList.length,
                ),
              ),
            if (controller.notificationList.isEmpty &&
                controller.isLoading.value)
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AllNotificationsShimmer(),
                ),
              ),
            if (!controller.isLoading.value &&
                controller.notificationList.isEmpty)
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
