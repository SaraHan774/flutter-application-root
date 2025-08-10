import 'package:flutter/material.dart';

import '../../../shared/design_system/colors.dart';
import '../../../shared/design_system/typography.dart';
import '../../../domain/entities/message_entity.dart';

/// 메시지 말풍선 위젯
/// 
/// 채팅 메시지를 표시하는 말풍선 형태의 위젯입니다.
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMyMessage,
    this.showTime = true,
  });

  /// 메시지 엔티티
  final MessageEntity message;
  
  /// 내 메시지 여부
  final bool isMyMessage;
  
  /// 시간 표시 여부
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: isMyMessage 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        children: [
          // 메시지 말풍선
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isMyMessage ? HandamColors.primary : HandamColors.secondary,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMyMessage ? 16 : 4),
                bottomRight: Radius.circular(isMyMessage ? 4 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 메시지 텍스트
                Text(
                  message.text,
                  style: HandamTypography.body1.copyWith(
                    color: isMyMessage 
                        ? HandamColors.onPrimary 
                        : HandamColors.onSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // 시간 표시
          if (showTime) ...[
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(
                left: isMyMessage ? 0 : 16,
                right: isMyMessage ? 16 : 0,
              ),
              child: Text(
                _formatTime(message.timestamp),
                style: HandamTypography.caption.copyWith(
                  color: HandamColors.textDefault.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 시간을 포맷합니다.
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year, 
      timestamp.month, 
      timestamp.day,
    );

    if (messageDate == today) {
      // 오늘: HH:MM 형식
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // 어제: 어제 HH:MM 형식
      return '어제 ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      // 그 외: MM/DD HH:MM 형식
      return '${timestamp.month.toString().padLeft(2, '0')}/${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// 시스템 메시지 말풍선 위젯
/// 
/// 시스템에서 보내는 알림 메시지를 표시합니다.
class SystemMessageBubble extends StatelessWidget {
  const SystemMessageBubble({
    super.key,
    required this.text,
    this.showTime = true,
    this.timestamp,
  });

  /// 메시지 텍스트
  final String text;
  
  /// 시간 표시 여부
  final bool showTime;
  
  /// 타임스탬프
  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // 시스템 메시지 컨테이너
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: HandamColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: HandamColors.outline.withOpacity(0.3),
              ),
            ),
            child: Text(
              text,
              style: HandamTypography.body2.copyWith(
                color: HandamColors.textDefault.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // 시간 표시
          if (showTime && timestamp != null) ...[
            const SizedBox(height: 4),
            Text(
              _formatTime(timestamp!),
              style: HandamTypography.caption.copyWith(
                color: HandamColors.textDefault.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 시간을 포맷합니다.
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year, 
      timestamp.month, 
      timestamp.day,
    );

    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return '어제 ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.month.toString().padLeft(2, '0')}/${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// 타이핑 인디케이터 위젯
/// 
/// 상대방이 메시지를 입력 중임을 표시합니다.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.isVisible = false,
  });

  /// 표시 여부
  final bool isVisible;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.repeat();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: HandamColors.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 점 애니메이션을 구성합니다.
  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final delay = index * 0.2;
        final value = (_animation.value + delay) % 1.0;
        final opacity = (value * 2).clamp(0.0, 1.0);
        
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: HandamColors.onSecondary.withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
