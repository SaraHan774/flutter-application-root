# 한담(HanDamn) 앱 - 사용자 인증 및 프로필 화면 구현 태스크

## 📋 프로젝트 개요
- **목표**: 사용자 인증 및 프로필 설정 화면 구현
- **기술 스택**: Flutter + Firebase Auth + Firestore
- **아키텍처**: Clean Architecture 기반
- **디자인 시스템**: 한담 커스텀 디자인 시스템 적용

---

## 🎯 Phase 1: 프로젝트 기반 설정 (우선순위: 최고)

### 1.1 의존성 설정
- [x] `pubspec.yaml` 업데이트 - Firebase 패키지 추가
  - [x] `firebase_core: ^2.24.2`
  - [x] `firebase_auth: ^4.15.3`
  - [x] `cloud_firestore: ^4.13.6`
  - [x] `riverpod: ^2.4.9`
  - [x] `flutter_riverpod: ^2.4.9`
  - [x] `go_router: ^12.1.3`
  - [x] `google_fonts: ^6.1.0`
  - [x] `flutter_dotenv: ^5.1.0`

### 1.2 Firebase 프로젝트 설정
- [x] Firebase 프로젝트 생성 (handam-chatting)
- [x] Android/iOS 앱 등록
- [x] `google-services.json` (Android) 추가
- [x] `GoogleService-Info.plist` (iOS) 추가
- [x] Android 빌드 설정 업데이트 (Google Services 플러그인)
- [x] Firebase Auth 설정 (전화번호 인증 활성화) - CLI로 프로젝트 초기화 완료, 콘솔에서 활성화 완료
- [x] Firestore 데이터베이스 생성 - CLI로 생성 및 보안 규칙 배포 완료
- [x] `.env` 파일 생성 - 수동 생성 완료

### 1.3 환경 변수 설정
- [x] `.env` 파일 생성 (Firebase 설정값)
- [x] `.gitignore`에 `.env` 포함 확인
- [x] 환경 변수 로딩용 EnvConfig 클래스 생성

### 1.4 Flutter 및 패키지 최신화
- [x] Flutter 최신 버전(3.32.7)으로 업그레이드
- [x] 패키지 호환성 맞춰 최신화 및 설치

---

**Phase 1 완료!**

---

## 🎨 Phase 2: 디자인 시스템 구축 (우선순위: 높음) - 완료!

---

## 🏗️ Phase 3: Core 레이어 구축 (우선순위: 높음) - 완료!

### 3.1 에러 처리
- [x] `lib/core/error/` 디렉토리 생성
  - [x] `failure.dart` - Failure 계층(통합)
  - [x] `error_handler.dart` - Firebase Exception 핸들러

### 3.2 라우팅 설정
- [x] `lib/core/router/` 디렉토리 생성
  - [x] `app_router.dart` - GoRouter 설정 및 라우트 정의

### 3.3 의존성 주입
- [x] `lib/core/di/` 디렉토리 생성
  - [x] `service_locator.dart` - Riverpod 기반 DI
  - [x] Firebase 서비스 Provider 등록
  - [x] 인증 상태 Provider 등록

### 3.4 유틸리티
- [x] `lib/core/utils/` 디렉토리 생성
  - [x] `constants.dart` - 상수 정의
  - [x] `validators.dart` - 입력값 검증
  - [x] `logger.dart` - 로깅 시스템
- [x] `lib/core/core.dart` - core export 파일

---

## 📊 Phase 4: Domain 레이어 구축 (우선순위: 높음) - 완료!

### 4.1 엔티티 정의
- [x] `lib/domain/entities/` 디렉토리 생성
  - [x] `user_entity.dart` - User 엔티티
  - [x] `matching_entity.dart` - Matching 엔티티
  - [x] `chat_room_entity.dart` - ChatRoom 엔티티
  - [x] `message_entity.dart` - Message 엔티티
  - [x] `feedback_entity.dart` - Feedback 엔티티
  - [x] `connection_request_entity.dart` - ConnectionRequest 엔티티
  - [x] `friendship_entity.dart` - Friendship 엔티티

