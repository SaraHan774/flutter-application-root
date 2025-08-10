import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../presentation/presentation.dart';
import '../../shared/shared.dart';

part 'app_router.g.dart';

/// 앱의 라우팅 경로 상수들
class AppRoutes {
  // 스플래시 화면
  static const String splash = '/splash';
  
  // 온보딩 및 인증 관련
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String phoneAuth = '/phone-auth';
  static const String otpVerification = '/otp-verification';
  
  // 프로필 설정 관련
  static const String nicknameSetup = '/nickname-setup';
  static const String emotionSelection = '/emotion-selection';
  static const String timePreference = '/time-preference';
  static const String empathySurvey = '/empathy-survey';
  
  // 메인 앱 화면들
  static const String home = '/home';
  static const String chat = '/chat';
  static const String chatRoom = '/chat-room';
  static const String friends = '/friends';
  static const String profile = '/profile';
  
  // 매칭 관련
  static const String matchingStatus = '/matching-status';
  static const String matchingResult = '/matching-result';
  
  // 설정 및 기타
  static const String settings = '/settings';
  static const String feedback = '/feedback';
  static const String connectionRequest = '/connection-request';
  
  // 에러 페이지
  static const String error = '/error';
}

/// 앱의 라우터 설정
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // 스플래시 화면
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // 온보딩 화면
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // TODO: 로그인 화면은 추후 구현 예정
      // GoRoute(
      //   path: AppRoutes.login,
      //   name: 'login',
      //   builder: (context, state) => const LoginPage(),
      // ),
      
      // 휴대폰 인증 화면
      GoRoute(
        path: AppRoutes.phoneAuth,
        name: 'phoneAuth',
        builder: (context, state) => const PhoneAuthPage(),
      ),
      
      // OTP 인증번호 확인 화면 (쿼리 파라미터 사용)
      GoRoute(
        path: AppRoutes.otpVerification,
        name: 'otpVerification',
        builder: (context, state) {
          final phoneNumber = state.uri.queryParameters['phoneNumber'] ?? '';
          final verificationId = state.uri.queryParameters['verificationId'] ?? '';
          
          return OtpVerificationPage(
            phoneNumber: phoneNumber,
            verificationId: verificationId,
          );
        },
      ),
      
      // 닉네임 설정 화면
      GoRoute(
        path: AppRoutes.nicknameSetup,
        name: 'nicknameSetup',
        builder: (context, state) => const NicknameSetupPage(),
      ),
      
      // 감정 키워드 선택 화면
      GoRoute(
        path: AppRoutes.emotionSelection,
        name: 'emotionSelection',
        builder: (context, state) => const EmotionSelectionPage(),
      ),
      
      // 대화 시간대 선택 화면
      GoRoute(
        path: AppRoutes.timePreference,
        name: 'timePreference',
        builder: (context, state) => const TimePreferencePage(),
      ),
      
      // 공감 성향 설문 화면
      GoRoute(
        path: AppRoutes.empathySurvey,
        name: 'empathySurvey',
        builder: (context, state) => const EmpathySurveyPage(),
      ),
      
      // 홈 화면
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      
      // 매칭 상태 화면
      GoRoute(
        path: AppRoutes.matchingStatus,
        name: 'matchingStatus',
        builder: (context, state) => const MatchingStatusPage(),
      ),
      
      // 매칭 결과 화면 (동적 라우트)
      GoRoute(
        path: '${AppRoutes.matchingResult}/:matchingId',
        name: 'matchingResult',
        builder: (context, state) {
          final matchingId = state.pathParameters['matchingId']!;
          // TODO: 매칭 ID로 매칭 정보를 조회하여 MatchingResultPage에 전달
          // 현재는 임시로 null을 전달 (실제 구현 시 매칭 정보 조회 로직 추가)
          return MatchingResultPage(matchingId: matchingId, matching: null);
        },
      ),
      
      // TODO: 다음 화면들은 추후 구현 예정
      // 채팅 목록 화면
      // GoRoute(
      //   path: AppRoutes.chat,
      //   name: 'chat',
      //   builder: (context, state) => const ChatListPage(),
      // ),
      
      // 채팅방 화면 (동적 라우트)
      // GoRoute(
      //   path: '${AppRoutes.chatRoom}/:chatRoomId',
      //   name: 'chatRoom',
      //   builder: (context, state) {
      //     final chatRoomId = state.pathParameters['chatRoomId']!;
      //     return ChatRoomPage(chatRoomId: chatRoomId);
      //   },
      // ),
      
      // 친구 목록 화면
      // GoRoute(
      //   path: AppRoutes.friends,
      //   name: 'friends',
      //   builder: (context, state) => const FriendsPage(),
      // ),
      
      // 프로필 화면
      // GoRoute(
      //   path: AppRoutes.profile,
      //   name: 'profile',
      //   builder: (context, state) => const ProfilePage(),
      // ),
      
      // 설정 화면
      // GoRoute(
      //   path: AppRoutes.settings,
      //   name: 'settings',
      //   builder: (context, state) => const SettingsPage(),
      // ),
      
      // 피드백 화면
      // GoRoute(
      //   path: AppRoutes.feedback,
      //   name: 'feedback',
      //   builder: (context, state) => const FeedbackPage(),
      // ),
      
      // 연결 요청 화면
      // GoRoute(
      //   path: AppRoutes.connectionRequest,
      //   name: 'connectionRequest',
      //   builder: (context, state) => const ConnectionRequestPage(),
      // ),
      
      // 에러 페이지
      // GoRoute(
      //   path: AppRoutes.error,
      //   name: 'error',
      //   builder: (context, state) => const ErrorPage(),
      // ),
    ],
    
    // 에러 핸들링
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '페이지를 찾을 수 없습니다',
              style: HandamTypography.headline4,
            ),
            const SizedBox(height: 8),
            Text(
              '요청하신 페이지가 존재하지 않습니다.',
              style: HandamTypography.body2.copyWith(
                color: HandamColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            HandamButton(
              text: '홈으로 돌아가기',
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    ),
    
    // 리다이렉트 로직 (인증 상태에 따른 화면 분기)
    redirect: (context, state) {
      // TODO: 인증 상태에 따른 리다이렉트 로직 구현
      // 예: 로그인되지 않은 사용자는 온보딩으로, 
      // 프로필 설정이 안된 사용자는 프로필 설정으로
      return null;
    },
  );
} 