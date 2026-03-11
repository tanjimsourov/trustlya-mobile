import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/chips.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/game_detail_cubit.dart';
import '../../presentation/cubit/game_detail_state.dart';
import '../../domain/entities/game_detail.dart';
import '../../../../app/routes.dart';
import '../../../../shared/cubit/base_state.dart';

/// Displays detailed information about a casino game. Shows hero artwork,
/// description, RTP/fairness info, betting limits and tags. Includes a
/// CTA to start playing the game.
class GameDetailPage extends StatelessWidget {
  final String gameId;
  const GameDetailPage({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameDetailCubit, GameDetailState>(
      builder: (context, state) {
        switch (state.status) {
          case Status.loading:
            return const LoadingWidget();
          case Status.error:
            return shared.ErrorWidgetView(message: state.message);
          case Status.success:
            final detail = state.data!;
            return AppScaffold(
              appBar: AppBar(
                title: Text(detail.name),
                backgroundColor: AppColorsDS.surface,
              ),
              body: SingleChildScrollView(
                child: ResponsivePageWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHero(detail),
                      const SectionSpacing(),
                      Text(
                        detail.name,
                        style: AppTypography.h5
                            .copyWith(color: AppColorsDS.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        detail.description,
                        style: AppTypography.body1
                            .copyWith(color: AppColorsDS.textSecondary),
                      ),
                      const SectionSpacing(),
                      _buildFairness(detail),
                      const SectionSpacing(),
                      _buildBetLimits(detail),
                      const SectionSpacing(),
                      _buildTags(detail.tags),
                      const SectionSpacing(),
                      PrimaryButton(
                        label: 'Play Now',
                        onPressed: () {
                          // Determine route based on game id
                          String route;
                          switch (detail.id) {
                            case 'slots':
                              route = Routes.slotsGame;
                              break;
                            case 'roulette':
                              route = Routes.rouletteGame;
                              break;
                            case 'blackjack':
                              route = Routes.blackjackGame;
                              break;
                            default:
                              route = Routes.slotsGame;
                          }
                          Navigator.pushNamed(context, route);
                        },
                      ),
                      const SectionSpacing(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            );
          default:
            return const LoadingWidget();
        }
      },
    );
  }

  Widget _buildHero(GameDetail detail) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColorsDS.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.videogame_asset,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFairness(GameDetail detail) {
    return Row(
      children: [
        const Icon(Icons.shield, size: 20, color: AppColorsDS.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'RTP: ${detail.rtp.toStringAsFixed(1)}%',
          style:
              AppTypography.subtitle2.copyWith(color: AppColorsDS.textPrimary),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          'Provably fair',
          style: AppTypography.caption.copyWith(color: AppColorsDS.success),
        ),
      ],
    );
  }

  Widget _buildBetLimits(GameDetail detail) {
    return Row(
      children: [
        _buildLimitCard('Min Bet', detail.minBet),
        const SizedBox(width: AppSpacing.md),
        _buildLimitCard('Max Bet', detail.maxBet),
      ],
    );
  }

  Widget _buildLimitCard(String label, double value) {
    return Expanded(
      child: Container(
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
              label,
              style: AppTypography.caption
                  .copyWith(color: AppColorsDS.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '\$${value.toStringAsFixed(2)}',
              style: AppTypography.subtitle1
                  .copyWith(color: AppColorsDS.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags(List<String> tags) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: tags
          .map((tag) => AppChip(
                label: tag,
              ))
          .toList(),
    );
  }
}
