import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:handam/shared/design_system/colors.dart';
import 'package:handam/shared/design_system/typography.dart';
import 'package:handam/shared/design_system/components/primary_button.dart';
import 'package:handam/presentation/widgets/auth_error_dialog.dart';

/// 감정 키워드 선택 화면
/// 사용자가 최소 3개, 최대 5개의 감정 키워드를 선택할 수 있는 화면
class EmotionSelectionPage extends ConsumerStatefulWidget {
  const EmotionSelectionPage({super.key});

  @override
  ConsumerState<EmotionSelectionPage> createState() => _EmotionSelectionPageState();
}

class _EmotionSelectionPageState extends ConsumerState<EmotionSelectionPage> {
  final Set<String> _selectedEmotions = {};
  
  // 감정 키워드 목록
  final List<String> _emotionKeywords = [
    '고요함',
    '피곤해',
    '위로가필요해',
    '무기력함',
    '외로움',
    '불안함',
    '기쁨',
    '평온함',
    '설렘',
    '그리움',
    '감사함',
    '희망',
    '우울함',
    '스트레스',
    '짜증',
    '답답함',
    '허전함',
    '따뜻함',
    '편안함',
    '행복함',
  ];

  /// 감정 키워드 선택/해제
  void _toggleEmotion(String emotion) {
    setState(() {
      if (_selectedEmotions.contains(emotion)) {
        _selectedEmotions.remove(emotion);
      } else {
        if (_selectedEmotions.length < 5) {
          _selectedEmotions.add(emotion);
        }
      }
    });
  }

  /// 다음 단계로 이동
  void _proceedToNext() async {
    if (_selectedEmotions.length < 3) {
      AuthErrorDialogHelper.showGeneralError(
        context, 
        message: '최소 3개의 감정 키워드를 선택해주세요.',
      );
      return;
    }

    try {
      // TODO: 사용자 프로필에 감정 키워드 저장
      // await ref.read(userProvider.notifier).updateUserProfile(
      //   emotionTags: _selectedEmotions.toList(),
      // );
      
      // 임시로 다음 화면으로 이동
      if (mounted) {
        context.go('/time-preference');
      }
    } catch (e) {
      AuthErrorDialogHelper.showGeneralError(
        context, 
        message: '감정 키워드 저장 중 오류가 발생했습니다.',
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
          '감정 키워드 선택',
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
                '요즘 당신의 감정을 골라주세요',
                style: HandamTypography.headline2.copyWith(
                  color: HandamColors.textDefault,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '최소 3개, 최대 5개까지 선택할 수 있어요',
                style: HandamTypography.body2.copyWith(
                  color: HandamColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // 선택 개수 표시
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: HandamColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: HandamColors.outline),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tag,
                      size: 16,
                      color: HandamColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedEmotions.length}개 선택 / 최대 5개',
                      style: HandamTypography.body2.copyWith(
                        color: HandamColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 감정 키워드 그리드
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: _emotionKeywords.length,
                  itemBuilder: (context, index) {
                    final emotion = _emotionKeywords[index];
                    final isSelected = _selectedEmotions.contains(emotion);
                    final isDisabled = !isSelected && _selectedEmotions.length >= 5;

                    return GestureDetector(
                      onTap: isDisabled ? null : () => _toggleEmotion(emotion),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? HandamColors.primary 
                              : HandamColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? HandamColors.primary 
                                : HandamColors.outline,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '#$emotion',
                            style: HandamTypography.body1.copyWith(
                              color: isSelected 
                                  ? HandamColors.onPrimary 
                                  : (isDisabled 
                                      ? HandamColors.textSecondary.withOpacity(0.5)
                                      : HandamColors.textDefault),
                              fontWeight: isSelected 
                                  ? FontWeight.w600 
                                  : FontWeight.w400,
                            ),
                          ),
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
                  onPressed: _selectedEmotions.length >= 3 ? _proceedToNext : null,
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