### 4.2 Repository 인터페이스
- [x] `lib/domain/repositories/` 디렉토리 생성
  - [x] `auth_repository.dart` - 인증 Repository 인터페이스
  - [x] `user_repository.dart` - 사용자 Repository 인터페이스
  - [x] `matching_repository.dart` - 매칭 Repository 인터페이스
  - [x] `chat_repository.dart` - 채팅 Repository 인터페이스
  - [x] `feedback_repository.dart` - 피드백 Repository 인터페이스
  - [x] `connection_repository.dart` - 연결 요청 Repository 인터페이스
  - [x] `friendship_repository.dart` - 말벗 친구 Repository 인터페이스

### 4.3 UseCase 정의
- [x] `lib/domain/usecases/` 디렉토리 생성
  - [x] `auth/` - 인증 관련 UseCase
    - [x] `sign_in_with_phone.dart` - 전화번호 인증 시작
    - [x] `verify_phone_code.dart` - 인증번호 확인
  - [x] `user/` - 사용자 관련 UseCase
    - [x] `create_user_profile.dart` - 사용자 프로필 생성
    - [x] `update_user_profile.dart` - 사용자 프로필 업데이트
    - [x] `get_user_profile.dart` - 사용자 프로필 조회
  - [x] `matching/` - 매칭 관련 UseCase
  - [x] `chat/` - 채팅 관련 UseCase
  - [x] `feedback/` - 피드백 관련 UseCase
  - [x] `connection/` - 연결 요청 관련 UseCase
  - [x] `friendship/` - 말벗 친구 관련 UseCase

---

## 💾 Phase 5: Data 레이어 구축 (우선순위: 높음) - 완료!

### 5.1 데이터 모델
- [x] `lib/data/models/` 디렉토리 생성
  - [x] `user_model.dart` - User DTO 모델
  - [x] `auth_model.dart` - 인증 관련 모델

### 5.2 데이터 소스
- [x] `lib/data/datasources/` 디렉토리 생성
  - [x] `firebase_auth_datasource.dart` - Firebase Auth 데이터소스
  - [x] `firestore_user_datasource.dart` - Firestore 사용자 데이터소스

### 5.3 Repository 구현
- [x] `lib/data/repositories/` 디렉토리 생성
  - [x] `auth_repository_impl.dart` - 인증 Repository 구현
  - [x] `user_repository_impl.dart` - 사용자 Repository 구현

---

## 🎭 Phase 6: Presentation 레이어 - 인증 화면 (우선순위: 높음) - 완료!

### 6.1 상태 관리
- [x] `lib/presentation/providers/` 디렉토리 생성
  - [x] `auth_provider.dart` - 인증 상태 관리 (Riverpod 기반)
  - [x] `user_provider.dart` - 사용자 상태 관리

### 6.2 온보딩 화면
- [x] `lib/presentation/pages/onboarding/` 디렉토리 생성
  - [x] `onboarding_page.dart` - 온보딩 슬라이드 화면
  - [x] `onboarding_slide.dart` - 개별 슬라이드 컴포넌트 (통합)

### 6.3 로그인 화면
- [x] `lib/presentation/pages/auth/` 디렉토리 생성
  - [x] `phone_auth_page.dart` - 전화번호 입력 화면
  - [x] `otp_verification_page.dart` - 인증번호 확인 화면
  - [x] `auth_error_dialog.dart` - 인증 에러 다이얼로그

### 6.4 공통 위젯
- [x] `lib/presentation/widgets/` 디렉토리 생성 (shared 디렉토리 활용)
  - [x] `loading_indicator.dart` - 로딩 인디케이터 (AppTextField 활용)
  - [x] `error_message.dart` - 에러 메시지 표시 (SnackBar 활용)
  - [x] `phone_input_field.dart` - 전화번호 입력 필드 (AppTextField 활용)
  - [x] `otp_input_field.dart` - OTP 입력 필드 (TextFormField 활용)

