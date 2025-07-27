import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/core.dart';
import '../../../shared/shared.dart';

/// 온보딩 페이지
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: '하루 한 사람과\n진심 어린 대화를',
      subtitle: '매일 새로운 상대와 24시간 동안\n따뜻한 대화를 나누세요',
      image: 'assets/images/onboarding_1.png', // TODO: 이미지 추가
      backgroundColor: HandamColors.primaryLight,
    ),
    OnboardingSlide(
      title: '감정 기반으로\n연결되는 공간',
      subtitle: '나의 감정을 표현하고\n비슷한 마음을 가진 사람과 만나요',
      image: 'assets/images/onboarding_2.png', // TODO: 이미지 추가
      backgroundColor: HandamColors.secondaryLight,
    ),
    OnboardingSlide(
      title: '안전하고\n익명의 대화',
      subtitle: '실명 없이 닉네임으로\n부담 없이 대화하세요',
      image: 'assets/images/onboarding_3.png', // TODO: 이미지 추가
      backgroundColor: HandamColors.accentLight,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onNextPressed() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 마지막 슬라이드에서 시작하기 버튼 클릭
      context.go(AppRoutes.phoneAuth);
    }
  }

  void _onSkipPressed() {
    context.go(AppRoutes.phoneAuth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 스킵 버튼
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _onSkipPressed,
                  child: Text(
                    '건너뛰기',
                    style: HandamTypography.body2.copyWith(
                      color: HandamColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ),
            
            // 슬라이드 페이지뷰
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _slides[index];
                },
              ),
            ),
            
            // 하단 인디케이터 및 버튼
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // 페이지 인디케이터
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index 
                              ? HandamColors.primaryLight 
                              : HandamColors.outlineLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 다음/시작하기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: HandamPrimaryButton(
                      onPressed: _onNextPressed,
                      child: Text(_currentPage == _slides.length - 1 
                          ? '시작하기' 
                          : '다음'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 온보딩 슬라이드 위젯
class OnboardingSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final Color backgroundColor;

  const OnboardingSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이미지 (임시로 아이콘 사용)
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 80,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // 제목
            Text(
              title,
              style: HandamTypography.headline1.copyWith(
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // 부제목
            Text(
              subtitle,
              style: HandamTypography.body1.copyWith(
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 