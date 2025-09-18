import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryBrown = Color(0xFF8B4513);
  static const Color darkBrown = Color(0xFF3E2723);
  static const Color mediumBrown = Color(0xFF5D4037);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color pendingOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);

  // Text Styles
  static const TextStyle headlineLarge = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkBrown);

  static const TextStyle headlineMedium = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkBrown);

  static const TextStyle titleLarge = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkBrown);

  static const TextStyle titleMedium = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkBrown);

  static const TextStyle bodyLarge = TextStyle(fontSize: 16, color: mediumBrown);

  static const TextStyle bodyMedium = TextStyle(fontSize: 14, color: mediumBrown);

  static const TextStyle bodySmall = TextStyle(fontSize: 12, color: mediumBrown);

  static const TextStyle priceText = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryBrown);

  static const TextStyle whiteText = TextStyle(color: Colors.white, fontWeight: FontWeight.w500);

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;

  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 12.0;
  static const double spaceL = 16.0;
  static const double spaceXL = 20.0;
  static const double spaceXXL = 24.0;
  static const double spaceXXXL = 32.0;

  // Shadows
  static List<BoxShadow> cardShadow = [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 2))];

  static List<BoxShadow> buttonShadow = [BoxShadow(color: primaryBrown.withAlpha(70), blurRadius: 8, offset: const Offset(0, 4))];

  // Complete Theme Configuration
  static ThemeData get appTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primaryBrown, brightness: Brightness.light),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(backgroundColor: primaryBrown, foregroundColor: Colors.white, elevation: 0, centerTitle: true),
    cardTheme: CardThemeData(
      elevation: 4,
      color: cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLarge)),
      shadowColor: Colors.black.withAlpha(25),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBrown,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
        padding: const EdgeInsets.symmetric(horizontal: spaceXL, vertical: spaceM),
        elevation: 4,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
    ),
    useMaterial3: true,
  );
}
