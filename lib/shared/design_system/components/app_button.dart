import 'package:flutter/material.dart';

import '../colors.dart';
import '../typography.dart';

/// 한담 디자인 시스템의 통합 버튼 컴포넌트
/// 
/// Primary, Secondary, Text 스타일을 모두 지원하는 통합 버튼입니다.
class HandamButton extends StatelessWidget {
  const HandamButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = HandamButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height = 48,
  });

  /// 버튼 텍스트
  final String text;
  
  /// 버튼 클릭 시 실행될 콜백
  final VoidCallback? onPressed;
  
  /// 버튼 스타일 변형
  final HandamButtonVariant variant;
  
  /// 로딩 상태 여부
  final bool isLoading;
  
  /// 비활성화 상태 여부
  final bool isDisabled;
  
  /// 버튼 아이콘 (선택사항)
  final IconData? icon;
  
  /// 버튼 너비 (선택사항)
  final double? width;
  
  /// 버튼 높이
  final double height;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading && !isDisabled;
    
    return SizedBox(
      width: width,
      height: height,
      child: _buildButton(context, isEnabled),
    );
  }

  /// 버튼 스타일에 따라 적절한 버튼을 구성합니다.
  Widget _buildButton(BuildContext context, bool isEnabled) {
    switch (variant) {
      case HandamButtonVariant.primary:
        return _buildPrimaryButton(context, isEnabled);
      case HandamButtonVariant.secondary:
        return _buildSecondaryButton(context, isEnabled);
      case HandamButtonVariant.text:
        return _buildTextButton(context, isEnabled);
    }
  }

  /// Primary 버튼을 구성합니다.
  Widget _buildPrimaryButton(BuildContext context, bool isEnabled) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;
    
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? colorScheme.primary : colorScheme.secondary,
        foregroundColor: isEnabled ? colorScheme.onPrimary : colorScheme.onSecondary,
        disabledBackgroundColor: colorScheme.secondary,
        disabledForegroundColor: colorScheme.onSecondary,
        elevation: isEnabled ? 2 : 0,
        shadowColor: colorScheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildButtonContent(context),
    );
  }

  /// Secondary 버튼을 구성합니다.
  Widget _buildSecondaryButton(BuildContext context, bool isEnabled) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;
    
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: isEnabled ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
        side: BorderSide(
          color: isEnabled ? colorScheme.primary : colorScheme.outline,
          width: 1.5,
        ),
        backgroundColor: Colors.transparent,
        disabledForegroundColor: colorScheme.onSurface.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildButtonContent(context),
    );
  }

  /// Text 버튼을 구성합니다.
  Widget _buildTextButton(BuildContext context, bool isEnabled) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;
    
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: isEnabled ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
        backgroundColor: Colors.transparent,
        disabledForegroundColor: colorScheme.onSurface.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildButtonContent(context),
    );
  }

  /// 버튼 내용을 구성합니다.
  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;
      
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == HandamButtonVariant.primary 
                ? colorScheme.onPrimary 
                : colorScheme.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: HandamTypography.button.copyWith(
              color: _getTextColor(context),
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: HandamTypography.button.copyWith(
        color: _getTextColor(context),
      ),
    );
  }

  /// 텍스트 색상을 결정합니다.
  Color _getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;
    
    if (isDisabled) {
      return colorScheme.onSurface.withOpacity(0.5);
    }

    switch (variant) {
      case HandamButtonVariant.primary:
        return colorScheme.onPrimary;
      case HandamButtonVariant.secondary:
        return colorScheme.primary;
      case HandamButtonVariant.text:
        return colorScheme.primary;
    }
  }
}

/// 버튼 스타일 변형
enum HandamButtonVariant {
  /// Primary 버튼 (주요 액션)
  primary,
  
  /// Secondary 버튼 (보조 액션)
  secondary,
  
  /// Text 버튼 (텍스트만 표시)
  text,
}

// 기존 컴포넌트와의 호환성을 위한 별칭
@Deprecated('HandamButton을 사용하세요')
class AppButton extends HandamButton {
  const AppButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.variant = HandamButtonVariant.primary,
    super.isLoading = false,
    super.isDisabled = false,
    super.icon,
    super.width,
    super.height = 48,
  });
}

@Deprecated('HandamButton을 사용하세요')
class HandamPrimaryButton extends HandamButton {
  const HandamPrimaryButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.isLoading = false,
    super.isDisabled = false,
    super.icon,
    super.width,
    super.height = 48,
  }) : super(variant: HandamButtonVariant.primary);
}

@Deprecated('HandamButton을 사용하세요')
class HandamSecondaryButton extends HandamButton {
  const HandamSecondaryButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.isLoading = false,
    super.isDisabled = false,
    super.icon,
    super.width,
    super.height = 48,
  }) : super(variant: HandamButtonVariant.secondary);
}
