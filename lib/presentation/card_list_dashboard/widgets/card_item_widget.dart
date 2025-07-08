import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CardItemWidget extends StatelessWidget {
  final Map<String, dynamic> card;
  final VoidCallback onTap;
  final VoidCallback onMarkAsPaid;
  final VoidCallback onDelete;
  final VoidCallback onSetReminder;

  const CardItemWidget({
    super.key,
    required this.card,
    required this.onTap,
    required this.onMarkAsPaid,
    required this.onDelete,
    required this.onSetReminder,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'unpaid':
        return AppTheme.lightTheme.colorScheme.error;
      case 'partial':
        return AppTheme.warningLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'unpaid':
        return 'Unpaid';
      case 'partial':
        return 'Partially Paid';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bankName = card['bankName'] as String? ?? '';
    final cardType = card['cardType'] as String? ?? '';
    final lastFourDigits = card['lastFourDigits'] as String? ?? '';
    final paymentStatus = card['paymentStatus'] as String? ?? '';
    final daysUntilDue = card['daysUntilDue'] as int? ?? 0;
    final billAmount = card['billAmount'] as String? ?? '';
    final bankLogo = card['bankLogo'] as String? ?? '';

    return Dismissible(
      key: Key('card_${card['id']}'),
      background: _buildSwipeBackground(isLeft: true),
      secondaryBackground: _buildSwipeBackground(isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onMarkAsPaid();
        } else {
          onDelete();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        }
        return true;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: () => _showContextMenu(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  _buildBankLogo(bankLogo),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                bankName,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildStatusIndicator(paymentStatus),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            _buildCardTypeBadge(cardType),
                            SizedBox(width: 2.w),
                            Text(
                              '•••• $lastFourDigits',
                              style: AppTheme.getDataTextStyle(
                                isLight: true,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amount Due',
                                  style:
                                      AppTheme.lightTheme.textTheme.labelSmall,
                                ),
                                Text(
                                  billAmount,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(paymentStatus),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Due in',
                                  style:
                                      AppTheme.lightTheme.textTheme.labelSmall,
                                ),
                                Text(
                                  '$daysUntilDue days',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: daysUntilDue <= 3
                                        ? AppTheme.lightTheme.colorScheme.error
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankLogo(String logoUrl) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: logoUrl.isNotEmpty
            ? CustomImageWidget(
                imageUrl: logoUrl,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                child: CustomIconWidget(
                  iconName: 'account_balance',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    return Container(
      width: 3.w,
      height: 3.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getStatusColor(status),
      ),
    );
  }

  Widget _buildCardTypeBadge(String cardType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        cardType,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'check_circle' : 'delete',
                size: 24,
                color: Colors.white,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Mark Paid' : 'Delete',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Card'),
            content: Text(
                'Are you sure you want to delete this card? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              title: Text('Edit Card'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit screen
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              title: Text('Duplicate'),
              onTap: () {
                Navigator.pop(context);
                // Duplicate card logic
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              title: Text('Set Reminder'),
              onTap: () {
                Navigator.pop(context);
                onSetReminder();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Share card logic
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
