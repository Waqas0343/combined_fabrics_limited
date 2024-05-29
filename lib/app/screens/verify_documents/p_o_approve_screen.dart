import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_controllers/p_o_approve_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class POApproveHomeScreen extends StatelessWidget {
  const POApproveHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final POApproveHomeController controller =
        Get.put(POApproveHomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('PO Approve Screen'),
      ),
      body: ListView.builder(
        itemCount: controller.dummyData.length,
        itemBuilder: (context, index) {
          final item = controller.dummyData[index];
          List<Color> rowColors = [const Color(0xffe5f7f1), Colors.white];
          Color rowColor = rowColors[index % rowColors.length];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomCard(
              color: rowColor,
              child: ListTile(
                leading:
                    SvgPicture.asset(item['image']!, width: 50, height: 50),
                title: Text(
                  item['title']!,
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                    '${item['subtitle']} \n${item['date']} ${item['time']}',
                  style: Get.textTheme.titleSmall,),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                ),
                isThreeLine: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
