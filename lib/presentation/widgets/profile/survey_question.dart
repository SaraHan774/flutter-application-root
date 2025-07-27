import 'package:flutter/material.dart';
import 'package:handam/shared/design_system/colors.dart';
import 'package:handam/shared/design_system/typography.dart';
import 'package:handam/shared/design_system/components/primary_button.dart';
import 'package:handam/shared/design_system/components/secondary_button.dart';

/// 설문 질문 모델
class SurveyQuestion {
  final int id;
  final String question;
  final String description;

  const SurveyQuestion({
    required this.id,
    required this.question,
    required this.description,
  });
}

/// 설문 질문 컴포넌트
/// 단일 설문 질문을 표시하고 답변을 수집하는 재사용 가능한 위젯
class SurveyQuestionWidget extends StatelessWidget {
  final SurveyQuestion question;
  final String? currentAnswer;
  final Function(String) onAnswerSelected;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onSkip;
  final bool isLastQuestion;
  final bool showProgress;
  final int currentIndex;
  final int totalQuestions;

  const SurveyQuestionWidget({
    super.key,
    required this.question,
    required this.currentAnswer,
    required this.onAnswerSelected,
    this.onNext,
    this.onPrevious,
    this.onSkip,
    this.isLastQuestion = false,
    this.showProgress = true,
    this.currentIndex = 0,
    this.totalQuestions = 1,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / totalQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 진행률 표시
        if (showProgress) ...[
          Row(
            children: [
              Text(
                '${currentIndex + 1}',
                style: HandamTypography.headline3.copyWith(
                  color: HandamColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' / $totalQuestions',
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
        ],

        // 질문
        Text(
          question.question,
          style: HandamTypography.headline2.copyWith(
            color: HandamColors.textDefault,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          question.description,
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
                () => onAnswerSelected('그렇다'),
              ),
              const SizedBox(height: 16),

              // 아니다
              _buildAnswerOption(
                '아니다',
                currentAnswer == '아니다',
                () => onAnswerSelected('아니다'),
              ),
            ],
          ),
        ),

        // 하단 버튼들
        Row(
          children: [
            // 이전 버튼
            if (onPrevious != null)
              Expanded(
                child: HandamSecondaryButton(
                  onPressed: onPrevious,
                  child: const Text('이전'),
                ),
              ),

            if (onPrevious != null) const SizedBox(width: 12),

            // 건너뛰기 버튼
            if (onSkip != null)
              Expanded(
                child: HandamSecondaryButton(
                  onPressed: onSkip,
                  child: const Text('건너뛰기'),
                ),
              ),

            if (onSkip != null) const SizedBox(width: 12),

            // 다음/완료 버튼
            Expanded(
              flex: 2,
              child: HandamPrimaryButton(
                onPressed: currentAnswer != null ? onNext : null,
                child: Text(isLastQuestion ? '완료' : '다음'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 답변 옵션 위젯
  Widget _buildAnswerOption(String answer, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isSelected 
              ? HandamColors.primary.withValues(alpha: 0.1)
              : HandamColors.surface,
          border: Border.all(
            color: isSelected 
                ? HandamColors.primary
                : HandamColors.outline,
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            // 선택 표시 아이콘
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                    ? HandamColors.primary
                    : HandamColors.outline,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: HandamColors.onPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // 답변 텍스트
            Expanded(
              child: Text(
                answer,
                style: HandamTypography.headline4.copyWith(
                  color: isSelected 
                      ? HandamColors.primary
                      : HandamColors.textDefault,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 