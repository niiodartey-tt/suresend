import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/theme.dart';

/// Message Chat Screen
/// Matches ui_references/message_chat.png
class MessageChatScreen extends StatefulWidget {
  final String transactionId;
  final String counterpartyName;
  final String itemName;

  const MessageChatScreen({
    super.key,
    required this.transactionId,
    required this.counterpartyName,
    this.itemName = 'MacBook Pro M3',
  });

  @override
  State<MessageChatScreen> createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hi! I\'m interested in this item.',
      isMe: false,
      timestamp: '10:30 AM',
    ),
    ChatMessage(
      text: 'Great! It\'s in perfect condition.',
      isMe: true,
      timestamp: '10:32 AM',
    ),
    ChatMessage(
      text: 'I\'ve sent the payment to escrow.',
      isMe: false,
      timestamp: '10:35 AM',
    ),
    ChatMessage(
      text: 'Perfect! I\'ll ship it today.',
      isMe: true,
      timestamp: '10:36 AM',
    ),
    ChatMessage(
      text: 'When can I expect delivery?',
      isMe: false,
      timestamp: '10:38 AM',
    ),
    ChatMessage(
      text: 'Should arrive in 2-3 business days.',
      isMe: true,
      timestamp: '10:40 AM',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isMe: true,
          timestamp: _formatTime(DateTime.now()),
        ),
      );
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            // User Avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accentBackground,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.counterpartyName.substring(0, 2).toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.itemName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primaryForeground,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Online',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryForeground
                              .withValues(alpha: 0.8),
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Transaction ID Badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            color: AppColors.accentBackground,
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.transactionId,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),

          // Typing Indicator (optional)
          // _buildTypingIndicator(),

          // Message Input
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Row(
                children: [
                  // Attach button
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      // Handle attachment
                    },
                    color: AppColors.textMuted,
                  ),

                  // Text input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),

                  // Send button
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _handleSendMessage,
                      color: AppColors.primaryForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.accentBackground,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.counterpartyName.substring(0, 1).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: message.isMe
                        ? AppColors.primary
                        : AppColors.card,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                      bottomRight: Radius.circular(message.isMe ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: message.isMe
                              ? AppColors.primaryForeground
                              : AppColors.textPrimary,
                        ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.timestamp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
          if (message.isMe) const SizedBox(width: 40),
          if (!message.isMe) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.counterpartyName.substring(0, 1).toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppTheme.modalBorderRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(),
                const SizedBox(width: 4),
                _buildDot(),
                const SizedBox(width: 4),
                _buildDot(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.textMuted,
        shape: BoxShape.circle,
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
