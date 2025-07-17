import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/core.dart';
import '../../../shared/shared.dart';
import '../../providers/auth_provider.dart';

/// OTP 인증번호 확인 페이지
class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  ConsumerState<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  String _phoneNumber = '';
  String _verificationId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _phoneNumber = args['phoneNumber'] ?? '';
        _verificationId = args['verificationId'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final otpCode = _getOtpCode();
    
    try {
      await ref.read(authNotifierProvider.notifier).verifyPhoneCode(
        phoneNumber: _phoneNumber,
        smsCode: otpCode,
        verificationId: _verificationId,
      );
      
      if (mounted) {
        // 인증 성공 시 프로필 설정 페이지로 이동
        context.go(AppRoutes.profileSetup);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: HandamColors.errorLight,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('인증번호 확인'),
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
                  '인증번호를\n입력해주세요',
                  style: HandamTypography.headline1,
                ),
                
                const SizedBox(height: 16),
                
                // 설명
                Text(
                  '$_phoneNumber로 전송된\n6자리 인증번호를 입력해주세요',
                  style: HandamTypography.body1.copyWith(
                    color: HandamColors.textSecondaryLight,
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
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                        ),
                        onChanged: (value) => _onOtpChanged(value, index),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 재전송 버튼
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: 재전송 로직 구현
                    },
                    child: Text(
                      '인증번호 재전송',
                      style: HandamTypography.body2.copyWith(
                        color: HandamColors.primaryLight,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // 확인 버튼
                SizedBox(
                  width: double.infinity,
                  child: authState.when(
                    loading: () => const HandamPrimaryButton(
                      onPressed: null,
                      text: '확인 중...',
                    ),
                    error: (error, stack) => HandamPrimaryButton(
                      onPressed: _verifyOtp,
                      text: '확인',
                    ),
                    data: (user) => HandamPrimaryButton(
                      onPressed: _verifyOtp,
                      text: '확인',
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