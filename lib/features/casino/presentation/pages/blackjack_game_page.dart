import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../presentation/cubit/blackjack_game_cubit.dart';
import '../../presentation/cubit/blackjack_game_state.dart';
import '../../domain/entities/bet_history.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// A simplified blackjack game page. Players can place a bet and play a hand.
/// The result is randomly determined by the repository. This page
/// emphasises premium UI rather than actual game mechanics.
class BlackjackGamePage extends StatefulWidget {
  const BlackjackGamePage({Key? key}) : super(key: key);

  @override
  State<BlackjackGamePage> createState() => _BlackjackGamePageState();
}

class _BlackjackGamePageState extends State<BlackjackGamePage> {
  final TextEditingController _betController =
      TextEditingController(text: '5.0');
  double _bet = 5.0;

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
    return BlocProvider<BlackjackGameCubit>(
      create: (_) => getIt<BlackjackGameCubit>(),
      child: BlocConsumer<BlackjackGameCubit, BlackjackGameState>(
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
              title: const Text('Blackjack'),
              backgroundColor: AppColorsDS.surface,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Card display
                    _buildCardsDisplay(),
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
                        _chipButton(1),
                        _chipButton(5),
                        _chipButton(10),
                        _chipButton(25),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            label: 'Hit',
                            onPressed: () {
                              // For mock UI we treat every control as playing the hand
                              if (state.status != Status.loading) {
                                context.read<BlackjackGameCubit>().play(_bet);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: SecondaryButton(
                            label: 'Stand',
                            onPressed: () {
                              if (state.status != Status.loading) {
                                context.read<BlackjackGameCubit>().play(_bet);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            label: 'Double',
                            onPressed: () {
                              if (state.status != Status.loading) {
                                _setBet(_bet * 2);
                                context.read<BlackjackGameCubit>().play(_bet);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: SecondaryButton(
                            label: 'Split',
                            onPressed: () {
                              // Splitting is not implemented; just play again
                              if (state.status != Status.loading) {
                                context.read<BlackjackGameCubit>().play(_bet);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PrimaryButton(
                      label: state.status == Status.loading
                          ? 'Dealing...'
                          : 'Deal',
                      onPressed: state.status == Status.loading
                          ? null
                          : () {
                              context.read<BlackjackGameCubit>().play(_bet);
                            },
                    ),
                    const SizedBox(height: AppSpacing.lg),
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

  Widget _buildCardsDisplay() {
    // Simple placeholder for dealer and player hands
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _cardPlaceholder('🂠'),
            const SizedBox(width: AppSpacing.sm),
            _cardPlaceholder('🂠'),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _cardPlaceholder('🂠'),
            const SizedBox(width: AppSpacing.sm),
            _cardPlaceholder('🂠'),
          ],
        ),
      ],
    );
  }

  Widget _cardPlaceholder(String symbol) {
    return Container(
      width: 60,
      height: 90,
      decoration: BoxDecoration(
        color: AppColorsDS.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          symbol,
          style: const TextStyle(fontSize: 32),
        ),
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
