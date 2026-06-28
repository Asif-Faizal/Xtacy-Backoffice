import 'package:flutter/material.dart';

/// IBM Carbon-inspired theme with zero border radius.
class AppTheme {
  AppTheme._();

  static const Color carbonBlue = Color(0xFF0F62FE);
  static const Color carbonBlueDark = Color(0xFF0043CE);
  static const Color carbonGray10 = Color(0xFFF4F4F4);
  static const Color carbonGray20 = Color(0xFFE0E0E0);
  static const Color carbonGray50 = Color(0xFF8D8D8D);
  static const Color carbonGray70 = Color(0xFF525252);
  static const Color carbonGray90 = Color(0xFF262626);
  static const Color carbonGray100 = Color(0xFF161616);
  static const Color successGreen = Color(0xFF24A148);
  static const Color errorRed = Color(0xFFDA1E28);
  static const Color warningOrange = Color(0xFFF1C21B);

  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: carbonBlue,
      brightness: Brightness.light,
      primary: carbonBlue,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: carbonGray100,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: carbonGray10,
      appBarTheme: const AppBarTheme(
        backgroundColor: carbonGray100,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: carbonGray20),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: carbonBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: carbonBlue,
          side: const BorderSide(color: carbonBlue),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: carbonBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: carbonBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: carbonGray20),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: carbonGray20),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: carbonBlue, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: carbonGray70),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: carbonGray10,
        selectedColor: carbonBlue.withValues(alpha: 0.15),
        labelStyle: const TextStyle(color: carbonGray100),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: carbonGray20),
        ),
      ),
      dividerTheme: const DividerThemeData(color: carbonGray20, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: carbonBlue,
        unselectedItemColor: carbonGray50,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: carbonBlue,
        unselectedLabelColor: carbonGray50,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: carbonGray20,
      ),
    );
  }

  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: carbonBlue,
      brightness: Brightness.dark,
      primary: carbonBlue,
      onPrimary: Colors.white,
      surface: carbonGray90,
      onSurface: carbonGray10,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: carbonGray100,
      appBarTheme: const AppBarTheme(
        backgroundColor: carbonGray90,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: carbonGray90,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: carbonGray70.withValues(alpha: 0.5)),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: carbonBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: carbonBlue,
          side: const BorderSide(color: carbonBlue),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: carbonBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: carbonBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: carbonGray90,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: carbonGray70.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: carbonGray70.withValues(alpha: 0.5)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: carbonBlue, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: carbonGray50),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: carbonGray90,
        selectedColor: carbonBlue.withValues(alpha: 0.25),
        labelStyle: const TextStyle(color: carbonGray10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: carbonGray70.withValues(alpha: 0.5)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: carbonGray70.withValues(alpha: 0.5),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: carbonGray90,
        selectedItemColor: carbonBlue,
        unselectedItemColor: carbonGray50,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: carbonBlue,
        unselectedLabelColor: carbonGray50,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: carbonGray70,
      ),
    );
  }
}