### 6.5 앱 설정
- [x] `lib/main.dart` 업데이트 - Firebase 초기화, Provider, 라우터 설정
- [x] `lib/presentation/presentation.dart` - Presentation Layer export 파일
- [x] 라우터 업데이트 - OTP 인증 화면 경로 추가

---

## 👤 Phase 7: Presentation 레이어 - 프로필 설정 화면 (우선순위: 높음)

### 7.1 프로필 설정 화면
- [x] `lib/presentation/pages/profile/` 디렉토리 생성
  - [x] `nickname_setup_page.dart` - 닉네임 설정 화면
  - [x] `emotion_selection_page.dart` - 감정 키워드 선택 화면
  - [x] `time_preference_page.dart` - 대화 시간대 선택 화면
  - [x] `empathy_survey_page.dart` - 공감 성향 설문 화면

### 7.2 프로필 관련 위젯
- [x] `lib/presentation/widgets/profile/` 디렉토리 생성
  - [x] `nickname_input.dart` - 닉네임 입력 컴포넌트
  - [x] `emotion_chip_grid.dart` - 감정 키워드 그리드
  - [x] `time_preference_card.dart` - 시간대 선택 카드
  - [x] `survey_question.dart` - 설문 질문 컴포넌트

### 7.3 프로필 상태 관리
- [x] `lib/presentation/providers/profile/` 디렉토리 생성
  - [x] `profile_setup_provider.dart` - 프로필 설정 상태 관리
  - [x] `emotion_selection_provider.dart` - 감정 선택 상태 관리

---

## 🔧 Phase 8: 메인 앱 설정 (우선순위: 중간)

### 8.1 메인 앱 구조
- [x] `lib/main.dart` 업데이트
  - [x] Firebase 초기화
  - [x] Provider 설정
  - [x] 라우터 설정
  - [x] 테마 적용

### 8.2 앱 진입점 로직
- [x] `lib/presentation/pages/` 디렉토리 생성
  - [x] `splash_page.dart` - 스플래시 화면
  - [x] `home_page.dart` - 홈 화면 (기본 구조)

---

## 🔄 Phase 9: 매칭 시스템 구현 (우선순위: 높음)

### 9.1 매칭 관련 UseCase 구현
- [ ] `lib/domain/usecases/matching/` 디렉토리 확장
  - [ ] `get_today_matching.dart` - 오늘의 매칭 조회
  - [ ] `create_matching.dart` - 매칭 생성
  - [ ] `cancel_matching.dart` - 매칭 취소
  - [ ] `get_matching_history.dart` - 매칭 이력 조회

### 9.2 매칭 데이터 모델
- [ ] `lib/data/models/` 디렉토리 확장
  - [ ] `matching_model.dart` - 매칭 DTO 모델
  - [ ] `chat_room_model.dart` - 채팅방 DTO 모델

### 9.3 매칭 데이터소스
- [ ] `lib/data/datasources/` 디렉토리 확장
  - [ ] `firestore_matching_datasource.dart` - 매칭 Firestore 데이터소스
  - [ ] `firestore_chat_datasource.dart` - 채팅 Firestore 데이터소스

### 9.4 매칭 Repository 구현
- [ ] `lib/data/repositories/` 디렉토리 확장
  - [ ] `matching_repository_impl.dart` - 매칭 Repository 구현
  - [ ] `chat_repository_impl.dart` - 채팅 Repository 구현

### 9.5 매칭 상태 관리
- [ ] `lib/presentation/providers/` 디렉토리 확장
  - [ ] `matching_provider.dart` - 매칭 상태 관리
  - [ ] `chat_provider.dart` - 채팅 상태 관리

### 9.6 매칭 UI 구현
- [ ] `lib/presentation/pages/matching/` 디렉토리 생성
  - [ ] `matching_status_page.dart` - 매칭 상태 화면
  - [ ] `matching_result_page.dart` - 매칭 결과 화면

---

## 💬 Phase 10: 채팅 시스템 구현 (우선순위: 높음)

