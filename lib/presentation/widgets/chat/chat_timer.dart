import 'dart:async';
import 'package:flutter/material.dart';

import '../../../shared/design_system/colors.dart';
import '../../../shared/design_system/typography.dart';

/// 채팅 타이머 위젯
/// 
/// 24시간 채팅 제한 시간을 표시하는 타이머입니다.
class ChatTimer extends StatefulWidget {
  const ChatTimer({
    super.key,
    required this.expiresAt,
    this.onExpired,
    this.showWarning = true,
  });

  /// 만료 시간
  final DateTime expiresAt;
  
  /// 만료 시 콜백
  final VoidCallback? onExpired;
  
  /// 경고 표시 여부
  final bool showWarning;

  @override
  State<ChatTimer> createState() => _ChatTimerState();
}

class _ChatTimerState extends State<ChatTimer> {
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 남은 시간을 계산합니다.
  void _calculateRemainingTime() {
    final now = DateTime.now();
    final remaining = widget.expiresAt.difference(now);
    
    setState(() {
      _remainingTime = remaining.isNegative ? Duration.zero : remaining;
      _isExpired = remaining.isNegative;
    });

    if (_isExpired && widget.onExpired != null) {
      widget.onExpired!();
    }
  }

  /// 타이머를 시작합니다.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateRemainingTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isExpired) {
      return _buildExpiredTimer();
    }

    return _buildActiveTimer();
  }

  /// 활성 타이머를 구성합니다.
  Widget _buildActiveTimer() {
    final hours = _remainingTime.inHours;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;
    
    final isWarning = hours < 1; // 1시간 미만일 때 경고
    final isCritical = hours < 1 && minutes < 10; // 10분 미만일 때 긴급

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getTimerColor(isWarning, isCritical),
        border: Border(
          bottom: BorderSide(
            color: HandamColors.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: _getTimerTextColor(isWarning, isCritical),
          ),
          const SizedBox(width: 8),
          Text(
            _formatTime(hours, minutes, seconds),
            style: HandamTypography.body2.copyWith(
              color: _getTimerTextColor(isWarning, isCritical),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.showWarning && isWarning) ...[
            const SizedBox(width: 8),
            Text(
              isCritical ? '곧 종료됩니다!' : '곧 종료됩니다',
              style: HandamTypography.body3.copyWith(
                color: _getTimerTextColor(isWarning, isCritical),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 만료된 타이머를 구성합니다.
  Widget _buildExpiredTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: HandamColors.error.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: HandamColors.error.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 16,
            color: HandamColors.error,
          ),
          const SizedBox(width: 8),
          Text(
            '대화가 종료되었습니다',
            style: HandamTypography.body2.copyWith(
              color: HandamColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 타이머 배경 색상을 결정합니다.
  Color _getTimerColor(bool isWarning, bool isCritical) {
    if (isCritical) {
      return HandamColors.error.withOpacity(0.1);
    } else if (isWarning) {
      return HandamColors.secondary.withOpacity(0.2);
    } else {
      return HandamColors.primary.withOpacity(0.1);
    }
  }

  /// 타이머 텍스트 색상을 결정합니다.
  Color _getTimerTextColor(bool isWarning, bool isCritical) {
    if (isCritical) {
      return HandamColors.error;
    } else if (isWarning) {
      return HandamColors.textDefault;
    } else {
      return HandamColors.primary;
    }
  }

  /// 시간을 포맷합니다.
  String _formatTime(int hours, int minutes, int seconds) {
    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else if (minutes > 0) {
      return '${minutes}분 ${seconds}초';
    } else {
      return '${seconds}초';
    }
  }
}

/// 간단한 타이머 위젯
/// 
/// 작은 크기의 타이머를 표시합니다.
class SimpleChatTimer extends StatelessWidget {
  const SimpleChatTimer({
    super.key,
    required this.expiresAt,
    this.size = 16,
  });

  /// 만료 시간
  final DateTime expiresAt;
  
  /// 아이콘 크기
  final double size;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final remaining = expiresAt.difference(now);
    final isExpired = remaining.isNegative;
    
    if (isExpired) {
      return Icon(
        Icons.schedule,
        size: size,
        color: HandamColors.error,
      );
    }

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    
    final isWarning = hours < 1;
    final isCritical = hours < 1 && minutes < 10;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time,
          size: size,
          color: _getTimerColor(isWarning, isCritical),
        ),
        const SizedBox(width: 4),
        Text(
          _formatTime(hours, minutes),
          style: HandamTypography.caption.copyWith(
            color: _getTimerColor(isWarning, isCritical),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 타이머 색상을 결정합니다.
  Color _getTimerColor(bool isWarning, bool isCritical) {
    if (isCritical) {
      return HandamColors.error;
    } else if (isWarning) {
      return HandamColors.textDefault;
    } else {
      return HandamColors.primary;
    }
  }

  /// 시간을 포맷합니다.
  String _formatTime(int hours, int minutes) {
    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else {
      return '${minutes}분';
    }
  }
}
