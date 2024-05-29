import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../app_assets/app_theme_info.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../../app_assets/styles/my_icons.dart';
import '../../app_widgets/custom_card.dart';
import '../../routes/app_routes.dart';
import '../complaint_portal/complain_widget/complain_portal_dashboard_card.dart';
import 'controllers/key_issue_home_controller.dart';

class KeysIssuanceHome extends StatelessWidget {
  const KeysIssuanceHome({super.key});

  @override
  Widget build(BuildContext context) {
    final KeysHomeController controller = Get.put(KeysHomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keys Dashboard"),
      ),
      body: RefreshIndicator(
        onRefresh: controller.applyFilter,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          children: [
            Obx(() {
              if (controller.keysDataList.value != null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ComplaintPortalCard(
                        icon: const Icon(Icons.key_outlined),
                        color: Colors.orange,
                        titleText: 'Totat',
                        subTitleText: (controller.keysDataList.value?.totalKey)
                            .toString(),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ComplaintPortalCard(
                        icon: const Icon(Icons.key_outlined),
                        color: Colors.green.shade500,
                        titleText: 'IN Keys',
                        subTitleText:
                            (controller.keysDataList.value?.keyIn).toString(),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ComplaintPortalCard(
                        icon: const Icon(Icons.key_outlined),
                        color: Colors.red.shade400,
                        titleText: 'OUT Key',
                        subTitleText:
                            (controller.keysDataList.value?.keyOut).toString(),
                      ),
                    ),
                  ],
                );
              } else {
                // Render an empty SizedBox when the condition is not met
                return const SizedBox.shrink();
              }
            }),
            const SizedBox(
              height: 14,
            ),
            PreferredSize(
              preferredSize: const Size.fromHeight(100.0),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: "Search Key No",
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
            const SizedBox(
              height: 14,
            ),
            Center(
              child: Column(
                children: [
                  Obx(() {
                    final departmentCounts = controller.keysList;
                    final isLoading = departmentCounts.isEmpty &&
                        controller.isLoading.value;
                    if (isLoading) {
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _calculateCrossAxisCount(context),
                          mainAxisSpacing: 9.0,
                          crossAxisSpacing: 9.0,
                          childAspectRatio: _calculateAspectRatio(context),
                        ),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true, // Set shrinkWrap to true
                        itemCount: controller.keysList.length,
                        itemBuilder: (context, index) {
                          final keys = controller.keysList[index];
                          return CustomCard(
                            onLongPressed: () {
                              Get.toNamed(AppRoutes.checkKeyHistory,
                                  arguments: keys.keysDetails);
                            },
                            onPressed: () {
                              Get.toNamed(
                                AppRoutes.keysIssuanceReturnForm,
                                arguments: {
                                  'keys': keys,
                                },
                              );
                            },
                            child: ListTile(
                              leading: keys.keyType == 'Car'
                                  ? ClipOval(
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        color: keys.keyStatus == "IN"
                                            ? MyColors.greenLight
                                            : Colors.red,
                                        child: const Center(
                                          child: Icon(
                                            Icons.directions_car,
                                            color: Colors.tealAccent,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        color: keys.keyStatus == "IN"
                                            ? MyColors.greenLight
                                            : Colors.red,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            MyIcons.isKeysIssuance,
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                              title: Text(
                                "Key #:${keys.keyCode.toString()}",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(keys.keyDept),
                                  Text(keys.keyType),
                                ],
                              ),
                              trailing: Text(
                                keys.keyStatus,
                                style: Get.textTheme.titleSmall?.copyWith(
                                  color: keys.keyStatus == "IN"
                                      ? MyColors.greenLight
                                      : Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
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

int _calculateCrossAxisCount(BuildContext context) {
  return MediaQuery.of(context).size.width >= 768 ? 4 : 2;
}

double _calculateAspectRatio(BuildContext context) {
  int crossAxisCount = _calculateCrossAxisCount(context);
  return MediaQuery.of(context).size.width / (crossAxisCount * 90);
}
