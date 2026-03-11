import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/favorite_item.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/segmented_control.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/chips.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Screen that displays all of the user's favourite items across
/// modules. Allows filtering by category and removing entries.
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesCubit>(
      create: (_) => FavoritesCubit(getIt())..load(),
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          Widget content;
          if (state.status == Status.loading) {
            content = const LoadingWidget();
          } else if (state.status == Status.error) {
            content = shared.ErrorWidgetView(message: state.message);
          } else if (state.status == Status.empty ||
              state.data == null ||
              state.data!.isEmpty) {
            content = const EmptyWidget(message: 'No favourites yet');
          } else {
            // Filter items based on selected category
            final items = state.selectedCategory == 'All'
                ? state.data!
                : state.data!
                    .where((i) => i.type == state.selectedCategory)
                    .toList();
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category filter
                if (state.categories.isNotEmpty) ...[
                  SegmentedControl<String>(
                    values: state.categories,
                    selected: state.selectedCategory,
                    onChanged: (val) =>
                        context.read<FavoritesCubit>().selectCategory(val),
                    labels: state.categories.map((e) => Text(e)).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final fav = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AppCard(
                          onTap: () => Navigator.pushNamed(context, fav.route,
                              arguments: fav.arguments),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColorsDS.surface,
                                child:
                                    Icon(fav.icon, color: AppColorsDS.primary),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(fav.title,
                                        style: AppTypography.subtitle1.copyWith(
                                            color: AppColorsDS.textPrimary)),
                                    if (fav.subtitle != null)
                                      Text(fav.subtitle!,
                                          style: AppTypography.caption.copyWith(
                                              color:
                                                  AppColorsDS.textSecondary)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite,
                                    color: AppColorsDS.danger),
                                onPressed: () => context
                                    .read<FavoritesCubit>()
                                    .remove(fav.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return AppScaffold(
            appBar: AppBar(title: const Text('Favourites')),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: content,
            ),
          );
        },
      ),
    );
  }
}
