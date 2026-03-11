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
import '../../domain/entities/counterparty_exposure.dart';
import '../cubit/counterparty_exposure_cubit.dart';
import '../cubit/counterparty_exposure_state.dart';

class CounterpartyExposurePage extends StatelessWidget {
  const CounterpartyExposurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterpartyExposureCubit>(
      create: (_) => getIt<CounterpartyExposureCubit>()..loadExposure(),
      child: BlocBuilder<CounterpartyExposureCubit, CounterpartyExposureState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading counterparty exposure'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<CounterpartyExposureCubit>().loadExposure(),
              ),
            );
          }

          final exposures = state.data ?? <CounterpartyExposure>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Counterparty exposure',
                      title: 'Exposure watchlist',
                      subtitle:
                          'Review upcoming exposure by counterparty, settlement date, and assigned operational risk level.',
                    ),
                    const SectionSpacing(),
                    if (exposures.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No exposure records',
                              tone: AppTone.neutral))
                    else
                      Column(
                        children: exposures
                            .map(
                              (exposure) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: AppCard(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(exposure.counterparty,
                                                style: AppTypography.h5),
                                            const SizedBox(
                                                height: AppSpacing.xs),
                                            Text(
                                              'Settlement ${AppFormatters.dateShort(exposure.settlementDate)}',
                                              style: AppTypography.body2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            AppFormatters.currency(
                                              exposure.exposure,
                                              symbol: exposure.currency,
                                              decimals: 0,
                                            ),
                                            style: AppTypography.subtitle2
                                                .copyWith(
                                                    color: AppColorsDS
                                                        .textPrimary),
                                          ),
                                          const SizedBox(height: AppSpacing.xs),
                                          StatusBadge(
                                            label:
                                                _riskLabel(exposure.riskLevel),
                                            tone: _riskTone(exposure.riskLevel),
                                          ),
                                        ],
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

  static String _riskLabel(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return 'Low risk';
      case RiskLevel.medium:
        return 'Medium risk';
      case RiskLevel.high:
        return 'High risk';
    }
  }

  static AppTone _riskTone(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppTone.success;
      case RiskLevel.medium:
        return AppTone.warning;
      case RiskLevel.high:
        return AppTone.danger;
    }
  }
}
