import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/search_result.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../../domain/entities/search_result_data.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/segmented_control.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../app/routes.dart';

/// Global search screen allowing users to search across all modules.
/// Provides category filters, suggestions, recent searches and
/// unified results. Uses [SearchCubit] for state management.
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (_) => SearchCubit(getIt()),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final data = state.data ?? const SearchResultData();
          Widget body;
          switch (state.status) {
            case Status.loading:
              body = const LoadingWidget();
              break;
            case Status.error:
              body = shared.ErrorWidgetView(message: state.message);
              break;
            case Status.empty:
              body = _buildEmpty(data);
              break;
            case Status.success:
              body = _buildContent(data);
              break;
            default:
              body = const LoadingWidget();
          }
          return AppScaffold(
            appBar: AppBar(
              title: const Text('Search'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search input
                  SearchField(
                    controller: _controller,
                    hintText: 'Search for anything...',
                    onChanged: (value) {
                      if (value.isEmpty) {
                        context.read<SearchCubit>().clear();
                      } else {
                        context.read<SearchCubit>().search(value);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Categories segmented control
                  SegmentedControl<String>(
                    values: data.categories,
                    selected: data.selectedCategory,
                    onChanged: (val) {
                      // Keep same query
                      context
                          .read<SearchCubit>()
                          .selectCategory(val, query: _controller.text);
                    },
                    labels: data.categories.map((e) => Text(e)).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(child: body),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the content for the success state. Shows suggestions and
  /// recents when there are no results, otherwise displays result
  /// cards.
  Widget _buildContent(SearchResultData data) {
    if (data.results.isEmpty) {
      return _buildEmpty(data);
    }
    return ListView.builder(
      itemCount: data.results.length,
      itemBuilder: (context, index) {
        final res = data.results[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: AppCard(
            onTap: () {
              Navigator.pushNamed(context, res.route, arguments: res.arguments);
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColorsDS.surface,
                  child: Icon(res.icon, color: AppColorsDS.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        res.title,
                        style: AppTypography.subtitle1
                            .copyWith(color: AppColorsDS.textPrimary),
                      ),
                      if (res.subtitle != null)
                        Text(
                          res.subtitle!,
                          style: AppTypography.caption
                              .copyWith(color: AppColorsDS.textSecondary),
                        ),
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

  /// Builds suggestions and recent searches when there are no results.
  Widget _buildEmpty(SearchResultData data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.suggestions.isNotEmpty) ...[
            Text('Suggestions',
                style: AppTypography.subtitle1
                    .copyWith(color: AppColorsDS.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              children: data.suggestions.map((s) {
                return GestureDetector(
                  onTap: () {
                    _controller.text = s;
                    context.read<SearchCubit>().search(s);
                  },
                  child: Chip(
                    label: Text(s),
                    backgroundColor: AppColorsDS.surface,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (data.recentSearches.isNotEmpty) ...[
            Text('Recent Searches',
                style: AppTypography.subtitle1
                    .copyWith(color: AppColorsDS.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              children: data.recentSearches.map((r) {
                return GestureDetector(
                  onTap: () {
                    _controller.text = r;
                    context.read<SearchCubit>().search(r);
                  },
                  child: Chip(
                    label: Text(r),
                    backgroundColor: AppColorsDS.surface,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (data.suggestions.isEmpty && data.recentSearches.isEmpty)
            const EmptyWidget(),
        ],
      ),
    );
  }
}
