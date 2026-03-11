import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../cubit/promotions_cubit.dart';
import '../cubit/promotions_state.dart';
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

/// Displays a list of active promotions and offers. Users can filter
/// by category and tap on an offer to navigate to the relevant
/// module to claim or view more details.
class PromotionsPage extends StatefulWidget {
  const PromotionsPage({Key? key}) : super(key: key);

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PromotionsCubit>(
      create: (_) => PromotionsCubit(getIt())..load(),
      child: BlocBuilder<PromotionsCubit, PromotionsState>(
        builder: (context, state) {
          Widget content;
          if (state.status == Status.loading) {
            content = const LoadingWidget();
          } else if (state.status == Status.error) {
            content = shared.ErrorWidgetView(message: state.message);
          } else if (state.status == Status.empty ||
              state.data == null ||
              state.data!.isEmpty) {
            content = const EmptyWidget(message: 'No promotions available');
          } else {
            final offers = state.selectedCategory == 'All'
                ? state.data!
                : state.data!
                    .where((o) => o.category == state.selectedCategory)
                    .toList();
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.categories.isNotEmpty) ...[
                  SegmentedControl<String>(
                    values: state.categories,
                    selected: state.selectedCategory,
                    onChanged: (val) =>
                        context.read<PromotionsCubit>().selectCategory(val),
                    labels: state.categories.map((e) => Text(e)).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Expanded(
                  child: ListView.builder(
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AppCard(
                          gradient: true,
                          onTap: () => Navigator.pushNamed(context, offer.route,
                              arguments: offer.arguments),
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
                                    child: Icon(offer.icon,
                                        color: AppColorsDS.onPrimary),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(offer.title,
                                            style: AppTypography.subtitle1
                                                .copyWith(
                                                    color:
                                                        AppColorsDS.onPrimary)),
                                        const SizedBox(height: 2),
                                        Text(offer.description,
                                            style: AppTypography.body2.copyWith(
                                                color: AppColorsDS.onPrimary
                                                    .withOpacity(0.8))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SecondaryButton(
                                    text: 'Learn More',
                                    onPressed: () => Navigator.pushNamed(
                                        context, offer.route,
                                        arguments: offer.arguments),
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
            appBar: AppBar(title: const Text('Promotions')),
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
