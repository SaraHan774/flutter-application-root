# Data

데이터 레이어를 포함하는 폴더입니다. 외부 데이터 소스와의 상호작용을 담당합니다.

## 구조
- `datasources/` - 데이터 소스들 (API, 로컬 데이터베이스 등)
- `models/` - 데이터 모델들
- `repositories/` - 리포지토리 구현체들
- `providers/` - 상태 관리 프로바이더들

## 예시
- `datasources/` - API 클라이언트, 로컬 스토리지 등
- `models/` - JSON 직렬화/역직렬화를 위한 데이터 모델들
- `repositories/` - 도메인 레이어의 리포지토리 인터페이스 구현체들 