import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CardVisualWidget extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final bool showCardBack;
  final VoidCallback onToggleView;

  const CardVisualWidget({
    Key? key,
    required this.cardData,
    required this.showCardBack,
    required this.onToggleView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 25.h,
      child: Stack(
        children: [
          // Card Container
          Container(
            width: double.infinity,
            height: 22.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final isShowingFront = animation.value < 0.5;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(animation.value * 3.14159),
                      child:
                          isShowingFront ? _buildCardFront() : _buildCardBack(),
                    );
                  },
                );
              },
              child: showCardBack ? _buildCardBack() : _buildCardFront(),
            ),
          ),

          // Toggle Button
          Positioned(
            bottom: 0,
            right: 4.w,
            child: GestureDetector(
              onTap: onToggleView,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'flip_camera_android',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      key: ValueKey('front'),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bank Name and Card Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cardData["bankName"] ?? "Bank Name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  cardData["cardType"] ?? "Credit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          Spacer(),

          // Card Number
          Text(
            _formatCardNumber(cardData["cardNumber"] ?? ""),
            style: AppTheme.getDataTextStyle(
              isLight: false,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ).copyWith(color: Colors.white),
          ),

          SizedBox(height: 2.h),

          // Cardholder Name and Expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CARDHOLDER NAME",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      cardData["cardholderName"] ?? "Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "EXPIRES",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    cardData["expiryDate"] ?? "MM/YY",
                    style: AppTheme.getDataTextStyle(
                      isLight: false,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ).copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      key: ValueKey('back'),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          // Magnetic Strip
          Container(
            width: double.infinity,
            height: 4.h,
            color: Colors.black,
          ),

          SizedBox(height: 2.h),

          // CVV Section
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 3.h,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  cardData["cvv"] ?? "CVV",
                  style: AppTheme.getDataTextStyle(
                    isLight: true,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          Spacer(),

          // Additional Info
          if (cardData["cardVariant"] != null)
            Text(
              cardData["cardVariant"],
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  String _formatCardNumber(String cardNumber) {
    if (cardNumber.isEmpty) return "•••• •••• •••• ••••";

    // Remove any existing spaces
    String cleanNumber = cardNumber.replaceAll(' ', '');

    // Show only last 4 digits
    if (cleanNumber.length >= 4) {
      String lastFour = cleanNumber.substring(cleanNumber.length - 4);
      return "•••• •••• •••• $lastFour";
    }

    return cardNumber;
  }
}
