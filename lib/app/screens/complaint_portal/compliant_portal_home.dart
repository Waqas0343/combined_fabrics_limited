import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:combined_fabrics_limited/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'complain_widget/complain_portal_dashboard_card.dart';
import 'compliant_portal_home_controller/complaint_portal_home_controller.dart';

class ComplaintPortalHome extends StatelessWidget {
  const ComplaintPortalHome({super.key});

  @override
  Widget build(BuildContext context) {
    final ComplaintPortalHomeController controller = Get.put(ComplaintPortalHomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaint Portal DashBoard"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Container(
            width: 200,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/complaint.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.createNewComplaint),
            child: const ComplaintPortalCard(
              icon: Icon(Icons.create_outlined),
              color: Color(0xFF6C63FF),
              titleText: '',
              subTitleText: "New Complaints",
            ),
          ),
          const SizedBox(height: 12.0),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'All Departments Complaints Overview',
              style: Get.textTheme.titleMedium?.copyWith(

              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(
                () => Expanded(
                  child: ComplaintPortalCard(
                    icon: const Icon(Icons.create_outlined),
                    color: Colors.green.shade500,
                    titleText: '',
                    subTitleText:
                        "Ttl Cmp ${controller.complaintDashboard.value?.complaintsCount.toString()}",
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Obx(
                () => Expanded(
                  child: ComplaintPortalCard(
                    icon: const Icon(Icons.receipt_long_outlined),
                    color: const Color(0xFF50C9C3),
                    titleText: '',
                    subTitleText:
                        "Launcher ${controller.complaintDashboard.value?.userluancherCount}",
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Obx(
                () => Expanded(
                  child: ComplaintPortalCard(
                    icon: const Icon(Icons.receipt_long_outlined),
                    color: Colors.orange,
                    titleText: '',
                    subTitleText:
                        "Receiver ${controller.complaintDashboard.value?.userRecieverCount}",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Center(
            child: Column(
              children: [
                Obx(() {
                  final departmentCounts = controller.departmentCounts;
                  final isLoading =
                      departmentCounts.isEmpty && controller.isLoading.value;

                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _calculateCrossAxisCount(context),
                        mainAxisSpacing: 9.0,
                        crossAxisSpacing: 9.0,
                        childAspectRatio: _calculateAspectRatio(context),
                      ),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true, // Set shrinkWrap to true
                      itemCount: controller.departmentCounts.length,
                      itemBuilder: (context, index) {
                        final color = index.isEven ? const Color(0xffe5f7f1) : null;
                        final department = controller.departmentCounts[index];
                        return CustomCard(
                          color: color,
                          onPressed: () {
                            Get.toNamed(
                              AppRoutes.receivedComplaints,
                              arguments: {
                                'dashboardDepartment': department,
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(
                              department.deptName,
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Total Complaints: ${department.totalComplaints}',
                              textAlign: TextAlign.center,
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
          const SizedBox(
            height: 16,
          ),
        ],
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
