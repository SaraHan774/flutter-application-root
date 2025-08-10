import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';
import '../../../shared/design_system/colors.dart';
import '../../../shared/design_system/typography.dart';
import '../../../shared/design_system/components/app_button.dart';
import '../../../shared/design_system/components/loading_indicator.dart';
import '../../providers/matching_provider.dart';
import '../../providers/auth_provider.dart';

/// 매칭 결과 화면
/// 
/// 매칭된 상대방의 정보를 표시하고 채팅방으로 이동할 수 있는 화면입니다.
class MatchingResultPage extends ConsumerStatefulWidget {
  const MatchingResultPage({
    super.key,
    required this.matchingId,
    this.matching,
  });

  final String matchingId;
  final dynamic matching;

  @override
  ConsumerState<MatchingResultPage> createState() => _MatchingResultPageState();
}

class _MatchingResultPageState extends ConsumerState<MatchingResultPage> {
  @override
  void initState() {
    super.initState();
    _loadMatchingResult();
  }

  /// 매칭 결과를 로드합니다.
  Future<void> _loadMatchingResult() async {
    final userAsync = ref.read(currentUserProviderProvider);
    final user = userAsync.value;
    if (user != null) {
      await ref.read(matchingNotifierProvider.notifier).loadTodayMatching(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchingAsync = ref.watch(matchingNotifierProvider);

    return Scaffold(
      backgroundColor: HandamColors.background,
      appBar: AppBar(
        title: Text(
          '매칭 결과',
          style: HandamTypography.headline3.copyWith(
            color: HandamColors.textDefault,
          ),
        ),
        backgroundColor: HandamColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: HandamColors.textDefault),
          onPressed: () => context.pop(),
        ),
      ),
      body: matchingAsync.when(
        data: (matching) => _buildMatchingResult(matching),
        loading: () => const Center(
          child: const HandamLoadingIndicator(),
        ),
        error: (error, stackTrace) => _buildErrorContent(error.toString()),
      ),
    );
  }

