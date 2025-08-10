/// Core 레이어의 모든 클래스들을 export하는 파일
/// 다른 레이어에서 core 기능을 사용할 때 이 파일만 import하면 됨

// 에러 처리
export 'error/failure.dart';
export 'error/error_handler.dart';

// 라우팅
export 'router/app_router.dart';

// 의존성 주입
export 'di/service_locator.dart';

// 유틸리티
export 'utils/constants.dart';
export 'utils/validators.dart';
export 'utils/logger.dart';
export 'utils/nickname_generator.dart'; 