### 10.1 채팅 관련 UseCase 구현
- [ ] `lib/domain/usecases/chat/` 디렉토리 확장
  - [ ] `send_message.dart` - 메시지 전송
  - [ ] `get_messages.dart` - 메시지 조회
  - [ ] `get_chat_room.dart` - 채팅방 조회
  - [ ] `close_chat_room.dart` - 채팅방 종료

### 10.2 채팅 데이터 모델
- [ ] `lib/data/models/` 디렉토리 확장
  - [ ] `message_model.dart` - 메시지 DTO 모델

### 10.3 채팅 UI 구현
- [ ] `lib/presentation/pages/chat/` 디렉토리 생성
  - [ ] `chat_room_page.dart` - 채팅방 화면
  - [ ] `chat_list_page.dart` - 채팅 목록 화면

### 10.4 채팅 위젯
- [ ] `lib/presentation/widgets/chat/` 디렉토리 생성
  - [ ] `message_bubble.dart` - 메시지 말풍선
  - [ ] `chat_input.dart` - 채팅 입력창
  - [ ] `empathy_card_button.dart` - 공감 카드 버튼
  - [ ] `chat_timer.dart` - 채팅 타이머

### 10.5 실시간 채팅 기능
- [ ] Firestore 실시간 리스너 구현
- [ ] 메시지 전송/수신 로직
- [ ] 채팅방 자동 종료 (24시간)
- [ ] 공감 카드 기능

---

## 📊 Phase 11: 피드백 시스템 구현 (우선순위: 중간)

### 11.1 피드백 관련 UseCase 구현
- [ ] `lib/domain/usecases/feedback/` 디렉토리 확장
  - [ ] `submit_feedback.dart` - 피드백 제출
  - [ ] `get_feedback_history.dart` - 피드백 이력 조회

### 11.2 피드백 데이터 모델
- [ ] `lib/data/models/` 디렉토리 확장
  - [ ] `feedback_model.dart` - 피드백 DTO 모델

### 11.3 피드백 데이터소스
- [ ] `lib/data/datasources/` 디렉토리 확장
  - [ ] `firestore_feedback_datasource.dart` - 피드백 Firestore 데이터소스

### 11.4 피드백 Repository 구현
- [ ] `lib/data/repositories/` 디렉토리 확장
  - [ ] `feedback_repository_impl.dart` - 피드백 Repository 구현

### 11.5 피드백 UI 구현
- [ ] `lib/presentation/pages/feedback/` 디렉토리 생성
  - [ ] `feedback_page.dart` - 피드백 입력 화면
  - [ ] `feedback_history_page.dart` - 피드백 이력 화면

### 11.6 피드백 위젯
- [ ] `lib/presentation/widgets/feedback/` 디렉토리 생성
  - [ ] `emotion_feedback_card.dart` - 감정 피드백 카드
  - [ ] `feedback_summary.dart` - 피드백 요약

---

## 🤝 Phase 12: 연결 요청 시스템 구현 (우선순위: 중간)

### 12.1 연결 요청 관련 UseCase 구현
- [ ] `lib/domain/usecases/connection/` 디렉토리 확장
  - [ ] `send_connection_request.dart` - 연결 요청 전송
  - [ ] `accept_connection_request.dart` - 연결 요청 수락
  - [ ] `get_connection_requests.dart` - 연결 요청 조회

### 12.2 연결 요청 데이터 모델
- [ ] `lib/data/models/` 디렉토리 확장
  - [ ] `connection_request_model.dart` - 연결 요청 DTO 모델

### 12.3 연결 요청 데이터소스
- [ ] `lib/data/datasources/` 디렉토리 확장
  - [ ] `firestore_connection_datasource.dart` - 연결 요청 Firestore 데이터소스

### 12.4 연결 요청 Repository 구현
- [ ] `lib/data/repositories/` 디렉토리 확장
  - [ ] `connection_repository_impl.dart` - 연결 요청 Repository 구현

### 12.5 연결 요청 UI 구현
- [ ] `lib/presentation/pages/connection/` 디렉토리 생성
  - [ ] `connection_request_page.dart` - 연결 요청 화면
  - [ ] `connection_result_page.dart` - 연결 결과 화면

