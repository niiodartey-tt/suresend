import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/error_retry_widget.dart';
import '../../theme/app_theme.dart';

class TransactionDetailScreen extends StatefulWidget {
  final String transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadTransactionDetails();
  }

  Future<void> _loadTransactionDetails() async {
    final provider = context.read<TransactionProvider>();
    await provider.fetchTransactionDetails(widget.transactionId);
  }

  void _showConfirmDeliveryDialog() {
    showDialog(
      context: context,
      builder: (context) => _ConfirmDeliveryDialog(
        transactionId: widget.transactionId,
        onConfirmed: () {
          _loadTransactionDetails();
        },
      ),
    );
  }

  void _showRaiseDisputeDialog() {
    showDialog(
      context: context,
      builder: (context) => _RaiseDisputeDialog(
        transactionId: widget.transactionId,
        onRaised: () {
          _loadTransactionDetails();
        },
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => _CancelTransactionDialog(
        transactionId: widget.transactionId,
        onCancelled: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final authProvider = context.watch<AuthProvider>();
    final transaction = transactionProvider.currentTransaction;
    final isLoading = transactionProvider.isLoading;

    if (isLoading && transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(
              4,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: SkeletonLoader.card(height: 120),
              ),
            ),
          ),
        ),
      );
    }

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: ErrorRetryWidget.notFound(
          message:
              'Transaction not found. It may have been deleted or you don\'t have access.',
          onRetry: _loadTransactionDetails,
        ),
      );
    }

    final isBuyer = transaction.buyer.id == authProvider.user!.id;
    final isSeller = transaction.seller.id == authProvider.user!.id;
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTransactionDetails,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactionDetails,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status header
              Card(
                color:
                    _getStatusColor(transaction.status).withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        _getStatusIcon(transaction.status),
                        size: 48,
                        color: _getStatusColor(transaction.status),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        transaction.statusDisplay,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(transaction.status),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.transactionRef,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Amount details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Amount Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Transaction Amount'),
                          Text(
                            'GHS ${transaction.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Platform Commission (2%)',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            'GHS ${transaction.commission.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Seller Receives',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'GHS ${transaction.amountAfterCommission.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.payment, color: Colors.blue.shade700),
                            const SizedBox(width: 12),
                            Text(
                              'Payment: ${transaction.paymentMethod.toUpperCase()}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      Text(
                        transaction.description,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Participants
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Participants',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      _ParticipantTile(
                        icon: Icons.shopping_bag,
                        role: 'Buyer',
                        participant: transaction.buyer,
                        isCurrentUser: isBuyer,
                      ),
                      const SizedBox(height: 12),
                      _ParticipantTile(
                        icon: Icons.sell,
                        role: 'Seller',
                        participant: transaction.seller,
                        isCurrentUser: isSeller,
                      ),
                      if (transaction.rider != null) ...[
                        const SizedBox(height: 12),
                        _ParticipantTile(
                          icon: Icons.delivery_dining,
                          role: 'Rider',
                          participant: transaction.rider!,
                          isCurrentUser:
                              transaction.rider!.id == authProvider.user!.id,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Timeline
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Timeline',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      _TimelineItem(
                        icon: Icons.add_circle,
                        title: 'Transaction Created',
                        time: dateFormat.format(transaction.createdAt),
                        isCompleted: true,
                      ),
                      if (transaction.heldAt != null)
                        _TimelineItem(
                          icon: Icons.lock,
                          title: 'Funds Held in Escrow',
                          time: dateFormat.format(transaction.heldAt!),
                          isCompleted: true,
                        ),
                      if (transaction.releasedAt != null)
                        _TimelineItem(
                          icon: Icons.check_circle,
                          title: 'Funds Released to Seller',
                          time: dateFormat.format(transaction.releasedAt!),
                          isCompleted: true,
                        ),
                      if (transaction.refundedAt != null)
                        _TimelineItem(
                          icon: Icons.undo,
                          title: 'Funds Refunded to Buyer',
                          time: dateFormat.format(transaction.refundedAt!),
                          isCompleted: true,
                        ),
                      if (transaction.completedAt != null)
                        _TimelineItem(
                          icon: Icons.done_all,
                          title: 'Transaction Completed',
                          time: dateFormat.format(transaction.completedAt!),
                          isCompleted: true,
                          isLast: true,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              if (isBuyer && transaction.isInEscrow) ...[
                ElevatedButton.icon(
                  onPressed: _showConfirmDeliveryDialog,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Confirm Delivery'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _showRaiseDisputeDialog,
                  icon: const Icon(Icons.report_problem),
                  label: const Text('Raise Dispute'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
              if (isBuyer && transaction.isPending) ...[
                OutlinedButton.icon(
                  onPressed: _showCancelDialog,
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Transaction'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
              if (transaction.isDisputed) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This transaction is disputed. Our team will review and resolve it within 3-5 business days.',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'in_escrow':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'disputed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      case 'refunded':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'in_escrow':
        return Icons.lock;
      case 'completed':
        return Icons.check_circle;
      case 'disputed':
        return Icons.report_problem;
      case 'cancelled':
        return Icons.cancel;
      case 'refunded':
        return Icons.undo;
      default:
        return Icons.help;
    }
  }
}

class _ParticipantTile extends StatelessWidget {
  final IconData icon;
  final String role;
  final TransactionParticipant participant;
  final bool isCurrentUser;

  const _ParticipantTile({
    required this.icon,
    required this.role,
    required this.participant,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: isCurrentUser ? Colors.blue : Colors.grey.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'You',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  participant.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@${participant.username}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (participant.phoneNumber != null)
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: participant.phoneNumber!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone number copied')),
                );
              },
              tooltip: participant.phoneNumber,
            ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final bool isCompleted;
  final bool isLast;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.time,
    this.isCompleted = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              icon,
              color: isCompleted ? Colors.green : Colors.grey,
              size: 24,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isCompleted ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConfirmDeliveryDialog extends StatefulWidget {
  final String transactionId;
  final VoidCallback onConfirmed;

  const _ConfirmDeliveryDialog({
    required this.transactionId,
    required this.onConfirmed,
  });

  @override
  State<_ConfirmDeliveryDialog> createState() => _ConfirmDeliveryDialogState();
}

class _ConfirmDeliveryDialogState extends State<_ConfirmDeliveryDialog> {
  final _notesController = TextEditingController();
  bool _confirmed = true;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<TransactionProvider>();
    final result = await provider.confirmDelivery(
      transactionId: widget.transactionId,
      confirmed: _confirmed,
      notes: _notesController.text,
    );

    if (!mounted) return;

    Navigator.pop(context);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _confirmed
                ? 'Delivery confirmed! Funds released to seller.'
                : 'Delivery rejected. Dispute has been created.',
          ),
          backgroundColor: _confirmed ? Colors.green : Colors.orange,
        ),
      );
      widget.onConfirmed();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Failed to confirm delivery'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delivery'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Have you received the product/service?'),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(_confirmed ? 'Yes, received' : 'No, not received'),
            value: _confirmed,
            onChanged: (value) => setState(() => _confirmed = value),
            activeThumbColor: Colors.green,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'Add any comments...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (!_confirmed) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A dispute will be created for review',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: _confirmed ? Colors.green : Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class _RaiseDisputeDialog extends StatefulWidget {
  final String transactionId;
  final VoidCallback onRaised;

  const _RaiseDisputeDialog({
    required this.transactionId,
    required this.onRaised,
  });

  @override
  State<_RaiseDisputeDialog> createState() => _RaiseDisputeDialogState();
}

class _RaiseDisputeDialogState extends State<_RaiseDisputeDialog> {
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TransactionProvider>();
    final result = await provider.raiseDispute(
      transactionId: widget.transactionId,
      reason: _reasonController.text,
    );

    if (!mounted) return;

    Navigator.pop(context);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Dispute raised successfully. Our team will review it.'),
          backgroundColor: Colors.orange,
        ),
      );
      widget.onRaised();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Failed to raise dispute'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Raise Dispute'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Please describe the issue with this transaction:'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: 'Reason',
                hintText: 'Describe the problem...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a reason';
                }
                if (value.length < 10) {
                  return 'Please provide more details (min 10 characters)';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Our team will review and respond within 3-5 business days',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Raise Dispute'),
        ),
      ],
    );
  }
}

class _CancelTransactionDialog extends StatefulWidget {
  final String transactionId;
  final VoidCallback onCancelled;

  const _CancelTransactionDialog({
    required this.transactionId,
    required this.onCancelled,
  });

  @override
  State<_CancelTransactionDialog> createState() =>
      _CancelTransactionDialogState();
}

class _CancelTransactionDialogState extends State<_CancelTransactionDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<TransactionProvider>();
    final result = await provider.cancelTransaction(
      transactionId: widget.transactionId,
      reason: _reasonController.text,
    );

    if (!mounted) return;

    Navigator.pop(context);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction cancelled successfully'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onCancelled();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Failed to cancel transaction'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancel Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Are you sure you want to cancel this transaction?'),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Reason (optional)',
              hintText: 'Why are you cancelling?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No, Keep It'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Yes, Cancel'),
        ),
      ],
    );
  }
}
