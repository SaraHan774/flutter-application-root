import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../presentation/presentation.dart';

part 'app_router.g.dart';

/// 앱의 라우팅 경로 상수들
class AppRoutes {
  // 온보딩 및 인증 관련
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String phoneAuth = '/phone-auth';
  static const String otpVerification = '/otp-verification';
  static const String profileSetup = '/profile-setup';
  
  // 메인 앱 화면들
  static const String home = '/home';
  static const String chat = '/chat';
  static const String chatRoom = '/chat-room';
  static const String friends = '/friends';
  static const String profile = '/profile';
  
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
    initialLocation: AppRoutes.onboarding,
    debugLogDiagnostics: true,
    routes: [
      // 온보딩 화면
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // 로그인 화면
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
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
      
      // 프로필 설정 화면
      GoRoute(
        path: AppRoutes.profileSetup,
        name: 'profileSetup',
        builder: (context, state) => const ProfileSetupPage(),
      ),
      
      // 홈 화면
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      
      // 채팅 목록 화면
      GoRoute(
        path: AppRoutes.chat,
        name: 'chat',
        builder: (context, state) => const ChatListPage(),
      ),
      
      // 채팅방 화면 (동적 라우트)
      GoRoute(
        path: '${AppRoutes.chatRoom}/:chatRoomId',
        name: 'chatRoom',
        builder: (context, state) {
          final chatRoomId = state.pathParameters['chatRoomId']!;
          return ChatRoomPage(chatRoomId: chatRoomId);
        },
      ),
      
      // 친구 목록 화면
      GoRoute(
        path: AppRoutes.friends,
        name: 'friends',
        builder: (context, state) => const FriendsPage(),
      ),
      
      // 프로필 화면
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      
      // 설정 화면
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      
      // 피드백 화면
      GoRoute(
        path: AppRoutes.feedback,
        name: 'feedback',
        builder: (context, state) => const FeedbackPage(),
      ),
      
      // 연결 요청 화면
      GoRoute(
        path: AppRoutes.connectionRequest,
        name: 'connectionRequest',
        builder: (context, state) => const ConnectionRequestPage(),
      ),
      
      // 에러 페이지
      GoRoute(
        path: AppRoutes.error,
        name: 'error',
        builder: (context, state) => const ErrorPage(),
      ),
    ],
    
    // 에러 핸들링
    errorBuilder: (context, state) => const ErrorPage(),
    
    // 리다이렉트 로직 (인증 상태에 따른 화면 분기)
    redirect: (context, state) {
      // TODO: 인증 상태에 따른 리다이렉트 로직 구현
      // 예: 로그인되지 않은 사용자는 온보딩으로, 
      // 프로필 설정이 안된 사용자는 프로필 설정으로
      return null;
    },
  );
}

// 임시 페이지 클래스들 (실제 구현 시 features 폴더로 이동)
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('로그인')));
}

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('프로필 설정')));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('홈')));
}

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('채팅 목록')));
}

class ChatRoomPage extends StatelessWidget {
  final String chatRoomId;
  const ChatRoomPage({super.key, required this.chatRoomId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('채팅방: $chatRoomId')));
}

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('친구 목록')));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('프로필')));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('설정')));
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('피드백')));
}

class ConnectionRequestPage extends StatelessWidget {
  const ConnectionRequestPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('연결 요청')));
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('에러 페이지')));
} 