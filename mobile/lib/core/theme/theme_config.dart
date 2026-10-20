import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  // Premium Modern Royal Blue, Purple & Cyan Palette
  static const Color primaryColor = Color(0xFF2563EB); // Royal Blue
  static const Color secondaryColor = Color(0xFF7C3AED); // Purple
  static const Color accentCyan = Color(0xFF0891B2); // Cyan
  
  // Premium Accents & Soft Red Error
  static const Color accentAmber = Color(0xFFF59E0B); // Amber
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color accentPink = Color(0xFFEC4899); // Pink
  static const Color errorColor = Color(0xFFF87171); // Soft Red (not aggressive)
  static const Color infoColor = Color(0xFF0EA5E9); // Light Blue

  // Light Palette
  static const Color lightBg = Color(0xFFF8FAFC); // Clean Porcelain Off-white
  static const Color lightCard = Color(0xFFFFFFFF); // Pure White
  static const Color lightBorder = Color(0xFFE2E8F0); // Subtle Slate Border
  static const Color lightTextPrimary = Color(0xFF0F172A); // Midnight Slate
  static const Color lightTextSecondary = Color(0xFF475569); // Slate Grey
  static const Color lightInputBg = Color(0xFFF1F5F9); // Light Input Fill

  // Dark Palette
  static const Color darkBg = Color(0xFF090D16); // Deep Midnight Obsidian
  static const Color darkCard = Color(0xFF131B2E); // Deep Slate Card
  static const Color darkBorder = Color(0xFF1E293B); // Dark Slate Border
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Bright Ice White
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Cool Slate Grey
  static const Color darkInputBg = Color(0xFF0D1527); // Deep Input Fill

  static TextStyle getFont(String languageCode, {
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    if (languageCode == 'ar') {
      return GoogleFonts.cairo(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ).copyWith(fontFamilyFallback: const ['Outfit']);
    } else {
      return GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ).copyWith(fontFamilyFallback: const ['Cairo']);
    }
  }

  static TextTheme getTextTheme(String languageCode, Color primaryTextColor, Color secondaryTextColor) {
    final baseTextTheme = const TextTheme().apply(
      bodyColor: primaryTextColor,
      displayColor: primaryTextColor,
    );

    if (languageCode == 'ar') {
      return GoogleFonts.cairoTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.cairo(color: primaryTextColor, fontSize: 57, fontWeight: FontWeight.normal).copyWith(fontFamilyFallback: const ['Outfit']),
        displayMedium: GoogleFonts.cairo(color: primaryTextColor, fontSize: 45, fontWeight: FontWeight.normal).copyWith(fontFamilyFallback: const ['Outfit']),
        displaySmall: GoogleFonts.cairo(color: primaryTextColor, fontSize: 36, fontWeight: FontWeight.normal).copyWith(fontFamilyFallback: const ['Outfit']),
        
        headlineLarge: GoogleFonts.cairo(color: primaryTextColor, fontSize: 32, fontWeight: FontWeight.w800).copyWith(fontFamilyFallback: const ['Outfit']),
        headlineMedium: GoogleFonts.cairo(color: primaryTextColor, fontSize: 24, fontWeight: FontWeight.bold).copyWith(fontFamilyFallback: const ['Outfit']),
        headlineSmall: GoogleFonts.cairo(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold).copyWith(fontFamilyFallback: const ['Outfit']),
        
        titleLarge: GoogleFonts.cairo(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold).copyWith(fontFamilyFallback: const ['Outfit']),
        titleMedium: GoogleFonts.cairo(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w600).copyWith(fontFamilyFallback: const ['Outfit']),
        titleSmall: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 14, fontWeight: FontWeight.w500).copyWith(fontFamilyFallback: const ['Outfit']),
        
        bodyLarge: GoogleFonts.cairo(color: primaryTextColor, fontSize: 16).copyWith(fontFamilyFallback: const ['Outfit']),
        bodyMedium: GoogleFonts.cairo(color: primaryTextColor, fontSize: 14).copyWith(fontFamilyFallback: const ['Outfit']),
        bodySmall: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 12).copyWith(fontFamilyFallback: const ['Outfit']),
        
        labelLarge: GoogleFonts.cairo(color: primaryTextColor, fontSize: 14, fontWeight: FontWeight.w500).copyWith(fontFamilyFallback: const ['Outfit']),
        labelMedium: GoogleFonts.cairo(color: primaryTextColor, fontSize: 12, fontWeight: FontWeight.w500).copyWith(fontFamilyFallback: const ['Outfit']),
        labelSmall: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 11, fontWeight: FontWeight.w500).copyWith(fontFamilyFallback: const ['Outfit']),
      );
    } else {
      return GoogleFonts.outfitTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.outfit(color: primaryTextColor, fontSize: 57, fontWeight: FontWeight.normal).copyWith(fontFamilyFallback: const ['Cairo']),
        displayMedium: GoogleFonts.outfit(color: primaryTextColor, fontSize: 45, fontWeight: FontWeight.normal).copyWith(fontFamilyFallback: const ['Cairo']),
        displaySmall: GoogleFonts.outfit(color: primaryTextColor, fontSize: 36, fontWeight: FontWeight.normal).copyWith(fontFamilyFallback: const ['Cairo']),
        
        headlineLarge: GoogleFonts.outfit(color: primaryTextColor, fontSize: 32, fontWeight: FontWeight.w800).copyWith(fontFamilyFallback: const ['Cairo']),
        headlineMedium: GoogleFonts.outfit(color: primaryTextColor, fontSize: 24, fontWeight: FontWeight.bold).copyWith(fontFamilyFallback: const ['Cairo']),
        headlineSmall: GoogleFonts.outfit(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold).copyWith(fontFamilyFallback: const ['Cairo']),
        
        titleLarge: GoogleFonts.outfit(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold).copyWith(fontFamilyFallback: const ['Cairo']),
        titleMedium: GoogleFonts.outfit(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w600).copyWith(fontFamilyFallback: const ['Cairo']),
        titleSmall: GoogleFonts.outfit(color: secondaryTextColor, fontSize: 14, fontWeight: FontWeight.w500).copyWith(fontFamilyFallback: const ['Cairo']),
        
        bodyLarge: GoogleFonts.outfit(color: primaryTextColor, fontSize: 16).copyWith(fontFamilyFallback: const ['Cairo']),
        bodyMedium: GoogleFonts.outfit(color: primaryTextColor, fontSize: 14).copyWith(fontFamilyFallback: const ['Cairo']),
        bodySmall: GoogleFonts.outfit(color: secondaryTextColor, fontSize: 12).copyWith(fontFamilyFallback: const ['Cairo']),
        
        labelLarge: GoogleFonts.outfit(color: primaryTextColor, fontSize: 14, fontWeight: FontWeight.w500).copyWith(fontFamilyFallback: const ['Cairo']),
        labelMedium: GoogleFonts.outfit(color: primaryTextColor, fontSize: 12, fontWeight: FontWeight.w500).copyWith(fontFamilyFallback: const ['Cairo']),
        labelSmall: GoogleFonts.outfit(color: secondaryTextColor, fontSize: 11, fontWeight: FontWeight.w500).copyWith(fontFamilyFallback: const ['Cairo']),
      );
    }
  }

  static ThemeData getLightTheme(String languageCode) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBg,
      cardColor: lightCard,
      dividerColor: lightBorder,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: lightCard,
      ),
      textTheme: getTextTheme(languageCode, lightTextPrimary, lightTextSecondary),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: lightCard,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: lightTextPrimary),
        titleTextStyle: getFont(languageCode, color: lightTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightInputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 1.8),
        ),
        labelStyle: getFont(languageCode, color: lightTextSecondary, fontSize: 14, fontWeight: FontWeight.normal),
        hintStyle: getFont(languageCode, color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
      ),
    );
  }

  static ThemeData getDarkTheme(String languageCode) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      dividerColor: darkBorder,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: darkCard,
      ),
      textTheme: getTextTheme(languageCode, darkTextPrimary, darkTextSecondary),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: darkCard,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkTextPrimary),
        titleTextStyle: getFont(languageCode, color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 1.8),
        ),
        labelStyle: getFont(languageCode, color: darkTextSecondary, fontSize: 14, fontWeight: FontWeight.normal),
        hintStyle: getFont(languageCode, color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
      ),
    );
  }
}

extension TextStyleArabicExt on TextStyle {
  TextStyle withArabicCheck(String text) {
    if (text.trim().isEmpty) return this;
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      return GoogleFonts.cairo(textStyle: this);
    }
    return GoogleFonts.outfit(textStyle: this);
  }
}
