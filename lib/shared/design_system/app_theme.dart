import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// 한담 앱 테마 설정
/// Material 3 기반 Light/Dark 테마 구성
class HandamAppTheme {
  // Private constructor to prevent instantiation
  HandamAppTheme._();

  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: HandamColors.lightColorScheme,
      textTheme: HandamTypography.lightTextTheme,
      fontFamily: HandamTypography.fontFamily,
      
      // AppBar 테마
      appBarTheme: AppBarTheme(
        backgroundColor: HandamColors.lightColorScheme.background,
        foregroundColor: HandamColors.lightColorScheme.onBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: HandamTypography.headline3.copyWith(
          color: HandamColors.lightColorScheme.onBackground,
        ),
        iconTheme: IconThemeData(
          color: HandamColors.lightColorScheme.onBackground,
          size: 24.0,
        ),
      ),

      // Scaffold 테마
      scaffoldBackgroundColor: HandamColors.lightColorScheme.background,

      // Card 테마
      cardTheme: CardTheme(
        color: HandamColors.lightColorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
      ),

      // ElevatedButton 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HandamColors.lightColorScheme.primary,
          foregroundColor: HandamColors.lightColorScheme.onPrimary,
          disabledBackgroundColor: HandamColors.lightColorScheme.secondary,
          disabledForegroundColor: HandamColors.lightColorScheme.onSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: HandamTypography.button,
          minimumSize: const Size(double.infinity, 48.0),
        ),
      ),

      // OutlinedButton 테마
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: HandamColors.lightColorScheme.primary,
          disabledForegroundColor: HandamColors.lightColorScheme.outline,
          side: BorderSide(
            color: HandamColors.lightColorScheme.primary,
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: HandamTypography.button,
          minimumSize: const Size(double.infinity, 48.0),
        ),
      ),

      // TextButton 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: HandamColors.lightColorScheme.primary,
          textStyle: HandamTypography.button,
        ),
      ),

      // InputDecoration 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HandamColors.lightColorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: HandamColors.lightColorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: HandamColors.lightColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: HandamColors.lightColorScheme.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: HandamColors.lightColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: HandamColors.lightColorScheme.error,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        hintStyle: HandamTypography.body1.copyWith(
          color: HandamColors.lightColorScheme.outline,
        ),
        labelStyle: HandamTypography.body2.copyWith(
          color: HandamColors.lightColorScheme.outline,
        ),
        errorStyle: HandamTypography.body3.copyWith(
          color: HandamColors.lightColorScheme.error,
        ),
      ),

      // BottomNavigationBar 테마
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: HandamColors.lightColorScheme.surface,
        selectedItemColor: HandamColors.lightColorScheme.primary,
        unselectedItemColor: HandamColors.lightColorScheme.outline,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: HandamTypography.caption,
        unselectedLabelStyle: HandamTypography.caption,
      ),

      // Dialog 테마
      dialogTheme: DialogTheme(
        backgroundColor: HandamColors.lightColorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        titleTextStyle: HandamTypography.headline3.copyWith(
          color: HandamColors.lightColorScheme.onSurface,
        ),
        contentTextStyle: HandamTypography.body2.copyWith(
          color: HandamColors.lightColorScheme.onSurface,
        ),
      ),

      // Chip 테마
      chipTheme: ChipThemeData(
        backgroundColor: HandamColors.emotionChipLight,
        selectedColor: HandamColors.emotionChipLight,
        disabledColor: HandamColors.lightColorScheme.outline.withOpacity(0.3),
        labelStyle: HandamTypography.body3.copyWith(
          color: HandamColors.primaryLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999.0),
        ),
        side: BorderSide.none,
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: HandamColors.darkColorScheme,
      textTheme: HandamTypography.darkTextTheme,
      fontFamily: HandamTypography.fontFamily,
      
      // AppBar 테마
      appBarTheme: AppBarTheme(
        backgroundColor: HandamColors.darkColorScheme.background,
        foregroundColor: HandamColors.darkColorScheme.onBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: HandamTypography.headline3.copyWith(
          color: HandamColors.darkColorScheme.onBackground,
        ),
        iconTheme: IconThemeData(
          color: HandamColors.darkColorScheme.onBackground,
          size: 24.0,
        ),
      ),

      // Scaffold 테마
      scaffoldBackgroundColor: HandamColors.darkColorScheme.background,

      // Card 테마
      cardTheme: CardTheme(
        color: HandamColors.darkColorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
      ),

      // ElevatedButton 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HandamColors.darkColorScheme.primary,
          foregroundColor: HandamColors.darkColorScheme.onPrimary,
          disabledBackgroundColor: HandamColors.darkColorScheme.secondary,
          disabledForegroundColor: HandamColors.darkColorScheme.onSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: HandamTypography.button,
          minimumSize: const Size(double.infinity, 48.0),
        ),
      ),

      // OutlinedButton 테마
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: HandamColors.darkColorScheme.primary,
          disabledForegroundColor: HandamColors.darkColorScheme.outline,
          side: BorderSide(
            color: HandamColors.darkColorScheme.primary,
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: HandamTypography.button,
          minimumSize: const Size(double.infinity, 48.0),
        ),
      ),

      // TextButton 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: HandamColors.darkColorScheme.primary,
          textStyle: HandamTypography.button,
        ),
      ),

      // InputDecoration 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HandamColors.darkColorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: HandamColors.darkColorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: HandamColors.darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: HandamColors.darkColorScheme.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: HandamColors.darkColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: HandamColors.darkColorScheme.error,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        hintStyle: HandamTypography.body1.copyWith(
          color: HandamColors.darkColorScheme.outline,
        ),
        labelStyle: HandamTypography.body2.copyWith(
          color: HandamColors.darkColorScheme.outline,
        ),
        errorStyle: HandamTypography.body3.copyWith(
          color: HandamColors.darkColorScheme.error,
        ),
      ),

      // BottomNavigationBar 테마
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: HandamColors.darkColorScheme.surface,
        selectedItemColor: HandamColors.darkColorScheme.primary,
        unselectedItemColor: HandamColors.darkColorScheme.outline,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: HandamTypography.caption,
        unselectedLabelStyle: HandamTypography.caption,
      ),

      // Dialog 테마
      dialogTheme: DialogTheme(
        backgroundColor: HandamColors.darkColorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        titleTextStyle: HandamTypography.headline3.copyWith(
          color: HandamColors.darkColorScheme.onSurface,
        ),
        contentTextStyle: HandamTypography.body2.copyWith(
          color: HandamColors.darkColorScheme.onSurface,
        ),
      ),

      // Chip 테마
      chipTheme: ChipThemeData(
        backgroundColor: HandamColors.emotionChipDark,
        selectedColor: HandamColors.emotionChipDark,
        disabledColor: HandamColors.darkColorScheme.outline.withOpacity(0.3),
        labelStyle: HandamTypography.body3.copyWith(
          color: HandamColors.primaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999.0),
        ),
        side: BorderSide.none,
      ),
    );
  }
} 