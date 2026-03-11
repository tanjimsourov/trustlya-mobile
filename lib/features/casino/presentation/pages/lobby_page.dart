import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../home/presentation/pages/dashboard_page.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/promotion.dart';
import '../../domain/entities/winner.dart';
import '../../presentation/cubit/casino_lobby_cubit.dart';
import '../../presentation/cubit/casino_lobby_state.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/chips.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../app/routes.dart';

/// Casino lobby page showing featured games, categories, promotions,
/// recent winners and recommendations. This page provides an engaging
/// entry point into the casino module with clear navigation to games
/// and promotions.
class LobbyPage extends StatelessWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CasinoLobbyCubit, CasinoLobbyState>(
      builder: (context, state) {
        switch (state.status) {
          case Status.loading:
            return const LoadingWidget();
          case Status.error:
            return shared.ErrorWidgetView(message: state.message);
          case Status.success:
            final data = state.data!;
            return AppScaffold(
              appBar: AppBar(
                title: const Text('Casino Lobby'),
                backgroundColor: AppColorsDS.surface,
              ),
              body: SingleChildScrollView(
                child: ResponsivePageWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero banner
                      _buildHeroBanner(context),
                      const SectionSpacing(),
                      // Categories
                      _buildCategories(context, data.categories),
                      const SectionSpacing(),
                      // Featured games
                      _buildSectionHeader('Featured Games'),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.featuredGames.length,
                          itemBuilder: (context, index) {
                            final game = data.featuredGames[index];
                            return _buildGameCard(context, game);
                          },
                        ),
                      ),
                      const SectionSpacing(),
                      // Promotions carousel
                      _buildSectionHeader('Promotions'),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 140,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.8),
                          itemCount: data.promotions.length,
                          itemBuilder: (context, index) {
                            final promo = data.promotions[index];
                            return _buildPromotionCard(promo);
                          },
                        ),
                      ),
                      const SectionSpacing(),
                      // Recent winners ticker
                      _buildSectionHeader('Recent Winners'),
                      const SizedBox(height: AppSpacing.sm),
                      _buildWinnersTicker(data.recentWinners),
                      const SectionSpacing(),
                      // Recommended games grid
                      _buildSectionHeader('Recommended for You'),
                      const SizedBox(height: AppSpacing.md),
                      AdaptiveGrid(
                        itemCount: data.recommendedGames.length,
                        minCellWidth: 160,
                        spacing: AppSpacing.md,
                        itemBuilder: (context, index) {
                          final game = data.recommendedGames[index];
                          return _buildGameGridTile(context, game);
                        },
                      ),
                      const SectionSpacing(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            );
          case Status.empty:
            return const EmptyWidget();
          default:
            return const LoadingWidget();
        }
      },
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColorsDS.primary, AppColorsDS.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Trustlya Casino',
              style: AppTypography.h5.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Experience premium games, bonuses and rewards.',
              style: AppTypography.body2.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Play Now',
              onPressed: () {
                // Scroll to featured games or navigate to a default game
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, List<String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final cat in categories)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: AppChip(
                label: cat,
                onTap: () {
                  // Navigate to respective game list or show coming soon
                  final id = cat.toLowerCase();
                  if (id == 'slots' || id == 'roulette' || id == 'blackjack') {
                    Navigator.pushNamed(context, Routes.gameDetail,
                        arguments: id);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, Game game) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.gameDetail, arguments: game.id);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColorsDS.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColorsDS.card,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                      child: Icon(Icons.casino, size: 40, color: Colors.white)),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                game.name,
                style: AppTypography.subtitle1
                    .copyWith(color: AppColorsDS.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                game.description,
                style: AppTypography.caption
                    .copyWith(color: AppColorsDS.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionCard(Promotion promo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Container(
        decoration: BoxDecoration(
          color: AppColorsDS.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColorsDS.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_offer,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promo.title,
                      style: AppTypography.subtitle1
                          .copyWith(color: AppColorsDS.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      promo.description,
                      style: AppTypography.caption
                          .copyWith(color: AppColorsDS.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWinnersTicker(List<Winner> winners) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: winners.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final winner = winners[index];
          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColorsDS.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events,
                    size: 16, color: AppColorsDS.primary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${winner.name} won \$${winner.amount.toStringAsFixed(0)}',
                  style: AppTypography.caption
                      .copyWith(color: AppColorsDS.textPrimary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameGridTile(BuildContext context, Game game) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.gameDetail, arguments: game.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColorsDS.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorsDS.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                    child: Icon(Icons.videogame_asset,
                        size: 40, color: Colors.white)),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              game.name,
              style: AppTypography.subtitle1
                  .copyWith(color: AppColorsDS.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              game.description,
              style: AppTypography.caption
                  .copyWith(color: AppColorsDS.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.subtitle1.copyWith(color: AppColorsDS.textPrimary),
    );
  }
}
