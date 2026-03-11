import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../cubit/suggestions_cubit.dart';
import '../cubit/suggestions_state.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/segmented_control.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// In‑app command centre providing smart suggestions to the user.
/// Suggestions are grouped by type and each card offers a clear
/// call to action to help the user achieve something valuable.
class SmartSuggestionsPage extends StatefulWidget {
  const SmartSuggestionsPage({Key? key}) : super(key: key);

  @override
  State<SmartSuggestionsPage> createState() => _SmartSuggestionsPageState();
}

class _SmartSuggestionsPageState extends State<SmartSuggestionsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SuggestionsCubit>(
      create: (_) => SuggestionsCubit(getIt())..load(),
      child: BlocBuilder<SuggestionsCubit, SuggestionsState>(
        builder: (context, state) {
          Widget content;
          if (state.status == Status.loading) {
            content = const LoadingWidget();
          } else if (state.status == Status.error) {
            content = shared.ErrorWidgetView(message: state.message);
          } else if (state.status == Status.empty ||
              state.data == null ||
              state.data!.isEmpty) {
            content =
                const EmptyWidget(message: 'No suggestions at the moment');
          } else {
            final list = state.selectedCategory == 'All'
                ? state.data!
                : state.data!
                    .where((s) => s.type == state.selectedCategory)
                    .toList();
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.categories.isNotEmpty) ...[
                  SegmentedControl<String>(
                    values: state.categories,
                    selected: state.selectedCategory,
                    onChanged: (val) =>
                        context.read<SuggestionsCubit>().selectCategory(val),
                    labels: state.categories.map((c) => Text(c)).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AppCard(
                          onTap: () => Navigator.pushNamed(context, item.route,
                              arguments: item.arguments),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(AppSpacing.sm),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColorsDS.surface.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(item.icon,
                                        color: AppColorsDS.primary),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(item.title,
                                        style: AppTypography.subtitle1.copyWith(
                                            color: AppColorsDS.textPrimary)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(item.description,
                                  style: AppTypography.body2.copyWith(
                                      color: AppColorsDS.textSecondary)),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PrimaryButton(
                                    text: 'Act Now',
                                    onPressed: () => Navigator.pushNamed(
                                        context, item.route,
                                        arguments: item.arguments),
                                  ),
                                ],
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
            appBar: AppBar(title: const Text('Smart Suggestions')),
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
