import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/payment_brand_badge.dart';
import '../../domain/entities/fiat_method.dart';
import '../cubit/fiat_ramp_cubit.dart';
import '../cubit/fiat_ramp_state.dart';

class FiatRampPage extends StatelessWidget {
  const FiatRampPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FiatRampCubit>(
      create: (_) => getIt<FiatRampCubit>()..load(),
      child: BlocBuilder<FiatRampCubit, FiatRampState>(
        builder: (context, state) {
          final methods = state.data ?? const <FiatMethod>[];
          final instantCount = methods
              .where((method) => method.processingTime == 'Instant')
              .length;
          final averageFee = methods.isEmpty
              ? 0.0
              : methods.fold<double>(0, (sum, method) => sum + method.fee) /
                  methods.length;

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Fiat rails',
                      title: 'Institutional funding and payout rails',
                      subtitle:
                          'Review available fiat access methods for funding operational wallets and settling balances back to banking or regional payment channels.',
                      metadata: const [
                        StatusBadge(
                            label: 'Operational rails', tone: AppTone.primary),
                        StatusBadge(
                            label: 'Method comparison', tone: AppTone.info),
                      ],
                      actions: [
                        SizedBox(
                          width: 180,
                          child: GhostButton(
                            label: 'Linked methods',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.linkedMethods),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: PrimaryButton(
                            label: 'Refresh',
                            icon: Icons.refresh,
                            onPressed: () =>
                                context.read<FiatRampCubit>().load(),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Providers',
                          value: '${methods.length}',
                          icon: Icons.account_balance_outlined,
                        ),
                        MetricCard(
                          title: 'Instant rails',
                          value: '$instantCount',
                          icon: Icons.flash_on_outlined,
                          iconColor: AppColorsDS.success,
                        ),
                        MetricCard(
                          title: 'Average fee',
                          value: AppFormatters.percent(averageFee * 100,
                              decimals: 1),
                          icon: Icons.percent_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                        MetricCard(
                          title: 'Coverage types',
                          value:
                              '${methods.map((method) => method.type).toSet().length}',
                          icon: Icons.tune_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    if (state.status == Status.loading && methods.isEmpty)
                      const LoadingWidget(label: 'Loading fiat rail catalogue')
                    else if (state.status == Status.error)
                      shared.ErrorWidgetView(
                        message: state.message,
                        onRetry: () => context.read<FiatRampCubit>().load(),
                      )
                    else if (methods.isEmpty)
                      const EmptyWidget(
                        title: 'No fiat rails configured',
                        message:
                            'Funding providers and payout rails will appear here once operational connectivity has been enabled.',
                        icon: Icons.account_balance_wallet_outlined,
                      )
                    else ...[
                      SectionCard(
                        title: 'Available rail catalogue',
                        subtitle:
                            'Compare funding and payout channels by speed, fee, and operating model.',
                        child: Column(
                          children: methods
                              .map(
                                (method) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.md),
                                  child: _FiatRailCard(method: method),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SectionSpacing(),
                      const InsightBanner(
                        title: 'Control expectation',
                        description:
                            'Fiat rails are presented as operational funding paths for wallet balances, not as speculative trading onramps. Fees and processing windows should be reviewed before routing treasury flows.',
                        icon: Icons.shield_outlined,
                        tone: AppTone.primary,
                      ),
                    ],
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

class _FiatRailCard extends StatelessWidget {
  final FiatMethod method;

  const _FiatRailCard({required this.method});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 600;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(method.provider, style: AppTypography.h5),
                  ),
                  StatusBadge(
                    label: AppFormatters.titleCase(method.type),
                    tone: AppTone.info,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xl,
                runSpacing: AppSpacing.md,
                children: [
                  InfoPair(
                    label: 'Fee',
                    value: AppFormatters.percent(method.fee * 100, decimals: 1),
                  ),
                  InfoPair(label: 'Processing', value: method.processingTime),
                  InfoPair(
                    label: 'Operational fit',
                    value: method.type == 'bank'
                        ? 'Treasury settlement'
                        : 'Funding access',
                  ),
                ],
              ),
            ],
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentBrandBadge(provider: method.provider, type: method.type),
                const SizedBox(height: AppSpacing.md),
                details,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentBrandBadge(provider: method.provider, type: method.type),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: details),
            ],
          );
        },
      ),
    );
  }
}
