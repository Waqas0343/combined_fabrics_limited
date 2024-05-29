import 'package:combined_fabrics_limited/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/app_theme_info.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../app_widgets/custom_card.dart';
import '../goods_inspections_note/igp_shimmer/igp_list_shimmer.dart';
import 'controllers/get_master_keys_controller.dart';
import 'models/get_master_keys_model.dart';

class KeysManagementScreen extends StatelessWidget {
  const KeysManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GetMasterKeysController controller = Get.put(GetMasterKeysController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Keys List"),
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
                      hintText: "Search Keys No",
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
              if (controller.masterKeysList.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4,
                    ),
                    itemBuilder: (_, int index) {
                      MasterKeysListModel masterKey = controller.masterKeysList[index];
                      Color backgroundColor = index % 2 == 0
                          ? Colors.white
                          : const Color(
                              0xffe5f7f1,
                            );

                      return CustomCard(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.addKeyByMasterScreen,
                            arguments: {"model": masterKey, 'index': index},
                          );
                        },
                        color: backgroundColor,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 20.0,
                            backgroundColor: MyColors.primaryColor,
                            child: Icon(
                              Icons.vpn_key_sharp,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            masterKey.keyCode.toString(),
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Key Type: ${masterKey.keyType} ",
                                style: Get.textTheme.titleSmall,
                              ),
                              Text(
                                  "Dept Code: ${masterKey.keyDeptCode.toString()} ",
                                  style: Get.textTheme.titleSmall),
                            ],
                          ),
                          trailing: Text(masterKey.keyDeptName),
                        ),
                      );
                    },
                    itemCount: controller.masterKeysList.length,
                  ),
                ),
              if (controller.masterKeysList.isEmpty &&
                  controller.isLoading.value)
                const Expanded(
                  child: AllNotificationsShimmer(),
                ),
              if (!controller.isLoading.value &&
                  controller.masterKeysList.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text("No Data Found..."),
                  ),
                )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addKeyByMasterScreen),
        backgroundColor: MyColors.blueAccentColor, // Professional color
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
