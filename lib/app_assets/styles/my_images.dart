
import 'package:flutter/services.dart';

class MyImages{
  static const logo = "assets/images/logo.png";
  static const String heartLogo = "assets/images/cfl_fav_logo.png";
  static const liveConsultation = "assets/images/live_consultation.png";
  static const labTest = "assets/images/lab_test.png";
  static const medicines = "assets/images/medicines.png";
  static const lastScreen = "assets/images/last_screen.png";
  static const logoWhite = "assets/images/logo_white.png";
  static const  user = "assets/images/user.png";
  static const isMachine = "assets/icons/sewing.svg";
  static const isNfc = "assets/images/nfc_card_image.png";

  static Future<Uint8List> getImageBytes(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    return data.buffer.asUint8List();
  }
}