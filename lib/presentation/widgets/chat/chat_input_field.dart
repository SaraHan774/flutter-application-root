import 'package:flutter/material.dart';

import '../../../shared/design_system/colors.dart';
import '../../../shared/design_system/typography.dart';

/// 채팅 입력 필드 위젯
/// 
/// 메시지를 입력하고 전송할 수 있는 입력 필드입니다.
class ChatInputField extends StatefulWidget {
  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.isEnabled = true,
    this.maxLines = 4,
    this.placeholder = '메시지를 입력하세요...',
  });

  /// 텍스트 컨트롤러
  final TextEditingController controller;
  
  /// 전송 콜백
  final VoidCallback onSend;
  
  /// 활성화 여부
  final bool isEnabled;
  
  /// 최대 줄 수
  final int maxLines;
  
  /// 플레이스홀더 텍스트
  final String placeholder;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  /// 텍스트 변경 리스너
  void _onTextChanged() {
    final isComposing = widget.controller.text.isNotEmpty;
    if (isComposing != _isComposing) {
      setState(() {
        _isComposing = isComposing;
      });
    }
  }

  /// 메시지를 전송합니다.
  void _handleSubmitted() {
    if (_isComposing && widget.isEnabled) {
      widget.onSend();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HandamColors.surface,
        border: Border(
          top: BorderSide(
            color: HandamColors.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            // 공감 카드 버튼
            _buildEmpathyCardButton(),
            
            const SizedBox(width: 12),
            
            // 입력 필드
            Expanded(
              child: _buildTextField(),
            ),
            
            const SizedBox(width: 12),
            
            // 전송 버튼
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  /// 공감 카드 버튼을 구성합니다.
  Widget _buildEmpathyCardButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: HandamColors.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: HandamColors.secondary.withOpacity(0.3),
        ),
      ),
      child: IconButton(
        onPressed: widget.isEnabled ? _showEmpathyCards : null,
        icon: Icon(
          Icons.emoji_emotions_outlined,
          size: 20,
          color: widget.isEnabled 
              ? HandamColors.textDefault 
              : HandamColors.textDefault.withOpacity(0.3),
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  /// 입력 필드를 구성합니다.
  Widget _buildTextField() {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40,
        maxHeight: 40 + (widget.maxLines - 1) * 20,
      ),
      decoration: BoxDecoration(
        color: HandamColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: HandamColors.outline.withOpacity(0.5),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        enabled: widget.isEnabled,
        maxLines: widget.maxLines,
        minLines: 1,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) => _handleSubmitted(),
        style: HandamTypography.body1.copyWith(
          color: HandamColors.textDefault,
        ),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: HandamTypography.body1.copyWith(
            color: HandamColors.textDefault.withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  /// 전송 버튼을 구성합니다.
  Widget _buildSendButton() {
    final canSend = _isComposing && widget.isEnabled;
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: canSend ? HandamColors.primary : HandamColors.outline.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        onPressed: canSend ? _handleSubmitted : null,
        icon: Icon(
          Icons.send,
          size: 18,
          color: canSend 
              ? HandamColors.onPrimary 
              : HandamColors.textDefault.withOpacity(0.3),
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  /// 공감 카드를 표시합니다.
  void _showEmpathyCards() {
    showModalBottomSheet(
      context: context,
      backgroundColor: HandamColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: HandamColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '공감 카드',
              style: HandamTypography.headline4.copyWith(
                color: HandamColors.textDefault,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '대화 주제가 막힐 때 사용해보세요',
              style: HandamTypography.body2.copyWith(
                color: HandamColors.textDefault.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            _buildEmpathyCardGrid(),
          ],
        ),
      ),
    );
  }

  /// 공감 카드 그리드를 구성합니다.
  Widget _buildEmpathyCardGrid() {
    final empathyCards = [
      '요즘 나를 웃게 한 건 뭐였어요?',
      '혼자일 때 자주 하는 루틴은 있나요?',
      '오늘 하루는 어땠나요?',
      '요즘 가장 고민되는 일이 있나요?',
      '가장 기억에 남는 여행은 언제였나요?',
      '요즘 새롭게 시작한 취미가 있나요?',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: empathyCards.length,
      itemBuilder: (context, index) {
        return _buildEmpathyCard(empathyCards[index]);
      },
    );
  }

  /// 공감 카드를 구성합니다.
  Widget _buildEmpathyCard(String text) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        widget.controller.text = text;
        _handleSubmitted();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: HandamColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: HandamColors.primary.withOpacity(0.2),
          ),
        ),
        child: Text(
          text,
          style: HandamTypography.body3.copyWith(
            color: HandamColors.textDefault,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
