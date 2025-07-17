# Features

앱의 각 기능별 모듈들을 포함하는 폴더입니다.

## 구조
각 기능은 독립적인 모듈로 구성되며, 다음과 같은 구조를 가집니다:

```
feature_name/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── pages/
    ├── widgets/
    └── controllers/
```

## 예시
- `auth/` - 인증 관련 기능
- `home/` - 홈 화면 관련 기능
- `profile/` - 프로필 관련 기능
- `settings/` - 설정 관련 기능 