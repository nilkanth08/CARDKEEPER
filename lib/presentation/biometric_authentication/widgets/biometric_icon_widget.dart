import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricIconWidget extends StatelessWidget {
  final String biometricType;
  final bool isAuthenticating;
  final bool isLoading;
  final VoidCallback? onTap;

  const BiometricIconWidget({
    Key? key,
    required this.biometricType,
    required this.isAuthenticating,
    required this.isLoading,
    this.onTap,
  }) : super(key: key);

  String _getIconName() {
    switch (biometricType) {
      case 'face':
        return 'face';
      case 'fingerprint':
        return 'fingerprint';
      default:
        return 'security';
    }
  }

  Color _getIconColor() {
    if (isLoading) {
      return AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.6);
    }
    if (isAuthenticating) {
      return AppTheme.lightTheme.colorScheme.primary;
    }
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        height: 25.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: _getIconColor(),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main biometric icon
            CustomIconWidget(
              iconName: _getIconName(),
              color: _getIconColor(),
              size: 12.w,
            ),

            // Loading indicator
            if (isLoading)
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
