import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/card_form_widget.dart';
import './widgets/card_preview_widget.dart';
import './widgets/image_capture_widget.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  late TabController _tabController;

  // Form Controllers
  final _cardholderNameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardLimitController = TextEditingController();
  final _billAmountController = TextEditingController();
  final _pinController = TextEditingController();
  final _ifscController = TextEditingController();
  final _statementPasswordController = TextEditingController();
  final _cardVariantController = TextEditingController();

  // Form State
  String _selectedCardType = 'Credit';
  DateTime? _expiryDate;
  DateTime? _billDate;
  DateTime? _dueDate;
  DateTime? _birthDate;
  String? _frontImagePath;
  String? _backImagePath;
  bool _isPinVisible = false;
  bool _isStatementPasswordVisible = false;
  bool _isSaving = false;

  // Focus Nodes
  final _cardholderNameFocus = FocusNode();
  final _bankNameFocus = FocusNode();
  final _cardNumberFocus = FocusNode();
  final _cvvFocus = FocusNode();
  final _cardLimitFocus = FocusNode();
  final _billAmountFocus = FocusNode();
  final _pinFocus = FocusNode();
  final _ifscFocus = FocusNode();
  final _statementPasswordFocus = FocusNode();
  final _cardVariantFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDraftData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _cardholderNameController.dispose();
    _bankNameController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();
    _cardLimitController.dispose();
    _billAmountController.dispose();
    _pinController.dispose();
    _ifscController.dispose();
    _statementPasswordController.dispose();
    _cardVariantController.dispose();
    _cardholderNameFocus.dispose();
    _bankNameFocus.dispose();
    _cardNumberFocus.dispose();
    _cvvFocus.dispose();
    _cardLimitFocus.dispose();
    _billAmountFocus.dispose();
    _pinFocus.dispose();
    _ifscFocus.dispose();
    _statementPasswordFocus.dispose();
    _cardVariantFocus.dispose();
    super.dispose();
  }

  Future<void> _loadDraftData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cardholderNameController.text =
          prefs.getString('draft_cardholder_name') ?? '';
      _bankNameController.text = prefs.getString('draft_bank_name') ?? '';
      _cardNumberController.text = prefs.getString('draft_card_number') ?? '';
      _selectedCardType = prefs.getString('draft_card_type') ?? 'Credit';
      _cardVariantController.text = prefs.getString('draft_card_variant') ?? '';
      _cvvController.text = prefs.getString('draft_cvv') ?? '';
      _cardLimitController.text = prefs.getString('draft_card_limit') ?? '';
      _billAmountController.text = prefs.getString('draft_bill_amount') ?? '';
      _pinController.text = prefs.getString('draft_pin') ?? '';
      _ifscController.text = prefs.getString('draft_ifsc') ?? '';
      _statementPasswordController.text =
          prefs.getString('draft_statement_password') ?? '';
      _frontImagePath = prefs.getString('draft_front_image');
      _backImagePath = prefs.getString('draft_back_image');
    });
  }

  Future<void> _saveDraftData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'draft_cardholder_name', _cardholderNameController.text);
    await prefs.setString('draft_bank_name', _bankNameController.text);
    await prefs.setString('draft_card_number', _cardNumberController.text);
    await prefs.setString('draft_card_type', _selectedCardType);
    await prefs.setString('draft_card_variant', _cardVariantController.text);
    await prefs.setString('draft_cvv', _cvvController.text);
    await prefs.setString('draft_card_limit', _cardLimitController.text);
    await prefs.setString('draft_bill_amount', _billAmountController.text);
    await prefs.setString('draft_pin', _pinController.text);
    await prefs.setString('draft_ifsc', _ifscController.text);
    await prefs.setString(
        'draft_statement_password', _statementPasswordController.text);
    if (_frontImagePath != null) {
      await prefs.setString('draft_front_image', _frontImagePath!);
    }
    if (_backImagePath != null) {
      await prefs.setString('draft_back_image', _backImagePath!);
    }
  }

  Future<void> _clearDraftData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = [
      'draft_cardholder_name',
      'draft_bank_name',
      'draft_card_number',
      'draft_card_type',
      'draft_card_variant',
      'draft_cvv',
      'draft_card_limit',
      'draft_bill_amount',
      'draft_pin',
      'draft_ifsc',
      'draft_statement_password',
      'draft_front_image',
      'draft_back_image'
    ];
    for (String key in keys) {
      await prefs.remove(key);
    }
  }

  void _onCardNumberChanged(String value) {
    String formatted = value.replaceAll(' ', '');
    if (formatted.length <= 16) {
      String display = '';
      for (int i = 0; i < formatted.length; i++) {
        if (i > 0 && i % 4 == 0) display += ' ';
        display += formatted[i];
      }
      _cardNumberController.value = TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      );
    }
    _saveDraftData();
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = type == 'expiry' ? DateTime.now() : DateTime(1900);
    DateTime lastDate = type == 'birth' ? DateTime.now() : DateTime(2100);

    if (type == 'expiry' && _expiryDate != null) {
      initialDate = _expiryDate!;
    } else if (type == 'bill' && _billDate != null) {
      initialDate = _billDate!;
    } else if (type == 'due' && _dueDate != null) {
      initialDate = _dueDate!;
    } else if (type == 'birth' && _birthDate != null) {
      initialDate = _birthDate!;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return DatePickerTheme(
          data: DatePickerThemeData(
            backgroundColor: AppTheme.lightTheme.cardColor,
            headerBackgroundColor: AppTheme.lightTheme.primaryColor,
            headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.lightTheme.colorScheme.onPrimary;
              }
              return AppTheme.lightTheme.colorScheme.onSurface;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.lightTheme.primaryColor;
              }
              return Colors.transparent;
            }),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        switch (type) {
          case 'expiry':
            _expiryDate = picked;
            break;
          case 'bill':
            _billDate = picked;
            break;
          case 'due':
            _dueDate = picked;
            break;
          case 'birth':
            _birthDate = picked;
            break;
        }
      });
      _saveDraftData();
    }
  }

  void _onImageCaptured(String imagePath, bool isFront) {
    setState(() {
      if (isFront) {
        _frontImagePath = imagePath;
      } else {
        _backImagePath = imagePath;
      }
    });
    _saveDraftData();
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Please fill all required fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.errorLight,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Simulate saving to database
      await Future.delayed(const Duration(seconds: 2));

      // Clear draft data after successful save
      await _clearDraftData();

      Fluttertoast.showToast(
        msg: "Card saved successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.successLight,
        textColor: Colors.white,
      );

      Navigator.pushReplacementNamed(context, '/card-list-dashboard');
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save card. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.errorLight,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _cancelAndGoBack() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Discard Changes?',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Your changes will be saved as draft and you can continue later.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue Editing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Add Card',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: _cancelAndGoBack,
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveCard,
            child: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          SizedBox(width: 4.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Card Info'),
            Tab(text: 'Billing'),
            Tab(text: 'Images'),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Card Info Tab
              SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    // Card Preview
                    CardPreviewWidget(
                      cardholderName: _cardholderNameController.text,
                      bankName: _bankNameController.text,
                      cardNumber: _cardNumberController.text,
                      expiryDate: _expiryDate,
                      cardType: _selectedCardType,
                    ),
                    SizedBox(height: 6.h),

                    // Card Form
                    CardFormWidget(
                      cardholderNameController: _cardholderNameController,
                      bankNameController: _bankNameController,
                      cardNumberController: _cardNumberController,
                      cvvController: _cvvController,
                      cardLimitController: _cardLimitController,
                      pinController: _pinController,
                      ifscController: _ifscController,
                      statementPasswordController: _statementPasswordController,
                      cardVariantController: _cardVariantController,
                      selectedCardType: _selectedCardType,
                      expiryDate: _expiryDate,
                      birthDate: _birthDate,
                      isPinVisible: _isPinVisible,
                      isStatementPasswordVisible: _isStatementPasswordVisible,
                      cardholderNameFocus: _cardholderNameFocus,
                      bankNameFocus: _bankNameFocus,
                      cardNumberFocus: _cardNumberFocus,
                      cvvFocus: _cvvFocus,
                      cardLimitFocus: _cardLimitFocus,
                      pinFocus: _pinFocus,
                      ifscFocus: _ifscFocus,
                      statementPasswordFocus: _statementPasswordFocus,
                      cardVariantFocus: _cardVariantFocus,
                      onCardTypeChanged: (String? value) {
                        setState(() {
                          _selectedCardType = value ?? 'Credit';
                        });
                        _saveDraftData();
                      },
                      onCardNumberChanged: _onCardNumberChanged,
                      onExpiryDateTap: () => _selectDate(context, 'expiry'),
                      onBirthDateTap: () => _selectDate(context, 'birth'),
                      onPinVisibilityToggle: () {
                        setState(() {
                          _isPinVisible = !_isPinVisible;
                        });
                      },
                      onStatementPasswordVisibilityToggle: () {
                        setState(() {
                          _isStatementPasswordVisible =
                              !_isStatementPasswordVisible;
                        });
                      },
                      onFieldChanged: _saveDraftData,
                    ),
                  ],
                ),
              ),

              // Billing Tab
              SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Billing Information',
                      style: AppTheme.lightTheme.textTheme.headlineSmall,
                    ),
                    SizedBox(height: 4.h),

                    // Bill Amount
                    TextFormField(
                      controller: _billAmountController,
                      focusNode: _billAmountFocus,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Bill Amount',
                        prefixText: '\$ ',
                        suffixIcon: CustomIconWidget(
                          iconName: 'attach_money',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter bill amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                      onChanged: (value) => _saveDraftData(),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                    SizedBox(height: 4.h),

                    // Bill Date
                    InkWell(
                      onTap: () => _selectDate(context, 'bill'),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Bill Date',
                          suffixIcon: CustomIconWidget(
                            iconName: 'calendar_today',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        child: Text(
                          _billDate != null
                              ? '${_billDate!.day}/${_billDate!.month}/${_billDate!.year}'
                              : 'Select bill date',
                          style: _billDate != null
                              ? AppTheme.lightTheme.textTheme.bodyLarge
                              : AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Due Date
                    InkWell(
                      onTap: () => _selectDate(context, 'due'),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          suffixIcon: CustomIconWidget(
                            iconName: 'event',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        child: Text(
                          _dueDate != null
                              ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                              : 'Select due date',
                          style: _dueDate != null
                              ? AppTheme.lightTheme.textTheme.bodyLarge
                              : AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Images Tab
              SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: ImageCaptureWidget(
                  frontImagePath: _frontImagePath,
                  backImagePath: _backImagePath,
                  onImageCaptured: _onImageCaptured,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
