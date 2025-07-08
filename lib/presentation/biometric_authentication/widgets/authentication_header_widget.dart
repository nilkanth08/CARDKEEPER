import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthenticationHeaderWidget extends StatelessWidget {
  const AuthenticationHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App logo with security badge
        Stack(
          alignment: Alignment.center,
          children: [
            // Main logo container
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'credit_card',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 10.w,
              ),
            ),

            // Security badge indicator
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'shield',
                  color: AppTheme.lightTheme.colorScheme.onTertiary,
                  size: 3.w,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // App name
        Text(
          'CardKeeper',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 0.5.h),

        // Security subtitle
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              'Secure Access',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
