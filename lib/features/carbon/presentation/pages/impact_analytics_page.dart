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
import '../../domain/entities/impact_analytics.dart';
import '../cubit/impact_analytics_cubit.dart';
import '../cubit/impact_analytics_state.dart';

class ImpactAnalyticsPage extends StatelessWidget {
  const ImpactAnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImpactAnalyticsCubit>(
      create: (_) => getIt<ImpactAnalyticsCubit>()..load(),
      child: BlocBuilder<ImpactAnalyticsCubit, ImpactAnalyticsState>(
        builder: (context, state) {
          final analytics = state.data;

          if (state.status == Status.loading && analytics == null) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading impact analytics'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context.read<ImpactAnalyticsCubit>().load(),
              ),
            );
          }

          if (analytics == null) {
            return const AppScaffold(
              body: EmptyWidget(
                title: 'No impact analytics available',
                message:
                    'Retirement activity is required before analytics can be generated.',
                icon: Icons.insights_outlined,
              ),
            );
          }

          final monthlyAverage = analytics.monthlyData.isEmpty
              ? 0.0
              : analytics.monthlyData.reduce((a, b) => a + b) /
                  analytics.monthlyData.length;
          final yearlyPeak = analytics.yearlyData.isEmpty
              ? 0.0
              : analytics.yearlyData.reduce((a, b) => a > b ? a : b);

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Impact analytics',
                      title: 'Retirement and offset reporting',
                      subtitle:
                          'Track cumulative offset delivery, monitor monthly and yearly retirement patterns, and review the project mix behind recorded impact.',
                      metadata: const [
                        StatusBadge(
                            label: 'Reporting ready', tone: AppTone.primary),
                        StatusBadge(
                            label: 'Portfolio breakdown',
                            tone: AppTone.success),
                      ],
                      actions: [
                        SizedBox(
                          width: 150,
                          child: GhostButton(
                            label: 'History',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonHistory),
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: PrimaryButton(
                            label: 'Retire credits',
                            icon: Icons.verified_outlined,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonRetire),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Total offset',
                          value:
                              '${analytics.totalOffset.toStringAsFixed(1)} tCO2e',
                          icon: Icons.eco_outlined,
                          iconColor: AppColorsDS.success,
                        ),
                        MetricCard(
                          title: 'Monthly average',
                          value: '${monthlyAverage.toStringAsFixed(1)} tCO2e',
                          icon: Icons.calendar_month_outlined,
                        ),
                        MetricCard(
                          title: 'Yearly peak',
                          value: '${yearlyPeak.toStringAsFixed(1)} tCO2e',
                          icon: Icons.trending_up_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Projects represented',
                          value: '${analytics.projectBreakdown.length}',
                          icon: Icons.account_tree_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stacked = constraints.maxWidth < 980;

                        final monthlyPanel = SectionCard(
                          title: 'Monthly retirement trend',
                          subtitle: 'Rolling 12-month retirement activity.',
                          child: _BarSeriesChart(
                            values: analytics.monthlyData,
                            color: AppColorsDS.success,
                          ),
                        );

                        final yearlyPanel = SectionCard(
                          title: 'Yearly offset progression',
                          subtitle:
                              'Year-over-year offset trajectory based on recorded retirements.',
                          child: _BarSeriesChart(
                            values: analytics.yearlyData,
                            color: AppColorsDS.primary,
                          ),
                        );

                        if (stacked) {
                          return Column(
                            children: [
                              monthlyPanel,
                              const SectionSpacing(height: AppSpacing.md),
                              yearlyPanel,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: monthlyPanel),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(child: yearlyPanel),
                          ],
                        );
                      },
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Project contribution mix',
                      subtitle: 'Share of total retired volume by project.',
                      child: analytics.projectBreakdown.isEmpty
                          ? const EmptyWidget(
                              title: 'No retired positions yet',
                              message:
                                  'Once credits are retired, the project contribution mix will appear here.',
                              icon: Icons.pie_chart_outline,
                            )
                          : Column(
                              children: analytics.projectBreakdown.entries
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSpacing.md),
                                      child: _BreakdownRow(
                                        label: entry.key,
                                        value: entry.value,
                                        maxValue: analytics
                                            .projectBreakdown.values
                                            .reduce((a, b) => a > b ? a : b),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    const SectionSpacing(),
                    InsightBanner(
                      title: 'Reporting context',
                      description:
                          'Use the retirement trend and project mix together when preparing sustainability reports, audit packs, or procurement reviews.',
                      icon: Icons.fact_check_outlined,
                      tone: analytics.totalOffset > 0
                          ? AppTone.info
                          : AppTone.neutral,
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

class _BarSeriesChart extends StatelessWidget {
  final List<double> values;
  final Color color;

  const _BarSeriesChart({
    required this.values,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const EmptyWidget(
        title: 'No data points',
        message:
            'Recorded activity will appear here once retirements are available.',
        icon: Icons.bar_chart_outlined,
      );
    }

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 170,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.map((value) {
          final ratio = maxValue == 0 ? 0.0 : value / maxValue;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    value.toStringAsFixed(0),
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    height: 20 + (ratio * 100),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.78),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;

  const _BreakdownRow({
    required this.label,
    required this.value,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue == 0 ? 0.0 : value / maxValue;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(label,
              style:
                  AppTypography.body2.copyWith(color: AppColorsDS.textPrimary)),
        ),
        Expanded(
          flex: 5,
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppColorsDS.surfaceMuted,
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: ratio,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorsDS.success,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          '${value.toStringAsFixed(1)} tCO2e',
          style: AppTypography.caption,
        ),
      ],
    );
  }
}
