# Domain

비즈니스 로직 레이어를 포함하는 폴더입니다. 앱의 핵심 비즈니스 규칙을 정의합니다.

## 구조
- `entities/` - 비즈니스 엔티티들
- `repositories/` - 리포지토리 인터페이스들
- `usecases/` - 유스케이스들 (비즈니스 로직)
- `value_objects/` - 값 객체들

## 예시
- `entities/` - User, Product, Order 등 비즈니스 엔티티
- `repositories/` - UserRepository, ProductRepository 등 인터페이스
- `usecases/` - GetUserProfile, CreateOrder 등 비즈니스 로직
- `value_objects/` - Email, Password, Money 등 값 객체들 