import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/core.dart';
import '../../shared/shared.dart';
import '../providers/auth_provider.dart';

/// 스플래시 화면
/// 앱 시작 시 로딩 화면으로 사용되며, 인증 상태에 따라 적절한 화면으로 이동
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // 애니메이션 컨트롤러 초기화
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // 애니메이션 설정
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // 애니메이션 시작
    _fadeController.forward();
    _scaleController.forward();

    // 3초 후 다음 화면으로 이동
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  /// 다음 화면으로 이동하는 로직
  Future<void> _navigateToNextScreen() async {
    // 최소 2초 대기 (스플래시 화면 표시 시간)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 인증 상태 확인
    final authState = ref.read(authNotifierProvider);
    
    authState.when(
      data: (user) {
        if (user != null) {
          // 로그인된 사용자
          if (user.isProfileComplete) {
            // 프로필 설정 완료: 홈 화면으로 이동
            print('[한담] [SPLASH] User profile complete, navigating to home');
            context.go(AppRoutes.home);
          } else {
            // 프로필 설정 미완료: 닉네임 설정 화면으로 이동
            print('[한담] [SPLASH] User profile incomplete, navigating to nickname setup');
            context.go(AppRoutes.nicknameSetup);
          }
        } else {
          // 로그인되지 않은 사용자: 온보딩 화면으로 이동
          print('[한담] [SPLASH] No user found, navigating to onboarding');
          context.go(AppRoutes.onboarding);
        }
      },
      loading: () {
        // 로딩 중: 잠시 더 대기
        print('[한담] [SPLASH] Auth loading, waiting...');
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            context.go(AppRoutes.onboarding);
          }
        });
      },
      error: (error, stackTrace) {
        // 에러 발생: 온보딩 화면으로 이동
        print('[한담] [SPLASH] Auth error: $error, navigating to onboarding');
        context.go(AppRoutes.onboarding);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HandamColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeController, _scaleController]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 앱 로고 (임시로 텍스트 사용)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: HandamColors.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: HandamColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 앱 이름
                    Text(
                      '한담',
                      style: HandamTypography.headline1.copyWith(
                        color: HandamColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 앱 설명
                    Text(
                      '하루 한 번, 진심 어린 대화를 나누는 공간',
                      style: HandamTypography.body2.copyWith(
                        color: HandamColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // 로딩 인디케이터
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          HandamColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 