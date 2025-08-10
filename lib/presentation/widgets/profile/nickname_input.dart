import 'package:flutter/material.dart';
import 'package:handam/shared/design_system/colors.dart';
import 'package:handam/shared/design_system/components/text_field.dart';
import 'package:handam/shared/design_system/components/app_button.dart';

/// 닉네임 입력 컴포넌트
/// 재사용 가능한 닉네임 입력 필드와 관련 기능들을 제공
class NicknameInput extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final VoidCallback? onRandomGenerate;
  final Future<bool> Function(String)? onDuplicateCheck;
  final bool showRandomButton;
  final bool showDuplicateCheck;

  const NicknameInput({
    super.key,
    required this.controller,
    this.labelText = '닉네임',
    this.hintText = '예: 따뜻한달빛',
    this.validator,
    this.onRandomGenerate,
    this.onDuplicateCheck,
    this.showRandomButton = true,
    this.showDuplicateCheck = true,
  });

  @override
  State<NicknameInput> createState() => _NicknameInputState();
}

class _NicknameInputState extends State<NicknameInput> {
  bool _isCheckingDuplicate = false;
  bool _isDuplicate = false;
  bool _isValidFormat = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onNicknameChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onNicknameChanged);
    super.dispose();
  }

  /// 닉네임 입력값 변경 시 호출
  void _onNicknameChanged() {
    final nickname = widget.controller.text.trim();
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
    final nickname = widget.controller.text.trim();
    if (!_isValidFormat || widget.onDuplicateCheck == null) return;

    setState(() {
      _isCheckingDuplicate = true;
    });

    try {
      final isDuplicate = await widget.onDuplicateCheck!(nickname);
      
      setState(() {
        _isDuplicate = isDuplicate;
        _isCheckingDuplicate = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingDuplicate = false;
      });
      rethrow;
    }
  }

  /// 랜덤 닉네임 생성
  void _generateRandomNickname() {
    if (widget.onRandomGenerate != null) {
      widget.onRandomGenerate!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 닉네임 입력 필드
        HandamTextField(
          controller: widget.controller,
          labelText: widget.labelText,
          hintText: widget.hintText,
          maxLength: 12,
          validator: widget.validator ?? (value) {
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

        // 랜덤 생성 버튼
        if (widget.showRandomButton)
          Row(
            children: [
              HandamButton(
                text: '랜덤 닉네임 생성',
                onPressed: _generateRandomNickname,
                variant: HandamButtonVariant.secondary,
              ),
              if (widget.showDuplicateCheck && _isValidFormat) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: HandamButton(
                    text: _isCheckingDuplicate ? '확인 중...' : '중복 확인',
                    onPressed: _isCheckingDuplicate ? null : _checkDuplicate,
                    variant: HandamButtonVariant.secondary,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
} 