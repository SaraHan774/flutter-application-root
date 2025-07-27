import 'package:flutter/material.dart';
import 'package:handam/shared/design_system/colors.dart';
import 'package:handam/shared/design_system/typography.dart';

/// 감정 키워드 그리드 컴포넌트
/// 감정 키워드를 칩 형태로 선택할 수 있는 재사용 가능한 위젯
class EmotionChipGrid extends StatefulWidget {
  final Set<String> selectedEmotions;
  final List<String> emotionKeywords;
  final int minSelection;
  final int maxSelection;
  final Function(String) onEmotionToggled;
  final bool showSelectionCount;

  const EmotionChipGrid({
    super.key,
    required this.selectedEmotions,
    required this.emotionKeywords,
    required this.onEmotionToggled,
    this.minSelection = 3,
    this.maxSelection = 5,
    this.showSelectionCount = true,
  });

  @override
  State<EmotionChipGrid> createState() => _EmotionChipGridState();
}

class _EmotionChipGridState extends State<EmotionChipGrid> {
  /// 감정 키워드 선택/해제
  void _toggleEmotion(String emotion) {
    if (widget.selectedEmotions.contains(emotion)) {
      widget.onEmotionToggled(emotion);
    } else {
      if (widget.selectedEmotions.length < widget.maxSelection) {
        widget.onEmotionToggled(emotion);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 선택 개수 표시
        if (widget.showSelectionCount)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '${widget.selectedEmotions.length}개 선택 / 최대 ${widget.maxSelection}개',
              style: HandamTypography.body2.copyWith(
                color: HandamColors.textSecondary,
              ),
            ),
          ),

        // 감정 키워드 그리드
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: widget.emotionKeywords.map((emotion) {
            final isSelected = widget.selectedEmotions.contains(emotion);
            final isDisabled = !isSelected && 
                widget.selectedEmotions.length >= widget.maxSelection;

            return GestureDetector(
              onTap: isDisabled ? null : () => _toggleEmotion(emotion),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? HandamColors.primary
                      : isDisabled
                          ? HandamColors.outline.withValues(alpha: 0.3)
                          : HandamColors.surface,
                  border: Border.all(
                    color: isSelected 
                        ? HandamColors.primary
                        : HandamColors.outline,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Text(
                  '#$emotion',
                  style: HandamTypography.body2.copyWith(
                    color: isSelected 
                        ? HandamColors.onPrimary
                        : isDisabled
                            ? HandamColors.textSecondary.withValues(alpha: 0.5)
                            : HandamColors.textDefault,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // 최소 선택 안내
        if (widget.selectedEmotions.length < widget.minSelection)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              '최소 ${widget.minSelection}개의 감정 키워드를 선택해주세요',
              style: HandamTypography.body3.copyWith(
                color: HandamColors.error,
              ),
            ),
          ),
      ],
    );
  }
} 