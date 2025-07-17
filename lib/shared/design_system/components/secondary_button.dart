import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../typography.dart';

/// 한담 Secondary Button 컴포넌트
/// 보조 액션 버튼으로 사용
class HandamSecondaryButton extends StatelessWidget {
  const HandamSecondaryButton({
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
      child: OutlinedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: isEnabled 
              ? colorScheme.primary 
              : colorScheme.outline,
          disabledForegroundColor: colorScheme.outline,
          side: BorderSide(
            color: isEnabled 
                ? colorScheme.primary 
                : colorScheme.outline,
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: HandamTypography.button.copyWith(
            color: isEnabled 
                ? colorScheme.primary 
                : colorScheme.outline,
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
                        ? colorScheme.primary 
                        : colorScheme.outline,
                  ),
                ),
              )
            : Text(text),
      ),
    );
  }
} 