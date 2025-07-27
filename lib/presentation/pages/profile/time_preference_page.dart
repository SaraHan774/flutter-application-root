import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:application_root/shared/design_system/colors.dart';
import 'package:application_root/shared/design_system/typography.dart';
import 'package:application_root/shared/design_system/components/primary_button.dart';

import 'package:application_root/presentation/widgets/auth_error_dialog.dart';

/// 대화 시간대 선택 화면
/// 사용자가 하루 중 언제 대화하고 싶은지 선택할 수 있는 화면
class TimePreferencePage extends ConsumerStatefulWidget {
  const TimePreferencePage({super.key});

  @override
  ConsumerState<TimePreferencePage> createState() => _TimePreferencePageState();
}

class _TimePreferencePageState extends ConsumerState<TimePreferencePage> {
  String? _selectedTimeSlot;

  // 시간대 옵션
  final List<TimeSlotOption> _timeSlotOptions = [
    TimeSlotOption(
      id: 'morning',
      title: '오전',
      subtitle: '9시 ~ 11시',
      description: '상쾌한 아침에 대화를 시작해보세요',
      icon: Icons.wb_sunny_outlined,
    ),
    TimeSlotOption(
      id: 'afternoon',
      title: '오후',
      subtitle: '12시 ~ 17시',
      description: '점심시간과 오후에 여유롭게 대화해보세요',
      icon: Icons.light_mode_outlined,
    ),
    TimeSlotOption(
      id: 'evening',
      title: '저녁',
      subtitle: '18시 ~ 22시',
      description: '하루를 마무리하며 따뜻한 대화를 나누세요',
      icon: Icons.nights_stay_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 기본값으로 오전 선택
    _selectedTimeSlot = 'morning';
  }

  /// 시간대 선택
  void _selectTimeSlot(String timeSlotId) {
    setState(() {
      _selectedTimeSlot = timeSlotId;
    });
  }

  /// 다음 단계로 이동
  void _proceedToNext() async {
    if (_selectedTimeSlot == null) {
      AuthErrorDialogHelper.showGeneralError(
        context, 
        message: '대화 시간대를 선택해주세요.',
      );
      return;
    }

    try {
      // TODO: 사용자 프로필에 시간대 저장
      // await ref.read(userProvider.notifier).updateUserProfile(
      //   preferredTime: _selectedTimeSlot,
      // );
      
      // 임시로 다음 화면으로 이동
      if (mounted) {
        context.go('/empathy-survey');
      }
    } catch (e) {
      AuthErrorDialogHelper.showGeneralError(
        context, 
        message: '시간대 설정 저장 중 오류가 발생했습니다.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HandamColors.background,
      appBar: AppBar(
        backgroundColor: HandamColors.background,
        foregroundColor: HandamColors.textDefault,
        elevation: 0,
        title: Text(
          '대화 시간대 선택',
          style: HandamTypography.headline3.copyWith(
            color: HandamColors.textDefault,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 안내 텍스트
              Text(
                '하루 중 언제 대화하고 싶으신가요?',
                style: HandamTypography.headline2.copyWith(
                  color: HandamColors.textDefault,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '선택한 시간대에 매칭이 이루어집니다',
                style: HandamTypography.body2.copyWith(
                  color: HandamColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // 시간대 선택 카드들
              Expanded(
                child: ListView.separated(
                  itemCount: _timeSlotOptions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final option = _timeSlotOptions[index];
                    final isSelected = _selectedTimeSlot == option.id;

                    return GestureDetector(
                      onTap: () => _selectTimeSlot(option.id),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? HandamColors.primary.withOpacity(0.1)
                              : HandamColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                                ? HandamColors.primary 
                                : HandamColors.outline,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // 아이콘
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? HandamColors.primary 
                                    : HandamColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected 
                                      ? HandamColors.primary 
                                      : HandamColors.outline,
                                ),
                              ),
                              child: Icon(
                                option.icon,
                                color: isSelected 
                                    ? HandamColors.onPrimary 
                                    : HandamColors.textSecondary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // 텍스트 정보
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
                                  const SizedBox(height: 4),
                                  Text(
                                    option.description,
                                    style: HandamTypography.body2.copyWith(
                                      color: HandamColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 선택 표시
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: HandamColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: HandamColors.onPrimary,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 다음 버튼
              SizedBox(
                width: double.infinity,
                child: HandamPrimaryButton(
                  onPressed: _selectedTimeSlot != null ? _proceedToNext : null,
                  child: Text(
                    '다음',
                    style: HandamTypography.button.copyWith(
                      color: HandamColors.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 시간대 옵션 데이터 클래스
class TimeSlotOption {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;

  TimeSlotOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });
} 