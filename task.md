# 한담(HanDamn) 앱 - 사용자 인증 및 프로필 화면 구현 태스크

## 📋 프로젝트 개요
- **목표**: 사용자 인증 및 프로필 설정 화면 구현
- **기술 스택**: Flutter + Firebase Auth + Firestore
- **아키텍처**: Clean Architecture 기반
- **디자인 시스템**: 한담 커스텀 디자인 시스템 적용

---

## 🎯 Phase 1: 프로젝트 기반 설정 (우선순위: 최고) - ✅ 완료

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

## 🎨 Phase 2: 디자인 시스템 구축 (우선순위: 높음) - ✅ 완료!

---

## 🏗️ Phase 3: Core 레이어 구축 (우선순위: 높음) - ✅ 완료!

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

## 📊 Phase 4: Domain 레이어 구축 (우선순위: 높음) - ✅ 완료!

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

## 💾 Phase 5: Data 레이어 구축 (우선순위: 높음) - ✅ 완료!

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

## 🎭 Phase 6: Presentation 레이어 - 인증 화면 (우선순위: 높음) - ✅ 완료!

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
- [x] `lib/domain/usecases/matching/` 디렉토리 확장
  - [x] `get_today_matching.dart` - 오늘의 매칭 조회
  - [x] `create_matching.dart` - 매칭 생성
  - [x] `cancel_matching.dart` - 매칭 취소
  - [x] `get_matching_history.dart` - 매칭 이력 조회

### 9.2 매칭 데이터 모델
- [x] `lib/data/models/` 디렉토리 확장
  - [x] `matching_model.dart` - 매칭 DTO 모델
  - [x] `chat_room_model.dart` - 채팅방 DTO 모델
  - [x] `message_model.dart` - 메시지 DTO 모델

### 9.3 매칭 데이터소스
- [x] `lib/data/datasources/` 디렉토리 확장
  - [x] `firestore_matching_datasource.dart` - 매칭 Firestore 데이터소스
  - [x] `firestore_chat_datasource.dart` - 채팅 Firestore 데이터소스

### 9.4 매칭 Repository 구현
- [x] `lib/data/repositories/` 디렉토리 확장
  - [x] `matching_repository_impl.dart` - 매칭 Repository 구현
  - [x] `chat_repository_impl.dart` - 채팅 Repository 구현

### 9.5 매칭 상태 관리
- [x] `lib/presentation/providers/` 디렉토리 확장
  - [x] `matching_provider.dart` - 매칭 상태 관리 Provider
  - [x] `chat_provider.dart` - 채팅 상태 관리 Provider

### 9.6 매칭 UI 화면
- [x] `lib/presentation/pages/matching/` 디렉토리 확장
  - [x] `matching_status_page.dart` - 매칭 상태 화면
  - [x] `matching_result_page.dart` - 매칭 결과 화면

### 9.7 공통 위젯
- [x] `lib/shared/design_system/components/` 디렉토리 확장
  - [x] `app_button.dart` - 통합 버튼 위젯 (Primary, Secondary, Text 지원)
  - [x] `loading_indicator.dart` - 로딩 인디케이터 위젯

### 9.8 채팅 관련 UseCase
- [x] `lib/domain/usecases/chat/` 디렉토리 확장
  - [x] `send_message.dart` - 메시지 전송
  - [x] `get_messages.dart` - 메시지 목록 조회
  - [x] `get_chat_room.dart` - 채팅방 정보 조회
  - [x] `close_chat_room.dart` - 채팅방 종료

---

## 🔄 Phase 10: 채팅 시스템 구현 (우선순위: 높음) - 🔄 진행 중

### 10.1 채팅 화면 구현
- [x] `lib/presentation/pages/chat/` 디렉토리 생성
  - [x] `chat_room_page.dart` - 채팅방 화면
  - [x] `chat_message_bubble.dart` - 메시지 말풍선 위젯
  - [x] `chat_input_field.dart` - 채팅 입력 필드 위젯
  - [x] `chat_timer.dart` - 채팅 타이머 위젯

### 10.2 실시간 채팅 기능
- [ ] Firestore 실시간 리스너 구현
- [ ] 메시지 송수신 실시간 처리
- [ ] 채팅방 상태 실시간 업데이트

