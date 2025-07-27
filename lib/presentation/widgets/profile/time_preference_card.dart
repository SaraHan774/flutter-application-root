import 'package:flutter/material.dart';
import 'package:handam/shared/design_system/colors.dart';
import 'package:handam/shared/design_system/typography.dart';

/// 시간대 옵션 모델
class TimeSlotOption {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;

  const TimeSlotOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });
}

/// 시간대 선택 카드 컴포넌트
/// 시간대 옵션을 카드 형태로 선택할 수 있는 재사용 가능한 위젯
class TimePreferenceCard extends StatelessWidget {
  final List<TimeSlotOption> options;
  final String? selectedTimeSlotId;
  final Function(String) onTimeSlotSelected;
  final bool showDescription;

  const TimePreferenceCard({
    super.key,
    required this.options,
    required this.selectedTimeSlotId,
    required this.onTimeSlotSelected,
    this.showDescription = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final isSelected = selectedTimeSlotId == option.id;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: () => onTimeSlotSelected(option.id),
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

                  // 시간대 아이콘
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? HandamColors.primary.withValues(alpha: 0.1)
                          : HandamColors.outline.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      option.icon,
                      color: isSelected 
                          ? HandamColors.primary
                          : HandamColors.textSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 시간대 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              option.title,
                              style: HandamTypography.headline4.copyWith(
                                color: isSelected 
                                    ? HandamColors.primary
                                    : HandamColors.textDefault,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              option.subtitle,
                              style: HandamTypography.body2.copyWith(
                                color: HandamColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        if (showDescription) ...[
                          const SizedBox(height: 4),
                          Text(
                            option.description,
                            style: HandamTypography.body3.copyWith(
                              color: HandamColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
} 