import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsSectionWidget extends StatelessWidget {
  final Map<String, dynamic> cardData;

  const QuickActionsSectionWidget({
    Key? key,
    required this.cardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                iconName: 'flash_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Quick Actions',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Action Buttons Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 2.5,
            children: [
              _buildActionButton(
                context,
                title: 'Set Reminder',
                icon: 'alarm',
                color: AppTheme.lightTheme.colorScheme.primary,
                onTap: () => _showReminderDialog(context),
              ),
              _buildActionButton(
                context,
                title: 'View Statement',
                icon: 'description',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                onTap: () => _viewStatement(context),
              ),
              _buildActionButton(
                context,
                title: 'Share Details',
                icon: 'share',
                color: AppTheme.warningLight,
                onTap: () => _shareDetails(context),
              ),
              _buildActionButton(
                context,
                title: 'Payment History',
                icon: 'history',
                color: AppTheme.lightTheme.colorScheme.secondary,
                onTap: () => _viewPaymentHistory(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'alarm',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Set Reminder',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose when you want to be reminded about your payment:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildReminderOption(
                context,
                title: '1 day before due date',
                subtitle: _calculateReminderDate(1),
                onTap: () => _setReminder(context, 1),
              ),
              _buildReminderOption(
                context,
                title: '3 days before due date',
                subtitle: _calculateReminderDate(3),
                onTap: () => _setReminder(context, 3),
              ),
              _buildReminderOption(
                context,
                title: '1 week before due date',
                subtitle: _calculateReminderDate(7),
                onTap: () => _setReminder(context, 7),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReminderOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CustomIconWidget(
        iconName: 'schedule',
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 20,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }

  void _setReminder(BuildContext context, int daysBefore) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for $daysBefore day(s) before due date'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        action: SnackBarAction(
          label: 'View Reminders',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/payment-reminders');
          },
        ),
      ),
    );
  }

  void _viewStatement(BuildContext context) {
    if (cardData["frontImageUrl"] != null || cardData["backImageUrl"] != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'description',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Statement Options',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'download',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  title: Text('Download Statement'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showSnackBar(context, 'Statement download started');
                  },
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'email',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 20,
                  ),
                  title: Text('Email Statement'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showSnackBar(
                        context, 'Statement sent to registered email');
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else {
      _showSnackBar(context, 'No statement images available');
    }
  }

  void _shareDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'share',
                color: AppTheme.warningLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Share Card Details',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.warningLight.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      color: AppTheme.warningLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Only basic card information will be shared. Sensitive data like PIN and CVV will be excluded.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Choose sharing method:',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackBar(context, 'Card details prepared for sharing');
              },
              child: Text('Share'),
            ),
          ],
        );
      },
    );
  }

  void _viewPaymentHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Payment History',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHistoryItem(
                  context,
                  date: '2024-01-10',
                  amount: '\$500.00',
                  status: 'Paid',
                ),
                _buildHistoryItem(
                  context,
                  date: '2023-12-10',
                  amount: '\$750.00',
                  status: 'Paid',
                ),
                _buildHistoryItem(
                  context,
                  date: '2023-11-10',
                  amount: '\$300.00',
                  status: 'Partial',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistoryItem(
    BuildContext context, {
    required String date,
    required String amount,
    required String status,
  }) {
    final Color statusColor = AppTheme.getStatusColor(status);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(date),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  amount,
                  style: AppTheme.getDataTextStyle(
                    isLight: true,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              status,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateReminderDate(int daysBefore) {
    try {
      final dueDate = DateTime.parse(cardData["dueDate"] ?? "");
      final reminderDate = dueDate.subtract(Duration(days: daysBefore));
      return _formatDate(reminderDate.toString());
    } catch (e) {
      return 'Invalid due date';
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