### 10.3 채팅 UI 컴포넌트
- [x] 메시지 타입별 UI (텍스트, 시스템 메시지)
- [x] 시간 표시 및 읽음 상태
- [x] 스크롤 자동 이동 기능

### 10.4 채팅 제한 기능
- [x] 24시간 타이머 구현
- [ ] 채팅방 자동 종료 처리
- [x] 만료 시간 표시

---

## 🔄 Phase 11: 피드백 시스템 구현 (우선순위: 중간)

### 11.1 피드백 UseCase
- [ ] `lib/domain/usecases/feedback/` 디렉토리 생성
  - [ ] `submit_feedback.dart` - 피드백 제출
  - [ ] `get_feedback_history.dart` - 피드백 이력 조회

### 11.2 피드백 데이터 모델
- [ ] `lib/data/models/feedback_model.dart` - 피드백 DTO 모델

### 11.3 피드백 Repository
- [ ] `lib/data/repositories/feedback_repository_impl.dart` - 피드백 Repository 구현

### 11.4 피드백 UI
- [ ] `lib/presentation/pages/feedback/` 디렉토리 생성
  - [ ] `feedback_page.dart` - 피드백 입력 화면
  - [ ] `emotion_selection_widget.dart` - 감정 선택 위젯

---

## 🔄 Phase 12: 연결 요청 시스템 구현 (우선순위: 중간)

### 12.1 연결 요청 UseCase
- [ ] `lib/domain/usecases/connection/` 디렉토리 생성
  - [ ] `send_connection_request.dart` - 연결 요청 전송
  - [ ] `accept_connection_request.dart` - 연결 요청 수락
  - [ ] `get_connection_requests.dart` - 연결 요청 목록 조회

### 12.2 연결 요청 데이터 모델
- [ ] `lib/data/models/connection_request_model.dart` - 연결 요청 DTO 모델

### 12.3 연결 요청 Repository
- [ ] `lib/data/repositories/connection_repository_impl.dart` - 연결 요청 Repository 구현

### 12.4 연결 요청 UI
- [ ] `lib/presentation/pages/connection/` 디렉토리 생성
  - [ ] `connection_request_page.dart` - 연결 요청 화면
  - [ ] `connection_status_page.dart` - 연결 상태 화면

---

## 🔄 Phase 13: 말벗 친구 시스템 구현 (우선순위: 낮음)

### 13.1 말벗 친구 UseCase
- [ ] `lib/domain/usecases/friendship/` 디렉토리 생성
  - [ ] `get_friendship_list.dart` - 말벗 친구 목록 조회
  - [ ] `remove_friendship.dart` - 말벗 친구 삭제

### 13.2 말벗 친구 데이터 모델
- [ ] `lib/data/models/friendship_model.dart` - 말벗 친구 DTO 모델

### 13.3 말벗 친구 Repository
- [ ] `lib/data/repositories/friendship_repository_impl.dart` - 말벗 친구 Repository 구현

### 13.4 말벗 친구 UI
- [ ] `lib/presentation/pages/friendship/` 디렉토리 생성
  - [ ] `friendship_list_page.dart` - 말벗 친구 목록 화면
  - [ ] `friendship_chat_page.dart` - 말벗 친구 채팅 화면

---

## 🔄 Phase 14: 푸시 알림 시스템 구현 (우선순위: 높음)

### 14.1 Firebase Cloud Messaging 설정
- [ ] FCM 토큰 관리
- [ ] 푸시 알림 권한 요청
- [ ] 백그라운드 메시지 처리

### 14.2 알림 UseCase
- [ ] `lib/domain/usecases/notification/` 디렉토리 생성
  - [ ] `send_notification.dart` - 알림 전송
  - [ ] `get_notification_history.dart` - 알림 이력 조회

### 14.3 알림 데이터 모델
- [ ] `lib/data/models/notification_model.dart` - 알림 DTO 모델

### 14.4 알림 Repository
- [ ] `lib/data/repositories/notification_repository_impl.dart` - 알림 Repository 구현

