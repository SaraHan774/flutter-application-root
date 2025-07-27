import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/shared.dart';
import '../../../domain/entities/matching_entity.dart';

/// 매칭 결과 화면
class MatchingResultPage extends ConsumerWidget {
  final MatchingEntity? matching;

  const MatchingResultPage({
    super.key,
    this.matching,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 매칭 정보가 없을 경우 에러 화면 표시
    if (matching == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('매칭 결과'),
          backgroundColor: HandamColors.primary,
          foregroundColor: HandamColors.onPrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: HandamColors.error,
              ),
              const SizedBox(height: 16),
                              Text(
                  '매칭 정보를 찾을 수 없습니다',
                  style: HandamTypography.headline2.copyWith(
                    color: HandamColors.textDefault,
                  ),
                ),
              const SizedBox(height: 8),
                              Text(
                  '매칭이 취소되었거나 만료되었을 수 있습니다.',
                  style: HandamTypography.body2.copyWith(
                    color: HandamColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              HandamPrimaryButton(
                onPressed: () => context.pop(),
                child: const Text('돌아가기'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('매칭 결과'),
        backgroundColor: HandamColors.primary,
        foregroundColor: HandamColors.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: _buildMatchingResult(),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchingResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 매칭 성공 아이콘
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: HandamColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.celebration,
            size: 60,
            color: HandamColors.primary,
          ),
        ),
        const SizedBox(height: 32),
        
        // 매칭 성공 메시지
        Text(
          '매칭 성공!',
          style: HandamTypography.headline1.copyWith(
            color: HandamColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Text(
          '새로운 대화 친구를 만났습니다',
          style: HandamTypography.headline3.copyWith(
            color: HandamColors.textDefault,
          ),
        ),
        const SizedBox(height: 24),
        
        // 매칭 정보 카드
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildInfoRow('매칭 ID', matching!.matchingId),
                const SizedBox(height: 12),
                _buildInfoRow('매칭 시간', _formatDateTime(matching!.createdAt)),
                const SizedBox(height: 12),
                _buildInfoRow('상태', _getStatusText(matching!.status)),
                if (matching?.chatRoomId != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow('채팅방 ID', matching!.chatRoomId!),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        
        // 안내 메시지
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: HandamColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: HandamColors.outline),
          ),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                color: HandamColors.primary,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                '채팅방은 24시간 후 자동으로 종료됩니다',
                style: HandamTypography.body2.copyWith(
                  color: HandamColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: HandamTypography.body2.copyWith(
              color: HandamColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: HandamTypography.body2.copyWith(
              color: HandamColors.textDefault,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        HandamPrimaryButton(
          onPressed: () {
            // TODO: 채팅방으로 이동 (추후 구현)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('채팅 기능은 추후 구현 예정입니다.')),
            );
          },
          child: const Text('채팅 시작하기'),
        ),
        const SizedBox(height: 12),
        HandamSecondaryButton(
          onPressed: () {
            // TODO: 매칭 취소 로직
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('매칭 취소'),
                content: const Text('정말로 이 매칭을 취소하시겠습니까?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('아니오'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                      context.pop(); // 결과 페이지 닫기
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('매칭이 취소되었습니다.')),
                      );
                    },
                    child: const Text('예'),
                  ),
                ],
              ),
            );
          },
          child: const Text('매칭 취소'),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분';
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return '활성';
      case 'cancelled':
        return '취소됨';
      case 'expired':
        return '만료됨';
      default:
        return status;
    }
  }
} 