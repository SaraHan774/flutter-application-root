import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../typography.dart';

/// 한담 감정 키워드 Chip 컴포넌트
/// 감정 태그 선택에 사용
class HandamEmotionChip extends StatelessWidget {
  const HandamEmotionChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.isEnabled = true,
    this.showBorder = false,
  });

  /// 칩 라벨
  final String label;

  /// 선택 상태
  final bool isSelected;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 활성화 상태
  final bool isEnabled;

  /// 테두리 표시 여부
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;

    return GestureDetector(
      onTap: (isEnabled && onTap != null) ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? HandamColors.getEmotionChipColor(isDark)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999.0), // pill shape
          border: showBorder
              ? Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outline,
                  width: isSelected ? 2.0 : 1.0,
                )
              : null,
        ),
        child: Text(
          label,
          style: HandamTypography.body3.copyWith(
            color: isSelected
                ? HandamColors.getEmotionChipTextColor(isDark)
                : colorScheme.outline,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// 한담 감정 키워드 Chip 그리드
/// 여러 감정 키워드를 그리드 형태로 표시
class HandamEmotionChipGrid extends StatelessWidget {
  const HandamEmotionChipGrid({
    super.key,
    required this.emotions,
    required this.selectedEmotions,
    required this.onEmotionSelected,
    this.maxSelections = 5,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.childAspectRatio = 3.0,
  });

  /// 사용 가능한 감정 목록
  final List<String> emotions;

  /// 선택된 감정 목록
  final List<String> selectedEmotions;

  /// 감정 선택 콜백
  final Function(String emotion, bool isSelected) onEmotionSelected;

  /// 최대 선택 개수
  final int maxSelections;

  /// 가로 칩 개수
  final int crossAxisCount;

  /// 세로 간격
  final double mainAxisSpacing;

  /// 가로 간격
  final double crossAxisSpacing;

  /// 칩 가로세로 비율
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: emotions.length,
      itemBuilder: (context, index) {
        final emotion = emotions[index];
        final isSelected = selectedEmotions.contains(emotion);
        final canSelect = selectedEmotions.length < maxSelections || isSelected;

        return HandamEmotionChip(
          label: emotion,
          isSelected: isSelected,
          isEnabled: canSelect,
          showBorder: true,
          onTap: canSelect
              ? () => onEmotionSelected(emotion, !isSelected)
              : null,
        );
      },
    );
  }
} 