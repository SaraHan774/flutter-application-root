import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 한담 앱의 타이포그래피 시스템
/// Pretendard 폰트를 기반으로 한 TextTheme 정의
class HandamTypography {
  // Private constructor to prevent instantization
  HandamTypography._();

  /// 기본 폰트 패밀리 (Pretendard)
  static const String fontFamily = 'Pretendard';

  /// 폰트 폴백 설정
  static const List<String> fontFallbacks = [
    'Apple SD Gothic Neo',
    'Roboto',
    'sans-serif',
  ];

  /// Headline1 스타일
  /// 메인 타이틀, 첫 화면 중심 메시지용
  static TextStyle get headline1 => GoogleFonts.getFont('Pretendard',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.33, // 32 / 24
        letterSpacing: -0.5,
      );

  /// Headline2 스타일
  /// 서브 타이틀, 피드백 질문용
  static TextStyle get headline2 => GoogleFonts.getFont('Pretendard',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4, // 28 / 20
        letterSpacing: -0.4,
      );

  /// Headline3 스타일
  /// 감정 라벨, 작은 섹션 헤더용
  static TextStyle get headline3 => GoogleFonts.getFont('Pretendard',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.44, // 26 / 18
        letterSpacing: -0.3,
      );

  /// Headline4 스타일
  /// 카드 타이틀, 모듈 내 소제목용
  static TextStyle get headline4 => GoogleFonts.getFont('Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5, // 24 / 16
        letterSpacing: -0.2,
      );

  /// Body1 스타일
  /// 일반 본문, 채팅 메시지용
  static TextStyle get body1 => GoogleFonts.getFont('Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5, // 24 / 16
      );

  /// Body2 스타일
  /// 부가 설명, 안내문용
  static TextStyle get body2 => GoogleFonts.getFont('Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43, // 20 / 14
      );

  /// Body3 스타일
  /// 힌트 텍스트, 감정 카드 설명용
  static TextStyle get body3 => GoogleFonts.getFont('Pretendard',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.38, // 18 / 13
      );

  /// Button 스타일
  /// 버튼 내부 텍스트용
  static TextStyle get button => GoogleFonts.getFont('Pretendard',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.33, // 20 / 15
        letterSpacing: 0.1,
      );

  /// Caption 스타일
  /// 날짜, 타임스탬프, 보조 라벨용
  static TextStyle get caption => GoogleFonts.getFont('Pretendard',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33, // 16 / 12
      );

  /// Light Theme TextTheme
  static TextTheme get lightTextTheme => TextTheme(
        headlineLarge: headline1,
        headlineMedium: headline2,
        headlineSmall: headline3,
        titleLarge: headline4,
        bodyLarge: body1,
        bodyMedium: body2,
        bodySmall: body3,
        labelLarge: button,
        labelSmall: caption,
      );

  /// Dark Theme TextTheme
  static TextTheme get darkTextTheme => TextTheme(
        headlineLarge: headline1,
        headlineMedium: headline2,
        headlineSmall: headline3,
        titleLarge: headline4,
        bodyLarge: body1,
        bodyMedium: body2,
        bodySmall: body3,
        labelLarge: button,
        labelSmall: caption,
      );

  /// 전체 TextTheme (Light/Dark 공통)
  static TextTheme get textTheme => lightTextTheme;

  /// 특정 색상이 적용된 TextTheme 생성
  static TextTheme getTextThemeWithColor(Color color) {
    return TextTheme(
      headlineLarge: headline1.copyWith(color: color),
      headlineMedium: headline2.copyWith(color: color),
      headlineSmall: headline3.copyWith(color: color),
      titleLarge: headline4.copyWith(color: color),
      bodyLarge: body1.copyWith(color: color),
      bodyMedium: body2.copyWith(color: color),
      bodySmall: body3.copyWith(color: color),
      labelLarge: button.copyWith(color: color),
      labelSmall: caption.copyWith(color: color),
    );
  }
} 