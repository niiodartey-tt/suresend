import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String transactionId;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.transactionId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final bool _isTyping = false;

  // Dummy messages for demo
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'senderId': 'user1',
      'text': "Hi, I'm interested in your product",
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
    },
    {
      'id': '2',
      'senderId': 'user2',
      'text': "Great! The product is still available",
      'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
    },
    {
      'id': '3',
      'senderId': 'user1',
      'text': "What's the best price you can offer?",
      'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userName),
            Text(
              'TRX: ${widget.transactionId}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['senderId'] == widget.userId;

                return _MessageBubble(
                  message: message['text'],
                  isMe: isMe,
                  timestamp: message['timestamp'],
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingS),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: const _TypingIndicator(),
                  ),
                ],
              ),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file_rounded),
              onPressed: () {
                // Handle attachment
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                ),
                maxLines: 4,
                minLines: 1,
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Send message
                  if (_messageController.text.isNotEmpty) {
                    // Handle send message
                    _messageController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime timestamp;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingS,
            ),
            decoration: BoxDecoration(
              color: isMe ? AppTheme.primary : Colors.grey[200],
              borderRadius: BorderRadius.circular(AppTheme.radiusM).copyWith(
                bottomRight: isMe ? Radius.zero : null,
                bottomLeft: !isMe ? Radius.zero : null,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: isMe ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  index * 0.2,
                  0.6 + index * 0.2,
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}
