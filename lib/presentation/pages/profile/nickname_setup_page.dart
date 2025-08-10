import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:handam/shared/design_system/colors.dart';
import 'package:handam/shared/design_system/typography.dart';
import 'package:handam/shared/design_system/components/app_button.dart';
import 'package:handam/shared/design_system/components/text_field.dart';

import 'package:handam/presentation/widgets/auth_error_dialog.dart';
import 'package:handam/presentation/providers/auth_provider.dart';
import 'package:handam/presentation/providers/user_provider.dart';

/// 닉네임 설정 화면
/// 사용자가 닉네임을 입력하고 중복 확인을 할 수 있는 화면
class NicknameSetupPage extends ConsumerStatefulWidget {
  const NicknameSetupPage({super.key});

  @override
  ConsumerState<NicknameSetupPage> createState() => _NicknameSetupPageState();
}

class _NicknameSetupPageState extends ConsumerState<NicknameSetupPage> {
  final _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isCheckingDuplicate = false;
  bool _isDuplicate = false;
  bool _isValidFormat = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_onNicknameChanged);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  /// 닉네임 입력값 변경 시 호출
  void _onNicknameChanged() {
    final nickname = _nicknameController.text.trim();
    final isValid = _validateNicknameFormat(nickname);
    
    setState(() {
      _isValidFormat = isValid;
      _isDuplicate = false; // 새로운 입력 시 중복 상태 초기화
    });
  }

  /// 닉네임 형식 검증
  bool _validateNicknameFormat(String nickname) {
    if (nickname.isEmpty) return false;
    if (nickname.length < 2 || nickname.length > 12) return false;
    
    // 한글, 영문, 숫자만 허용 (특수문자 제외)
    final regex = RegExp(r'^[가-힣a-zA-Z0-9]+$');
    return regex.hasMatch(nickname);
  }

  /// 중복 확인
  Future<void> _checkDuplicate() async {
    final nickname = _nicknameController.text.trim();
    if (!_isValidFormat) return;

    setState(() {
      _isCheckingDuplicate = true;
    });

    try {
      // TODO: 실제 중복 확인 로직 구현
      // final isDuplicate = await ref.read(userRepositoryProvider).checkNicknameDuplicate(nickname);
      
      // 임시로 랜덤 중복 확인 (실제 구현 시 제거)
      await Future.delayed(const Duration(milliseconds: 500));
      final isDuplicate = nickname.toLowerCase() == 'test' || nickname.toLowerCase() == 'admin';
      
      setState(() {
        _isDuplicate = isDuplicate;
        _isCheckingDuplicate = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingDuplicate = false;
      });
      AuthErrorDialogHelper.showGeneralError(
        context, 
        message: '중복 확인 중 오류가 발생했습니다.',
      );
    }
  }

  /// 랜덤 닉네임 생성
  void _generateRandomNickname() {
    final randomNicknames = [
      '따뜻한달빛',
      '코코아러버',
      '노을속귤',
      '고요한바람',
      '차분한구름',
      '따스한햇살',
      '평온한숲',
      '부드러운물결',
    ];
    
    final random = DateTime.now().millisecond % randomNicknames.length;
    _nicknameController.text = randomNicknames[random];
  }

  /// 다음 단계로 이동
  Future<void> _proceedToNext() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isDuplicate) {
      AuthErrorDialogHelper.showGeneralError(
        context, 
        message: '이미 사용 중인 닉네임입니다.',
      );
      return;
    }

    // 중복 실행 방지
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final nickname = _nicknameController.text.trim();
      final user = ref.read(authNotifierProvider).value;
      
      if (user == null) {
        throw Exception('사용자 ID를 찾을 수 없습니다.');
      }

      print('[한담] [DEBUG] User: $user');
      print('[한담] [DEBUG] User ID: ${user.uid}');

      // 사용자 프로필에 닉네임 저장
      await ref.read(userNotifierProvider.notifier).updateUserProfile(
        userId: user.uid,
        nickname: nickname,
      );
      
      print('[한담] [PROFILE] Nickname saved: $nickname');
      
      // 다음 화면으로 이동
      if (mounted) {
        context.go('/emotion-selection');
      }
      
    } catch (e) {
      print('[한담] [PROFILE] Error saving nickname: $e');
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        AuthErrorDialogHelper.showGeneralError(
          context, 
          message: '닉네임 저장 중 오류가 발생했습니다.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    
    return Scaffold(
      backgroundColor: HandamColors.background,
      appBar: AppBar(
        backgroundColor: HandamColors.background,
        foregroundColor: HandamColors.textDefault,
        elevation: 0,
        title: Text(
          '닉네임 설정',
          style: HandamTypography.headline3.copyWith(
            color: HandamColors.textDefault,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: authState.when(
          data: (user) => Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 안내 텍스트
                  Text(
                    '사용할 닉네임을 입력해주세요',
                    style: HandamTypography.headline2.copyWith(
                      color: HandamColors.textDefault,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2-12자, 한글/영문/숫자만 사용 가능합니다',
                    style: HandamTypography.body2.copyWith(
                      color: HandamColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 닉네임 입력 필드
                  HandamTextField(
                    controller: _nicknameController,
                    labelText: '닉네임',
                    hintText: '예: 따뜻한달빛',
                    maxLength: 12,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '닉네임을 입력해주세요';
                      }
                      if (!_validateNicknameFormat(value.trim())) {
                        return '2-12자의 한글/영문/숫자만 사용 가능합니다';
                      }
                      if (_isDuplicate) {
                        return '이미 사용 중인 닉네임입니다';
                      }
                      return null;
                    },
                    suffixIcon: _isCheckingDuplicate
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : _isValidFormat
                            ? Icon(
                                _isDuplicate ? Icons.error : Icons.check_circle,
                                color: _isDuplicate 
                                    ? HandamColors.error 
                                    : Colors.green,
                              )
                            : null,
                  ),
                  const SizedBox(height: 16),

                  // 중복 확인 버튼
                  if (_isValidFormat && !_isDuplicate)
                    SizedBox(
                      width: double.infinity,
                      child: HandamButton(
                        text: _isCheckingDuplicate ? '확인 중...' : '중복 확인',
                        onPressed: _isCheckingDuplicate ? null : _checkDuplicate,
                        variant: HandamButtonVariant.secondary,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // 랜덤 닉네임 생성 버튼
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _generateRandomNickname,
                      child: Text(
                        '랜덤 닉네임 추천',
                        style: HandamTypography.body1.copyWith(
                          color: HandamColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),

                  // 다음 버튼
                  SizedBox(
                    width: double.infinity,
                    child: HandamButton(
                      text: _isSaving ? '저장 중...' : '다음',
                      onPressed: (_isValidFormat && !_isDuplicate && !_isSaving) ? _proceedToNext : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: HandamColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  '사용자 정보를 불러올 수 없습니다',
                  style: HandamTypography.body1.copyWith(
                    color: HandamColors.textDefault,
                  ),
                ),
                const SizedBox(height: 16),
                HandamButton(
                  text: '다시 시도',
                  onPressed: () {
                    ref.read(authNotifierProvider.notifier).refreshCurrentUser();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 