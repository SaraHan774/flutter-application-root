import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/shared.dart';
import '../../../domain/entities/matching_entity.dart';
import '../../providers/matching_provider.dart';
import '../../../core/di/service_locator.dart';

/// 매칭 상태 화면
class MatchingStatusPage extends ConsumerStatefulWidget {
  const MatchingStatusPage({super.key});

  @override
  ConsumerState<MatchingStatusPage> createState() => _MatchingStatusPageState();
}

class _MatchingStatusPageState extends ConsumerState<MatchingStatusPage> {
  @override
  void initState() {
    super.initState();
    // 위젯 빌드 완료 후 매칭 상태 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMatchingStatus();
    });
  }

  void _loadMatchingStatus() {
    final currentUserId = ref.read(currentUserIdProvider);
    print('[한담] [MATCHING] Loading matching status for user: $currentUserId');
    if (currentUserId != null) {
      ref.read(matchingProvider.notifier).getTodayMatching(currentUserId);
    } else {
      print('[한담] [MATCHING] No current user ID found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchingState = ref.watch(matchingProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 매칭'),
        backgroundColor: HandamColors.primary,
        foregroundColor: HandamColors.onPrimary,
      ),
      body: currentUserId == null
          ? const Center(
              child: Text('로그인이 필요합니다.'),
            )
          : _buildMatchingContent(matchingState),
    );
  }

  Widget _buildMatchingContent(MatchingState matchingState) {
    print('[한담] [MATCHING] Building content - isLoading: ${matchingState.isLoading}, error: ${matchingState.error}, todayMatching: ${matchingState.todayMatching}');
    
    // 로딩 상태 확인
    if (matchingState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('매칭 정보를 불러오는 중...'),
          ],
        ),
      );
    }

    // 에러 상태 확인
    if (matchingState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('오류: ${matchingState.error}'),
            const SizedBox(height: 16),
            HandamPrimaryButton(
              onPressed: () {
                ref.read(matchingProvider.notifier).clearError();
                _loadMatchingStatus();
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    // 매칭이 없는 경우
    if (matchingState.todayMatching == null) {
      return _buildNoMatchingView();
    }

    // 매칭이 있는 경우
    return _buildMatchingView(matchingState.todayMatching!);
  }

  Widget _buildNoMatchingView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: HandamColors.textSecondary,
          ),
          const SizedBox(height: 24),
          Text(
            '오늘의 매칭이 없습니다',
            style: HandamTypography.headline2.copyWith(
              color: HandamColors.textDefault,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '매칭을 요청하면 새로운 대화 친구를 만날 수 있어요!',
            style: HandamTypography.body2.copyWith(
              color: HandamColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          HandamPrimaryButton(
            onPressed: () {
              // TODO: 매칭 요청 로직 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('매칭 요청이 전송되었습니다.')),
              );
            },
            child: const Text('매칭 요청하기'),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingView(MatchingEntity matching) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: HandamColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '매칭 완료!',
                        style: HandamTypography.headline3.copyWith(
                          color: HandamColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '새로운 대화 친구와 매칭되었습니다.',
                    style: HandamTypography.body1.copyWith(
                      color: HandamColors.textDefault,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '매칭 시간: ${_formatDateTime(matching.createdAt)}',
                    style: HandamTypography.body2.copyWith(
                      color: HandamColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: HandamSecondaryButton(
                          onPressed: () {
                            // TODO: 매칭 취소 로직
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('매칭이 취소되었습니다.')),
                            );
                          },
                          child: const Text('매칭 취소'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: HandamPrimaryButton(
                          onPressed: () {
                            // 매칭 결과 페이지로 이동
                            context.push('/matching-result/${matching.matchingId}');
                          },
                          child: const Text('매칭 상세보기'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분';
  }
} 