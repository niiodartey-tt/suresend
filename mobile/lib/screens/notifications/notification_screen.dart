import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:suresend/theme/app_theme.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification.dart' as app_notification;
import '../../widgets/skeleton_loader.dart';
import '../../widgets/error_retry_widget.dart';
import 'package:suresend/theme/app_animations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialLoading = true;
  bool _hasError = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final provider = context.read<NotificationProvider>();
      if (!provider.isLoading && provider.hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadNotifications() async {
    if (mounted) {
      setState(() {
        _hasError = false;
      });
    }

    try {
      final provider = context.read<NotificationProvider>();
      await provider.fetchNotifications(refresh: true);

      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    final provider = context.read<NotificationProvider>();
    await provider.fetchNotifications();
  }

  Future<void> _markAllAsRead() async {
    final provider = context.read<NotificationProvider>();
    final success = await provider.markAllAsRead();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'All notifications marked as read'
              : 'Failed to mark as read',
        ),
        backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();
    final allNotifications = notificationProvider.notifications;
    final unreadCount = notificationProvider.unreadCount;

    // Filter notifications based on search query
    final notifications = _searchQuery.isEmpty
        ? allNotifications
        : allNotifications.where((n) {
            return n.title.toLowerCase().contains(_searchQuery) ||
                   n.message.toLowerCase().contains(_searchQuery) ||
                   n.type.toLowerCase().contains(_searchQuery);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          if (unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
              onPressed: _markAllAsRead,
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notifications...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
            ),
          ),

          // Notifications List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadNotifications,
              color: AppTheme.primaryColor,
              child: _buildBody(notificationProvider, notifications),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    NotificationProvider notificationProvider,
    List<app_notification.Notification> notifications,
  ) {
    // Show skeleton loaders on initial load
    if (_isInitialLoading && notifications.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => const SkeletonNotificationCard(),
      );
    }

    // Show error state with retry
    if (_hasError && notifications.isEmpty) {
      return ErrorRetryWidget.network(
        message:
            'Failed to load notifications. Please check your connection and try again.',
        onRetry: _loadNotifications,
      );
    }

    // Show empty state
    if (notifications.isEmpty && !notificationProvider.isLoading) {
      if (_searchQuery.isNotEmpty) {
        // Show search-specific empty state
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No notifications found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }
      return const EmptyStateWidget.notifications();
    }

    // Show notification list with animations
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length + (notificationProvider.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == notifications.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
          );
        }

        final notification = notifications[index];
        return AnimatedListItem(
          index: index,
          child: _NotificationCard(
            notification: notification,
            onTap: () => _handleNotificationTap(notification),
            onDelete: () => _deleteNotification(notification.id),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll be notified about transactions and updates',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _handleNotificationTap(
      app_notification.Notification notification) async {
    final provider = context.read<NotificationProvider>();

    // Mark as read if not already read
    if (!notification.isRead) {
      await provider.markAsRead(notification.id);
    }

    // TODO: Navigate to relevant screen based on notification type
    // For example, if it's a transaction notification, navigate to transaction detail
  }

  Future<void> _deleteNotification(String notificationId) async {
    final provider = context.read<NotificationProvider>();
    final success = await provider.deleteNotification(notificationId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Notification deleted' : 'Failed to delete notification',
        ),
        backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final app_notification.Notification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  Color _getTypeColor() {
    switch (notification.type) {
      case 'transaction':
        return Colors.blue;
      case 'delivery':
        return Colors.orange;
      case 'dispute':
        return Colors.red;
      case 'system':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case 'transaction':
        return Icons.account_balance_wallet;
      case 'delivery':
        return Icons.local_shipping;
      case 'dispute':
        return Icons.warning;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Notification'),
            content: const Text(
                'Are you sure you want to delete this notification?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: notification.isRead ? Colors.white : Colors.blue.shade50,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTypeColor().withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getTypeIcon(),
                    color: _getTypeColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(notification.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
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
