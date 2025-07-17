import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../typography.dart';

/// 한담 Primary Button 컴포넌트
/// 메인 액션 버튼으로 사용
class HandamPrimaryButton extends StatelessWidget {
  const HandamPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height = 48.0,
    this.borderRadius = 12.0,
  });

  /// 버튼 텍스트
  final String text;

  /// 버튼 클릭 콜백
  final VoidCallback? onPressed;

  /// 로딩 상태
  final bool isLoading;

  /// 활성화 상태
  final bool isEnabled;

  /// 버튼 너비 (null이면 자동)
  final double? width;

  /// 버튼 높이
  final double height;

  /// 모서리 둥글기
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled 
              ? colorScheme.primary 
              : colorScheme.secondary,
          foregroundColor: isEnabled 
              ? colorScheme.onPrimary 
              : colorScheme.onSecondary,
          disabledBackgroundColor: colorScheme.secondary,
          disabledForegroundColor: colorScheme.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
          textStyle: HandamTypography.button.copyWith(
            color: isEnabled 
                ? colorScheme.onPrimary 
                : colorScheme.onSecondary,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isEnabled 
                        ? colorScheme.onPrimary 
                        : colorScheme.onSecondary,
                  ),
                ),
              )
            : Text(text),
      ),
    );
  }
} 