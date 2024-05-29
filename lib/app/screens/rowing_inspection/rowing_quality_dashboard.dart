import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_widgets/confirmation_alert.dart';
import '../../routes/app_routes.dart';
import '../../services/preferences.dart';
import '../complaint_portal/complain_widget/complain_portal_dashboard_card.dart';
import 'controllers/rowing_quality_dashboard_controller.dart';

class RowingInspectionDashboard extends StatelessWidget {
  const RowingInspectionDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RowingQualityDashBoardController controller = Get.put(RowingQualityDashBoardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rowing Quality Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () => ConfirmationAlert.showDialog(
              title: "Logout Confirmation",
              description: "Are you sure you want to log out of this app?",
              onConfirm: () {
                Get.find<Preferences>().logout();
              },
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double deviceWidth = constraints.maxWidth;
          double imageHeight = 200.0;
          if (deviceWidth > 600) {
            imageHeight = 350.0;
          }
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              // Container(
              //   width: deviceWidth,
              //   height: imageHeight,
              //   decoration: BoxDecoration(
              //     color: Colors.blue,
              //     borderRadius: BorderRadius.circular(8.0),
              //   ),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(8.0),
              //     child: Image.asset(
              //       'assets/images/rowing_quality.png',
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 12.0,
              // ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Current ",
                  style: Get.textTheme.titleSmall,
                  children: [
                    TextSpan(
                      text: "User ",
                      style: Get.textTheme.titleSmall,
                    ),
                    TextSpan(
                      text: controller.employeeName,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>   Get.toNamed(AppRoutes.inLineInspection),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.start_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF50C9C3),
                        titleText: '',
                        subTitleText: "7.0 InLine Inspection",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.rowingQualityInLineReportsDashBoard),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.start_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF50C9C3),
                        titleText: '',
                        subTitleText: "7.0 InLine Inspection Reports",
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>  Get.toNamed(AppRoutes.inLineCurrentMachineFlagScreen),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.color_lens_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF50C9C3),
                        titleText: '',
                        subTitleText: "7.0 InLine Live Flagged Machine",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>  Get.toNamed(AppRoutes.liveFlagMarkPerRoundScreen),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.flaky_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF50C9C3),
                        titleText: '',
                        subTitleText: "Line Production Quality DashBoard",
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [

                  Expanded(
                    child: GestureDetector(
                      onTap: ()  =>  Get.toNamed(AppRoutes.endLineInspection),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.line_axis_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "EndLine Inspection",
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.rowingQualityEndLineReportsDashBoard),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.accessibility_rounded,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "EndLine Inspection Report",
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: ()  =>  Get.toNamed(AppRoutes.rowingQualityCheckCardOperation),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.line_axis_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "Check Card Operation For EndLine",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
