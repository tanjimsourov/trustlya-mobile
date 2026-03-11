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
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/carbon_holding.dart';
import '../../domain/entities/carbon_project.dart';
import '../cubit/carbon_history_cubit.dart';
import '../cubit/carbon_history_state.dart';
import '../cubit/holdings_cubit.dart';
import '../cubit/holdings_state.dart';
import '../cubit/marketplace_dashboard_cubit.dart';
import '../cubit/marketplace_dashboard_state.dart';

class CarbonDashboardPage extends StatelessWidget {
  final bool embedded;

  const CarbonDashboardPage({Key? key, this.embedded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = MultiBlocProvider(
      providers: [
        BlocProvider<MarketplaceDashboardCubit>(
          create: (_) => getIt<MarketplaceDashboardCubit>()..load(),
        ),
        BlocProvider<HoldingsCubit>(
          create: (_) => getIt<HoldingsCubit>()..load(),
        ),
        BlocProvider<CarbonHistoryCubit>(
          create: (_) => getIt<CarbonHistoryCubit>()..load(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final dashboardState =
              context.watch<MarketplaceDashboardCubit>().state;
          final holdingsState = context.watch<HoldingsCubit>().state;
          final historyState = context.watch<CarbonHistoryCubit>().state;

          final loading = [
            dashboardState.status,
            holdingsState.status,
            historyState.status,
          ].contains(Status.loading);

          final error = dashboardState.message ??
              holdingsState.message ??
              historyState.message;
          final hasError = [
            dashboardState.status,
            holdingsState.status,
            historyState.status,
          ].contains(Status.error);

          if (loading) {
            return const LoadingWidget(label: 'Loading carbon marketplace');
          }

          if (hasError) {
            return shared.ErrorWidgetView(
              message: error,
              onRetry: () {
                context.read<MarketplaceDashboardCubit>().load();
                context.read<HoldingsCubit>().load();
                context.read<CarbonHistoryCubit>().load();
              },
            );
          }

          final dashboard = dashboardState.data!;
          final holdings = holdingsState.data ?? <CarbonHolding>[];
          final history = historyState.data ?? [];

          final body = SingleChildScrollView(
            child: ResponsivePageWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    eyebrow: 'Carbon credit marketplace',
                    title: 'Tokenized carbon sourcing and retirement',
                    subtitle:
                        'Source verified projects, monitor marketplace inventory, manage holdings, and retire credits with auditable operational records.',
                    metadata: const [
                      StatusBadge(
                          label: 'Verified projects', tone: AppTone.success),
                      StatusBadge(
                          label: 'Retirement reporting', tone: AppTone.primary),
                      StatusBadge(
                          label: 'Lifecycle visibility', tone: AppTone.info),
                    ],
                    actions: [
                      SizedBox(
                        width: 140,
                        child: GhostButton(
                          label: 'Holdings',
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.carbonHoldings),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: PrimaryButton(
                          label: 'Browse projects',
                          icon: Icons.arrow_forward,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.carbonProjects),
                        ),
                      ),
                    ],
                  ),
                  const SectionSpacing(),
                  AdaptiveGrid(
                    itemCount: 4,
                    minCellWidth: 240,
                    itemBuilder: (_, index) {
                      switch (index) {
                        case 0:
                          return MetricCard(
                            title: 'Credits held',
                            value:
                                dashboard.totalCreditsHeld.toStringAsFixed(0),
                            icon: Icons.inventory_2_outlined,
                          );
                        case 1:
                          return MetricCard(
                            title: 'Impact delivered',
                            value:
                                '${dashboard.totalImpact.toStringAsFixed(1)} tCO2e',
                            icon: Icons.eco_outlined,
                            iconColor: AppColorsDS.success,
                          );
                        case 2:
                          return MetricCard(
                            title: 'Active holdings',
                            value:
                                '${holdings.where((item) => !item.retired).length}',
                            icon: Icons.pie_chart_outline,
                          );
                        default:
                          return MetricCard(
                            title: 'Recent transactions',
                            value: '${history.length}',
                            icon: Icons.receipt_long_outlined,
                            iconColor: AppColorsDS.secondary,
                          );
                      }
                    },
                  ),
                  const SectionSpacing(),
                  SectionCard(
                    title: 'Marketplace actions',
                    subtitle:
                        'Move from sourcing to retirement without leaving the carbon workspace.',
                    child: Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: [
                        SizedBox(
                          width: 180,
                          child: PrimaryButton(
                            label: 'Buy credits',
                            icon: Icons.add_shopping_cart_outlined,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonProjects),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: GhostButton(
                            label: 'Retire',
                            icon: Icons.verified_outlined,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonRetire),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: GhostButton(
                            label: 'Analytics',
                            icon: Icons.insights_outlined,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonImpact),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: GhostButton(
                            label: 'History',
                            icon: Icons.receipt_long_outlined,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonHistory),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SectionSpacing(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 980;

                      final projectPanel = SectionCard(
                        title: 'Featured projects',
                        subtitle:
                            'Projects currently highlighted for procurement and retirement workflows.',
                        child: Column(
                          children: dashboard.featuredProjects
                              .map(
                                (project) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm),
                                  child: _ProjectTile(project: project),
                                ),
                              )
                              .toList(),
                        ),
                      );

                      final holdingsPanel = SectionCard(
                        title: 'Holdings summary',
                        subtitle: 'Current carbon inventory across projects.',
                        child: holdings.isEmpty
                            ? const Center(
                                child: StatusBadge(
                                    label: 'No holdings available',
                                    tone: AppTone.neutral))
                            : Column(
                                children: holdings
                                    .take(4)
                                    .map(
                                      (holding) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: AppSpacing.sm),
                                        child: _HoldingTile(holding: holding),
                                      ),
                                    )
                                    .toList(),
                              ),
                      );

                      if (stacked) {
                        return Column(
                          children: [
                            projectPanel,
                            const SectionSpacing(height: AppSpacing.md),
                            holdingsPanel,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: projectPanel),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: holdingsPanel),
                        ],
                      );
                    },
                  ),
                  const SectionSpacing(),
                  SectionCard(
                    title: 'Recent carbon activity',
                    subtitle:
                        'Latest buys and retirement events for reporting teams.',
                    child: history.isEmpty
                        ? const Center(
                            child: StatusBadge(
                                label: 'No recent transactions',
                                tone: AppTone.neutral))
                        : Column(
                            children: history
                                .take(4)
                                .map(
                                  (tx) => TimelineTile(
                                    title:
                                        '${AppFormatters.titleCase(tx.type)} • ${tx.projectName}',
                                    subtitle:
                                        '${tx.quantity.toStringAsFixed(2)} credits at ${AppFormatters.currency(tx.pricePerCredit, symbol: '\$', decimals: 2, symbolFirst: true)}',
                                    trailing: AppFormatters.dateShort(tx.date),
                                    accent: tx.type == 'retire'
                                        ? AppColorsDS.success
                                        : AppColorsDS.primary,
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          );

          if (embedded) {
            return body;
          }

          return AppScaffold(body: body);
        },
      ),
    );

    return content;
  }
}

class _ProjectTile extends StatelessWidget {
  final CarbonProject project;

