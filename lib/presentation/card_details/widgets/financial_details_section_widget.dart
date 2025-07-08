import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FinancialDetailsSectionWidget extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final bool isEditMode;
  final Map<String, TextEditingController> controllers;

  const FinancialDetailsSectionWidget({
    Key? key,
    required this.cardData,
    required this.isEditMode,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cardLimit = (cardData["cardLimit"] as num?)?.toDouble() ?? 0.0;
    final double billAmount =
        (cardData["billAmount"] as num?)?.toDouble() ?? 0.0;
    final double availableCredit = cardLimit - billAmount;
    final double utilizationPercentage =
        cardLimit > 0 ? (billAmount / cardLimit) * 100 : 0;

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
                iconName: 'account_balance_wallet',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Financial Details',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Card Limit
          _buildFinancialField(
            context,
            label: 'Card Limit',
            value: '\$${cardLimit.toStringAsFixed(2)}',
            controller: controllers['cardLimit'],
            icon: 'credit_score',
            color: AppTheme.lightTheme.colorScheme.primary,
          ),

          SizedBox(height: 2.h),

          // Current Bill Amount
          _buildFinancialField(
            context,
            label: 'Current Bill Amount',
            value: '\$${billAmount.toStringAsFixed(2)}',
            controller: controllers['billAmount'],
            icon: 'receipt_long',
            color: _getBillAmountColor(utilizationPercentage),
          ),

          SizedBox(height: 2.h),

          // Available Credit
          _buildFinancialField(
            context,
            label: 'Available Credit',
            value: '\$${availableCredit.toStringAsFixed(2)}',
            controller: null,
            icon: 'savings',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            isReadOnly: true,
          ),

          SizedBox(height: 3.h),

          // Credit Utilization Bar
          _buildCreditUtilizationBar(context, utilizationPercentage),

          SizedBox(height: 2.h),

          // Bill Dates
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  context,
                  label: 'Bill Date',
                  value: cardData["billDate"] ?? "",
                  icon: 'calendar_today',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildDateField(
                  context,
                  label: 'Due Date',
                  value: cardData["dueDate"] ?? "",
                  icon: 'event',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialField(
    BuildContext context, {
    required String label,
    required String value,
    TextEditingController? controller,
    required String icon,
    required Color color,
    bool isReadOnly = false,
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
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: isEditMode && controller != null && !isReadOnly
              ? TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomIconWidget(
                        iconName: icon,
                        color: color,
                        size: 20,
                      ),
                    ),
                    prefixText: '\$ ',
                    prefixStyle: AppTheme.getDataTextStyle(
                      isLight: true,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ).copyWith(color: color),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  style: AppTheme.getDataTextStyle(
                    isLight: true,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ).copyWith(color: color),
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
                        color: color,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        value,
                        style: AppTheme.getDataTextStyle(
                          isLight: true,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ).copyWith(color: color),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required String value,
    required String icon,
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
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 1.5.h,
          ),
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
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  _formatDate(value),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreditUtilizationBar(BuildContext context, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Credit Utilization',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _getUtilizationColor(percentage),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (percentage / 100).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: _getUtilizationColor(percentage),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getBillAmountColor(double utilizationPercentage) {
    if (utilizationPercentage >= 80) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (utilizationPercentage >= 50) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }
  }

  Color _getUtilizationColor(double percentage) {
    if (percentage >= 80) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (percentage >= 50) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.lightTheme.colorScheme.tertiary;
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
