import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentStatusSectionWidget extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final Function(String) onStatusUpdate;

  const PaymentStatusSectionWidget({
    Key? key,
    required this.cardData,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentStatus = cardData["paymentStatus"] ?? "Unpaid";
    final String lastPaymentDate = cardData["lastPaymentDate"] ?? "";
    final String dueDate = cardData["dueDate"] ?? "";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'payment',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Payment Status',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Current Status Display
          _buildCurrentStatusDisplay(context, currentStatus),

          SizedBox(height: 3.h),

          // Payment Dates
          Row(
            children: [
              Expanded(
                child: _buildDateInfo(
                  context,
                  label: 'Last Payment',
                  date: lastPaymentDate,
                  icon: 'history',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildDateInfo(
                  context,
                  label: 'Due Date',
                  date: dueDate,
                  icon: 'schedule',
                  isUrgent: _isDateUrgent(dueDate),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Status Toggle Buttons
          _buildStatusToggleButtons(context, currentStatus),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusDisplay(BuildContext context, String status) {
    final Color statusColor = AppTheme.getStatusColor(status);
    final IconData statusIcon = _getStatusIcon(status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            status.toUpperCase(),
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: statusColor,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _getStatusDescription(status),
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(
    BuildContext context, {
    required String label,
    required String date,
    required String icon,
    bool isUrgent = false,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isUrgent
            ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUrgent
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: isUrgent
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isUrgent
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            _formatDate(date),
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isUrgent
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggleButtons(BuildContext context, String currentStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Status',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            Expanded(
              child: _buildStatusButton(
                context,
                status: 'Paid',
                isSelected: currentStatus == 'Paid',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                icon: 'check_circle',
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildStatusButton(
                context,
                status: 'Partial',
                isSelected: currentStatus == 'Partial',
                color: AppTheme.warningLight,
                icon: 'schedule',
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildStatusButton(
                context,
                status: 'Unpaid',
                isSelected: currentStatus == 'Unpaid',
                color: AppTheme.lightTheme.colorScheme.error,
                icon: 'cancel',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusButton(
    BuildContext context, {
    required String status,
    required bool isSelected,
    required Color color,
    required String icon,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onStatusUpdate(status);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected ? Colors.white : color,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              status,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle;
      case 'partial':
        return Icons.schedule;
      case 'unpaid':
      default:
        return Icons.cancel;
    }
  }

  String _getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Payment completed successfully';
      case 'partial':
        return 'Partial payment made';
      case 'unpaid':
      default:
        return 'Payment pending';
    }
  }

  bool _isDateUrgent(String dateString) {
    if (dateString.isEmpty) return false;

    try {
      final dueDate = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = dueDate.difference(now).inDays;
      return difference <= 3 && difference >= 0;
    } catch (e) {
      return false;
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Not set';

    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
