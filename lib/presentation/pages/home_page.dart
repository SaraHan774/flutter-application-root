import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/shared.dart';

/// 홈 화면
/// 앱의 메인 허브 화면으로, 오늘의 매칭 상태와 주요 기능에 접근할 수 있음
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // 홈 화면 진입 시 필요한 데이터 로드
    _loadHomeData();
  }

  /// 홈 화면 데이터 로드
  Future<void> _loadHomeData() async {
    // TODO: 오늘의 매칭 상태, 감정 히스토리, 말벗 친구 수 등 로드
    // 현재는 기본 구조만 구현
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HandamColors.background,
      appBar: AppBar(
        backgroundColor: HandamColors.background,
        elevation: 0,
        title: Text(
          '한담',
          style: HandamTypography.headline3.copyWith(
            color: HandamColors.textDefault,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: 설정 화면으로 이동
            },
            icon: Icon(
              Icons.settings_outlined,
              color: HandamColors.textSecondary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 오늘의 매칭 상태 카드
              _buildMatchingStatusCard(),
              
              const SizedBox(height: 24),
              
              // 공감 카드 갤러리
              _buildEmpathyCardGallery(),
              
              const SizedBox(height: 24),
              
              // 감정 일지 위젯
              _buildEmotionDiaryWidget(),
              
              const SizedBox(height: 24),
              
              // 말벗 친구 상태
              _buildFriendshipStatus(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// 오늘의 매칭 상태 카드
  Widget _buildMatchingStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HandamColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_outline,
                color: HandamColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '오늘의 대화',
                style: HandamTypography.headline4.copyWith(
                  color: HandamColors.textDefault,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 매칭 상태에 따른 메시지
          Text(
            '오늘의 대화 상대를 찾고 있어요',
            style: HandamTypography.body1.copyWith(
              color: HandamColors.textDefault,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '매칭까지 약 2시간 13분 남음',
            style: HandamTypography.body2.copyWith(
              color: HandamColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 매칭 상태 확인 버튼
          Row(
            children: [
              Expanded(
                child: HandamButton(
                  text: '매칭 상태 확인',
                  onPressed: () {
                    // 매칭 상태 페이지로 이동
                    context.push('/matching-status');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HandamButton(
                  text: '매칭 대기 중',
                  onPressed: null, // 매칭 완료 시에만 활성화
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 공감 카드 갤러리
  Widget _buildEmpathyCardGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '공감 카드 모아보기',
          style: HandamTypography.headline4.copyWith(
            color: HandamColors.textDefault,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 12),
        
                 SizedBox(
           height: 120,
           child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildEmpathyCard('#피곤해', Icons.bedtime_outlined),
              _buildEmpathyCard('#위로가필요해', Icons.favorite_outline),
                             _buildEmpathyCard('#고요함', Icons.favorite_border),
              _buildEmpathyCard('#생각이많은', Icons.psychology_outlined),
            ],
          ),
        ),
      ],
    );
  }

  /// 개별 공감 카드
  Widget _buildEmpathyCard(String emotion, IconData icon) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: HandamColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HandamColors.secondary.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: HandamColors.secondary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            emotion,
            style: HandamTypography.body3.copyWith(
              color: HandamColors.textDefault,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 감정 일지 위젯
  Widget _buildEmotionDiaryWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HandamColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HandamColors.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights_outlined,
                color: HandamColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '이번 주 감정 요약',
                style: HandamTypography.headline4.copyWith(
                  color: HandamColors.textDefault,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            '이번 주 당신은 \'편안함\'을 가장 많이 느꼈어요',
            style: HandamTypography.body2.copyWith(
              color: HandamColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          HandamButton(
            text: '자세히 보기',
            onPressed: () {
              // TODO: 감정 일지 상세 화면으로 이동
            },
          ),
        ],
      ),
    );
  }

  /// 말벗 친구 상태
  Widget _buildFriendshipStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HandamColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HandamColors.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people_outline,
                color: HandamColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '말벗 친구',
                style: HandamTypography.headline4.copyWith(
                  color: HandamColors.textDefault,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            '3명의 말벗 친구가 있어요',
            style: HandamTypography.body2.copyWith(
              color: HandamColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          HandamButton(
            text: '친구 목록 보기',
            onPressed: () {
              // TODO: 말벗 친구 목록 화면으로 이동
            },
          ),
        ],
      ),
    );
  }

  /// 하단 네비게이션 바
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: HandamColors.surface,
      selectedItemColor: HandamColors.primary,
      unselectedItemColor: HandamColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: '친구',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: '내 정보',
        ),
      ],
      currentIndex: 0, // 홈 탭이 활성화
      onTap: (index) {
        // TODO: 탭 변경 로직 구현
        switch (index) {
          case 1:
            // 친구 탭으로 이동
            break;
          case 2:
            // 내 정보 탭으로 이동
            break;
        }
      },
    );
  }
} 