import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CardInfoSectionWidget extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final bool isEditMode;
  final Map<String, TextEditingController> controllers;

  const CardInfoSectionWidget({
    Key? key,
    required this.cardData,
    required this.isEditMode,
    required this.controllers,
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
                iconName: 'credit_card',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Card Information',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Cardholder Name
          _buildInfoField(
            context,
            label: 'Cardholder Name',
            value: cardData["cardholderName"] ?? "",
            controller: controllers['cardholderName'],
            icon: 'person',
          ),

          SizedBox(height: 2.h),

          // Bank Name
          _buildInfoField(
            context,
            label: 'Bank Name',
            value: cardData["bankName"] ?? "",
            controller: controllers['bankName'],
            icon: 'account_balance',
          ),

          SizedBox(height: 2.h),

          // Card Type and Variant
          Row(
            children: [
              Expanded(
                child: _buildInfoField(
                  context,
                  label: 'Card Type',
                  value: cardData["cardType"] ?? "",
                  controller: null,
                  icon: 'category',
                  isReadOnly: true,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildInfoField(
                  context,
                  label: 'Card Variant',
                  value: cardData["cardVariant"] ?? "",
                  controller: controllers['cardVariant'],
                  icon: 'stars',
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Card Number
          _buildCardNumberField(context),

          SizedBox(height: 2.h),

          // Expiry and CVV
          Row(
            children: [
              Expanded(
                child: _buildInfoField(
                  context,
                  label: 'Expiry Date',
                  value: cardData["expiryDate"] ?? "",
                  controller: controllers['expiryDate'],
                  icon: 'date_range',
                  keyboardType: TextInputType.datetime,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildInfoField(
                  context,
                  label: 'CVV',
                  value: cardData["cvv"] ?? "",
                  controller: controllers['cvv'],
                  icon: 'security',
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Mobile Number
          _buildInfoField(
            context,
            label: 'Mobile Number',
            value: cardData["mobileNumber"] ?? "",
            controller: controllers['mobileNumber'],
            icon: 'phone',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(
    BuildContext context, {
    required String label,
    required String value,
    TextEditingController? controller,
    required String icon,
    bool isReadOnly = false,
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
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: isEditMode && controller != null && !isReadOnly
              ? TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
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
                    counterText: '',
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
                          value.isEmpty ? 'Not provided' : value,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: value.isEmpty
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCardNumberField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Number',
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
          child: isEditMode
              ? TextFormField(
                  controller: controllers['cardNumber'],
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    _CardNumberInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomIconWidget(
                        iconName: 'credit_card',
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
                  style: AppTheme.getDataTextStyle(
                    isLight: true,
                    fontSize: 14.sp,
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
                        iconName: 'credit_card',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          cardData["cardNumber"] ?? "Not provided",
                          style: AppTheme.getDataTextStyle(
                            isLight: true,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _copyToClipboard(
                          context,
                          cardData["cardNumber"] ?? "",
                          'Card number',
                        ),
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

  void _copyToClipboard(BuildContext context, String text, String label) {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
