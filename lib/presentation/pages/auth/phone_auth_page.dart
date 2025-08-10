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
  bool _isCodeSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    if (!_formKey.currentState!.validate()) return;

    final phoneNumber = _phoneController.text.trim();
    
    // 전화번호에서 숫자만 추출하고 국가 코드 추가
    final digits = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final formattedPhoneNumber = '+82${digits.substring(1)}'; // 010 -> +8210
    
    try {
      final verificationId = await ref.read(authNotifierProvider.notifier).sendPhoneVerificationCode(formattedPhoneNumber);
      
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
          '${AppRoutes.otpVerification}?phoneNumber=$phoneNumber&verificationId=$verificationId',
        );
      }
    } catch (e) {
      if (mounted) {
        // 에러를 Failure 객체로 변환하여 다이얼로그 표시
        final failure = e is Failure ? e : UnknownFailure(e.toString());
        await AuthErrorDialogHelper.showErrorFromFailure(
          context,
          failure,
          onRetry: () {
            // 에러 상태 초기화 후 재시도
            ref.read(authNotifierProvider.notifier).resetError();
            _sendVerificationCode();
          },
        );
        
        // 다이얼로그가 닫힌 후 상태 초기화
        if (mounted) {
          ref.read(authNotifierProvider.notifier).resetError();
        }
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
                  // 전화번호 자동 포맷팅
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text;
                    if (text.isEmpty) return newValue;
                    
                    // 숫자만 추출
                    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
                    
                    // 포맷팅 적용
                    String formatted = '';
                    if (digits.length <= 3) {
                      formatted = digits;
                    } else if (digits.length <= 7) {
                      formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
                    } else {
                      formatted = '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
                    }
                    
                    return TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전화번호를 입력해주세요.';
                  }
                  
                  // 숫자만 추출
                  final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                  
                  if (digits.length < 10) {
                    return '전화번호는 10자리 이상이어야 합니다.';
                  }
                  
                  if (digits.length > 11) {
                    return '전화번호는 11자리를 초과할 수 없습니다.';
                  }
                  
                  // 한국 휴대폰 번호 형식 검증 (010, 011, 016, 017, 018, 019)
                  if (!digits.startsWith(RegExp(r'01[0-9]'))) {
                    return '올바른 휴대폰 번호 형식이 아닙니다.';
                  }
                  
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // 인증번호 전송 버튼
              authState.when(
                data: (_) => HandamButton(
                  text: _isCodeSent ? '인증번호 전송됨' : '인증번호 받기',
                  onPressed: _isCodeSent ? null : _sendVerificationCode,
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Column(
                  children: [
                    HandamButton(
                      text: '다시 시도',
                      onPressed: () {
                        // 에러 상태 초기화 후 재시도
                        ref.read(authNotifierProvider.notifier).resetError();
                        _sendVerificationCode();
                      },
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