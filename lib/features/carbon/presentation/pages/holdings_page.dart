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
import '../../domain/entities/carbon_holding.dart';
import '../cubit/holdings_cubit.dart';
import '../cubit/holdings_state.dart';

class HoldingsPage extends StatelessWidget {
  const HoldingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HoldingsCubit>(
      create: (_) => getIt<HoldingsCubit>()..load(),
      child: BlocBuilder<HoldingsCubit, HoldingsState>(
        builder: (context, state) {
          final holdings = state.data ?? const <CarbonHolding>[];
          final activeHoldings = holdings
              .where((holding) => !holding.retired && holding.quantity > 0)
              .toList();
          final retiredHoldings = holdings
              .where((holding) => holding.retired || holding.quantity <= 0)
              .toList();
          final portfolioValue = activeHoldings.fold<double>(
              0, (sum, holding) => sum + holding.value);
          final totalCredits = activeHoldings.fold<double>(
              0, (sum, holding) => sum + holding.quantity);

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Carbon holdings',
                      title: 'Portfolio and retirement-ready positions',
                      subtitle:
                          'Review active positions, archived retirements, and value exposure across the carbon portfolio before sourcing or retiring additional credits.',
                      metadata: const [
                        StatusBadge(
                            label: 'Portfolio view', tone: AppTone.primary),
                        StatusBadge(
                            label: 'Retirement ready', tone: AppTone.success),
                      ],
                      actions: [
                        SizedBox(
                          width: 160,
                          child: GhostButton(
                            label: 'Marketplace',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonProjects),
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
                          title: 'Active positions',
                          value: '${activeHoldings.length}',
                          icon: Icons.inventory_2_outlined,
                        ),
                        MetricCard(
                          title: 'Credits held',
                          value: AppFormatters.compactNumber(totalCredits),
                          icon: Icons.eco_outlined,
                          iconColor: AppColorsDS.success,
                        ),
                        MetricCard(
                          title: 'Portfolio value',
                          value: AppFormatters.currency(
                            portfolioValue,
                            symbol: '\$',
                            decimals: 0,
                            symbolFirst: true,
                          ),
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Retired records',
                          value: '${retiredHoldings.length}',
                          icon: Icons.assignment_turned_in_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    if (state.status == Status.loading && holdings.isEmpty)
                      const LoadingWidget(label: 'Loading carbon holdings')
                    else if (state.status == Status.error)
                      shared.ErrorWidgetView(
                        message: state.message,
                        onRetry: () => context.read<HoldingsCubit>().load(),
                      )
                    else if (holdings.isEmpty)
                      EmptyWidget(
                        title: 'No holdings in portfolio',
                        message:
                            'Purchase credits from the project marketplace to create active positions in this workspace.',
                        actionLabel: 'Browse projects',
                        onAction: () => Navigator.of(context)
                            .pushNamed(Routes.carbonProjects),
                      )
                    else ...[
                      SectionCard(
                        title: 'Active positions',
                        subtitle:
                            'Inventory currently available for reporting and retirement.',
                        child: activeHoldings.isEmpty
                            ? const EmptyWidget(
                                title: 'No active positions',
                                message:
                                    'All visible records are already retired or archived.',
                                icon: Icons.inventory_2_outlined,
                              )
                            : Column(
                                children: activeHoldings
                                    .map(
                                      (holding) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: AppSpacing.md),
                                        child: _HoldingCard(
                                            holding: holding, active: true),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                      const SectionSpacing(),
                      SectionCard(
                        title: 'Retired and archived records',
                        subtitle:
                            'Positions already retired or fully consumed in retirement workflows.',
                        child: retiredHoldings.isEmpty
                            ? const EmptyWidget(
                                title: 'No retired records yet',
                                message:
                                    'Completed retirements will appear here for audit and reporting review.',
                                icon: Icons.assignment_turned_in_outlined,
                              )
                            : Column(
                                children: retiredHoldings
                                    .map(
                                      (holding) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: AppSpacing.md),
                                        child: _HoldingCard(
                                            holding: holding, active: false),
                                      ),
                                    )
                                    .toList(),
                              ),
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

class _HoldingCard extends StatelessWidget {
  final CarbonHolding holding;
  final bool active;

  const _HoldingCard({
    required this.holding,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: active
          ? () => Navigator.of(context).pushNamed(
                Routes.carbonProjectDetail,
                arguments: holding.projectId,
              )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: active
                  ? AppColorsDS.accentGreenSoft
                  : AppColorsDS.accentSlateSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              active
                  ? Icons.inventory_2_outlined
                  : Icons.assignment_turned_in_outlined,
              color: active ? AppColorsDS.success : AppColorsDS.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(holding.projectName, style: AppTypography.h5),
                    ),
                    StatusBadge(
                      label: active ? 'Active' : 'Retired',
                      tone: active ? AppTone.success : AppTone.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xl,
                  runSpacing: AppSpacing.md,
                  children: [
                    InfoPair(
                        label: 'Credits',
                        value: holding.quantity.toStringAsFixed(2)),
                    InfoPair(
                      label: 'Unit price',
                      value: AppFormatters.currency(
                        holding.pricePerCredit,
                        symbol: '\$',
                        decimals: 2,
                        symbolFirst: true,
                      ),
                    ),
                    InfoPair(
                      label: 'Value',
                      value: AppFormatters.currency(
                        holding.value,
                        symbol: '\$',
                        decimals: 2,
                        symbolFirst: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (active) ...[
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 120,
              child: GhostButton(
                label: 'Retire',
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.carbonRetire),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
