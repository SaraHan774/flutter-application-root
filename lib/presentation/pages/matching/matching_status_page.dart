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

/// 매칭 상태 화면
/// 
/// 오늘의 매칭 상태를 표시하고 매칭 결과를 보여줍니다.
class MatchingStatusPage extends ConsumerStatefulWidget {
  const MatchingStatusPage({super.key});

  @override
  ConsumerState<MatchingStatusPage> createState() => _MatchingStatusPageState();
}

class _MatchingStatusPageState extends ConsumerState<MatchingStatusPage> {
  @override
  void initState() {
    super.initState();
    _loadTodayMatching();
  }

  /// 오늘의 매칭을 로드합니다.
  Future<void> _loadTodayMatching() async {
    final userAsync = ref.read(currentUserProviderProvider);
    final user = userAsync.value;
    if (user != null) {
      await ref.read(matchingNotifierProvider.notifier).loadTodayMatching(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchingAsync = ref.watch(matchingNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: HandamColors.background,
      appBar: AppBar(
        title: Text(
          '오늘의 매칭',
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
      body: RefreshIndicator(
        onRefresh: _loadTodayMatching,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: matchingAsync.when(
            data: (matching) => _buildMatchingContent(matching),
                    loading: () => const Center(
          child: const HandamLoadingIndicator(),
        ),
            error: (error, stackTrace) => _buildErrorContent(error.toString()),
          ),
        ),
      ),
    );
  }

  /// 매칭 내용을 구성합니다.
  Widget _buildMatchingContent(dynamic matching) {
    if (matching == null) {
      return _buildNoMatchingContent();
    }

    return _buildMatchingResultContent(matching);
  }

  /// 매칭이 없을 때의 내용을 구성합니다.
  Widget _buildNoMatchingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.people_outline,
          size: 80,
          color: HandamColors.secondary,
        ),
        const SizedBox(height: 24),
        Text(
          '오늘의 대화 상대를 찾고 있어요',
          style: HandamTypography.headline2.copyWith(
            color: HandamColors.textDefault,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          '매일 오전 9시에 새로운 대화 상대가 도착합니다.\n잠시만 기다려주세요!',
          style: HandamTypography.body1.copyWith(
            color: HandamColors.textDefault.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        _buildNextMatchingTime(),
        const SizedBox(height: 40),
        HandamButton(
          text: '새로고침',
          onPressed: _loadTodayMatching,
          variant: HandamButtonVariant.secondary,
        ),
      ],
    );
  }

  /// 다음 매칭 시간을 표시합니다.
  Widget _buildNextMatchingTime() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 9, 0);
    final timeUntilNext = tomorrow.difference(now);

    final hours = timeUntilNext.inHours;
    final minutes = timeUntilNext.inMinutes % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HandamColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HandamColors.outline),
      ),
      child: Column(
        children: [
          Text(
            '다음 매칭까지',
            style: HandamTypography.body2.copyWith(
              color: HandamColors.textDefault.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${hours}시간 ${minutes}분',
            style: HandamTypography.headline2.copyWith(
              color: HandamColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '내일 오전 9시',
            style: HandamTypography.body2.copyWith(
              color: HandamColors.textDefault.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// 매칭 결과 내용을 구성합니다.
  Widget _buildMatchingResultContent(dynamic matching) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: HandamColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: HandamColors.outline),
            boxShadow: [
              BoxShadow(
                color: HandamColors.textDefault.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
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
                '오늘의 대화 상대가 도착했어요!',
                style: HandamTypography.headline2.copyWith(
                  color: HandamColors.textDefault,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildMatchingInfo(matching),
              const SizedBox(height: 32),
              HandamButton(
                text: '대화 시작하기',
                onPressed: () => _startChat(matching),
                variant: HandamButtonVariant.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        HandamButton(
          text: '매칭 취소하기',
          onPressed: () => _cancelMatching(matching),
          variant: HandamButtonVariant.text,
        ),
      ],
    );
  }

  /// 매칭 정보를 표시합니다.
  Widget _buildMatchingInfo(dynamic matching) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HandamColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HandamColors.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: HandamColors.primary,
                child: Text(
                  '👤',
                  style: HandamTypography.headline3,
                ),
              ),
              const SizedBox(width: 12),
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
                      style: HandamTypography.headline4.copyWith(
                        color: HandamColors.textDefault,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: HandamColors.textDefault.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                '24시간 동안 대화 가능',
                style: HandamTypography.body2.copyWith(
                  color: HandamColors.textDefault.withOpacity(0.7),
                ),
              ),
            ],
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
      }
    }
  }

  /// 에러 내용을 구성합니다.
  Widget _buildErrorContent(String error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
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
          onPressed: _loadTodayMatching,
          variant: HandamButtonVariant.primary,
        ),
      ],
    );
  }
} 