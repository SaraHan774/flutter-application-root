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

## 🏗️ Phase 3: Core 레이어 구축 (우선순위: 높음) - 진행 중

---

## 🎨 Phase 2: 디자인 시스템 구축 (우선순위: 높음)

### 2.1 색상 시스템
- [x] `lib/shared/design_system/colors.dart` 생성
  - [x] Light Theme ColorScheme 정의
  - [x] Dark Theme ColorScheme 정의
  - [x] 한담 브랜드 컬러 토큰화

### 2.2 타이포그래피 시스템
- [x] `lib/shared/design_system/typography.dart` 생성
  - [x] Pretendard 폰트 설정
  - [x] TextTheme 정의 (Headline1~4, Body1~3, Button, Caption)
  - [x] 폰트 크기 및 높이 비율 설정

### 2.3 컴포넌트 시스템
- [x] `lib/shared/design_system/components/` 디렉토리 생성
  - [x] `primary_button.dart` - Primary Button 컴포넌트
  - [x] `secondary_button.dart` - Secondary Button 컴포넌트
  - [x] `text_field.dart` - TextField 컴포넌트
  - [x] `emotion_chip.dart` - 감정 키워드 Chip 컴포넌트

### 2.4 테마 설정
- [x] `lib/shared/design_system/app_theme.dart` 생성
  - [x] Material 3 기반 테마 설정
  - [x] Light/Dark 테마 전환 로직
  - [x] 커스텀 컴포넌트 테마 적용

---

## 🏗️ Phase 3: Core 레이어 구축 (우선순위: 높음)

### 3.1 에러 처리
- [ ] `lib/core/failures/` 디렉토리 생성
  - [ ] `auth_failure.dart` - 인증 관련 에러 정의
  - [ ] `network_failure.dart` - 네트워크 에러 정의
  - [ ] `server_failure.dart` - 서버 에러 정의

### 3.2 라우팅 설정
- [ ] `lib/core/router/` 디렉토리 생성
  - [ ] `app_router.dart` - GoRouter 설정
  - [ ] 라우트 정의 (온보딩, 로그인, 프로필설정, 홈)

### 3.3 의존성 주입
- [ ] `lib/core/di/` 디렉토리 생성
  - [ ] `service_locator.dart` - GetIt 설정
  - [ ] Firebase 서비스 등록
  - [ ] Repository 등록

---

## 📊 Phase 4: Domain 레이어 구축 (우선순위: 높음)

### 4.1 엔티티 정의
- [ ] `lib/domain/entities/` 디렉토리 생성
  - [ ] `user.dart` - User 엔티티
  - [ ] `auth_result.dart` - 인증 결과 엔티티
  - [ ] `emotion_tag.dart` - 감정 태그 엔티티

### 4.2 Repository 인터페이스
- [ ] `lib/domain/repositories/` 디렉토리 생성
  - [ ] `auth_repository.dart` - 인증 Repository 인터페이스
  - [ ] `user_repository.dart` - 사용자 Repository 인터페이스

### 4.3 UseCase 정의
- [ ] `lib/domain/usecases/` 디렉토리 생성
  - [ ] `sign_in_with_phone.dart` - 전화번호 로그인 UseCase
  - [ ] `verify_phone_code.dart` - 인증번호 확인 UseCase
  - [ ] `create_user_profile.dart` - 프로필 생성 UseCase
  - [ ] `update_user_profile.dart` - 프로필 업데이트 UseCase

---

## 💾 Phase 5: Data 레이어 구축 (우선순위: 높음)

### 5.1 데이터 모델
- [ ] `lib/data/models/` 디렉토리 생성
  - [ ] `user_model.dart` - User DTO 모델
  - [ ] `auth_model.dart` - 인증 관련 모델

### 5.2 데이터 소스
- [ ] `lib/data/datasources/` 디렉토리 생성
  - [ ] `firebase_auth_datasource.dart` - Firebase Auth 데이터소스
  - [ ] `firestore_user_datasource.dart` - Firestore 사용자 데이터소스

### 5.3 Repository 구현
- [ ] `lib/data/repositories/` 디렉토리 생성
  - [ ] `auth_repository_impl.dart` - 인증 Repository 구현
  - [ ] `user_repository_impl.dart` - 사용자 Repository 구현

---

## 🎭 Phase 6: Presentation 레이어 - 인증 화면 (우선순위: 높음)

### 6.1 상태 관리
- [ ] `lib/presentation/providers/` 디렉토리 생성
  - [ ] `auth_provider.dart` - 인증 상태 관리
  - [ ] `user_provider.dart` - 사용자 상태 관리

### 6.2 온보딩 화면
- [ ] `lib/presentation/pages/onboarding/` 디렉토리 생성
  - [ ] `onboarding_page.dart` - 온보딩 슬라이드 화면
  - [ ] `onboarding_slide.dart` - 개별 슬라이드 컴포넌트

### 6.3 로그인 화면
- [ ] `lib/presentation/pages/auth/` 디렉토리 생성
  - [ ] `phone_auth_page.dart` - 전화번호 입력 화면
  - [ ] `otp_verification_page.dart` - 인증번호 확인 화면
  - [ ] `auth_error_dialog.dart` - 인증 에러 다이얼로그

