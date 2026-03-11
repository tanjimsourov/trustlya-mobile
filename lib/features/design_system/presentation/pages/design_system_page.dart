import 'package:flutter/material.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/chips.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/animations.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/filter_row.dart';
import '../../../../shared/widgets/cta_footer.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// A showcase screen displaying the various components available in the
/// design system. Use this page to verify visual consistency and quickly
/// test new widgets during development. This page is not intended for
/// production use and should only be accessible in debug mode.
class DesignSystemPage extends StatefulWidget {
  const DesignSystemPage({Key? key}) : super(key: key);
  @override
  _DesignSystemPageState createState() => _DesignSystemPageState();
}

class _DesignSystemPageState extends State<DesignSystemPage> {
  int _filterIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _otp = '';
  String? _dropdownValue;

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Design System'),
      ),
      body: ResponsivePageWrapper(
        child: ListView(
          children: [
            Text('Buttons', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: const [
                PrimaryButton(label: 'Primary'),
                SecondaryButton(label: 'Secondary'),
                GhostButton(label: 'Ghost'),
                DestructiveButton(label: 'Delete'),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Inputs', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.md),
            AppTextField(hintText: 'Standard input'),
            const SizedBox(height: AppSpacing.sm),
            SearchField(controller: _searchController),
            const SizedBox(height: AppSpacing.sm),
            AmountInput(
                controller: _amountController, prefix: const Text('\$')),
            const SizedBox(height: AppSpacing.sm),
            OtpInput(onChanged: (val) => setState(() => _otp = val)),
            const SizedBox(height: AppSpacing.sm),
            AppDropdown<String>(
              value: _dropdownValue,
              hint: 'Select option',
              items: const [
                DropdownMenuItem(value: 'One', child: Text('One')),
                DropdownMenuItem(value: 'Two', child: Text('Two')),
              ],
              onChanged: (v) => setState(() => _dropdownValue = v),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Chips & Filters', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: const [
                AppChip(label: 'Tag'),
                AppChip(label: 'Selected', selected: true),
                AppChip(label: 'Removable', selected: true),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            FilterRow(
              options: const ['All', 'Open', 'Closed'],
              selectedIndex: _filterIndex,
              onSelected: (i) => setState(() => _filterIndex = i),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Cards', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.md),
            MetricCard(
                title: 'Balance',
                value: '\$12,345',
                icon: Icons.account_balance_wallet),
            const SizedBox(height: AppSpacing.sm),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Glass Card', style: AppTypography.subtitle1),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Semi transparent surface', style: AppTypography.body2),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TransactionRow(
                icon: Icons.call_made,
                title: 'Send ETH',
                subtitle: 'to 0x1234...abcd',
                amount: '-0.50',
                negative: true),
            TransactionRow(
                icon: Icons.call_received,
                title: 'Receive BTC',
                subtitle: 'from 0xabcd...efgh',
                amount: '+0.25',
                negative: false),
            const SizedBox(height: AppSpacing.sm),
            AssetRow(
                symbol: 'BTC',
                name: 'Bitcoin',
                price: '\$40,000',
                change: '+2.5%'),
            const SizedBox(height: AppSpacing.sm),
            PaymentMethodCard(
                provider: 'Visa', maskedNumber: '**** **** **** 1234'),
            const SizedBox(height: AppSpacing.sm),
            WalletAddressCard(address: '0xabcdef1234567890', onCopy: () {}),
            const SizedBox(height: AppSpacing.sm),
            MarketItemCard(
                name: 'Crypto Kitty', price: '\$150', imageUrl: null),
            const SizedBox(height: AppSpacing.sm),
            CasinoGameCard(name: 'Slots', imageUrl: null),
            const SizedBox(height: AppSpacing.sm),
            CarbonProjectCard(
                title: 'Reforestation',
                description: 'Planting trees in the Amazon',
                price: '\$10/ton'),
            const SizedBox(height: AppSpacing.lg),
            Text('Animations', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.md),
            NumberCountUp(target: 1000, formatter: (v) => v.toStringAsFixed(0)),
            const SizedBox(height: AppSpacing.sm),
            BalanceReveal(value: '\$9,876'),
            const SizedBox(height: AppSpacing.sm),
            ShimmerLoading(
                child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: AppSpacing.lg),
            Text('Dialogs & Snackbar', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                PrimaryButton(
                  label: 'Show Dialog',
                  onPressed: () {
                    showConfirmationDialog(context,
                        title: 'Confirm', message: 'Are you sure?');
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                SecondaryButton(
                  label: 'Show Success',
                  onPressed: () {
                    showSuccessDialog(context,
                        title: 'Success',
                        message: 'Operation completed successfully');
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                GhostButton(
                  label: 'Snackbar',
                  onPressed: () {
                    showAppSnackBar(context, message: 'This is a snackbar');
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
