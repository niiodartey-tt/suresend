import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/theme/app_theme.dart';
import 'package:suresend/widgets/pin_confirmation_modal.dart';
import 'package:suresend/screens/success/transaction_confirmation_screen.dart';

/// Transaction Detail Screen
/// Shows complete transaction information with actions
class TransactionDetailScreen extends StatefulWidget {
  final String transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  // Demo transaction data
  late Map<String, dynamic> _transaction;

  @override
  void initState() {
    super.initState();
    _loadTransactionData();
  }

  void _loadTransactionData() {
    // Demo data based on dashboard transactions
    final demoTransactions = {
      'ESC-45823': {
        'id': 'ESC-45823',
        'date': 'Oct 28, 2025, 02:30 PM',
        'amount': 850.00,
        'description': 'MacBook Pro M3',
        'category': 'Physical Product',
        'seller': 'Sarah Johnson',
        'sellerUsername': '@sarahjohnson',
        'buyer': 'John Doe',
        'buyerUsername': '@johndoe',
        'status': 'In Escrow',
        'progress': 50,
      },
      'ESC-45822': {
        'id': 'ESC-45822',
        'date': 'Oct 27, 2025, 10:15 AM',
        'amount': 450.00,
        'description': 'iPhone 14 Pro',
        'category': 'Physical Product',
        'seller': 'Mike Davis',
        'sellerUsername': '@mikedavis',
        'buyer': 'John Doe',
        'buyerUsername': '@johndoe',
        'status': 'Completed',
        'progress': 100,
      },
      'ESC-45821': {
        'id': 'ESC-45821',
        'date': 'Oct 26, 2025, 04:45 PM',
        'amount': 1200.00,
        'description': 'Gaming Console Bundle',
        'category': 'Physical Product',
        'seller': 'Emma Wilson',
        'sellerUsername': '@emmawilson',
        'buyer': 'John Doe',
        'buyerUsername': '@johndoe',
        'status': 'In Progress',
        'progress': 75,
      },
      'ESC-45820': {
        'id': 'ESC-45820',
        'date': 'Oct 25, 2025, 09:20 AM',
        'amount': 2500.00,
        'description': 'Graphic Design Package',
        'category': 'Service',
        'seller': 'Mike Davis',
        'sellerUsername': '@mikedavis',
        'buyer': 'John Doe',
        'buyerUsername': '@johndoe',
        'status': 'Disputed',
        'progress': 50,
      },
    };

    _transaction = demoTransactions[widget.transactionId] ?? {
      'id': widget.transactionId,
      'date': 'Oct 28, 2025, 02:30 PM',
      'amount': 500.00,
      'description': 'Sample Transaction',
      'category': 'Physical Product',
      'seller': 'Seller Name',
      'sellerUsername': '@seller',
      'buyer': 'John Doe',
      'buyerUsername': '@johndoe',
      'status': 'In Escrow',
      'progress': 50,
    };
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return AppColors.success;
      case 'In Escrow':
        return AppColors.primary;
      case 'In Progress':
        return const Color(0xFFF59E0B);
      case 'Disputed':
        return AppColors.error;
      default:
        return AppColors.textMuted;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Completed':
        return Icons.check_circle;
      case 'In Escrow':
        return Icons.lock;
      case 'In Progress':
        return Icons.hourglass_bottom;
      case 'Disputed':
        return Icons.report_problem;
      default:
        return Icons.help;
    }
  }

  void _handleConfirmReceipt() async {
    await PinConfirmationModal.show(
      context: context,
      action: 'Confirm & Release Funds',
      amount: '\$${_transaction['amount'].toStringAsFixed(2)}',
      transactionId: _transaction['id'],
      onConfirm: (pin) {
        // Navigate to confirmation screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionConfirmationScreen(
              title: 'Transaction Confirmed',
              subtitle: 'Funds have been released to the seller',
              transactionId: _transaction['id'],
              amount: '\$${_transaction['amount'].toStringAsFixed(2)}',
              recipient: _transaction['seller'],
              date: _transaction['date'],
              description: _transaction['description'],
              additionalDetails: {
                'Category': _transaction['category'],
                'Seller': '${_transaction['seller']} ${_transaction['sellerUsername']}',
                'Status': 'Completed',
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _transaction['status'];
    final statusColor = _getStatusColor(status);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Navy Blue Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Transaction Detail',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Receipt downloaded')),
                      );
                    },
                    icon: const Icon(Icons.download, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Info Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _transaction['description'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _transaction['category'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '\$${_transaction['amount'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Created',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                _transaction['date'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Transaction Progress
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Transaction Progress',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _transaction['progress'] / 100,
                              minHeight: 8,
                              backgroundColor: AppColors.border,
                              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_transaction['progress']}% Complete',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Participants Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Participants',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildParticipantRow(
                            icon: Icons.shopping_bag,
                            role: 'Buyer',
                            name: _transaction['buyer'],
                            username: _transaction['buyerUsername'],
                            isYou: true,
                          ),
                          const Divider(height: 24),
                          _buildParticipantRow(
                            icon: Icons.sell,
                            role: 'Seller',
                            name: _transaction['seller'],
                            username: _transaction['sellerUsername'],
                            isYou: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Payment Details
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Transaction ID', _transaction['id']),
                          const SizedBox(height: 12),
                          _buildDetailRow('Payment Method', 'Wallet'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Platform Fee', '\$5.00'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Activity Log
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Activity Log',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildActivityItem(
                            'Transaction Created',
                            _transaction['date'],
                            true,
                          ),
                          if (status == 'In Escrow' || status == 'In Progress' || status == 'Completed')
                            _buildActivityItem(
                              'Funds Held in Escrow',
                              _transaction['date'],
                              true,
                            ),
                          if (status == 'Completed')
                            _buildActivityItem(
                              'Funds Released to Seller',
                              _transaction['date'],
                              true,
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    if (status == 'In Escrow') ...[
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _handleConfirmReceipt,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle),
                          label: const Text(
                            'Confirm & Release Funds',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dispute raised. Our team will review it.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.report_problem),
                          label: const Text(
                            'Raise Dispute',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantRow({
    required IconData icon,
    required String role,
    required String name,
    required String username,
    required bool isYou,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (isYou) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
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
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, bool completed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? AppColors.success : AppColors.textMuted,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: completed ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
