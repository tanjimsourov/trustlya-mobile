import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../domain/entities/watchlist_item.dart';
import '../cubit/watchlist_cubit.dart';
import '../cubit/watchlist_state.dart';

/// Lists the user's watched items and their target price alerts. Allows
/// removal from the watchlist. Uses [WatchlistCubit] to manage the
/// watchlist stored in the repository.
class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<WatchlistCubit>().loadWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WatchlistCubit>(
      create: (_) => getIt<WatchlistCubit>(),
      child: BlocBuilder<WatchlistCubit, WatchlistState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          final List<WatchlistItem> list = state.data ?? [];
          return AppScaffold(
            appBar: AppBar(title: const Text('Watchlist')),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: list.isEmpty
                  ? const EmptyWidget(message: 'No items in your watchlist')
                  : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (_, index) {
                        final entry = list[index];
                        final item = entry.item;
                        return AppCard(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.itemDetail,
                                arguments: item.id);
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.imageUrl,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 50,
                                    width: 50,
                                    color: AppColorsDS.surface,
                                    child: const Icon(Icons.image_not_supported,
                                        size: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name,
                                        style: AppTypography.subtitle1),
                                    const SizedBox(height: 2),
                                    Text(
                                        'Current: \$${item.price.toStringAsFixed(0)}',
                                        style: AppTypography.body2.copyWith(
                                            color: AppColorsDS.textSecondary)),
                                    if (entry.targetPrice != null)
                                      Text(
                                          'Target: \$${entry.targetPrice!.toStringAsFixed(0)}',
                                          style: AppTypography.body2.copyWith(
                                              color: AppColorsDS.info))
                                    else
                                      Text('No target set',
                                          style: AppTypography.body2.copyWith(
                                              color:
                                                  AppColorsDS.textSecondary)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppColorsDS.danger),
                                onPressed: () {
                                  context
                                      .read<WatchlistCubit>()
                                      .removeFromWatchlist(entry);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
