import 'package:flutter/material.dart';

import '../colors.dart';
import '../typography.dart';

/// 한담 디자인 시스템의 로딩 인디케이터 컴포넌트
/// 
/// 다양한 스타일의 로딩 표시를 제공합니다.
class HandamLoadingIndicator extends StatelessWidget {
  const HandamLoadingIndicator({
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.color,
    this.message,
    this.showMessage = false,
  });

  /// 로딩 인디케이터 크기
  final double size;
  
  /// 선 두께
  final double strokeWidth;
  
  /// 색상 (기본값: primary 색상)
  final Color? color;
  
  /// 로딩 메시지
  final String? message;
  
  /// 메시지 표시 여부
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;
    final loadingColor = color ?? colorScheme.primary;
    
    if (showMessage && message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message!,
            style: HandamTypography.body2.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
      ),
    );
  }
}

/// 전체 화면 로딩 인디케이터
class HandamFullScreenLoadingIndicator extends StatelessWidget {
  const HandamFullScreenLoadingIndicator({
    super.key,
    this.message = '로딩 중...',
    this.backgroundColor,
  });

  /// 로딩 메시지
  final String message;
  
  /// 배경 색상
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;
    
    return Container(
      color: backgroundColor ?? colorScheme.background,
      child: Center(
        child: HandamLoadingIndicator(
          size: 32,
          strokeWidth: 3,
          message: message,
          showMessage: true,
        ),
      ),
    );
  }
}

/// 작은 크기의 로딩 인디케이터
class HandamSmallLoadingIndicator extends StatelessWidget {
  const HandamSmallLoadingIndicator({
    super.key,
    this.color,
  });

  /// 색상
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return HandamLoadingIndicator(
      size: 16,
      strokeWidth: 1.5,
      color: color,
    );
  }
}

// 기존 컴포넌트와의 호환성을 위한 별칭
@Deprecated('HandamLoadingIndicator를 사용하세요')
class LoadingIndicator extends HandamLoadingIndicator {
  const LoadingIndicator({
    super.key,
    super.size = 24,
    super.strokeWidth = 2,
    super.color,
    super.message,
    super.showMessage = false,
  });
}

@Deprecated('HandamFullScreenLoadingIndicator를 사용하세요')
class FullScreenLoadingIndicator extends HandamFullScreenLoadingIndicator {
  const FullScreenLoadingIndicator({
    super.key,
    super.message = '로딩 중...',
    super.backgroundColor,
  });
}

@Deprecated('HandamSmallLoadingIndicator를 사용하세요')
class SmallLoadingIndicator extends HandamSmallLoadingIndicator {
  const SmallLoadingIndicator({
    super.key,
    super.color,
  });
}
