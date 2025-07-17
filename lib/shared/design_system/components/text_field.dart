import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors.dart';
import '../typography.dart';

/// 한담 TextField 컴포넌트
/// 입력 필드로 사용
class HandamTextField extends StatefulWidget {
  const HandamTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.height = 48.0,
    this.borderRadius = 10.0,
  });

  /// 텍스트 컨트롤러
  final TextEditingController? controller;

  /// 힌트 텍스트
  final String? hintText;

  /// 라벨 텍스트
  final String? labelText;

  /// 도움말 텍스트
  final String? helperText;

  /// 에러 텍스트
  final String? errorText;

  /// 비밀번호 모드
  final bool obscureText;

  /// 키보드 타입
  final TextInputType? keyboardType;

  /// 텍스트 입력 액션
  final TextInputAction? textInputAction;

  /// 텍스트 변경 콜백
  final ValueChanged<String>? onChanged;

  /// 제출 콜백
  final ValueChanged<String>? onSubmitted;

  /// 유효성 검사 함수
  final String? Function(String?)? validator;

  /// 최대 길이
  final int? maxLength;

  /// 최대 라인 수
  final int? maxLines;

  /// 최소 라인 수
  final int? minLines;

  /// 확장 모드
  final bool expands;

  /// 읽기 전용
  final bool readOnly;

  /// 활성화 상태
  final bool enabled;

  /// 자동 포커스
  final bool autofocus;

  /// 텍스트 대문자화
  final TextCapitalization textCapitalization;

  /// 입력 포맷터
  final List<TextInputFormatter>? inputFormatters;

  /// 접두 아이콘
  final Widget? prefixIcon;

  /// 접미 아이콘
  final Widget? suffixIcon;

  /// 높이
  final double height;

  /// 모서리 둥글기
  final double borderRadius;

  @override
  State<HandamTextField> createState() => _HandamTextFieldState();
}

class _HandamTextFieldState extends State<HandamTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDark ? HandamColors.darkColorScheme : HandamColors.lightColorScheme;

    return SizedBox(
      height: widget.height,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        style: HandamTypography.body1.copyWith(
          color: widget.enabled 
              ? colorScheme.onSurface 
              : colorScheme.outline,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: colorScheme.outline,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.suffixIcon,
          filled: true,
          fillColor: widget.enabled 
              ? colorScheme.surface 
              : colorScheme.surface.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          hintStyle: HandamTypography.body1.copyWith(
            color: colorScheme.outline,
          ),
          labelStyle: HandamTypography.body2.copyWith(
            color: colorScheme.outline,
          ),
          errorStyle: HandamTypography.body3.copyWith(
            color: colorScheme.error,
          ),
          helperStyle: HandamTypography.body3.copyWith(
            color: colorScheme.outline,
          ),
        ),
      ),
    );
  }
} 