import 'dart:math';

/// 랜덤 닉네임 생성 유틸리티
class NicknameGenerator {
  static final Random _random = Random();
  
  // 감성적인 형용사 목록
  static const List<String> _adjectives = [
    '따뜻한', '차분한', '밝은', '고요한', '포근한', '맑은', '부드러운', '깊은',
    '달콤한', '시원한', '따스한', '평온한', '편안한', '신나는', '감미로운', '상쾌한',
    '우아한', '자연스러운', '순수한', '진한', '은은한', '화려한', '담백한', '깔끔한',
    '신선한', '향기로운', '맛있는', '아름다운', '귀여운', '멋진', '특별한', '소중한'
  ];
  
  // 감성적인 명사 목록
  static const List<String> _nouns = [
    '달빛', '구름', '바람', '꽃잎', '나뭇잎', '물방울', '별빛', '햇살',
    '코코아', '라떼', '차', '커피', '우유', '꿀', '시럽', '크림',
    '노을', '아침', '저녁', '새벽', '오후', '밤', '낮', '해',
    '달', '별', '하늘', '구름', '비', '눈', '안개', '무지개',
    '나무', '꽃', '풀', '잎', '씨앗', '열매', '가지', '뿌리',
    '바다', '강', '호수', '산', '들', '숲', '정원', '공원'
  ];

  /// 랜덤 닉네임을 생성합니다.
  /// 
  /// [includeNumber]가 true이면 닉네임 뒤에 랜덤 숫자를 추가합니다.
  static String generate({bool includeNumber = false}) {
    final adjective = _adjectives[_random.nextInt(_adjectives.length)];
    final noun = _nouns[_random.nextInt(_nouns.length)];
    
    String nickname = '$adjective$noun';
    
    if (includeNumber) {
      final number = _random.nextInt(999) + 1;
      nickname = '$nickname$number';
    }
    
    return nickname;
  }
  
  /// 중복을 피하기 위해 여러 개의 랜덤 닉네임을 생성합니다.
  static List<String> generateMultiple(int count, {bool includeNumber = false}) {
    final nicknames = <String>{};
    
    while (nicknames.length < count) {
      nicknames.add(generate(includeNumber: includeNumber));
    }
    
    return nicknames.toList();
  }
}
