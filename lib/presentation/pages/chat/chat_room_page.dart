import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';
import '../../../shared/design_system/colors.dart';
import '../../../shared/design_system/typography.dart';
import '../../../shared/design_system/components/loading_indicator.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/chat/chat_message_bubble.dart';
import '../../widgets/chat/chat_input_field.dart';
import '../../widgets/chat/chat_timer.dart';

/// 채팅방 화면
/// 
/// 사용자 간의 1:1 대화를 진행하는 화면입니다.
class ChatRoomPage extends ConsumerStatefulWidget {
  const ChatRoomPage({
    super.key,
    required this.chatRoomId,
  });

  final String chatRoomId;

  @override
  ConsumerState<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends ConsumerState<ChatRoomPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadChatRoom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// 채팅방을 로드합니다.
  Future<void> _loadChatRoom() async {
    await ref.read(chatNotifierProvider.notifier).loadChatRoom(widget.chatRoomId);
  }

  /// 메시지를 전송합니다.
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final userAsync = ref.watch(currentUserProviderProvider);
    final user = userAsync.value;
    if (user == null) return;

    await ref.read(chatNotifierProvider.notifier).sendMessage(
      chatRoomId: widget.chatRoomId,
      message: message,
      senderId: user.uid,
    );

    _messageController.clear();
    _scrollToBottom();
  }

  /// 스크롤을 하단으로 이동합니다.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatNotifierProvider);
    final userAsync = ref.watch(currentUserProviderProvider);

    return Scaffold(
      backgroundColor: HandamColors.background,
      appBar: _buildAppBar(chatAsync),
      body: Column(
        children: [
          // 채팅 타이머
          _buildChatTimer(chatAsync),
          
          // 메시지 목록
          Expanded(
            child: _buildMessageList(chatAsync, userAsync.value?.uid),
          ),
          
          // 입력 필드
          _buildInputField(userAsync.value?.uid),
        ],
      ),
    );
  }

  /// 앱바를 구성합니다.
  PreferredSizeWidget _buildAppBar(AsyncValue<dynamic> chatAsync) {
    return AppBar(
      title: chatAsync.when(
        data: (chatRoom) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '익명의 친구',
              style: HandamTypography.headline4.copyWith(
                color: HandamColors.textDefault,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '24시간 대화',
              style: HandamTypography.body3.copyWith(
                color: HandamColors.textDefault.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        loading: () => Text(
          '로딩 중...',
          style: HandamTypography.headline4.copyWith(
            color: HandamColors.textDefault,
          ),
        ),
        error: (_, __) => Text(
          '채팅방',
          style: HandamTypography.headline4.copyWith(
            color: HandamColors.textDefault,
          ),
        ),
      ),
      backgroundColor: HandamColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: HandamColors.textDefault),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: HandamColors.textDefault),
          onPressed: () => _showChatOptions(),
        ),
      ],
    );
  }

  /// 채팅 타이머를 구성합니다.
  Widget _buildChatTimer(AsyncValue<dynamic> chatAsync) {
    return chatAsync.when(
      data: (chatRoom) => ChatTimer(
        expiresAt: chatRoom.expiresAt,
        onExpired: () => _handleChatExpired(),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// 메시지 목록을 구성합니다.
  Widget _buildMessageList(AsyncValue<dynamic> chatAsync, String? currentUserId) {
    return chatAsync.when(
      data: (chatRoom) {
        final messages = ref.watch(messagesNotifierProvider);
        
        return messages.when(
          data: (messageList) {
            if (messageList.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                final message = messageList[index];
                final isMyMessage = message.senderId == currentUserId;
                
                return ChatMessageBubble(
                  message: message,
                  isMyMessage: isMyMessage,
                  showTime: _shouldShowTime(messageList, index),
                );
              },
            );
          },
          loading: () => Center(
            child: HandamLoadingIndicator(
              message: '메시지를 불러오는 중...',
              showMessage: true,
            ),
          ),
          error: (error, _) => Center(
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
                  '메시지를 불러올 수 없습니다',
                  style: HandamTypography.body1.copyWith(
                    color: HandamColors.textDefault,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: HandamTypography.body2.copyWith(
                    color: HandamColors.textDefault.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadChatRoom,
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Center(
                  child: HandamLoadingIndicator(
                    message: '채팅방을 불러오는 중...',
                    showMessage: true,
                  ),
      ),
      error: (error, _) => Center(
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
              '채팅방을 불러올 수 없습니다',
              style: HandamTypography.body1.copyWith(
                color: HandamColors.textDefault,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: HandamTypography.body2.copyWith(
                color: HandamColors.textDefault.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadChatRoom,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  /// 빈 상태를 구성합니다.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: HandamColors.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            '첫 번째 메시지를 보내보세요',
            style: HandamTypography.headline3.copyWith(
              color: HandamColors.textDefault,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '상대방과 따뜻한 대화를 나누어보세요',
            style: HandamTypography.body1.copyWith(
              color: HandamColors.textDefault.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 입력 필드를 구성합니다.
  Widget _buildInputField(String? currentUserId) {
    return ChatInputField(
      controller: _messageController,
      onSend: _sendMessage,
      isEnabled: currentUserId != null,
    );
  }

  /// 시간 표시 여부를 결정합니다.
  bool _shouldShowTime(List<dynamic> messages, int index) {
    if (index == 0) return true;
    
    final currentMessage = messages[index];
    final previousMessage = messages[index - 1];
    
    final timeDifference = currentMessage.timestamp.difference(previousMessage.timestamp);
    return timeDifference.inMinutes >= 5;
  }

  /// 채팅 옵션을 표시합니다.
  void _showChatOptions() {
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
            ListTile(
              leading: Icon(Icons.report, color: HandamColors.error),
              title: const Text('신고하기'),
              onTap: () {
                Navigator.pop(context);
                _reportUser();
              },
            ),
            ListTile(
              leading: Icon(Icons.block, color: HandamColors.error),
              title: const Text('차단하기'),
              onTap: () {
                Navigator.pop(context);
                _blockUser();
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: HandamColors.textDefault),
              title: const Text('채팅방 나가기'),
              onTap: () {
                Navigator.pop(context);
                _leaveChatRoom();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 사용자를 신고합니다.
  void _reportUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사용자 신고'),
        content: const Text('이 사용자를 신고하시겠습니까?\n신고된 내용은 검토 후 처리됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 신고 로직 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('신고가 접수되었습니다.')),
              );
            },
            child: const Text('신고'),
          ),
        ],
      ),
    );
  }

  /// 사용자를 차단합니다.
  void _blockUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사용자 차단'),
        content: const Text('이 사용자를 차단하시겠습니까?\n차단하면 더 이상 대화할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 차단 로직 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('사용자가 차단되었습니다.')),
              );
              context.pop();
            },
            child: const Text('차단'),
          ),
        ],
      ),
    );
  }

  /// 채팅방을 나갑니다.
  void _leaveChatRoom() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('채팅방 나가기'),
        content: const Text('정말로 채팅방을 나가시겠습니까?\n나가면 대화 내용을 볼 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('나가기'),
          ),
        ],
      ),
    );
  }

  /// 채팅 만료 처리를 합니다.
  void _handleChatExpired() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('대화 종료'),
        content: const Text('24시간이 지나 대화가 종료되었습니다.\n감사합니다!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}


