/// 앱 전체에서 사용하는 상수들

/// 앱 기본 정보
class AppConstants {
  static const String appName = '한담';
  static const String appVersion = '1.0.0';
  static const String appDescription = '하루 한 사람과 진심 어린 대화를 나누는 공간';
}

/// Firebase 관련 상수
class FirebaseConstants {
  // Firestore 컬렉션 이름
  static const String usersCollection = 'users';
  static const String matchingsCollection = 'matchings';
  static const String chatRoomsCollection = 'chatRooms';
  static const String messagesCollection = 'messages';
  static const String feedbacksCollection = 'feedbacks';
  static const String connectionRequestsCollection = 'connectionRequests';
  static const String friendshipsCollection = 'friendships';
  
  // 문서 필드 이름
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const String userIdField = 'userId';
  static const String nicknameField = 'nickname';
  static const String emotionTagsField = 'emotionTags';
  static const String preferredTimeField = 'preferredTime';
}

/// 채팅 관련 상수
class ChatConstants {
  static const int maxMessageLength = 500; // 최대 메시지 길이
  static const int chatDurationHours = 24; // 채팅방 유지 시간 (시간)
  static const int messageRetentionHours = 48; // 메시지 보존 시간 (시간)
  static const int maxEmotionCardsPerChat = 3; // 채팅당 최대 공감 카드 사용 횟수
}

/// 매칭 관련 상수
class MatchingConstants {
  static const String defaultMatchingTime = '09:00'; // 기본 매칭 시간
  static const int maxRecentMatchingDays = 7; // 최근 매칭 이력 확인 기간 (일)
  static const int minEmotionTagsRequired = 3; // 최소 감정 태그 개수
  static const int maxEmotionTagsAllowed = 5; // 최대 감정 태그 개수
}

/// 프로필 관련 상수
class ProfileConstants {
  static const int minNicknameLength = 2; // 최소 닉네임 길이
  static const int maxNicknameLength = 12; // 최대 닉네임 길이
  static const int maxProfileChangesPerDay = 1; // 하루 최대 프로필 변경 횟수
}

/// 시간대 관련 상수
class TimeConstants {
  static const String morningTime = 'morning'; // 오전 (9-11시)
  static const String afternoonTime = 'afternoon'; // 오후 (12-17시)
  static const String eveningTime = 'evening'; // 저녁 (18-22시)
  
  static const Map<String, String> timeDisplayNames = {
    morningTime: '오전 (9-11시)',
    afternoonTime: '오후 (12-17시)',
    eveningTime: '저녁 (18-22시)',
  };
}

/// 감정 태그 관련 상수
class EmotionConstants {
  static const List<String> availableEmotionTags = [
    '고요함',
    '공허함',
    '위로가필요해',
    '웃고싶어',
    '피곤해',
    '무기력함',
    '대화가필요해',
    '따뜻함',
    '설렘',
    '감사함',
    '희망',
    '안정감',
  ];
  
  static const List<String> feedbackEmotions = [
    '위로받은 느낌이에요',
    '좋았어요',
    '편안했어요',
    '어색했어요',
    '불쾌했어요',
  ];
}

/// 공감 카드 관련 상수
class EmpathyCardConstants {
  static const List<String> empathyQuestions = [
    '요즘 나를 웃게 한 순간은?',
    '혼자일 때 좋아하는 루틴은?',
    '오늘 하루 중 가장 기억에 남는 순간은?',
    '요즘 가장 듣고 싶은 말은?',
    '나만의 스트레스 해소법은?',
    '요즘 가장 관심 있는 것은?',
    '오늘 하루를 한 단어로 표현한다면?',
    '요즘 가장 감사한 일은?',
    '나만의 작은 행복은?',
    '요즘 가장 궁금한 것은?',
  ];
}

/// 에러 메시지 상수
class ErrorMessages {
  static const String networkError = '네트워크 연결을 확인해주세요.';
  static const String unknownError = '예상치 못한 오류가 발생했습니다.';
  static const String authRequired = '로그인이 필요합니다.';
  static const String permissionDenied = '권한이 없습니다.';
  static const String dataNotFound = '데이터를 찾을 수 없습니다.';
  static const String invalidInput = '입력값이 올바르지 않습니다.';
}

/// 성공 메시지 상수
class SuccessMessages {
  static const String profileUpdated = '프로필이 업데이트되었습니다.';
  static const String messageSent = '메시지가 전송되었습니다.';
  static const String connectionRequestSent = '연결 요청이 전송되었습니다.';
  static const String feedbackSubmitted = '피드백이 제출되었습니다.';
}

/// 앱 설정 관련 상수
class AppSettings {
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  static const int maxRetryAttempts = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
} 