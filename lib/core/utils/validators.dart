import '../utils/constants.dart';

/// 입력값 검증을 위한 유틸리티 클래스
class Validators {
  /// 닉네임 검증
  static String? validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '닉네임을 입력해주세요.';
    }
    
    final trimmedValue = value.trim();
    
    if (trimmedValue.length < ProfileConstants.minNicknameLength) {
      return '닉네임은 ${ProfileConstants.minNicknameLength}자 이상이어야 합니다.';
    }
    
    if (trimmedValue.length > ProfileConstants.maxNicknameLength) {
      return '닉네임은 ${ProfileConstants.maxNicknameLength}자 이하여야 합니다.';
    }
    
    // 특수문자 제한 (한글, 영문, 숫자만 허용)
    final nicknameRegex = RegExp(r'^[가-힣a-zA-Z0-9]+$');
    if (!nicknameRegex.hasMatch(trimmedValue)) {
      return '닉네임은 한글, 영문, 숫자만 사용 가능합니다.';
    }
    
    return null;
  }

  /// 휴대폰 번호 검증
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '휴대폰 번호를 입력해주세요.';
    }
    
    // 한국 휴대폰 번호 형식 검증 (010-1234-5678 또는 01012345678)
    final phoneRegex = RegExp(r'^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return '올바른 휴대폰 번호 형식이 아닙니다.';
    }
    
    return null;
  }

  /// 인증번호 검증
  static String? validateVerificationCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '인증번호를 입력해주세요.';
    }
    
    if (value.length != 6) {
      return '인증번호는 6자리입니다.';
    }
    
    // 숫자만 허용
    final codeRegex = RegExp(r'^[0-9]{6}$');
    if (!codeRegex.hasMatch(value)) {
      return '인증번호는 숫자만 입력 가능합니다.';
    }
    
    return null;
  }

  /// 감정 태그 검증
  static String? validateEmotionTags(List<String> tags) {
    if (tags.isEmpty) {
      return '감정 태그를 선택해주세요.';
    }
    
    if (tags.length < MatchingConstants.minEmotionTagsRequired) {
      return '감정 태그는 최소 ${MatchingConstants.minEmotionTagsRequired}개 선택해주세요.';
    }
    
    if (tags.length > MatchingConstants.maxEmotionTagsAllowed) {
      return '감정 태그는 최대 ${MatchingConstants.maxEmotionTagsAllowed}개까지 선택 가능합니다.';
    }
    
    // 중복 검사
    final uniqueTags = tags.toSet();
    if (uniqueTags.length != tags.length) {
      return '중복된 감정 태그가 있습니다.';
    }
    
    // 유효한 태그인지 검사
    for (final tag in tags) {
      if (!EmotionConstants.availableEmotionTags.contains(tag)) {
        return '유효하지 않은 감정 태그입니다.';
      }
    }
    
    return null;
  }

  /// 메시지 검증
  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '메시지를 입력해주세요.';
    }
    
    final trimmedValue = value.trim();
    
    if (trimmedValue.length > ChatConstants.maxMessageLength) {
      return '메시지는 ${ChatConstants.maxMessageLength}자 이하여야 합니다.';
    }
    
    // 욕설 필터링 (기본적인 예시)
    final inappropriateWords = ['욕설1', '욕설2']; // 실제 욕설 필터링 로직으로 대체
    for (final word in inappropriateWords) {
      if (trimmedValue.toLowerCase().contains(word.toLowerCase())) {
        return '부적절한 표현이 포함되어 있습니다.';
      }
    }
    
    return null;
  }

  /// 이메일 검증
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '이메일을 입력해주세요.';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return '올바른 이메일 형식이 아닙니다.';
    }
    
    return null;
  }

  /// 비밀번호 검증
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    
    if (value.length < 6) {
      return '비밀번호는 6자 이상이어야 합니다.';
    }
    
    if (value.length > 20) {
      return '비밀번호는 20자 이하여야 합니다.';
    }
    
    return null;
  }

  /// 시간대 검증
  static String? validatePreferredTime(String? value) {
    if (value == null || value.isEmpty) {
      return '선호하는 시간대를 선택해주세요.';
    }
    
    final validTimes = [
      TimeConstants.morningTime,
      TimeConstants.afternoonTime,
      TimeConstants.eveningTime,
    ];
    
    if (!validTimes.contains(value)) {
      return '유효하지 않은 시간대입니다.';
    }
    
    return null;
  }

  /// 일반적인 필수 입력 검증
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName을(를) 입력해주세요.';
    }
    return null;
  }

  /// 숫자 범위 검증
  static String? validateNumberRange(int? value, int min, int max, String fieldName) {
    if (value == null) {
      return '$fieldName을(를) 입력해주세요.';
    }
    
    if (value < min || value > max) {
      return '$fieldName은 $min에서 $max 사이의 값이어야 합니다.';
    }
    
    return null;
  }
} 