---

## 👥 Phase 13: 말벗 친구 시스템 구현 (우선순위: 중간)

### 13.1 말벗 친구 관련 UseCase 구현
- [ ] `lib/domain/usecases/friendship/` 디렉토리 확장
  - [ ] `get_friends_list.dart` - 친구 목록 조회
  - [ ] `remove_friend.dart` - 친구 삭제
  - [ ] `get_friend_profile.dart` - 친구 프로필 조회

### 13.2 말벗 친구 데이터 모델
- [ ] `lib/data/models/` 디렉토리 확장
  - [ ] `friendship_model.dart` - 친구 관계 DTO 모델

### 13.3 말벗 친구 데이터소스
- [ ] `lib/data/datasources/` 디렉토리 확장
  - [ ] `firestore_friendship_datasource.dart` - 친구 관계 Firestore 데이터소스

### 13.4 말벗 친구 Repository 구현
- [ ] `lib/data/repositories/` 디렉토리 확장
  - [ ] `friendship_repository_impl.dart` - 친구 관계 Repository 구현

### 13.5 말벗 친구 UI 구현
- [ ] `lib/presentation/pages/friends/` 디렉토리 생성
  - [ ] `friends_list_page.dart` - 친구 목록 화면
  - [ ] `friend_profile_page.dart` - 친구 프로필 화면

### 13.6 말벗 친구 위젯
- [ ] `lib/presentation/widgets/friends/` 디렉토리 생성
  - [ ] `friend_card.dart` - 친구 카드
  - [ ] `friend_chat_button.dart` - 친구와 채팅 버튼

---

## 🔔 Phase 14: 푸시 알림 시스템 구현 (우선순위: 중간)

### 14.1 Firebase Cloud Messaging 설정
- [ ] FCM 패키지 추가 (`firebase_messaging`)
- [ ] FCM 토큰 관리
- [ ] 백그라운드 메시지 처리
- [ ] 포그라운드 메시지 처리

### 14.2 알림 UseCase 구현
- [ ] `lib/domain/usecases/notification/` 디렉토리 생성
  - [ ] `get_notification_token.dart` - 알림 토큰 조회
  - [ ] `update_notification_token.dart` - 알림 토큰 업데이트
  - [ ] `handle_notification.dart` - 알림 처리

### 14.3 알림 데이터 모델
- [ ] `lib/data/models/` 디렉토리 확장
  - [ ] `notification_model.dart` - 알림 DTO 모델

### 14.4 알림 데이터소스
- [ ] `lib/data/datasources/` 디렉토리 확장
  - [ ] `firebase_messaging_datasource.dart` - FCM 데이터소스

### 14.5 알림 Repository 구현
- [ ] `lib/data/repositories/` 디렉토리 확장
  - [ ] `notification_repository_impl.dart` - 알림 Repository 구현

### 14.6 알림 UI 구현
- [ ] `lib/presentation/pages/notification/` 디렉토리 생성
  - [ ] `notification_settings_page.dart` - 알림 설정 화면
  - [ ] `notification_history_page.dart` - 알림 이력 화면

---

## ⚙️ Phase 15: Cloud Functions 구현 (우선순위: 높음)

### 15.1 매칭 Cloud Function
- [ ] `functions/` 디렉토리 생성
- [ ] `functions/src/matching/` 디렉토리 생성
  - [ ] `daily_matching.ts` - 일일 매칭 실행 함수
  - [ ] `matching_algorithm.ts` - 매칭 알고리즘
  - [ ] `matching_utils.ts` - 매칭 유틸리티

### 15.2 채팅 Cloud Function
- [ ] `functions/src/chat/` 디렉토리 생성
  - [ ] `close_expired_chats.ts` - 만료된 채팅방 종료
  - [ ] `send_notification.ts` - 채팅 알림 전송

