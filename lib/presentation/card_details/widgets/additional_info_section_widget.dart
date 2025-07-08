import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdditionalInfoSectionWidget extends StatefulWidget {
  final Map<String, dynamic> cardData;
  final bool isEditMode;
  final Map<String, TextEditingController> controllers;

  const AdditionalInfoSectionWidget({
    Key? key,
    required this.cardData,
    required this.isEditMode,
    required this.controllers,
  }) : super(key: key);

  @override
  State<AdditionalInfoSectionWidget> createState() =>
      _AdditionalInfoSectionWidgetState();
}

class _AdditionalInfoSectionWidgetState
    extends State<AdditionalInfoSectionWidget> {
  bool isPinVisible = false;
  bool isStatementPasswordVisible = false;

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
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Additional Information',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // PIN Field
          _buildSecureField(
            context,
            label: 'Card PIN',
            value: widget.cardData["pin"] ?? "",
            controller: widget.controllers['pin'],
            icon: 'lock',
            isVisible: isPinVisible,
            onToggleVisibility: () {
              setState(() {
                isPinVisible = !isPinVisible;
              });
              if (isPinVisible) {
                _autoHideAfterDelay(() {
                  if (mounted) {
                    setState(() {
                      isPinVisible = false;
                    });
                  }
                });
              }
            },
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),

          SizedBox(height: 2.h),

          // IFSC Code
          _buildInfoField(
            context,
            label: 'IFSC Code',
            value: widget.cardData["ifscCode"] ?? "",
            controller: widget.controllers['ifscCode'],
            icon: 'account_balance',
            canCopy: true,
          ),

          SizedBox(height: 2.h),

          // Statement Password
          _buildSecureField(
            context,
            label: 'Statement Password',
            value: widget.cardData["statementPassword"] ?? "",
            controller: widget.controllers['statementPassword'],
            icon: 'password',
            isVisible: isStatementPasswordVisible,
            onToggleVisibility: () {
              setState(() {
                isStatementPasswordVisible = !isStatementPasswordVisible;
              });
              if (isStatementPasswordVisible) {
                _autoHideAfterDelay(() {
                  if (mounted) {
                    setState(() {
                      isStatementPasswordVisible = false;
                    });
                  }
                });
              }
            },
          ),

          SizedBox(height: 2.h),

          // Birth Date (if available)
          if (widget.cardData["birthDate"] != null)
            _buildInfoField(
              context,
              label: 'Birth Date (Reference)',
              value: widget.cardData["birthDate"] ?? "",
              controller: null,
              icon: 'cake',
              isReadOnly: true,
            ),
        ],
      ),
    );
  }

  Widget _buildSecureField(
    BuildContext context, {
    required String label,
    required String value,
    TextEditingController? controller,
    required String icon,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: widget.isEditMode && controller != null
              ? TextFormField(
                  controller: controller,
                  obscureText: !isVisible,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomIconWidget(
                        iconName: icon,
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 20,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: onToggleVisibility,
                      icon: CustomIconWidget(
                        iconName: isVisible ? 'visibility_off' : 'visibility',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    counterText: '',
                  ),
                  style: AppTheme.getDataTextStyle(
                    isLight: true,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: icon,
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          isVisible ? value : _maskValue(value),
                          style: AppTheme.getDataTextStyle(
                            isLight: true,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: onToggleVisibility,
                            icon: CustomIconWidget(
                              iconName:
                                  isVisible ? 'visibility_off' : 'visibility',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 18,
                            ),
                          ),
                          if (isVisible)
                            IconButton(
                              onPressed: () =>
                                  _copyToClipboard(context, value, label),
                              icon: CustomIconWidget(
                                iconName: 'copy',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
        if (isVisible)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.warningLight,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Sensitive information visible - will auto-hide in 3 seconds',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.warningLight,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoField(
    BuildContext context, {
    required String label,
    required String value,
    TextEditingController? controller,
    required String icon,
    bool isReadOnly = false,
    bool canCopy = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: widget.isEditMode && controller != null && !isReadOnly
              ? TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomIconWidget(
                        iconName: icon,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: icon,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          value.isEmpty
                              ? 'Not provided'
                              : _formatValue(label, value),
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: value.isEmpty
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (canCopy && value.isNotEmpty)
                        IconButton(
                          onPressed: () =>
                              _copyToClipboard(context, value, label),
                          icon: CustomIconWidget(
                            iconName: 'copy',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  String _maskValue(String value) {
    if (value.isEmpty) return 'Not provided';
    return '•' * value.length;
  }

  String _formatValue(String label, String value) {
    if (label.contains('Birth Date')) {
      return _formatDate(value);
    }
    return value;
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

  void _autoHideAfterDelay(VoidCallback callback) {
    Future.delayed(Duration(seconds: 3), callback);
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label copied to clipboard'),
          duration: Duration(seconds: 2),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );

      // Clear clipboard after 30 seconds for security
      Future.delayed(Duration(seconds: 30), () {
        Clipboard.setData(ClipboardData(text: ''));
      });
    }
  }
}