  const _ProjectTile({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.carbonProjectDetail, arguments: project.id),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColorsDS.accentGreenSoft,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: const Icon(Icons.eco_outlined, color: AppColorsDS.success),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name, style: AppTypography.h5),
                Text('${project.category} • ${project.location}',
                    style: AppTypography.body2),
              ],
            ),
          ),
          Text(
            AppFormatters.currency(project.pricePerCredit,
                symbol: '\$', decimals: 2, symbolFirst: true),
            style: AppTypography.subtitle2
                .copyWith(color: AppColorsDS.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _HoldingTile extends StatelessWidget {
  final CarbonHolding holding;

  const _HoldingTile({Key? key, required this.holding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.of(context).pushNamed(Routes.carbonHoldings),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: holding.retired
                  ? AppColorsDS.accentSlateSoft
                  : AppColorsDS.accentGreenSoft,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Icon(
              holding.retired
                  ? Icons.verified_outlined
                  : Icons.inventory_2_outlined,
              color: holding.retired
                  ? AppColorsDS.textSecondary
                  : AppColorsDS.success,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(holding.projectName, style: AppTypography.h5),
                Text('${holding.quantity.toStringAsFixed(2)} credits',
                    style: AppTypography.body2),
              ],
            ),
          ),
          StatusBadge(
            label: holding.retired ? 'Retired' : 'Active',
            tone: holding.retired ? AppTone.neutral : AppTone.success,
          ),
        ],
      ),
    );
  }
}
