import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/chips.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/dialogs.dart';
import '../../domain/entities/item.dart';
import '../cubit/item_detail_cubit.dart';
import '../cubit/item_detail_state.dart';
import '../cubit/watchlist_cubit.dart';

/// Detailed view of a game item. Shows a large artwork, metadata,
/// rarity badge, wear/float indicator, current price and a simple
/// seven day performance visual. Provides actions to add the item to
/// a trade, add to the watchlist and compare (placeholder). Uses
/// [ItemDetailCubit] to fetch the item by id. The [itemId] must be
/// provided via the constructor or route arguments.
class ItemDetailPage extends StatelessWidget {
  final String itemId;
  const ItemDetailPage({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemDetailCubit>(
      create: (_) => getIt<ItemDetailCubit>()..loadItem(itemId),
      child: BlocBuilder<ItemDetailCubit, ItemDetailState>(
        builder: (context, state) {
          // Loading
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          // Error
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          // Success
          if (state.status == Status.success && state.data != null) {
            final Item item = state.data!;
            // Generate dummy historical values for mini chart (relative to price)
            final random = Random(item.id.hashCode);
            final values = List<double>.generate(
                7, (_) => 0.5 + random.nextDouble() * 0.5);
            final maxVal = values.reduce(max);
            return AppScaffold(
              appBar: AppBar(title: Text(item.name)),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Artwork
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item.imageUrl,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 220,
                            width: double.infinity,
                            color: AppColorsDS.surface,
                            child:
                                const Icon(Icons.image_not_supported, size: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Name and rarity
                      Row(
                        children: [
                          Expanded(
                            child: Text(item.name, style: AppTypography.h3),
                          ),
                          AppChip(
                            label: item.rarity,
                            selected: true,
                            backgroundColor: Colors.transparent,
                            textColor: AppColorsDS.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Metadata
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Game',
                                    style: AppTypography.caption.copyWith(
                                        color: AppColorsDS.textSecondary)),
                                Text(item.game, style: AppTypography.subtitle1),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Wear',
                                    style: AppTypography.caption.copyWith(
                                        color: AppColorsDS.textSecondary)),
                                Text(item.wear.toStringAsFixed(2),
                                    style: AppTypography.subtitle1),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Price',
                                    style: AppTypography.caption.copyWith(
                                        color: AppColorsDS.textSecondary)),
                                Text('\$${item.price.toStringAsFixed(0)}',
                                    style: AppTypography.subtitle1
                                        .copyWith(color: AppColorsDS.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Historical performance mini chart
                      Text('Historical (7d)',
                          style: AppTypography.subtitle2
                              .copyWith(color: AppColorsDS.textSecondary)),
                      const SizedBox(height: AppSpacing.xs),
                      SizedBox(
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final v in values) ...[
                              Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  height: 50 * (v / maxVal),
                                  decoration: BoxDecoration(
                                    color: AppColorsDS.primary.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              label: 'Add to Trade',
                              onPressed: () {
                                // Navigate to trade builder; user will add this item manually
                                Navigator.of(context)
                                    .pushNamed(Routes.tradeBuilder);
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: SecondaryButton(
                              label: 'Watch',
                              onPressed: () async {
                                // Add to watchlist using the cubit from dependency injection
                                final watchlistCubit = getIt<WatchlistCubit>();
                                await watchlistCubit.addToWatchlist(item);
                                showAppSnackBar(
                                  context,
                                  message: '${item.name} added to watchlist',
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: GhostButton(
                              label: 'Compare',
                              onPressed: () {
                                // Placeholder for compare functionality
                                showAppSnackBar(
                                  context,
                                  message: 'Compare feature coming soon',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          // Default fallback
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
