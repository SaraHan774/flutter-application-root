import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';

/// 한담 디자인 시스템의 Secondary 버튼 컴포넌트
class HandamSecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const HandamSecondaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HandamColors.surface,
          foregroundColor: HandamColors.primary,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: BorderSide(
            color: HandamColors.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    HandamColors.primary,
                  ),
                ),
              )
            : DefaultTextStyle(
                style: HandamTypography.button.copyWith(
                  color: HandamColors.primary,
                ),
                child: child,
              ),
      ),
    );
  }
} 