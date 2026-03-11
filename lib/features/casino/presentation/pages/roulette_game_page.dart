import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/bet_history.dart';
import '../../presentation/cubit/roulette_game_cubit.dart';
import '../../presentation/cubit/roulette_game_state.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// A simplified roulette game page. Users can place a bet amount and
/// spin the wheel. The outcome is simulated via the repository with
/// mock randomness. This page focuses on the visual layout rather
/// than implementing the full roulette betting board.
class RouletteGamePage extends StatefulWidget {
  const RouletteGamePage({Key? key}) : super(key: key);

  @override
  State<RouletteGamePage> createState() => _RouletteGamePageState();
}

class _RouletteGamePageState extends State<RouletteGamePage> {
  final TextEditingController _betController =
      TextEditingController(text: '1.0');
  double _bet = 1.0;

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RouletteGameCubit>(
      create: (_) => getIt<RouletteGameCubit>(),
      child: BlocConsumer<RouletteGameCubit, RouletteGameState>(
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
              title: const Text('Roulette'),
              backgroundColor: AppColorsDS.surface,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Wheel area
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColorsDS.secondary, AppColorsDS.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          state.data != null
                              ? state.data!.result.toUpperCase()
                              : 'Spin!',
                          style: AppTypography.h4.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Bet input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: () {
                            _setBet(100.0);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Quick chips
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
                    // Spin button
                    PrimaryButton(
                      label: state.status == Status.loading
                          ? 'Spinning...'
                          : 'Spin',
                      onPressed: state.status == Status.loading
                          ? null
                          : () {
                              context.read<RouletteGameCubit>().play(_bet);
                            },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Outcome panel
                    if (state.data != null) _buildOutcomePanel(state.data!),
                    const SizedBox(height: AppSpacing.lg),
                    // Fairness info
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
      label: '\$${amount.toStringAsFixed(0)}',
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
