import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final int tabIndex;
  final VoidCallback onAddReminder;

  const EmptyStateWidget({
    super.key,
    required this.tabIndex,
    required this.onAddReminder,
  });

  Map<String, dynamic> _getEmptyStateContent() {
    switch (tabIndex) {
      case 0: // Upcoming
        return {
          'icon': 'schedule',
          'title': 'No Upcoming Payments',
          'subtitle':
              'You\'re all caught up! No payments due in the near future.',
          'buttonText': 'Add New Card',
          'showButton': true,
        };
      case 1: // Overdue
        return {
          'icon': 'celebration',
          'title': 'All Caught Up!',
          'subtitle': 'Great job! You have no overdue payments.',
          'buttonText': '',
          'showButton': false,
        };
      case 2: // Paid
        return {
          'icon': 'check_circle',
          'title': 'No Paid Bills',
          'subtitle':
              'Paid bills will appear here once you mark them as complete.',
          'buttonText': '',
          'showButton': false,
        };
      case 3: // All
      default:
        return {
          'icon': 'credit_card',
          'title': 'No Payment Reminders',
          'subtitle':
              'Add your first card to start tracking payment reminders.',
          'buttonText': 'Add Your First Card',
          'showButton': true,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _getEmptyStateContent();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
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
              child: Center(
                child: CustomIconWidget(
                  iconName: content['icon'] as String,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              content['title'] as String,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              content['subtitle'] as String,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (content['showButton'] as bool) ...[
              SizedBox(height: 4.h),
              ElevatedButton(
                onPressed: onAddReminder,
                child: Text(content['buttonText'] as String),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
