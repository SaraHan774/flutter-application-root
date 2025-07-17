# 한담 (HanDamn) - 감정 기반 랜덤 채팅 앱

## 📱 프로젝트 개요

한담은 하루 한 사람과 24시간 동안 진심 어린 대화를 나눌 수 있는 감정 기반 랜덤 채팅 앱입니다.

## 🚀 시작하기

### 필수 요구사항

- Flutter 3.32.7 이상
- Dart 3.0.0 이상
- Firebase 프로젝트

### 설치 및 설정

1. **저장소 클론**
   ```bash
   git clone https://github.com/your-username/handam.git
   cd handam
   ```

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **환경 변수 설정**
   
   `env.example` 파일을 참고하여 `.env` 파일을 생성하고 Firebase 설정값을 입력하세요:
   
   ```bash
   cp env.example .env
   ```
   
   `.env` 파일에 다음 값들을 설정하세요:
   ```
   FIREBASE_API_KEY=your_firebase_api_key_here
   FIREBASE_APP_ID=your_firebase_app_id_here
   FIREBASE_MESSAGING_SENDER_ID=your_firebase_messaging_sender_id_here
   FIREBASE_PROJECT_ID=your_firebase_project_id_here
   FIREBASE_AUTH_DOMAIN=your_firebase_auth_domain_here
   FIREBASE_STORAGE_BUCKET=your_firebase_storage_bucket_here
   FIREBASE_IOS_CLIENT_ID=your_firebase_ios_client_id_here
   FIREBASE_IOS_BUNDLE_ID=your_firebase_ios_bundle_id_here
   ```

4. **Firebase 설정 파일 추가**
   
   Firebase 콘솔에서 다운로드한 설정 파일들을 다음 위치에 추가하세요:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
   - macOS: `macos/Runner/GoogleService-Info.plist`

5. **앱 실행**
   ```bash
   flutter run
   ```

## 🏗️ 아키텍처

이 프로젝트는 Clean Architecture 패턴을 따릅니다:

```
lib/
├── core/           # 핵심 기능 (에러 처리, 라우팅, DI 등)
├── data/           # 데이터 레이어 (Repository 구현, DataSource)
├── domain/         # 도메인 레이어 (Entity, Repository 인터페이스, UseCase)
├── presentation/   # 프레젠테이션 레이어 (UI, Provider)
├── shared/         # 공유 컴포넌트 (디자인 시스템)
└── features/       # 기능별 모듈
```

## 🔧 개발 환경

### 코드 생성

Riverpod 코드 생성을 위해 다음 명령어를 실행하세요:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 테스트

```bash
# 단위 테스트
flutter test

# 통합 테스트
flutter test integration_test/
```

## 📱 주요 기능

- [x] 전화번호 인증
- [x] 온보딩 화면
- [x] 프로필 설정
- [ ] 감정 기반 매칭
- [ ] 24시간 채팅
- [ ] 친구 관리
- [ ] 피드백 시스템

## 🔒 보안

- API 키와 민감한 정보는 환경 변수로 관리
- `.env` 파일은 `.gitignore`에 포함되어 Git에 커밋되지 않음
- Firebase 보안 규칙 적용

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 문의

프로젝트에 대한 문의사항이 있으시면 이슈를 생성해 주세요.
