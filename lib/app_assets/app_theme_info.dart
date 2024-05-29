import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeInfo {
  static double get borderRadius => 6.0;

  static ThemeData get themeData {
    var primaryColor = const MaterialColor(0xFF4a9672, {
      50: Color(0xffe5f7f1),
      100: Color(0xffb3e3d7),
      200: Color(0xff80cfbd),
      300: Color(0xff4dbba3),
      400: Color(0xff1da78a),
      500: Color(0xFF4a9672),
      600: Color(0xff417f61),
      700: Color(0xff386d51),
      800: Color(0xff2f5b41),
      900: Color(0xff264931),
    });
    var baseTheme = ThemeData(
      useMaterial3: false, // Disabling Material 3
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeInfo.borderRadius),
        ),
        filled: false,
        fillColor: MyColors.fillColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              AppThemeInfo.borderRadius,
            ),
          ),
        ),
      ),
      cardTheme: const CardTheme(
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MyColors.lightBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeInfo.borderRadius),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MyColors.accentColor,
        elevation: 2,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MyColors.lightBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          side: const BorderSide(color: MyColors.lightBlue),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: MyColors.lightBlue),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: MyColors.primaryColor,
        selectionHandleColor: MyColors.primaryColor,
        selectionColor: MyColors.primaryColor.withOpacity(0.5),
      ),
      tabBarTheme: const TabBarTheme(
        labelStyle: TextStyle(fontSize: 16),
        unselectedLabelStyle: TextStyle(fontSize: 16),
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeInfo.borderRadius),
        ),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.transparent,
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return MyColors.primaryColor;
              }
              return null;
            }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return MyColors.primaryColor;
              }
              return null;
            }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return MyColors.primaryColor;
              }
              return null;
            }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return MyColors.primaryColor;
              }
              return null;
            }),
      ),
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
        accentColor: MyColors.accentColor,
        backgroundColor: Colors.white,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.openSansTextTheme(baseTheme.textTheme),
    );
  }
}
