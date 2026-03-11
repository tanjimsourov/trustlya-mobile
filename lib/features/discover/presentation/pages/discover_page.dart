import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../cubit/discover_cubit.dart';
import '../cubit/discover_state.dart';
import '../../domain/entities/discover_item.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/segmented_control.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Explore and discover page that surfaces curated items across
/// modules. Users can filter by category or browse all items with
/// sections. Each item navigates to its respective detail page.
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscoverCubit>(
      create: (_) => DiscoverCubit(getIt())..load(),
      child: BlocBuilder<DiscoverCubit, DiscoverState>(
        builder: (context, state) {
          Widget body;
          if (state.status == Status.loading) {
            body = const LoadingWidget();
          } else if (state.status == Status.error) {
            body = shared.ErrorWidgetView(message: state.message);
          } else if (state.status == Status.empty ||
              state.data == null ||
              state.data!.isEmpty) {
            body = const EmptyWidget(message: 'Nothing to discover yet');
          } else {
            final items = state.data!;
            body = _buildContent(context, items, state);
          }
          return AppScaffold(
            appBar: AppBar(title: const Text('Discover')),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: body,
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, List<DiscoverItem> items, DiscoverState state) {
    final cubit = context.read<DiscoverCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.categories.isNotEmpty) ...[
          SegmentedControl<String>(
            values: state.categories,
            selected: state.selectedCategory,
            onChanged: (val) => cubit.selectCategory(val),
            labels: state.categories.map((c) => Text(c)).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Expanded(
          child: state.selectedCategory == 'All'
              ? _buildAllSections(context, items)
              : _buildCategoryList(
                  context,
                  items
                      .where((i) => i.type == state.selectedCategory)
                      .toList()),
        ),
      ],
    );
  }

  /// Builds a list of sections for all categories. Each section
  /// contains a title and a horizontal list of discover items of that
  /// type.
  Widget _buildAllSections(BuildContext context, List<DiscoverItem> items) {
    final Map<String, List<DiscoverItem>> groups = {};
    for (final item in items) {
      groups.putIfAbsent(item.type, () => []).add(item);
    }
    return ListView(
      children: groups.entries.map((entry) {
        final type = entry.key;
        final list = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type,
                style:
                    AppTypography.h4.copyWith(color: AppColorsDS.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return SizedBox(
                    width: 200,
                    child: AppCard(
                      onTap: () => Navigator.pushNamed(context, item.route,
                          arguments: item.arguments),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColorsDS.surface.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    Icon(item.icon, color: AppColorsDS.primary),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: AppTypography.subtitle2
                                      .copyWith(color: AppColorsDS.textPrimary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              item.description,
                              style: AppTypography.caption
                                  .copyWith(color: AppColorsDS.textSecondary),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text('Learn more',
                              style: AppTypography.overline
                                  .copyWith(color: AppColorsDS.primary)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        );
      }).toList(),
    );
  }

  /// Builds a list view for a single category selection.
  Widget _buildCategoryList(BuildContext context, List<DiscoverItem> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: AppCard(
            onTap: () => Navigator.pushNamed(context, item.route,
                arguments: item.arguments),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColorsDS.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: AppColorsDS.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: AppTypography.subtitle1
                              .copyWith(color: AppColorsDS.textPrimary)),
                      const SizedBox(height: 2),
                      Text(item.description,
                          style: AppTypography.body2
                              .copyWith(color: AppColorsDS.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColorsDS.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }
}