### 6.4 공통 위젯
- [ ] `lib/presentation/widgets/` 디렉토리 생성
  - [ ] `loading_indicator.dart` - 로딩 인디케이터
  - [ ] `error_message.dart` - 에러 메시지 표시
  - [ ] `phone_input_field.dart` - 전화번호 입력 필드
  - [ ] `otp_input_field.dart` - OTP 입력 필드

---

## 👤 Phase 7: Presentation 레이어 - 프로필 설정 화면 (우선순위: 높음)

### 7.1 프로필 설정 화면
- [ ] `lib/presentation/pages/profile/` 디렉토리 생성
  - [ ] `nickname_setup_page.dart` - 닉네임 설정 화면
  - [ ] `emotion_selection_page.dart` - 감정 키워드 선택 화면
  - [ ] `time_preference_page.dart` - 대화 시간대 선택 화면
  - [ ] `empathy_survey_page.dart` - 공감 성향 설문 화면

### 7.2 프로필 관련 위젯
- [ ] `lib/presentation/widgets/profile/` 디렉토리 생성
  - [ ] `nickname_input.dart` - 닉네임 입력 컴포넌트
  - [ ] `emotion_chip_grid.dart` - 감정 키워드 그리드
  - [ ] `time_preference_card.dart` - 시간대 선택 카드
  - [ ] `survey_question.dart` - 설문 질문 컴포넌트

### 7.3 프로필 상태 관리
- [ ] `lib/presentation/providers/profile/` 디렉토리 생성
  - [ ] `profile_setup_provider.dart` - 프로필 설정 상태 관리
  - [ ] `emotion_selection_provider.dart` - 감정 선택 상태 관리

---

## 🔧 Phase 8: 메인 앱 설정 (우선순위: 중간)

### 8.1 메인 앱 구조
- [ ] `lib/main.dart` 업데이트
  - [ ] Firebase 초기화
  - [ ] Provider 설정
  - [ ] 라우터 설정
  - [ ] 테마 적용

### 8.2 앱 진입점 로직
- [ ] `lib/presentation/pages/` 디렉토리 생성
  - [ ] `splash_page.dart` - 스플래시 화면
  - [ ] `home_page.dart` - 홈 화면 (기본 구조)

---

## 🧪 Phase 9: 테스트 및 검증 (우선순위: 중간)

### 9.1 단위 테스트
- [ ] `test/` 디렉토리 구조 생성
  - [ ] `unit/usecases/` - UseCase 테스트
  - [ ] `unit/repositories/` - Repository 테스트
  - [ ] `unit/providers/` - Provider 테스트

### 9.2 위젯 테스트
- [ ] `test/widget/` 디렉토리 생성
  - [ ] 인증 화면 위젯 테스트
  - [ ] 프로필 설정 화면 위젯 테스트

### 9.3 통합 테스트
- [ ] `integration_test/` 디렉토리 생성
  - [ ] 전체 인증 플로우 테스트
  - [ ] 프로필 설정 플로우 테스트

---

## 📱 Phase 10: 플랫폼별 설정 (우선순위: 낮음)

### 10.1 Android 설정
- [ ] `android/app/build.gradle` 업데이트
- [ ] 권한 설정 (인터넷, 전화 상태)
- [ ] Firebase 설정 확인

### 10.2 iOS 설정
- [ ] `ios/Runner/Info.plist` 업데이트
- [ ] Firebase 설정 확인
- [ ] 권한 설정

---

## 🚀 Phase 11: 배포 준비 (우선순위: 낮음)

### 11.1 빌드 설정
- [ ] Release 빌드 설정
- [ ] ProGuard 설정 (Android)
- [ ] 코드 서명 설정

### 11.2 성능 최적화
- [ ] 이미지 최적화
- [ ] 코드 분할
- [ ] 메모리 사용량 최적화

---

## 📝 구현 체크리스트

### 완료 조건
- [ ] 사용자가 전화번호로 로그인 가능
- [ ] 인증번호 확인 후 프로필 설정 화면으로 이동
- [ ] 닉네임, 감정 키워드, 시간대 설정 완료
- [ ] Firestore에 사용자 프로필 저장
- [ ] 홈 화면으로 정상 이동
- [ ] 디자인 시스템이 일관되게 적용됨
- [ ] 에러 처리 및 로딩 상태 표시
- [ ] 기본 테스트 통과

### 품질 기준
- [ ] Clean Architecture 원칙 준수
- [ ] 한담 디자인 시스템 적용
- [ ] 반응형 UI 구현
- [ ] 접근성 고려
- [ ] 성능 최적화
- [ ] 코드 가독성 및 유지보수성

---

## 📅 예상 일정

- **Phase 1-3**: 3-4일 (기반 설정)
- **Phase 4-5**: 2-3일 (데이터 레이어)
- **Phase 6-7**: 4-5일 (UI 구현)
- **Phase 8-11**: 2-3일 (통합 및 배포)

**총 예상 기간**: 11-15일

---

## 🔗 관련 문서

- [디자인 시스템 가이드](./design-system.md)
- [PRD 문서](./product-requirements-document.md)
- [프로젝트 아키텍처](./project-architecture.md)
- [와이어프레임](./wire-frame.md) 