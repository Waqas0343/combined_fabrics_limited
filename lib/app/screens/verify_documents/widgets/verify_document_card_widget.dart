import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_widgets/home_tools/tools_widget.dart';
import '../../../routes/app_routes.dart';

class DocumentsAppCard extends StatelessWidget {
  const DocumentsAppCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dummyData = [
      {'icon': 'assets/icons/verify.svg', 'title': 'PO Approve', 'route':  AppRoutes.verifyDocumentPOApproveScreen},
      {'icon': 'assets/icons/verify.svg', 'title': 'Stock', 'route':  AppRoutes.verifyDocumentPOApproveScreen},
      {'icon': 'assets/icons/verify.svg', 'title': 'Leave Management', 'route':  AppRoutes.verifyDocumentPOApproveScreen},
      {'icon': 'assets/icons/verify.svg', 'title': 'Gate Passes', 'route':  AppRoutes.verifyDocumentPOApproveScreen},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth / 4;
        final cardHeight = cardWidth * 1;
        return GridView.builder(
          itemCount: dummyData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(constraints.maxWidth),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: cardWidth / cardHeight,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final item = dummyData[index];
            return ToolsWidget(
              icon: item['icon']!,
              title: item['title']!,
              onTap: () {
                Get.toNamed(item['route']!);
              },
            );
          },
        );
      },
    );
  }

  int _calculateCrossAxisCount(double maxWidth) {
    if (maxWidth < 600) {
      return 2;
    } else if (maxWidth < 900) {
      return 3;
    } else {
      return 4;
    }
  }
}