### 15.3 피드백 Cloud Function
- [ ] `functions/src/feedback/` 디렉토리 생성
  - [ ] `process_feedback.ts` - 피드백 처리
  - [ ] `update_user_score.ts` - 사용자 신뢰도 업데이트

### 15.4 연결 요청 Cloud Function
- [ ] `functions/src/connection/` 디렉토리 생성
  - [ ] `process_connection_request.ts` - 연결 요청 처리
  - [ ] `create_friendship.ts` - 친구 관계 생성

### 15.5 Cloud Functions 배포
- [ ] Firebase CLI 설정
- [ ] TypeScript 설정
- [ ] 함수 배포 스크립트
- [ ] 환경 변수 설정

---

## 🎨 Phase 16: 홈 화면 및 네비게이션 완성 (우선순위: 높음)

### 16.1 홈 화면 완성
- [ ] `lib/presentation/pages/home/` 디렉토리 확장
  - [ ] `home_page.dart` - 홈 화면 완성
  - [ ] `matching_status_widget.dart` - 매칭 상태 위젯
  - [ ] `empathy_card_gallery.dart` - 공감 카드 갤러리
  - [ ] `emotion_diary_widget.dart` - 감정 일지 위젯

### 16.2 하단 네비게이션
- [ ] `lib/presentation/widgets/navigation/` 디렉토리 생성
  - [ ] `bottom_navigation_bar.dart` - 하단 네비게이션 바
  - [ ] `navigation_controller.dart` - 네비게이션 컨트롤러

### 16.3 탭별 화면 구현
- [ ] `lib/presentation/pages/` 디렉토리 확장
  - [ ] `friends_tab_page.dart` - 친구 탭 화면
  - [ ] `profile_tab_page.dart` - 프로필 탭 화면

---

## 🔒 Phase 17: 보안 및 안전 기능 구현 (우선순위: 높음)

### 17.1 신고 시스템
- [ ] `lib/domain/usecases/report/` 디렉토리 생성
  - [ ] `report_user.dart` - 사용자 신고
  - [ ] `get_report_history.dart` - 신고 이력 조회

### 17.2 차단 시스템
- [ ] `lib/domain/usecases/block/` 디렉토리 생성
  - [ ] `block_user.dart` - 사용자 차단
  - [ ] `unblock_user.dart` - 사용자 차단 해제
  - [ ] `get_blocked_users.dart` - 차단된 사용자 목록

### 17.3 신고/차단 UI
- [ ] `lib/presentation/pages/safety/` 디렉토리 생성
  - [ ] `report_page.dart` - 신고 화면
  - [ ] `block_list_page.dart` - 차단 목록 화면

### 17.4 안전 기능 위젯
- [ ] `lib/presentation/widgets/safety/` 디렉토리 생성
  - [ ] `report_dialog.dart` - 신고 다이얼로그
  - [ ] `block_dialog.dart` - 차단 다이얼로그

---

## 📱 Phase 18: 플랫폼별 설정 및 최적화 (우선순위: 중간)

### 18.1 Android 설정
- [ ] `android/app/build.gradle` 최적화
- [ ] 권한 설정 (인터넷, 전화 상태, 알림)
- [ ] Firebase 설정 확인
- [ ] 앱 아이콘 및 스플래시 화면

### 18.2 iOS 설정
- [ ] `ios/Runner/Info.plist` 최적화
- [ ] Firebase 설정 확인
- [ ] 권한 설정 (알림, 네트워크)
- [ ] 앱 아이콘 및 스플래시 화면

### 18.3 웹 설정
- [ ] `web/` 디렉토리 최적화
- [ ] PWA 설정
- [ ] Firebase Hosting 설정

---

## 🧪 Phase 19: 테스트 및 검증 (우선순위: 중간)

### 19.1 단위 테스트
- [ ] `test/` 디렉토리 구조 생성
  - [ ] `unit/usecases/` - UseCase 테스트
  - [ ] `unit/repositories/` - Repository 테스트
  - [ ] `unit/providers/` - Provider 테스트

