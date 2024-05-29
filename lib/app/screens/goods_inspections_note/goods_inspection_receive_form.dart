import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/app_theme_info.dart';
import '../../app_widgets/custom_card.dart';
import 'goods_inspection_controllers/goods_inspection_receive_igp_controller.dart';
import 'goods_inspection_models/goods_inspection_receive_igps_model.dart';
import 'igp_shimmer/igp_list_shimmer.dart';

class ReceiveIGPScreen extends StatelessWidget {
  const ReceiveIGPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoodsInspectionReceiveIGPController controller = Get.put(GoodsInspectionReceiveIGPController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receive IGP Screen"),
      ),
      body: RefreshIndicator(
        onRefresh: controller.applyFilter,
        child: Obx(
          () => Column(
            children: [
              PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
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
              if (controller.receiveList.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4,
                    ),
                    itemBuilder: (_, int index) {
                      ReceiveIGPListModel igpModel = controller.receiveList[index];
                      Color backgroundColor = index % 2 == 0
                          ? Colors.white
                          : const Color(
                              0xffe5f7f1,
                            );

                      return CustomCard(
                        color: backgroundColor,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 20.0,
                            backgroundColor: MyColors.primaryColor,
                            child: Icon(
                              Icons.call_received_outlined,
                              color: Colors.white, // Set the color of the icon
                            ),
                          ),
                          title: Text(
                            igpModel.igpNo.toString(),
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            igpModel.date,
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              controller.saveReceiveIGP(igpModel.igpNo);
                            },
                            child: const Text("Receive"),
                          ),
                        ),
                      );
                    },
                    itemCount: controller.receiveList.length,
                  ),
                ),
              if (controller.receiveList.isEmpty && controller.isLoading.value)
                const Expanded(
                  child: AllNotificationsShimmer(),
                ),
              if (!controller.isLoading.value && controller.receiveList.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text("No Data Found..."),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
