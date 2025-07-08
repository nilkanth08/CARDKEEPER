import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReminderCardWidget extends StatelessWidget {
  final Map<String, dynamic> reminder;
  final String dueDateText;
  final VoidCallback onTap;
  final Function(String) onQuickAction;

  const ReminderCardWidget({
    super.key,
    required this.reminder,
    required this.dueDateText,
    required this.onTap,
    required this.onQuickAction,
  });

  Color _getStatusColor() {
    final status = reminder["status"] as String;
    switch (status.toLowerCase()) {
      case 'paid':
        return AppTheme.successLight;
      case 'overdue':
        return AppTheme.errorLight;
      default:
        return AppTheme.warningLight;
    }
  }

  Widget _buildQuickActions() {
    return Container(
      width: 60.w,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionButton(
            'Mark as Paid',
            Icons.check_circle,
            AppTheme.successLight,
            () => onQuickAction('mark_paid'),
          ),
          Divider(height: 1),
          _buildActionButton(
            'Snooze 1 Day',
            Icons.snooze,
            AppTheme.warningLight,
            () => onQuickAction('snooze_1'),
          ),
          Divider(height: 1),
          _buildActionButton(
            'Snooze 3 Days',
            Icons.snooze,
            AppTheme.warningLight,
            () => onQuickAction('snooze_3'),
          ),
          Divider(height: 1),
          _buildActionButton(
            'Snooze 1 Week',
            Icons.snooze,
            AppTheme.warningLight,
            () => onQuickAction('snooze_7'),
          ),
          Divider(height: 1),
          _buildActionButton(
            'Edit Amount',
            Icons.edit,
            AppTheme.primaryLight,
            () => onQuickAction('edit_amount'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon.toString().split('.').last,
              color: color,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = reminder["status"] == "overdue";
    final statusColor = _getStatusColor();

    return Dismissible(
      key: Key(reminder["id"].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.only(left: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'swipe_right',
              color: AppTheme.primaryLight,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: _buildQuickActions(),
            ),
          );
        }
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: isOverdue
                ? Border.all(color: AppTheme.errorLight, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Bank Logo
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CustomImageWidget(
                      imageUrl: reminder["bankLogo"] as String,
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Card Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder["cardName"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${reminder["cardType"]} •••• ${reminder["lastFourDigits"]}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Text(
                            reminder["billAmount"] as String,
                            style: AppTheme.getDataTextStyle(
                              isLight: true,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              dueDateText,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Indicator
                Container(
                  width: 3.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(2),
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
