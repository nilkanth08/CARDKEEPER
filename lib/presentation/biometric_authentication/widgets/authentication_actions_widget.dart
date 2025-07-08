import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthenticationActionsWidget extends StatelessWidget {
  final bool isLoading;
  final bool isCooldownActive;
  final int failedAttempts;
  final VoidCallback onUsePinInstead;
  final VoidCallback onRetry;

  const AuthenticationActionsWidget({
    Key? key,
    required this.isLoading,
    required this.isCooldownActive,
    required this.failedAttempts,
    required this.onUsePinInstead,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Use PIN Instead button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onUsePinInstead,
            icon: CustomIconWidget(
              iconName: 'pin',
              color: isLoading
                  ? AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.4)
                  : AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text(
              'Use PIN Instead',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: isLoading
                    ? AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.4)
                    : AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLoading
                  ? AppTheme.lightTheme.colorScheme.surface
                  : AppTheme.lightTheme.colorScheme.primary,
              elevation: isLoading ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Retry button (shown after failed attempts)
        if (failedAttempts > 0 && !isCooldownActive)
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onRetry,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: isLoading
                    ? AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.4)
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              label: Text(
                'Try Again',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: isLoading
                      ? AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.4)
                      : AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isLoading
                      ? AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.4)
                      : AppTheme.lightTheme.colorScheme.primary,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

        SizedBox(height: 3.h),

        // Help text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              'Having trouble? Use PIN to access',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Failed attempts indicator
        if (failedAttempts > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.errorContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Failed attempts: $failedAttempts/3',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