### 14.5 알림 UI
- [ ] `lib/presentation/pages/notification/` 디렉토리 생성
  - [ ] `notification_list_page.dart` - 알림 목록 화면
  - [ ] `notification_settings_page.dart` - 알림 설정 화면

---

## 🔄 Phase 15: 자동 매칭 시스템 구현 (우선순위: 높음)

### 15.1 Firebase Cloud Functions
- [ ] 매칭 알고리즘 구현
- [ ] 매일 오전 9시 자동 매칭 트리거
- [ ] 매칭 조건 필터링 (감정 키워드, 시간대 등)

### 15.2 매칭 품질 관리
- [ ] 신고 처리 시스템
- [ ] 부적절한 사용자 필터링
- [ ] 매칭 성공률 분석

### 15.3 매칭 통계
- [ ] 매칭 통계 데이터 모델
- [ ] 매칭 성공률 추적
- [ ] 사용자 만족도 분석

---

## 🔄 Phase 16: 테스트 및 최적화 (우선순위: 중간)

### 16.1 단위 테스트
- [ ] UseCase 테스트
- [ ] Repository 테스트
- [ ] Provider 테스트

### 16.2 위젯 테스트
- [ ] UI 컴포넌트 테스트
- [ ] 사용자 인터랙션 테스트

### 16.3 통합 테스트
- [ ] 전체 플로우 테스트
- [ ] Firebase 연동 테스트

### 16.4 성능 최적화
- [ ] 이미지 최적화
- [ ] 메모리 사용량 최적화
- [ ] 네트워크 요청 최적화

---

## 🔄 Phase 17: 배포 준비 (우선순위: 낮음)

### 17.1 앱 아이콘 및 스플래시
- [ ] 앱 아이콘 디자인 및 적용
- [ ] 스플래시 화면 디자인 및 적용

### 17.2 앱 스토어 준비
- [ ] 앱 설명 및 스크린샷
- [ ] 개인정보처리방침
- [ ] 이용약관

### 17.3 최종 테스트
- [ ] 실제 기기 테스트
- [ ] 다양한 화면 크기 테스트
- [ ] 성능 테스트

---

## 🔧 Phase 18: 디자인 시스템 리팩토링 (우선순위: 높음) - ✅ 완료!

### 18.1 컴포넌트 통합
- [x] `shared/widgets/` 폴더 제거
- [x] `design_system/components/` 폴더로 통합
- [x] `app_button.dart` - 통합 버튼 컴포넌트 (Primary, Secondary, Text 지원)
- [x] `loading_indicator.dart` - 로딩 인디케이터 컴포넌트

### 18.2 중복 제거
- [x] 기존 `primary_button.dart`, `secondary_button.dart` 삭제
- [x] `shared/widgets/app_button.dart`, `shared/widgets/loading_indicator.dart` 삭제
- [x] `shared/widgets/` 폴더 삭제

### 18.3 호환성 유지
- [x] 기존 컴포넌트와의 호환성을 위한 별칭 클래스 추가
- [x] Deprecated 어노테이션으로 마이그레이션 안내

### 18.4 Import 경로 업데이트
- [x] 모든 파일의 import 경로를 새로운 구조로 업데이트
- [x] `shared.dart` export 파일 업데이트

---

## 📋 다음 진행할 태스크

**Phase 10의 실시간 채팅 기능**을 완성하겠습니다.

### 우선순위:
1. **Firestore 실시간 리스너 구현** - 메시지 실시간 송수신
2. **채팅방 자동 종료 처리** - 24시간 후 자동 종료
3. **채팅 상태 실시간 업데이트** - 상대방 상태 표시

### 구현 순서:
1. Firestore 실시간 리스너 설정
2. 메시지 실시간 송수신 로직 구현
3. 채팅방 자동 종료 Cloud Function 연동
4. 상대방 타이핑 상태 표시
5. 채팅방 상태 실시간 업데이트

### 현재 상태:
- ✅ 디자인 시스템 리팩토링 완료
- ✅ 컴포넌트 중복 제거 완료
- ⚠️ 일부 컴파일 에러 존재 (버튼 API 변경으로 인한 호환성 문제)
- 🔄 다음 단계: 컴파일 에러 수정 후 실시간 채팅 기능 구현 