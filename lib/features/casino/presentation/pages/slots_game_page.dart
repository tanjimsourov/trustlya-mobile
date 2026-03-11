import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/bet_history.dart';
import '../../presentation/cubit/slots_game_cubit.dart';
import '../../presentation/cubit/slots_game_state.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// A premium slots game mock. Allows the user to set a bet amount,
/// spin the reels and displays an outcome. The visual reel uses
/// random emoji icons to simulate slot symbols.
class SlotsGamePage extends StatefulWidget {
  const SlotsGamePage({Key? key}) : super(key: key);

  @override
  State<SlotsGamePage> createState() => _SlotsGamePageState();
}

class _SlotsGamePageState extends State<SlotsGamePage> {
  final TextEditingController _betController =
      TextEditingController(text: '1.0');
  double _bet = 1.0;
  final Random _rand = Random();
  List<String> _symbols = ['🍒', '🔔', '💎', '7️⃣', '🍋', '🍀'];
  List<String> _reels = ['🍒', '🍒', '🍒'];

  @override
  void dispose() {
    _betController.dispose();
    super.dispose();
  }

  void _setBet(double value) {
    setState(() {
      _bet = value;
      _betController.text = value.toStringAsFixed(2);
    });
  }

  void _spinReels() {
    setState(() {
      _reels =
          List.generate(3, (_) => _symbols[_rand.nextInt(_symbols.length)]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SlotsGameCubit>(
      create: (_) => getIt<SlotsGameCubit>(),
      child: BlocConsumer<SlotsGameCubit, SlotsGameState>(
        listener: (context, state) {
          if (state.status == Status.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Error')),
            );
          }
        },
        builder: (context, state) {
          return AppScaffold(
            appBar: AppBar(
              title: const Text('Slots'),
              backgroundColor: AppColorsDS.surface,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Slot cabinet display
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColorsDS.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _reels
                            .map((s) => Text(
                                  s,
                                  style: const TextStyle(fontSize: 48),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Bet input and quick chips
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _betController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Bet Amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              final v = double.tryParse(value);
                              if (v != null) {
                                _bet = v;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        PrimaryButton(
                          label: 'Max',
                          onPressed: () => _setBet(100.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        _chipButton(0.5),
                        _chipButton(1),
                        _chipButton(2),
                        _chipButton(5),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Spin button
                    PrimaryButton(
                      label: state.status == Status.loading
                          ? 'Spinning...'
                          : 'Spin',
                      onPressed: state.status == Status.loading
                          ? null
                          : () {
                              _spinReels();
                              context.read<SlotsGameCubit>().play(_bet);
                            },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Outcome panel
                    if (state.data != null) _buildOutcomePanel(state.data!),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shield,
                            size: 18, color: AppColorsDS.primary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Provably fair',
                          style: AppTypography.caption
                              .copyWith(color: AppColorsDS.success),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _chipButton(double amount) {
    return SecondaryButton(
      label: '\$${amount.toStringAsFixed(amount < 1 ? 1 : 0)}',
      onPressed: () => _setBet(amount),
    );
  }

  Widget _buildOutcomePanel(BetHistoryItem result) {
    final payout = result.payout;
    final isWin = payout > 0;
    return Container(
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
        children: [
          Text(
            isWin ? 'You win!' : 'You lose',
            style: AppTypography.subtitle1.copyWith(
                color: isWin ? AppColorsDS.success : AppColorsDS.danger),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isWin
                ? '+\$${payout.toStringAsFixed(2)}'
                : '-\$${(-payout).toStringAsFixed(2)}',
            style: AppTypography.h5.copyWith(
                color: isWin ? AppColorsDS.success : AppColorsDS.danger),
          ),
        ],
      ),
    );
  }
}
