import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/core.dart';
import '../../../shared/shared.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/auth_error_dialog.dart';

/// OTP 인증번호 확인 페이지
class OtpVerificationPage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  ConsumerState<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String _getOtpCode() {
    final otpCode = _controllers.map((controller) => controller.text).join();
    print('🔢 _getOtpCode called: "$otpCode" (length: ${otpCode.length})');
    return otpCode;
  }

  void _onOtpChanged(String value, int index) {
    print('🔢 OTP Changed: index=$index, value="$value"');
    
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // 전체 OTP 코드 상태 출력
    final currentOtp = _getOtpCode();
    print('🔢 Current OTP: "$currentOtp" (length: ${currentOtp.length})');
  }

  /// 랜덤 닉네임을 생성하고 서버에 저장한 후 다음 화면으로 이동
  Future<void> _createRandomNicknameAndProceed(String userId) async {
    try {
      // 랜덤 닉네임 생성 (숫자 포함하여 중복 가능성 줄임)
      final randomNickname = NicknameGenerator.generate(includeNumber: true);
      
      print('[한담] [OTP] Generated random nickname: $randomNickname');
      
      // 사용자 프로필에 랜덤 닉네임 저장
      await ref.read(userNotifierProvider.notifier).updateUserProfile(
        userId: userId,
        nickname: randomNickname,
      );
      
      print('[한담] [OTP] Random nickname saved successfully');
      
      // AuthProvider 상태 새로고침
      await ref.read(authNotifierProvider.notifier).refreshCurrentUser();
      
      // 감정 선택 화면으로 직접 이동
      if (mounted) {
        print('[한담] [OTP] Navigating to emotion selection');
        context.go(AppRoutes.emotionSelection);
      }
      
    } catch (e) {
      print('[한담] [OTP] Error creating random nickname: $e');
      if (mounted) {
        AuthErrorDialogHelper.showGeneralError(
          context,
          message: '닉네임 생성 중 오류가 발생했습니다. 다시 시도해주세요.',
        );
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final otpCode = _getOtpCode();
    
    // 전화번호에서 숫자만 추출하고 국가 코드 추가 (PhoneAuthPage와 동일한 형식)
    final digits = widget.phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final formattedPhoneNumber = '+82${digits.substring(1)}'; // 010 -> +8210
    
    print('🔍 OTP Verification Debug:');
    print('  - Original Phone: ${widget.phoneNumber}');
    print('  - Formatted Phone: $formattedPhoneNumber');
    print('  - OTP Code: $otpCode');
    print('  - Verification ID: ${widget.verificationId}');
    
    try {
      await ref.read(authNotifierProvider.notifier).verifyPhoneCode(
        phoneNumber: formattedPhoneNumber,
        smsCode: otpCode,
        verificationId: widget.verificationId,
      );
      
      print('✅ OTP Verification Success!');
      
      if (mounted) {
        // 인증 성공 후 사용자 상태 확인
        final authState = ref.read(authNotifierProvider);
        authState.whenData((user) async {
          if (user != null) {
            if (user.isProfileComplete) {
              // 프로필 설정 완료: 홈 화면으로 이동
              print('[한담] [OTP] User profile complete, navigating to home');
              context.go(AppRoutes.home);
            } else {
              // 프로필 설정 미완료: 자동으로 랜덤 닉네임 생성 및 저장
              await _createRandomNicknameAndProceed(user.uid);
            }
          } else {
            // 사용자 정보를 찾을 수 없음: 에러 처리
            print('[한담] [OTP] No user data found after verification');
            if (mounted) {
              AuthErrorDialogHelper.showGeneralError(
                context,
                message: '사용자 정보를 찾을 수 없습니다. 다시 시도해주세요.',
              );
            }
          }
        });
      }
    } catch (e) {
      print('❌ OTP Verification Error: $e');
      
      if (mounted) {
        // 에러를 Failure 객체로 변환하여 다이얼로그 표시
        final failure = e is Failure ? e : UnknownFailure(e.toString());
        await AuthErrorDialogHelper.showErrorFromFailure(
          context,
          failure,
          onRetry: _verifyOtp,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final otpCode = _getOtpCode();
    final isOtpComplete = otpCode.length == 6;

    print('🔍 Build Debug: OTP length = ${otpCode.length}, isComplete = $isOtpComplete');
    print('🔍 Auth State: $authState');

    return Scaffold(
      backgroundColor: HandamColors.background,
      appBar: AppBar(
        backgroundColor: HandamColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: HandamColors.textDefault),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Text(
                '인증번호 입력',
                style: HandamTypography.headline1.copyWith(
                  color: HandamColors.textDefault,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.phoneNumber}로 전송된 6자리 인증번호를 입력해주세요.',
                style: HandamTypography.body2.copyWith(
                  color: HandamColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              // OTP 입력 필드들
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: HandamTypography.headline3.copyWith(
                        color: HandamColors.textDefault,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: HandamColors.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: HandamColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      onChanged: (value) => _onOtpChanged(value, index),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        if (value.length != 1) {
                          return '';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 인증 확인 버튼
              Builder(
                builder: (context) {
                  print('🔘 Building button widget - Auth state: $authState');
                  
                  if (authState.isLoading) {
                    return Column(
                      children: [
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '인증 처리 중...',
                          style: HandamTypography.body2.copyWith(
                            color: HandamColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  }
                  
                  if (authState.hasError) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print('🔘 Retry button pressed');
                            _verifyOtp();
                          },
                          child: const Text('다시 시도'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '인증에 실패했습니다.',
                          style: HandamTypography.body3.copyWith(
                            color: HandamColors.errorLight,
                          ),
                        ),
                      ],
                    );
                  }
                  
                  // 기본 상태 (data 또는 null)
                  print('🔘 Rendering default button - OTP Complete: $isOtpComplete');
                  return ElevatedButton(
                    onPressed: () {
                      print('🔘 Verify button pressed - Always enabled');
                      _verifyOtp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOtpComplete ? Colors.blue : Colors.grey,
                    ),
                    child: Text(
                      isOtpComplete ? '인증 확인' : '인증번호 6자리 입력',
                      style: TextStyle(
                        color: isOtpComplete ? Colors.white : Colors.black54,
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // 재전송 버튼
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: 재전송 로직 구현
                  },
                  child: Text(
                    '인증번호 재전송',
                    style: HandamTypography.button.copyWith(
                      color: HandamColors.primary,
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