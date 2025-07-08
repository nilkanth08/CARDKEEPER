import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CardFormWidget extends StatelessWidget {
  final TextEditingController cardholderNameController;
  final TextEditingController bankNameController;
  final TextEditingController cardNumberController;
  final TextEditingController cvvController;
  final TextEditingController cardLimitController;
  final TextEditingController pinController;
  final TextEditingController ifscController;
  final TextEditingController statementPasswordController;
  final TextEditingController cardVariantController;
  final String selectedCardType;
  final DateTime? expiryDate;
  final DateTime? birthDate;
  final bool isPinVisible;
  final bool isStatementPasswordVisible;
  final FocusNode cardholderNameFocus;
  final FocusNode bankNameFocus;
  final FocusNode cardNumberFocus;
  final FocusNode cvvFocus;
  final FocusNode cardLimitFocus;
  final FocusNode pinFocus;
  final FocusNode ifscFocus;
  final FocusNode statementPasswordFocus;
  final FocusNode cardVariantFocus;
  final Function(String?) onCardTypeChanged;
  final Function(String) onCardNumberChanged;
  final VoidCallback onExpiryDateTap;
  final VoidCallback onBirthDateTap;
  final VoidCallback onPinVisibilityToggle;
  final VoidCallback onStatementPasswordVisibilityToggle;
  final VoidCallback onFieldChanged;

  final List<Map<String, dynamic>> _bankSuggestions = [
    {"name": "Chase Bank", "icon": "account_balance"},
    {"name": "Bank of America", "icon": "account_balance"},
    {"name": "Wells Fargo", "icon": "account_balance"},
    {"name": "Citibank", "icon": "account_balance"},
    {"name": "Capital One", "icon": "account_balance"},
    {"name": "American Express", "icon": "credit_card"},
    {"name": "Discover", "icon": "credit_card"},
    {"name": "US Bank", "icon": "account_balance"},
  ];

  final List<Map<String, dynamic>> _cardTypes = [
    {"value": "Credit", "label": "Credit Card", "icon": "credit_card"},
    {"value": "Debit", "label": "Debit Card", "icon": "payment"},
    {"value": "Prepaid", "label": "Prepaid Card", "icon": "card_giftcard"},
  ];

  CardFormWidget({
    Key? key,
    required this.cardholderNameController,
    required this.bankNameController,
    required this.cardNumberController,
    required this.cvvController,
    required this.cardLimitController,
    required this.pinController,
    required this.ifscController,
    required this.statementPasswordController,
    required this.cardVariantController,
    required this.selectedCardType,
    required this.expiryDate,
    required this.birthDate,
    required this.isPinVisible,
    required this.isStatementPasswordVisible,
    required this.cardholderNameFocus,
    required this.bankNameFocus,
    required this.cardNumberFocus,
    required this.cvvFocus,
    required this.cardLimitFocus,
    required this.pinFocus,
    required this.ifscFocus,
    required this.statementPasswordFocus,
    required this.cardVariantFocus,
    required this.onCardTypeChanged,
    required this.onCardNumberChanged,
    required this.onExpiryDateTap,
    required this.onBirthDateTap,
    required this.onPinVisibilityToggle,
    required this.onStatementPasswordVisibilityToggle,
    required this.onFieldChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Information Section
        _buildSectionHeader('Basic Information'),
        SizedBox(height: 2.h),

        // Cardholder Name
        TextFormField(
          controller: cardholderNameController,
          focusNode: cardholderNameFocus,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Cardholder Name *',
            prefixIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon: cardholderNameController.text.isNotEmpty
                ? CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successLight,
                    size: 20,
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter cardholder name';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
          onChanged: (value) => onFieldChanged(),
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(bankNameFocus);
          },
        ),
        SizedBox(height: 3.h),

        // Bank Name with Autocomplete
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return _bankSuggestions
                .where((bank) => (bank["name"] as String)
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()))
                .map((bank) => bank["name"] as String);
          },
          onSelected: (String selection) {
            bankNameController.text = selection;
            onFieldChanged();
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            bankNameController.addListener(() {
              controller.text = bankNameController.text;
            });
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Bank Name *',
                prefixIcon: CustomIconWidget(
                  iconName: 'account_balance',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                suffixIcon: bankNameController.text.isNotEmpty
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successLight,
                        size: 20,
                      )
                    : null,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter bank name';
                }
                return null;
              },
              onChanged: (value) {
                bankNameController.text = value;
                onFieldChanged();
              },
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(cardNumberFocus);
              },
            );
          },
        ),
        SizedBox(height: 3.h),

        // Card Type Dropdown
        DropdownButtonFormField<String>(
          value: selectedCardType,
          decoration: InputDecoration(
            labelText: 'Card Type *',
            prefixIcon: CustomIconWidget(
              iconName: _cardTypes.firstWhere(
                  (type) => type["value"] == selectedCardType)["icon"],
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          items: _cardTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type["value"],
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: type["icon"],
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(type["label"]),
                ],
              ),
            );
          }).toList(),
          onChanged: onCardTypeChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select card type';
            }
            return null;
          },
        ),
        SizedBox(height: 3.h),

        // Card Variant (Optional)
        TextFormField(
          controller: cardVariantController,
          focusNode: cardVariantFocus,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Card Variant (Optional)',
            hintText: 'e.g., Platinum, Gold, Classic',
            prefixIcon: CustomIconWidget(
              iconName: 'style',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          onChanged: (value) => onFieldChanged(),
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(cardNumberFocus);
          },
        ),
        SizedBox(height: 4.h),

        // Card Details Section
        _buildSectionHeader('Card Details'),
        SizedBox(height: 2.h),

        // Card Number
        TextFormField(
          controller: cardNumberController,
          focusNode: cardNumberFocus,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          decoration: InputDecoration(
            labelText: 'Card Number *',
            hintText: '1234 5678 9012 3456',
            prefixIcon: CustomIconWidget(
              iconName: 'credit_card',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon:
                cardNumberController.text.replaceAll(' ', '').length == 16
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successLight,
                        size: 20,
                      )
                    : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card number';
            }
            String cleaned = value.replaceAll(' ', '');
            if (cleaned.length != 16) {
              return 'Card number must be 16 digits';
            }
            return null;
          },
          onChanged: onCardNumberChanged,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(cvvFocus);
          },
        ),
        SizedBox(height: 3.h),

        // Expiry Date and CVV Row
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onExpiryDateTap,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date *',
                    prefixIcon: CustomIconWidget(
                      iconName: 'calendar_today',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: expiryDate != null
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.successLight,
                            size: 20,
                          )
                        : null,
                  ),
                  child: Text(
                    expiryDate != null
                        ? '${expiryDate!.month.toString().padLeft(2, '0')}/${expiryDate!.year.toString().substring(2)}'
                        : 'MM/YY',
                    style: expiryDate != null
                        ? AppTheme.lightTheme.textTheme.bodyLarge
                        : AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: TextFormField(
                controller: cvvController,
                focusNode: cvvFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  labelText: 'CVV *',
                  hintText: '123',
                  prefixIcon: CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  suffixIcon: cvvController.text.length == 3
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.successLight,
                          size: 20,
                        )
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  }
                  if (value.length != 3) {
                    return 'CVV must be 3 digits';
                  }
                  return null;
                },
                onChanged: (value) => onFieldChanged(),
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(cardLimitFocus);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Card Limit
        TextFormField(
          controller: cardLimitController,
          focusNode: cardLimitFocus,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            labelText: 'Card Limit *',
            prefixText: '\$ ',
            prefixIcon: CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card limit';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid amount';
            }
            return null;
          },
          onChanged: (value) => onFieldChanged(),
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(pinFocus);
          },
        ),
        SizedBox(height: 4.h),

        // Security Information Section
        _buildSectionHeader('Security Information'),
        SizedBox(height: 2.h),

        // PIN
        TextFormField(
          controller: pinController,
          focusNode: pinFocus,
          keyboardType: TextInputType.number,
          obscureText: !isPinVisible,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: InputDecoration(
            labelText: 'PIN *',
            hintText: '1234',
            prefixIcon: CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: onPinVisibilityToggle,
              icon: CustomIconWidget(
                iconName: isPinVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter PIN';
            }
            if (value.length != 4) {
              return 'PIN must be 4 digits';
            }
            return null;
          },
          onChanged: (value) => onFieldChanged(),
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(ifscFocus);
          },
        ),
        SizedBox(height: 3.h),

        // IFSC Code
        TextFormField(
          controller: ifscController,
          focusNode: ifscFocus,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
          decoration: InputDecoration(
            labelText: 'IFSC Code *',
            hintText: 'ABCD0123456',
            prefixIcon: CustomIconWidget(
              iconName: 'code',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon: ifscController.text.length == 11
                ? CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successLight,
                    size: 20,
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter IFSC code';
            }
            if (value.length != 11) {
              return 'IFSC code must be 11 characters';
            }
            if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
              return 'Please enter a valid IFSC code';
            }
            return null;
          },
          onChanged: (value) => onFieldChanged(),
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(statementPasswordFocus);
          },
        ),
        SizedBox(height: 3.h),

        // Statement Password
        TextFormField(
          controller: statementPasswordController,
          focusNode: statementPasswordFocus,
          obscureText: !isStatementPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Statement Password',
            hintText: 'Optional',
            prefixIcon: CustomIconWidget(
              iconName: 'password',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: onStatementPasswordVisibilityToggle,
              icon: CustomIconWidget(
                iconName: isStatementPasswordVisible
                    ? 'visibility_off'
                    : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          onChanged: (value) => onFieldChanged(),
        ),
        SizedBox(height: 3.h),

        // Birth Date (Optional)
        InkWell(
          onTap: onBirthDateTap,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Birth Date (Optional)',
              prefixIcon: CustomIconWidget(
                iconName: 'cake',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: birthDate != null
                  ? CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 20,
                    )
                  : null,
            ),
            child: Text(
              birthDate != null
                  ? '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}'
                  : 'Select birth date',
              style: birthDate != null
                  ? AppTheme.lightTheme.textTheme.bodyLarge
                  : AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.6),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
        color: AppTheme.lightTheme.primaryColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
