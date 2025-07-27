import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/core.dart';
import '../../../shared/shared.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth_error_dialog.dart';

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
            backgroundColor: Colors.green,
          ),
        );
        
        // OTP 인증 페이지로 이동 (쿼리 파라미터 전달)
        context.go(
          '${AppRoutes.otpVerification}?phoneNumber=$phoneNumber&verificationId=$_verificationId',
        );
      }
    } catch (e) {
      if (mounted) {
        // 에러를 Failure 객체로 변환하여 다이얼로그 표시
        final failure = e is Failure ? e : UnknownFailure(e.toString());
        await AuthErrorDialogHelper.showErrorFromFailure(
          context,
          failure,
          onRetry: _sendVerificationCode,
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
                '전화번호로 로그인',
                style: HandamTypography.headline1.copyWith(
                  color: HandamColors.textDefault,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '안전한 대화를 위해 전화번호 인증이 필요합니다.',
                style: HandamTypography.body2.copyWith(
                  color: HandamColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              // 전화번호 입력 필드
              HandamTextField(
                controller: _phoneController,
                labelText: '전화번호',
                hintText: '010-1234-5678',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전화번호를 입력해주세요.';
                  }
                  if (value.length < 10) {
                    return '올바른 전화번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // 인증번호 전송 버튼
              authState.when(
                data: (_) => HandamPrimaryButton(
                  onPressed: _isCodeSent ? null : _sendVerificationCode,
                  child: _isCodeSent ? const Text('인증번호 전송됨') : const Text('인증번호 받기'),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Column(
                  children: [
                    HandamPrimaryButton(
                      onPressed: _sendVerificationCode,
                      child: const Text('다시 시도'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '인증번호 전송에 실패했습니다.',
                      style: HandamTypography.body3.copyWith(
                        color: HandamColors.errorLight,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 하단 안내 텍스트
              Text(
                '인증번호는 SMS로 전송됩니다.',
                style: HandamTypography.caption.copyWith(
                  color: HandamColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 