  /// 매칭 결과를 구성합니다.
  Widget _buildMatchingResult(dynamic matching) {
    if (matching == null) {
      return _buildNoMatchingContent();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildSuccessHeader(),
          const SizedBox(height: 32),
          _buildPartnerInfo(matching),
          const SizedBox(height: 32),
          _buildMatchingDetails(matching),
          const SizedBox(height: 40),
          _buildActionButtons(matching),
          const SizedBox(height: 24),
          _buildGuidelines(),
        ],
      ),
    );
  }

  /// 성공 헤더를 구성합니다.
  Widget _buildSuccessHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HandamColors.primary.withOpacity(0.1),
            HandamColors.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HandamColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.celebration,
            size: 60,
            color: HandamColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            '매칭 성공!',
            style: HandamTypography.headline1.copyWith(
              color: HandamColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '오늘의 대화 상대를 찾았어요',
            style: HandamTypography.headline3.copyWith(
              color: HandamColors.textDefault,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 상대방 정보를 구성합니다.
  Widget _buildPartnerInfo(dynamic matching) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HandamColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HandamColors.outline),
        boxShadow: [
          BoxShadow(
            color: HandamColors.textDefault.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: HandamColors.primary,
                child: Text(
                  '👤',
                  style: HandamTypography.headline2,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '대화 상대',
                      style: HandamTypography.body2.copyWith(
                        color: HandamColors.textDefault.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '익명의 친구',
                      style: HandamTypography.headline3.copyWith(
                        color: HandamColors.textDefault,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildEmotionTags(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 감정 태그를 구성합니다.
  Widget _buildEmotionTags() {
    // TODO: 실제 감정 태그 데이터 연동
    final emotionTags = ['#위로가필요해', '#고요함', '#대화가필요해'];
    
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: emotionTags.map((tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: HandamColors.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: HandamColors.secondary.withOpacity(0.3)),
        ),
        child: Text(
          tag,
          style: HandamTypography.body3.copyWith(
            color: HandamColors.textDefault,
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  /// 매칭 상세 정보를 구성합니다.
  Widget _buildMatchingDetails(dynamic matching) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HandamColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HandamColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '매칭 정보',
            style: HandamTypography.headline4.copyWith(
              color: HandamColors.textDefault,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.access_time,
            label: '대화 가능 시간',
            value: '24시간',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: '매칭 시간',
            value: _formatDateTime(matching.createdAt),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.schedule,
            label: '만료 시간',
            value: _formatDateTime(matching.expiresAt),
          ),
        ],
      ),
    );
  }

  /// 정보 행을 구성합니다.
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: HandamColors.textDefault.withOpacity(0.7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: HandamTypography.body2.copyWith(
              color: HandamColors.textDefault.withOpacity(0.7),
            ),
          ),
        ),
        Text(
          value,
          style: HandamTypography.body2.copyWith(
            color: HandamColors.textDefault,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 액션 버튼들을 구성합니다.
  Widget _buildActionButtons(dynamic matching) {
    return Column(
      children: [
        HandamButton(
          text: '대화 시작하기',
          onPressed: () => _startChat(matching),
          variant: HandamButtonVariant.primary,
        ),
        const SizedBox(height: 12),
        HandamButton(
          text: '매칭 취소하기',
          onPressed: () => _cancelMatching(matching),
          variant: HandamButtonVariant.secondary,
        ),
      ],
    );
  }

  /// 가이드라인을 구성합니다.
  Widget _buildGuidelines() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HandamColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HandamColors.secondary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: HandamColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                '대화 가이드라인',
                style: HandamTypography.headline4.copyWith(
                  color: HandamColors.textDefault,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGuidelineItem('• 서로를 존중하고 예의 바르게 대화해주세요'),
          _buildGuidelineItem('• 개인정보나 연락처는 공유하지 마세요'),
          _buildGuidelineItem('• 불쾌한 언행이나 괴롭힘은 금지됩니다'),
          _buildGuidelineItem('• 24시간 후 자동으로 대화가 종료됩니다'),
        ],
      ),
    );
  }

  /// 가이드라인 항목을 구성합니다.
  Widget _buildGuidelineItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: HandamTypography.body2.copyWith(
          color: HandamColors.textDefault.withOpacity(0.8),
        ),
      ),
    );
  }

  /// 매칭이 없을 때의 내용을 구성합니다.
  Widget _buildNoMatchingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: HandamColors.secondary,
          ),
          const SizedBox(height: 24),
          Text(
            '매칭 정보를 찾을 수 없습니다',
            style: HandamTypography.headline2.copyWith(
              color: HandamColors.textDefault,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '매칭이 취소되었거나 만료되었을 수 있습니다.',
            style: HandamTypography.body1.copyWith(
              color: HandamColors.textDefault.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          HandamButton(
            text: '홈으로 돌아가기',
            onPressed: () => context.go('/'),
            variant: HandamButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  /// 에러 내용을 구성합니다.
  Widget _buildErrorContent(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: HandamColors.error,
          ),
          const SizedBox(height: 24),
          Text(
            '매칭 정보를 불러오는데 실패했습니다',
            style: HandamTypography.headline2.copyWith(
              color: HandamColors.textDefault,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: HandamTypography.body1.copyWith(
              color: HandamColors.textDefault.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          HandamButton(
            text: '다시 시도',
            onPressed: _loadMatchingResult,
            variant: HandamButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  /// 채팅을 시작합니다.
  void _startChat(dynamic matching) {
    // TODO: 채팅방으로 이동하는 로직 구현
    context.push('/chat/${matching.chatRoomId}');
  }

  /// 매칭을 취소합니다.
  Future<void> _cancelMatching(dynamic matching) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('매칭 취소'),
        content: const Text('정말로 이 매칭을 취소하시겠습니까?\n취소하면 오늘은 새로운 매칭을 받을 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('네, 취소합니다'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final userAsync = ref.read(currentUserProviderProvider);
      final user = userAsync.value;
      if (user != null) {
        await ref.read(matchingNotifierProvider.notifier).cancelMatching(
          matchingId: matching.id,
          userId: user.uid,
        );
        
        if (mounted) {
          context.go('/');
        }
      }
    }
  }

  /// 날짜 시간을 포맷합니다.
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분';
  }
} 