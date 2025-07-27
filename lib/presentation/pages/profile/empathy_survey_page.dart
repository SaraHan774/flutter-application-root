import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:handam/shared/design_system/colors.dart';
import 'package:handam/shared/design_system/typography.dart';
import 'package:handam/shared/design_system/components/primary_button.dart';
import 'package:handam/shared/design_system/components/secondary_button.dart';
import 'package:handam/presentation/widgets/auth_error_dialog.dart';
import 'package:handam/presentation/providers/auth_provider.dart';
import 'package:handam/presentation/providers/user_provider.dart';

/// 공감 성향 설문 화면
/// 사용자의 대화 성향을 파악하기 위한 간단한 설문 화면
class EmpathySurveyPage extends ConsumerStatefulWidget {
  const EmpathySurveyPage({super.key});

  @override
  ConsumerState<EmpathySurveyPage> createState() => _EmpathySurveyPageState();
}

class _EmpathySurveyPageState extends ConsumerState<EmpathySurveyPage> {
  int _currentQuestionIndex = 0;
  final Map<int, String?> _answers = {};

  // 설문 질문 목록
  final List<SurveyQuestion> _questions = [
    SurveyQuestion(
      id: 1,
      question: '나는 감정을 자주 표현하는 편이다',
      description: '일상에서 기쁨, 슬픔, 화남 등의 감정을 자주 드러내는 편인가요?',
    ),
    SurveyQuestion(
      id: 2,
      question: '타인의 이야기를 잘 들어주는 편이다',
      description: '다른 사람의 고민이나 이야기를 경청하고 공감해주는 편인가요?',
    ),
    SurveyQuestion(
      id: 3,
      question: '낯선 사람과의 대화를 즐기는 편이다',
      description: '처음 만나는 사람과도 편하게 대화할 수 있는 편인가요?',
    ),
    SurveyQuestion(
      id: 4,
      question: '감정적인 대화보다는 논리적인 대화를 선호한다',
      description: '감정 교류보다는 이성적이고 합리적인 대화를 더 좋아하나요?',
    ),
    SurveyQuestion(
      id: 5,
      question: '대화할 때 상대방의 반응을 많이 살펴본다',
      description: '대화 중 상대방의 표정이나 반응을 자주 확인하는 편인가요?',
    ),
  ];

  /// 답변 선택
  void _selectAnswer(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
  }

  /// 다음 질문으로 이동
  void _nextQuestion() {
    if (_answers[_currentQuestionIndex] == null) {
      AuthErrorDialogHelper.showGeneralError(
        context, 
        message: '답변을 선택해주세요.',
      );
      return;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeSurvey();
    }
  }

  /// 이전 질문으로 이동
  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  /// 설문 완료
  void _completeSurvey() async {
    try {
      final authState = ref.watch(authNotifierProvider);
      
      return authState.when(
        data: (user) async {
          if (user == null) {
            throw Exception('사용자 ID를 찾을 수 없습니다.');
          }

          final empathyScore = _calculateEmpathyScore();
          
          // 사용자 프로필에 공감 성향 점수 저장
          await ref.read(userNotifierProvider.notifier).updateUserProfile(
            userId: user.uid,
            empathyScore: empathyScore,
          );
          
          print('[한담] [PROFILE] Empathy score saved: $empathyScore');
          
          // AuthProvider 상태 새로고침
          await ref.read(authNotifierProvider.notifier).refreshCurrentUser();
          
          // 홈 화면으로 이동
          if (mounted) {
            context.go('/home');
          }
        },
        loading: () {
          throw Exception('사용자 정보를 불러오는 중입니다.');
        },
        error: (error, stackTrace) {
          throw Exception('사용자 정보를 불러오는 중 오류가 발생했습니다: $error');
        },
      );
    } catch (e) {
      print('[한담] [PROFILE] Error saving empathy score: $e');
      AuthErrorDialogHelper.showGeneralError(
        context, 
        message: '설문 결과 저장 중 오류가 발생했습니다.',
      );
    }
  }

  /// 공감 성향 점수 계산
  double _calculateEmpathyScore() {
    double totalScore = 0;
    int answeredCount = 0;
    
    for (int i = 0; i < _questions.length; i++) {
      final answer = _answers[i];
      if (answer != null) {
        answeredCount++;
        switch (answer) {
          case '매우 그렇다':
            totalScore += 5;
            break;
          case '그렇다':
            totalScore += 4;
            break;
          case '보통이다':
            totalScore += 3;
            break;
          case '아니다':
            totalScore += 2;
            break;
          case '매우 아니다':
            totalScore += 1;
            break;
        }
      }
    }
    
    return answeredCount > 0 ? totalScore / answeredCount : 3.0;
  }

