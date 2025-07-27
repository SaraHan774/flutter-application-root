import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../shared/shared.dart';

/// 인증 에러 다이얼로그
class AuthErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final VoidCallback? onDismiss;

  const AuthErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onActionPressed,
    this.onDismiss,
  });

  /// 네트워크 에러 다이얼로그 생성
  factory AuthErrorDialog.networkError({
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return AuthErrorDialog(
      title: '네트워크 오류',
      message: '인터넷 연결을 확인하고 다시 시도해주세요.',
      actionText: '다시 시도',
      onActionPressed: onRetry,
      onDismiss: onDismiss,
    );
  }

  /// 인증번호 오류 다이얼로그 생성
  factory AuthErrorDialog.invalidCode({
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return AuthErrorDialog(
      title: '인증번호 오류',
      message: '인증번호가 올바르지 않습니다. 다시 확인해주세요.',
      actionText: '다시 시도',
      onActionPressed: onRetry,
      onDismiss: onDismiss,
    );
  }

  /// 인증 세션 만료 다이얼로그 생성
  factory AuthErrorDialog.sessionExpired({
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return AuthErrorDialog(
      title: '인증 세션 만료',
      message: '인증 시간이 만료되었습니다. 다시 시도해주세요.',
      actionText: '다시 시도',
      onActionPressed: onRetry,
      onDismiss: onDismiss,
    );
  }

  /// 일일 인증 횟수 초과 다이얼로그 생성
  factory AuthErrorDialog.quotaExceeded({
    VoidCallback? onDismiss,
  }) {
    return AuthErrorDialog(
      title: '인증 횟수 초과',
      message: '오늘 인증 시도 횟수를 초과했습니다. 내일 다시 시도해주세요.',
      onDismiss: onDismiss,
    );
  }

  /// 일반적인 인증 에러 다이얼로그 생성
  factory AuthErrorDialog.general({
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return AuthErrorDialog(
      title: '인증 오류',
      message: message,
      actionText: '다시 시도',
      onActionPressed: onRetry,
      onDismiss: onDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: HandamColors.errorLight,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: HandamTypography.headline4.copyWith(
                color: HandamColors.textDefault,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: HandamTypography.body2.copyWith(
          color: HandamColors.textDefault,
        ),
      ),
      actions: [
        // 취소 버튼 (항상 표시)
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss?.call();
          },
          child: Text(
            '취소',
            style: HandamTypography.button.copyWith(
              color: HandamColors.textSecondary,
            ),
          ),
        ),
        // 액션 버튼 (actionText가 있을 때만 표시)
        if (actionText != null)
          HandamPrimaryButton(
            onPressed: () {
              Navigator.of(context).pop();
              onActionPressed?.call();
            },
            text: actionText!,
          ),
      ],
    );
  }
}

/// 인증 에러 다이얼로그 표시 헬퍼 함수
class AuthErrorDialogHelper {
  /// 네트워크 에러 다이얼로그 표시
  static Future<void> showNetworkError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AuthErrorDialog.networkError(
        onRetry: onRetry,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// 인증번호 오류 다이얼로그 표시
  static Future<void> showInvalidCodeError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AuthErrorDialog.invalidCode(
        onRetry: onRetry,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// 인증 세션 만료 다이얼로그 표시
  static Future<void> showSessionExpiredError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AuthErrorDialog.sessionExpired(
        onRetry: onRetry,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// 일일 인증 횟수 초과 다이얼로그 표시
  static Future<void> showQuotaExceededError(
    BuildContext context,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AuthErrorDialog.quotaExceeded(
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// 일반적인 인증 에러 다이얼로그 표시
  static Future<void> showGeneralError(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AuthErrorDialog.general(
        message: message,
        onRetry: onRetry,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Failure 객체를 기반으로 적절한 에러 다이얼로그 표시
  static Future<void> showErrorFromFailure(
    BuildContext context,
    Failure failure, {
    VoidCallback? onRetry,
  }) {
    if (failure is AuthFailure) {
      final message = failure.message;
      
      // 특정 에러 코드에 따른 처리
      if (message.contains('네트워크') || message.contains('연결')) {
        return showNetworkError(context, onRetry: onRetry);
      } else if (message.contains('인증번호') || message.contains('코드')) {
        return showInvalidCodeError(context, onRetry: onRetry);
      } else if (message.contains('세션') || message.contains('만료')) {
        return showSessionExpiredError(context, onRetry: onRetry);
      } else if (message.contains('횟수') || message.contains('초과')) {
        return showQuotaExceededError(context);
      } else {
        return showGeneralError(context, message: message, onRetry: onRetry);
      }
    } else if (failure is NetworkFailure) {
      return showNetworkError(context, onRetry: onRetry);
    } else {
      return showGeneralError(
        context,
        message: failure.message,
        onRetry: onRetry,
      );
    }
  }
} 