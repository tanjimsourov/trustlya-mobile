import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/payment_brand_badge.dart';
import '../../domain/entities/payment_method.dart';
import '../cubit/payment_methods_cubit.dart';

/// Form for adding a new payment method. Supports cards, bank accounts,
/// e-wallets and crypto addresses. Displays relevant fields based on
/// the selected type and persists the method via the cubit.
class AddPaymentMethodPage extends StatefulWidget {
  const AddPaymentMethodPage({Key? key}) : super(key: key);

  @override
  State<AddPaymentMethodPage> createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'card';
  final TextEditingController _providerController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _routingNumberController =
      TextEditingController();
  final TextEditingController _walletProviderController =
      TextEditingController();
  final TextEditingController _walletIdentifierController =
      TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _providerController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    _walletProviderController.dispose();
    _walletIdentifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentMethodsCubit>(
      create: (_) => getIt<PaymentMethodsCubit>(),
      child: AppScaffold(
        body: SingleChildScrollView(
          child: ResponsivePageWrapper(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(
                    eyebrow: 'Add payment method',
                    title: 'Connect a settlement or funding rail',
                    subtitle:
                        'Capture card, bank, wallet, or crypto method details with clear payment-brand visibility for operators.',
                    metadata: [
                      StatusBadge(
                          label: 'Responsive form', tone: AppTone.primary),
                      StatusBadge(
                          label: 'Brand-ready rails', tone: AppTone.info),
                    ],
                  ),
                  const SectionSpacing(),
                  SectionCard(
                    title: 'Method details',
                    subtitle:
                        'Choose a rail type first. The form and brand cues adjust automatically.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Method Type', style: AppTypography.subtitle1),
                        const SizedBox(height: AppSpacing.sm),
                        AppDropdown<String>(
                          value: _type,
                          items: const [
                            DropdownMenuItem(
                                value: 'card', child: Text('Card')),
                            DropdownMenuItem(
                                value: 'bank', child: Text('Bank Account')),
                            DropdownMenuItem(
                                value: 'e-wallet', child: Text('E-wallet')),
                            DropdownMenuItem(
                                value: 'crypto', child: Text('Crypto')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _type = value ?? 'card';
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _MethodBrandStrip(type: _type),
                        const SizedBox(height: AppSpacing.lg),
                        if (_type == 'card') ...[
                          AppTextField(
                            controller: _providerController,
                            hintText: 'Card Provider (e.g. Visa)',
                            prefixIcon: Icons.credit_card,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            controller: _numberController,
                            hintText: 'Card Number',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.numbers,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final stacked = constraints.maxWidth < 480;
                              if (stacked) {
                                return Column(
                                  children: [
                                    AppTextField(
                                      controller: _expiryController,
                                      hintText: 'MM/YY',
                                      prefixIcon: Icons.calendar_today,
                                      keyboardType: TextInputType.datetime,
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    AppTextField(
                                      controller: _cvvController,
                                      hintText: 'CVV',
                                      prefixIcon: Icons.lock,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                );
                              }

                              return Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      controller: _expiryController,
                                      hintText: 'MM/YY',
                                      prefixIcon: Icons.calendar_today,
                                      keyboardType: TextInputType.datetime,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: AppTextField(
                                      controller: _cvvController,
                                      hintText: 'CVV',
                                      prefixIcon: Icons.lock,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ] else if (_type == 'bank') ...[
                          AppTextField(
                            controller: _bankNameController,
                            hintText: 'Bank Name',
                            prefixIcon: Icons.account_balance,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            controller: _accountNumberController,
                            hintText: 'Account Number',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.numbers,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            controller: _routingNumberController,
                            hintText: 'Routing Number',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.numbers,
                          ),
                        ] else if (_type == 'e-wallet') ...[
                          AppTextField(
                            controller: _walletProviderController,
                            hintText: 'Provider (e.g. PayPal)',
                            prefixIcon: Icons.account_balance_wallet,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            controller: _walletIdentifierController,
                            hintText: 'Email / Username',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.person,
                          ),
                        ] else if (_type == 'crypto') ...[
                          AppTextField(
                            controller: _walletProviderController,
                            hintText: 'Network (e.g. Ethereum)',
                            prefixIcon: Icons.hexagon,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            controller: _walletIdentifierController,
                            hintText: 'Wallet Address',
                            keyboardType: TextInputType.text,
                            prefixIcon: Icons.code,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Checkbox(
                              value: _isDefault,
                              activeColor: AppColorsDS.primary,
                              onChanged: (val) =>
                                  setState(() => _isDefault = val ?? false),
                            ),
                            const SizedBox(width: 4),
                            Text('Set as default', style: AppTypography.body2),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final stacked = constraints.maxWidth < 520;
                            final cancel = SecondaryButton(
                              label: 'Cancel',
                              onPressed: () => Navigator.of(context).pop(),
                            );
                            final save = PrimaryButton(
                              label: 'Save',
                              onPressed: () async {
                                final provider = _type == 'card'
                                    ? _providerController.text
                                    : _type == 'bank'
                                        ? _bankNameController.text
                                        : _walletProviderController.text;
                                if (provider.isEmpty) {
                                  showAppSnackBar(
                                    context,
                                    message: 'Please fill all required fields',
                                  );
                                  return;
                                }

                                String masked = '';
                                String expiry = '';
                                if (_type == 'card') {
                                  if (_numberController.text.length < 12) {
                                    showAppSnackBar(
                                      context,
                                      message: 'Invalid card number',
                                    );
                                    return;
                                  }
                                  masked =
                                      '**** **** **** ${_numberController.text.substring(_numberController.text.length - 4)}';
                                  expiry = _expiryController.text;
                                } else if (_type == 'bank') {
                                  if (_accountNumberController.text.isEmpty) {
                                    showAppSnackBar(
                                      context,
                                      message: 'Invalid account number',
                                    );
                                    return;
                                  }
                                  masked =
                                      '****${_accountNumberController.text.substring(_accountNumberController.text.length - 4)}';
                                } else {
                                  masked = _walletIdentifierController.text;
                                }

                                final newMethod = PaymentMethod(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  type: _type,
                                  provider: provider,
                                  maskedNumber: masked,
                                  expiryDate: expiry,
                                  isDefault: _isDefault,
                                );

                                await context
                                    .read<PaymentMethodsCubit>()
                                    .addMethod(newMethod);
                                if (!mounted) {
                                  return;
                                }

                                showSuccessDialog(
                                  context,
                                  title: 'Method Added',
                                  message:
                                      'Your payment method has been added successfully.',
                                ).then((_) => Navigator.of(context).pop());
                              },
                            );

                            if (stacked) {
                              return Column(
                                children: [
                                  SizedBox(
                                      width: double.infinity, child: cancel),
                                  const SizedBox(height: AppSpacing.md),
                                  SizedBox(width: double.infinity, child: save),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(child: cancel),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(child: save),
                              ],
                            );
                          },
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
}

class _MethodBrandStrip extends StatelessWidget {
  final String type;

  const _MethodBrandStrip({required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'bank':
        return const Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            PaymentBrandBadge(provider: 'Bank', type: 'bank'),
            PaymentBrandBadge(provider: 'SEPA', type: 'regional'),
            PaymentBrandBadge(provider: 'Local Bank', type: 'bank'),
          ],
        );
      case 'e-wallet':
        return const Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            PaymentBrandBadge(provider: 'PayPal', type: 'e-wallet'),
            PaymentBrandBadge(provider: 'Trustlya Wallet', type: 'e-wallet'),
          ],
        );
      case 'crypto':
        return const Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            PaymentBrandBadge(provider: 'Crypto Bridge', type: 'crypto'),
            PaymentBrandBadge(provider: 'Ethereum', type: 'crypto'),
          ],
        );
      case 'card':
      default:
        return const Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            PaymentBrandBadge(provider: 'Visa'),
            PaymentBrandBadge(provider: 'MasterCard'),
            PaymentBrandBadge(provider: 'American Express'),
          ],
        );
    }
  }
}
