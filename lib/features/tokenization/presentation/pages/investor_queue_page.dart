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
import '../../domain/entities/onboarding_case.dart';
import '../cubit/investor_queue_cubit.dart';
import '../cubit/investor_queue_state.dart';

class InvestorQueuePage extends StatelessWidget {
  const InvestorQueuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvestorQueueCubit>(
      create: (_) => getIt<InvestorQueueCubit>()..loadQueue(),
      child: BlocBuilder<InvestorQueueCubit, InvestorQueueState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading investor queue'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context.read<InvestorQueueCubit>().loadQueue(),
              ),
            );
          }

          final cases = state.data ?? <OnboardingCase>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Investor queue',
                      title: 'Onboarding and review cases',
                      subtitle:
                          'Review institutional investor submissions, committed allocations, and queue status before progressing issuance access.',
                    ),
                    const SectionSpacing(),
                    if (cases.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No onboarding cases',
                              tone: AppTone.neutral))
                    else
                      Column(
                        children: cases
                            .map(
                              (caseItem) => Padding(
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
                                        decoration: const BoxDecoration(
                                          color: AppColorsDS.accentBlueSoft,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: const Icon(Icons.groups_outlined,
                                            color: AppColorsDS.primary),
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
                                                  child: Text(
                                                      caseItem.investor.name,
                                                      style: AppTypography.h5),
                                                ),
                                                StatusBadge(
                                                  label: _statusLabel(
                                                      caseItem.status),
                                                  tone: _statusTone(
                                                      caseItem.status),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: AppSpacing.xs),
                                            Text(caseItem.investor.organization,
                                                style: AppTypography.body2),
                                            const SizedBox(
                                                height: AppSpacing.md),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InfoPair(
                                                    label: 'Country',
                                                    value: caseItem
                                                        .investor.country,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InfoPair(
                                                    label: 'Committed',
                                                    value:
                                                        AppFormatters.currency(
                                                      caseItem.investor
                                                          .committedAmount,
                                                      symbol: '€',
                                                      decimals: 0,
                                                      symbolFirst: true,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InfoPair(
                                                    label: 'Submitted',
                                                    value:
                                                        AppFormatters.dateShort(
                                                            caseItem
                                                                .submittedAt),
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

  static String _statusLabel(OnboardingStatus status) {
    switch (status) {
      case OnboardingStatus.awaitingReview:
        return 'Awaiting review';
      case OnboardingStatus.inReview:
        return 'In review';
      case OnboardingStatus.completed:
        return 'Completed';
      case OnboardingStatus.rejected:
        return 'Rejected';
    }
  }

  static AppTone _statusTone(OnboardingStatus status) {
    switch (status) {
      case OnboardingStatus.awaitingReview:
        return AppTone.warning;
      case OnboardingStatus.inReview:
        return AppTone.info;
      case OnboardingStatus.completed:
        return AppTone.success;
      case OnboardingStatus.rejected:
        return AppTone.danger;
    }
  }
}
