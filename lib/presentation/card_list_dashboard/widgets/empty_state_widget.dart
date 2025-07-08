import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddCard;

  const EmptyStateWidget({
    super.key,
    required this.onAddCard,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(),
            SizedBox(height: 4.h),
            Text(
              'No Cards Added Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start by adding your first payment card to keep track of bills and due dates.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: onAddCard,
              icon: CustomIconWidget(
                iconName: 'add_card',
                size: 20,
                color: AppTheme
                    .lightTheme.elevatedButtonTheme.style?.foregroundColor
                    ?.resolve({}),
              ),
              label: Text('Add Your First Card'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: () {
                // Show help or tutorial
                _showHelpDialog(context);
              },
              icon: CustomIconWidget(
                iconName: 'help_outline',
                size: 18,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              label: Text('How it works'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 60.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'credit_card',
              size: 40,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 40.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 20.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'info_outline',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Text('How CardKeeper Works'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              icon: 'add_card',
              title: 'Add Cards',
              description:
                  'Store your credit and debit card information securely',
            ),
            SizedBox(height: 2.h),
            _buildHelpItem(
              icon: 'notifications',
              title: 'Set Reminders',
              description: 'Get notified before payment due dates',
            ),
            SizedBox(height: 2.h),
            _buildHelpItem(
              icon: 'track_changes',
              title: 'Track Payments',
              description: 'Monitor payment status with color-coded indicators',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            size: 16,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