### 19.2 위젯 테스트
- [ ] `test/widget/` 디렉토리 생성
  - [ ] 인증 화면 위젯 테스트
  - [ ] 프로필 설정 화면 위젯 테스트
  - [ ] 채팅 화면 위젯 테스트
  - [ ] 매칭 화면 위젯 테스트

### 19.3 통합 테스트
- [ ] `integration_test/` 디렉토리 생성
  - [ ] 전체 인증 플로우 테스트
  - [ ] 프로필 설정 플로우 테스트
  - [ ] 매칭 및 채팅 플로우 테스트
  - [ ] 피드백 및 연결 요청 플로우 테스트

### 19.4 성능 테스트
- [ ] 메모리 사용량 테스트
- [ ] 네트워크 성능 테스트
- [ ] 배터리 사용량 테스트

---

## 🚀 Phase 20: 배포 준비 및 최적화 (우선순위: 낮음)

### 20.1 빌드 설정
- [ ] Release 빌드 설정
- [ ] ProGuard 설정 (Android)
- [ ] 코드 서명 설정
- [ ] 앱 번들 최적화

### 20.2 성능 최적화
- [ ] 이미지 최적화
- [ ] 코드 분할
- [ ] 메모리 사용량 최적화
- [ ] 네트워크 요청 최적화

### 20.3 앱 스토어 준비
- [ ] 앱 스토어 메타데이터 준비
- [ ] 스크린샷 및 비디오 제작
- [ ] 앱 설명 및 키워드 최적화
- [ ] 개인정보처리방침 및 이용약관

---

## 📊 Phase 21: 모니터링 및 분석 시스템 (우선순위: 낮음)

### 21.1 Firebase Analytics 설정
- [ ] Firebase Analytics 패키지 추가
- [ ] 사용자 이벤트 추적
- [ ] 화면 전환 추적
- [ ] 사용자 행동 분석

### 21.2 Firebase Crashlytics 설정
- [ ] Firebase Crashlytics 패키지 추가
- [ ] 크래시 리포트 수집
- [ ] 에러 모니터링

### 21.3 사용자 피드백 시스템
- [ ] 인앱 피드백 기능
- [ ] 앱 스토어 리뷰 연동
- [ ] 사용자 만족도 조사

---

## 📝 구현 체크리스트

### 완료 조건
- [ ] 사용자가 전화번호로 로그인 가능
- [ ] 인증번호 확인 후 프로필 설정 화면으로 이동
- [ ] 닉네임, 감정 키워드, 시간대 설정 완료
- [ ] Firestore에 사용자 프로필 저장
- [ ] 홈 화면으로 정상 이동
- [ ] 매칭 시스템 정상 작동
- [ ] 24시간 제한 채팅 기능 구현
- [ ] 피드백 시스템 구현
- [ ] 연결 요청 및 말벗 친구 기능 구현
- [ ] 푸시 알림 시스템 구현
- [ ] 신고 및 차단 기능 구현
- [ ] 디자인 시스템이 일관되게 적용됨
- [ ] 에러 처리 및 로딩 상태 표시
- [ ] 기본 테스트 통과
- [ ] Cloud Functions 배포 완료

### 품질 기준
- [ ] Clean Architecture 원칙 준수
- [ ] 한담 디자인 시스템 적용
- [ ] 반응형 UI 구현
- [ ] 접근성 고려
- [ ] 성능 최적화
- [ ] 코드 가독성 및 유지보수성
- [ ] 보안 및 안전성 확보
- [ ] 사용자 경험 최적화

---

## 📅 예상 일정

- **Phase 1-8**: 11-15일 (기반 설정 및 기본 UI)
- **Phase 9-14**: 20-25일 (핵심 기능 구현)
- **Phase 15-17**: 10-15일 (백엔드 및 보안)
- **Phase 18-21**: 10-15일 (최적화 및 배포)

**총 예상 기간**: 51-70일

---

## 🔗 관련 문서

- [디자인 시스템 가이드](./design-system.md)
- [PRD 문서](./product-requirements-document.md)
- [프로젝트 아키텍처](./project-architecture.md)
- [와이어프레임](./wire-frame.md) 