import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/additional_info_section_widget.dart';
import './widgets/card_info_section_widget.dart';
import './widgets/card_visual_widget.dart';
import './widgets/financial_details_section_widget.dart';
import './widgets/payment_status_section_widget.dart';
import './widgets/quick_actions_section_widget.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({Key? key}) : super(key: key);

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  bool isEditMode = false;
  bool showCardBack = false;

  // Mock card data
  final Map<String, dynamic> cardData = {
    "id": 1,
    "cardholderName": "John Smith",
    "bankName": "Chase Bank",
    "cardType": "Credit",
    "cardVariant": "Platinum Rewards",
    "cardNumber": "4532 1234 5678 9012",
    "expiryDate": "12/26",
    "cvv": "123",
    "cardLimit": 5000.0,
    "billAmount": 1250.0,
    "billDate": "2024-01-15",
    "dueDate": "2024-02-10",
    "birthDate": "1990-05-15",
    "pin": "1234",
    "ifscCode": "CHAS0001234",
    "statementPassword": "stmt123",
    "frontImageUrl":
        "https://images.pexels.com/photos/164501/pexels-photo-164501.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "backImageUrl":
        "https://images.pexels.com/photos/259200/pexels-photo-259200.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "paymentStatus": "Unpaid",
    "lastPaymentDate": "2024-01-10",
    "mobileNumber": "+1 (555) 123-4567"
  };

  // Controllers for edit mode
  late TextEditingController cardholderNameController;
  late TextEditingController bankNameController;
  late TextEditingController cardVariantController;
  late TextEditingController cardNumberController;
  late TextEditingController expiryDateController;
  late TextEditingController cvvController;
  late TextEditingController cardLimitController;
  late TextEditingController billAmountController;
  late TextEditingController pinController;
  late TextEditingController ifscController;
  late TextEditingController statementPasswordController;
  late TextEditingController mobileNumberController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    cardholderNameController =
        TextEditingController(text: cardData["cardholderName"]);
    bankNameController = TextEditingController(text: cardData["bankName"]);
    cardVariantController =
        TextEditingController(text: cardData["cardVariant"]);
    cardNumberController = TextEditingController(text: cardData["cardNumber"]);
    expiryDateController = TextEditingController(text: cardData["expiryDate"]);
    cvvController = TextEditingController(text: cardData["cvv"]);
    cardLimitController =
        TextEditingController(text: cardData["cardLimit"].toString());
    billAmountController =
        TextEditingController(text: cardData["billAmount"].toString());
    pinController = TextEditingController(text: cardData["pin"]);
    ifscController = TextEditingController(text: cardData["ifscCode"]);
    statementPasswordController =
        TextEditingController(text: cardData["statementPassword"]);
    mobileNumberController =
        TextEditingController(text: cardData["mobileNumber"]);
  }

  @override
  void dispose() {
    cardholderNameController.dispose();
    bankNameController.dispose();
    cardVariantController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardLimitController.dispose();
    billAmountController.dispose();
    pinController.dispose();
    ifscController.dispose();
    statementPasswordController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void _saveChanges() {
    // Update card data with controller values
    cardData["cardholderName"] = cardholderNameController.text;
    cardData["bankName"] = bankNameController.text;
    cardData["cardVariant"] = cardVariantController.text;
    cardData["cardNumber"] = cardNumberController.text;
    cardData["expiryDate"] = expiryDateController.text;
    cardData["cvv"] = cvvController.text;
    cardData["cardLimit"] = double.tryParse(cardLimitController.text) ?? 0.0;
    cardData["billAmount"] = double.tryParse(billAmountController.text) ?? 0.0;
    cardData["pin"] = pinController.text;
    cardData["ifscCode"] = ifscController.text;
    cardData["statementPassword"] = statementPasswordController.text;
    cardData["mobileNumber"] = mobileNumberController.text;

    setState(() {
      isEditMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Card details updated successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _cancelEdit() {
    _initializeControllers();
    setState(() {
      isEditMode = false;
    });
  }

  void _updatePaymentStatus(String status) {
    setState(() {
      cardData["paymentStatus"] = status;
      if (status == "Paid") {
        cardData["lastPaymentDate"] = DateTime.now().toString().split(' ')[0];
      }
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment status updated to $status'),
        backgroundColor: AppTheme.getStatusColor(status),
      ),
    );
  }

  void _toggleCardView() {
    setState(() {
      showCardBack = !showCardBack;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          cardData["cardholderName"] ?? "Card Details",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (isEditMode) ...[
            TextButton(
              onPressed: _cancelEdit,
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontSize: 16.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: _saveChanges,
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ] else
            TextButton(
              onPressed: _toggleEditMode,
              child: Text(
                'Edit',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Visual Representation
              CardVisualWidget(
                cardData: cardData,
                showCardBack: showCardBack,
                onToggleView: _toggleCardView,
              ),

              SizedBox(height: 3.h),

              // Card Information Section
              CardInfoSectionWidget(
                cardData: cardData,
                isEditMode: isEditMode,
                controllers: {
                  'cardholderName': cardholderNameController,
                  'bankName': bankNameController,
                  'cardVariant': cardVariantController,
                  'cardNumber': cardNumberController,
                  'expiryDate': expiryDateController,
                  'cvv': cvvController,
                  'mobileNumber': mobileNumberController,
                },
              ),

              SizedBox(height: 3.h),

              // Financial Details Section
              FinancialDetailsSectionWidget(
                cardData: cardData,
                isEditMode: isEditMode,
                controllers: {
                  'cardLimit': cardLimitController,
                  'billAmount': billAmountController,
                },
              ),

              SizedBox(height: 3.h),

              // Payment Status Section
              PaymentStatusSectionWidget(
                cardData: cardData,
                onStatusUpdate: _updatePaymentStatus,
              ),

              SizedBox(height: 3.h),

              // Additional Info Section
              AdditionalInfoSectionWidget(
                cardData: cardData,
                isEditMode: isEditMode,
                controllers: {
                  'pin': pinController,
                  'ifscCode': ifscController,
                  'statementPassword': statementPasswordController,
                },
              ),

              SizedBox(height: 3.h),

              // Quick Actions Section
              QuickActionsSectionWidget(
                cardData: cardData,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
