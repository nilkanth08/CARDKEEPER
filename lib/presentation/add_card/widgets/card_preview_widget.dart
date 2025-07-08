import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CardPreviewWidget extends StatelessWidget {
  final String cardholderName;
  final String bankName;
  final String cardNumber;
  final DateTime? expiryDate;
  final String cardType;

  const CardPreviewWidget({
    Key? key,
    required this.cardholderName,
    required this.bankName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardType,
  }) : super(key: key);

  Color _getCardColor() {
    switch (cardType) {
      case 'Credit':
        return const Color(0xFF1E3A8A); // Blue
      case 'Debit':
        return const Color(0xFF059669); // Green
      case 'Prepaid':
        return const Color(0xFFD97706); // Orange
      default:
        return const Color(0xFF64748B); // Gray
    }
  }

  String _getCardTypeIcon() {
    switch (cardType) {
      case 'Credit':
        return 'credit_card';
      case 'Debit':
        return 'payment';
      case 'Prepaid':
        return 'card_giftcard';
      default:
        return 'credit_card';
    }
  }

  String _formatCardNumber(String number) {
    String cleaned = number.replaceAll(' ', '');
    if (cleaned.isEmpty) return '•••• •••• •••• ••••';

    String formatted = '';
    for (int i = 0; i < 16; i++) {
      if (i > 0 && i % 4 == 0) formatted += ' ';
      if (i < cleaned.length) {
        formatted += cleaned[i];
      } else {
        formatted += '•';
      }
    }
    return formatted;
  }

  String _formatExpiryDate() {
    if (expiryDate == null) return 'MM/YY';
    return '${expiryDate!.month.toString().padLeft(2, '0')}/${expiryDate!.year.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 25.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCardColor(),
            _getCardColor().withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with bank name and card type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bankName.isEmpty ? 'Bank Name' : bankName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: _getCardTypeIcon(),
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        cardType,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Card Number
            Text(
              _formatCardNumber(cardNumber),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                fontFamily: 'monospace',
              ),
            ),

            SizedBox(height: 2.h),

            // Bottom row with cardholder name and expiry
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARDHOLDER NAME',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        cardholderName.isEmpty
                            ? 'YOUR NAME'
                            : cardholderName.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'EXPIRES',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _formatExpiryDate(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