  /// 설문 건너뛰기
  void _skipSurvey() async {
    try {
      final authState = ref.watch(authNotifierProvider);
      
      return authState.when(
        data: (user) async {
          if (user == null) {
            throw Exception('사용자 ID를 찾을 수 없습니다.');
          }

          // 기본 공감 성향 점수로 저장
          await ref.read(userNotifierProvider.notifier).updateUserProfile(
            userId: user.uid,
            empathyScore: 3.0, // 기본값
          );
          
          print('[한담] [PROFILE] Default empathy score saved: 3.0');
          
          // AuthProvider 상태 새로고침
          await ref.read(authNotifierProvider.notifier).refreshCurrentUser();
          
          // 홈 화면으로 이동
          if (mounted) {
            context.go('/home');
          }
        },
        loading: () {
          throw Exception('사용자 정보를 불러오는 중입니다.');
        },
        error: (error, stackTrace) {
          throw Exception('사용자 정보를 불러오는 중 오류가 발생했습니다: $error');
        },
      );
      
    } catch (e) {
      print('[한담] [PROFILE] Error saving default empathy score: $e');
      AuthErrorDialogHelper.showGeneralError(
        context, 
        message: '설문 건너뛰기 중 오류가 발생했습니다.',
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final currentAnswer = _answers[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: HandamColors.background,
      appBar: AppBar(
        backgroundColor: HandamColors.background,
        foregroundColor: HandamColors.textDefault,
        elevation: 0,
        title: Text(
          '공감 성향 설문',
          style: HandamTypography.headline3.copyWith(
            color: HandamColors.textDefault,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _skipSurvey,
            child: Text(
              '건너뛰기',
              style: HandamTypography.body2.copyWith(
                color: HandamColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 진행률 표시
              Row(
                children: [
                  Text(
                    '${_currentQuestionIndex + 1}',
                    style: HandamTypography.headline3.copyWith(
                      color: HandamColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ' / ${_questions.length}',
                    style: HandamTypography.headline3.copyWith(
                      color: HandamColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 진행률 바
              LinearProgressIndicator(
                value: progress,
                backgroundColor: HandamColors.outline,
                valueColor: AlwaysStoppedAnimation<Color>(HandamColors.primary),
                minHeight: 4,
              ),
              const SizedBox(height: 32),

              // 질문
              Text(
                currentQuestion.question,
                style: HandamTypography.headline2.copyWith(
                  color: HandamColors.textDefault,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentQuestion.description,
                style: HandamTypography.body2.copyWith(
                  color: HandamColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // 답변 옵션
              Expanded(
                child: Column(
                  children: [
                    // 그렇다
                    _buildAnswerOption(
                      '그렇다',
                      currentAnswer == '그렇다',
                      () => _selectAnswer('그렇다'),
                    ),
                    const SizedBox(height: 16),

                    // 아니다
                    _buildAnswerOption(
                      '아니다',
                      currentAnswer == '아니다',
                      () => _selectAnswer('아니다'),
                    ),
                  ],
                ),
              ),

              // 네비게이션 버튼들
              Row(
                children: [
                  // 이전 버튼
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: HandamSecondaryButton(
                        onPressed: _previousQuestion,
                        child: Text(
                          '이전',
                          style: HandamTypography.button.copyWith(
                            color: HandamColors.primary,
                          ),
                        ),
                      ),
                    ),
                  if (_currentQuestionIndex > 0) const SizedBox(width: 16),

                  // 다음/완료 버튼
                  Expanded(
                    child: HandamPrimaryButton(
                      onPressed: currentAnswer != null ? _nextQuestion : null,
                      child: Text(
                        isLastQuestion ? '완료' : '다음',
                        style: HandamTypography.button.copyWith(
                          color: HandamColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 답변 옵션 위젯
  Widget _buildAnswerOption(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? HandamColors.primary.withOpacity(0.1)
              : HandamColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? HandamColors.primary 
                : HandamColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected 
                      ? HandamColors.primary 
                      : HandamColors.outline,
                  width: 2,
                ),
                color: isSelected ? HandamColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 12,
                      color: HandamColors.onPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: HandamTypography.body1.copyWith(
                color: isSelected 
                    ? HandamColors.primary 
                    : HandamColors.textDefault,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 설문 질문 데이터 클래스
class SurveyQuestion {
  final int id;
  final String question;
  final String description;

  SurveyQuestion({
    required this.id,
    required this.question,
    required this.description,
  });
} 