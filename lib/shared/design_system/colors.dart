import 'package:flutter/material.dart';

/// 한담 앱의 색상 시스템
/// Light/Dark 테마에 따른 ColorScheme 정의
class HandamColors {
  // Private constructor to prevent instantiation
  HandamColors._();

  // Light Theme Colors
  static const Color primaryLight = Color(0xFFD96C6C); // Blush Rose
  static const Color secondaryLight = Color(0xFFF6C6A7); // Soft Apricot
  static const Color accentLight = Color(0xFF5C3C58); // Plum Purple
  static const Color backgroundLight = Color(0xFFFAF8F6); // Ivory Gray
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color textDefaultLight = Color(0xFF3E3A39); // Charcoal Brown
  static const Color textSecondaryLight = Color(0xFFB0ADA9); // Placeholder
  static const Color errorLight = Color(0xFFD64545); // Warm Coral Red
  static const Color outlineLight = Color(0xFFE0DEDC); // Border
  static const Color emotionChipLight = Color(0xFFFFF4F2); // Emotion Chip Background

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFFD96C6C); // Blush Rose (same as light)
  static const Color secondaryDark = Color(0xFFF6C6A7); // Soft Apricot (same as light)
  static const Color accentDark = Color(0xFFE8DFF1); // Lavender Mist
  static const Color backgroundDark = Color(0xFF1E1C1B); // Dark Espresso
  static const Color surfaceDark = Color(0xFF2A2826); // Dark Surface
  static const Color textDefaultDark = Color(0xFFE8E6E5); // Misty White
  static const Color textSecondaryDark = Color(0xFFA0A0A0); // Secondary Text
  static const Color errorDark = Color(0xFFFF6B6B); // Soft Alert Red
  static const Color outlineDark = Color(0xFF4A4846); // Dark Border
  static const Color emotionChipDark = Color(0xFF3A3836); // Dark Emotion Chip

  // 현재 테마에 따른 색상 접근자 (기본값은 Light 테마)
  static Color get primary => primaryLight;
  static Color get secondary => secondaryLight;
  static Color get accent => accentLight;
  static Color get background => backgroundLight;
  static Color get surface => surfaceLight;
  static Color get textDefault => textDefaultLight;
  static Color get textSecondary => textSecondaryLight;
  static Color get error => errorLight;
  static Color get outline => outlineLight;
  static Color get onPrimary => Colors.white;

  /// Light Theme ColorScheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryLight,
    onPrimary: Colors.white,
    secondary: secondaryLight,
    onSecondary: textDefaultLight,
    background: backgroundLight,
    onBackground: textDefaultLight,
    surface: surfaceLight,
    onSurface: textDefaultLight,
    error: errorLight,
    onError: Colors.white,
    outline: outlineLight,
  );

  /// Dark Theme ColorScheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: Colors.white,
    secondary: secondaryDark,
    onSecondary: textDefaultDark,
    background: backgroundDark,
    onBackground: textDefaultDark,
    surface: surfaceDark,
    onSurface: textDefaultDark,
    error: errorDark,
    onError: Colors.white,
    outline: outlineDark,
  );

  /// 감정 키워드 칩 색상
  static Color getEmotionChipColor(bool isDark) {
    return isDark ? emotionChipDark : emotionChipLight;
  }

  /// 감정 키워드 텍스트 색상
  static Color getEmotionChipTextColor(bool isDark) {
    return isDark ? primaryDark : primaryLight;
  }

  /// 채팅 말풍선 색상 (내 메시지)
  static Color getMyChatBubbleColor(bool isDark) {
    return isDark ? primaryDark : primaryLight;
  }

  /// 채팅 말풍선 색상 (상대 메시지)
  static Color getOtherChatBubbleColor(bool isDark) {
    return isDark ? secondaryDark : secondaryLight;
  }

  /// 채팅 말풍선 텍스트 색상 (내 메시지)
  static Color getMyChatTextColor(bool isDark) {
    return Colors.white;
  }

  /// 채팅 말풍선 텍스트 색상 (상대 메시지)
  static Color getOtherChatTextColor(bool isDark) {
    return isDark ? textDefaultDark : textDefaultLight;
  }
} 