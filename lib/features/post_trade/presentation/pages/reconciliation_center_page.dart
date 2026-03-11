import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/reconciliation_break.dart';
import '../cubit/reconciliation_cubit.dart';
import '../cubit/reconciliation_state.dart';

class ReconciliationCenterPage extends StatelessWidget {
  const ReconciliationCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReconciliationCubit>(
      create: (_) => getIt<ReconciliationCubit>()..loadBreaks(),
      child: BlocBuilder<ReconciliationCubit, ReconciliationState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading reconciliation breaks'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context.read<ReconciliationCubit>().loadBreaks(),
              ),
            );
          }

          final breaks = state.data ?? <ReconciliationBreak>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Reconciliation center',
                      title: 'Break investigation',
                      subtitle:
                          'Review unresolved cash and position breaks with clear monetary impact and resolution status.',
                    ),
                    const SectionSpacing(),
                    if (breaks.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No reconciliation breaks',
                              tone: AppTone.neutral))
                    else
                      Column(
                        children: breaks
                            .map(
                              (breakItem) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: AppCard(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: breakItem.status ==
                                                  BreakStatus.unresolved
                                              ? AppColorsDS.accentAmberSoft
                                              : AppColorsDS.accentGreenSoft,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: Icon(
                                          Icons.compare_arrows_outlined,
                                          color: breakItem.status ==
                                                  BreakStatus.unresolved
                                              ? AppColorsDS.warning
                                              : AppColorsDS.success,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(breakItem.type,
                                                        style:
                                                            AppTypography.h5)),
                                                StatusBadge(
                                                  label: breakItem.status ==
                                                          BreakStatus.unresolved
                                                      ? 'Unresolved'
                                                      : 'Resolved',
                                                  tone: breakItem.status ==
                                                          BreakStatus.unresolved
                                                      ? AppTone.warning
                                                      : AppTone.success,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: AppSpacing.xs),
                                            Text(breakItem.description,
                                                style: AppTypography.body2),
                                            const SizedBox(
                                                height: AppSpacing.md),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InfoPair(
                                                    label: 'Impact',
                                                    value:
                                                        AppFormatters.currency(
                                                      breakItem.amount,
                                                      symbol:
                                                          breakItem.currency,
                                                      decimals: 0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InfoPair(
                                                    label: 'Raised',
                                                    value:
                                                        AppFormatters.dateShort(
                                                            breakItem.date),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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
}
