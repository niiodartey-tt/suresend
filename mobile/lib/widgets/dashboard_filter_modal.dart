import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/theme.dart';

/// Dashboard Filter Modal
/// Matches ui_references/dashboard_filter.png
class DashboardFilterModal extends StatefulWidget {
  final Function(DashboardFilters) onApply;

  const DashboardFilterModal({
    super.key,
    required this.onApply,
  });

  @override
  State<DashboardFilterModal> createState() => _DashboardFilterModalState();
}

class _DashboardFilterModalState extends State<DashboardFilterModal> {
  String? _selectedStatus;
  String? _selectedType;
  DateTimeRange? _selectedDateRange;
  double _minAmount = 0;
  double _maxAmount = 10000;

  final List<String> _statusOptions = [
    'All',
    'In Escrow',
    'Completed',
    'In Progress',
    'Disputed',
  ];

  final List<String> _typeOptions = [
    'All',
    'Buying',
    'Selling',
  ];

  void _handleApply() {
    final filters = DashboardFilters(
      status: _selectedStatus,
      type: _selectedType,
      dateRange: _selectedDateRange,
      minAmount: _minAmount,
      maxAmount: _maxAmount,
    );

    widget.onApply(filters);
    Navigator.of(context).pop();
  }

  void _handleReset() {
    setState(() {
      _selectedStatus = null;
      _selectedType = null;
      _selectedDateRange = null;
      _minAmount = 0;
      _maxAmount = 10000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Transactions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: AppColors.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Status Filter
              Text(
                'Status',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _statusOptions.map((status) {
                  final isSelected = _selectedStatus == status;
                  return FilterChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = selected ? status : null;
                      });
                    },
                    backgroundColor: AppColors.background,
                    selectedColor: AppColors.accentBackground,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Type Filter
              Text(
                'Transaction Type',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _typeOptions.map((type) {
                  final isSelected = _selectedType == type;
                  return FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedType = selected ? type : null;
                      });
                    },
                    backgroundColor: AppColors.background,
                    selectedColor: AppColors.accentBackground,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Date Range Filter
              Text(
                'Date Range',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    setState(() {
                      _selectedDateRange = picked;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  _selectedDateRange != null
                      ? '${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}'
                      : 'Select Date Range',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Amount Range Filter
              Text(
                'Amount Range',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '\$${_minAmount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: RangeValues(_minAmount, _maxAmount),
                      min: 0,
                      max: 10000,
                      divisions: 100,
                      activeColor: AppColors.primary,
                      onChanged: (values) {
                        setState(() {
                          _minAmount = values.start;
                          _maxAmount = values.end;
                        });
                      },
                    ),
                  ),
                  Text(
                    '\$${_maxAmount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleReset,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _handleApply,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dashboard Filters Model
class DashboardFilters {
  final String? status;
  final String? type;
  final DateTimeRange? dateRange;
  final double minAmount;
  final double maxAmount;

  DashboardFilters({
    this.status,
    this.type,
    this.dateRange,
    required this.minAmount,
    required this.maxAmount,
  });
}

/// Helper function to show dashboard filter modal
Future<DashboardFilters?> showDashboardFilterModal(BuildContext context) {
  return showModalBottomSheet<DashboardFilters>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DashboardFilterModal(
      onApply: (filters) {
        // Filters will be returned
      },
    ),
  );
}
