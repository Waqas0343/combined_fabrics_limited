import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/app_theme_info.dart';
import '../../app_widgets/custom_card.dart';
import '../../routes/app_routes.dart';
import 'controllers/check_all_machine_controller.dart';

class OtherApplication extends StatelessWidget {
  const OtherApplication({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckAllMachineFlagController controller =
        Get.put(CheckAllMachineFlagController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check All Machine Flags"),
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
            PreferredSize(
              preferredSize: const Size.fromHeight(100.0),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: "Search Machine No",
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
                  SizedBox(
                    height: Get.height * 3.1,
                    child: Obx(() {
                      final machineDataList = controller.machineList;
                      final isLoading =
                          machineDataList.isEmpty && controller.isLoading.value;
                      if (isLoading) {
                        return const Align(
                          alignment: Alignment.topCenter,
                          child: CircularProgressIndicator(),
                        );
                      } else if (machineDataList.isEmpty && controller.isLoading.value) {
                        return const Center(
                          child: Text(
                            "Data Not Found",
                          ),
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.machineList.length,
                          itemBuilder: (context, index) {
                            final machine = controller.machineList[index];
                            return CustomCard(
                              onPressed: () {
                                Get.toNamed(
                                  AppRoutes.changeMachineFlagScreen,
                                  arguments: {
                                    'model': machine,
                                  },
                                );
                              },
                              child: ListTile(
                                leading: ClipOval(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    color: Color(
                                        int.parse('0x${machine.colorHexCode}')),
                                    child: const Center(
                                      child: Icon(
                                        Icons.flag_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "MC# ${machine.machineCode}",
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12
                                  ),
                                ),
                                subtitle: Text(
                                    "Emp ${machine.empOperatorCode.toString()}"),

                              ),
                            );
                          },
                        );
                      }
                    }),
                  ),
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
