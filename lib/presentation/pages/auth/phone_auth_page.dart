import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/core.dart';
import '../../../shared/shared.dart';
import '../../providers/auth_provider.dart';

/// 전화번호 인증 페이지
class PhoneAuthPage extends ConsumerStatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  ConsumerState<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends ConsumerState<PhoneAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _verificationId = '';
  bool _isCodeSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    if (!_formKey.currentState!.validate()) return;

    final phoneNumber = _phoneController.text.trim();
    
    try {
      await ref.read(authNotifierProvider.notifier).sendPhoneVerificationCode(phoneNumber);
      
      // TODO: 실제 verificationId는 Firebase Auth 콜백에서 받아야 함
      _verificationId = 'temp_verification_id';
      
      setState(() {
        _isCodeSent = true;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('인증번호가 전송되었습니다.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _onNextPressed() {
    if (_isCodeSent) {
      // OTP 확인 페이지로 이동
      context.go(AppRoutes.otpVerification, extra: {
        'phoneNumber': _phoneController.text.trim(),
        'verificationId': _verificationId,
      });
    } else {
      _sendVerificationCode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('전화번호 인증'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                
                // 제목
                Text(
                  '전화번호를\n입력해주세요',
                  style: AppTextStyles.headline1,
                ),
                
                const SizedBox(height: 16),
                
                // 설명
                Text(
                  '안전한 인증을 위해 SMS로 인증번호를\n발송합니다',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // 전화번호 입력 필드
                AppTextField(
                  controller: _phoneController,
                  label: '전화번호',
                  hint: '010-1234-5678',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '전화번호를 입력해주세요';
                    }
                    if (value.length < 10) {
                      return '올바른 전화번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // 인증번호 전송 상태 표시
                if (_isCodeSent)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '인증번호가 전송되었습니다',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const Spacer(),
                
                // 다음 버튼
                SizedBox(
                  width: double.infinity,
                  child: authState.when(
                    loading: () => const PrimaryButton(
                      onPressed: null,
                      text: '처리 중...',
                    ),
                    error: (error, stack) => PrimaryButton(
                      onPressed: _onNextPressed,
                      text: _isCodeSent ? '다음' : '인증번호 받기',
                    ),
                    data: (user) => PrimaryButton(
                      onPressed: _onNextPressed,
                      text: _isCodeSent ? '다음' : '인증번호 받기',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 