import 'package:flutter/material.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Arguments for the bet setup screen. Allows specifying the game
/// identifier and an optional initial bet amount.
class BetSetupArgs {
  final String gameId;
  final double? initialBet;
  const BetSetupArgs({required this.gameId, this.initialBet});
}

/// A generic bet setup page used to configure the wager before
/// starting a game. Provides an amount input, quick chip buttons,
/// multiplier placeholder and a potential payout preview. Returns the
/// selected bet amount when the user taps "Apply".
class BetSetupPage extends StatefulWidget {
  final BetSetupArgs? args;
  const BetSetupPage({Key? key, this.args}) : super(key: key);

  @override
  State<BetSetupPage> createState() => _BetSetupPageState();
}

class _BetSetupPageState extends State<BetSetupPage> {
  late TextEditingController _amountController;
  double _amount = 1.0;

  @override
  void initState() {
    super.initState();
    _amount = widget.args?.initialBet ?? 1.0;
    _amountController = TextEditingController(text: _amount.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setAmount(double val) {
    setState(() {
      _amount = val;
      _amountController.text = val.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Bet Setup'),
        backgroundColor: AppColorsDS.surface,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configure your bet',
                style:
                    AppTypography.h6.copyWith(color: AppColorsDS.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Bet Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  final v = double.tryParse(value);
                  if (v != null) {
                    _amount = v;
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  _chipButton(0.5),
                  _chipButton(1),
                  _chipButton(5),
                  _chipButton(10),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              // Multiplier / lines placeholder
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColorsDS.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lines',
                      style: AppTypography.subtitle2
                          .copyWith(color: AppColorsDS.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('x1 (placeholder)',
                        style: AppTypography.subtitle1
                            .copyWith(color: AppColorsDS.textPrimary)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Multiplier',
                      style: AppTypography.subtitle2
                          .copyWith(color: AppColorsDS.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('1x (placeholder)',
                        style: AppTypography.subtitle1
                            .copyWith(color: AppColorsDS.textPrimary)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Payout preview (mock)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColorsDS.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Potential Payout',
                      style: AppTypography.subtitle2
                          .copyWith(color: AppColorsDS.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '\$${(_amount * 5).toStringAsFixed(2)} (placeholder)',
                      style: AppTypography.subtitle1
                          .copyWith(color: AppColorsDS.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Apply Bet',
                onPressed: () {
                  Navigator.pop(context, _amount);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chipButton(double amount) {
    return SecondaryButton(
      label: '\$${amount.toStringAsFixed(amount < 1 ? 1 : 0)}',
      onPressed: () => _setAmount(amount),
    );
  }
}
