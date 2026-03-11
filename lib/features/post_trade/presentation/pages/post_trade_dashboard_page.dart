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
import '../../domain/entities/settlement_instruction.dart';
import '../cubit/operations_sla_cubit.dart';
import '../cubit/operations_sla_state.dart';
import '../cubit/post_trade_dashboard_cubit.dart';
import '../cubit/post_trade_dashboard_state.dart';
import '../cubit/settlement_queue_cubit.dart';
import '../cubit/settlement_queue_state.dart';

class PostTradeDashboardPage extends StatelessWidget {
  final bool embedded;

  const PostTradeDashboardPage({Key? key, this.embedded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = MultiBlocProvider(
      providers: [
        BlocProvider<PostTradeDashboardCubit>(
          create: (_) => getIt<PostTradeDashboardCubit>()..loadDashboard(),
        ),
        BlocProvider<SettlementQueueCubit>(
          create: (_) => getIt<SettlementQueueCubit>()..loadQueue(),
        ),
        BlocProvider<OperationsSlaCubit>(
          create: (_) => getIt<OperationsSlaCubit>()..loadSla(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final dashboardState = context.watch<PostTradeDashboardCubit>().state;
          final queueState = context.watch<SettlementQueueCubit>().state;
          final slaState = context.watch<OperationsSlaCubit>().state;

          final loading = [
            dashboardState.status,
            queueState.status,
            slaState.status,
          ].contains(Status.loading);

          final error =
              dashboardState.message ?? queueState.message ?? slaState.message;
          final hasError = [
            dashboardState.status,
            queueState.status,
            slaState.status,
          ].contains(Status.error);

          if (loading) {
            return const LoadingWidget(label: 'Loading post-trade operations');
          }

          if (hasError) {
            return shared.ErrorWidgetView(
              message: error,
              onRetry: () {
                context.read<PostTradeDashboardCubit>().loadDashboard();
                context.read<SettlementQueueCubit>().loadQueue();
                context.read<OperationsSlaCubit>().loadSla();
              },
            );
          }

          final dashboard = dashboardState.data!;
          final queue = queueState.data ?? <SettlementInstruction>[];
          final slaMetrics = slaState.data ?? [];

          final body = SingleChildScrollView(
            child: ResponsivePageWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    eyebrow: 'Post-trade and settlement',
                    title: 'Settlement operations and exception control',
                    subtitle:
                        'Manage settlement throughput, reconciliation, counterparty exposure, operational SLAs, and finality monitoring from a single operations desk.',
                    metadata: const [
                      StatusBadge(
                          label: 'Finality monitoring', tone: AppTone.info),
                      StatusBadge(
                          label: 'Treasury oversight', tone: AppTone.primary),
                      StatusBadge(
                          label: 'Exception workflow', tone: AppTone.warning),
                    ],
                    actions: [
                      SizedBox(
                        width: 150,
                        child: GhostButton(
                          label: 'SLA view',
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.postTradeSlaMonitoring),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: PrimaryButton(
                          label: 'Open queue',
                          icon: Icons.arrow_forward,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.postTradeSettlementQueue),
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
                            title: 'Instructions',
                            value: '${dashboard.totalInstructions}',
                            footer: '${dashboard.pendingInstructions} pending',
                            icon: Icons.receipt_long_outlined,
                          );
                        case 1:
                          return MetricCard(
                            title: 'Open exceptions',
                            value: '${dashboard.openExceptions}',
                            footer:
                                '${dashboard.unresolvedBreaks} unresolved breaks',
                            icon: Icons.error_outline,
                            iconColor: AppColorsDS.warning,
                          );
                        case 2:
                          return MetricCard(
                            title: 'Counterparty exposure',
                            value: '${dashboard.exposures}',
                            icon: Icons.groups_outlined,
                          );
                        default:
                          return MetricCard(
                            title: 'Treasury balance',
                            value: AppFormatters.currency(
                              dashboard.treasuryBalance,
                              symbol: '€',
                              decimals: 0,
                              symbolFirst: true,
                            ),
                            icon: Icons.account_balance_outlined,
                            iconColor: AppColorsDS.secondary,
                          );
                      }
                    },
                  ),
                  const SectionSpacing(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 980;

                      final queuePanel = SectionCard(
                        title: 'Live settlement queue',
                        subtitle:
                            'Prioritize pending and processing instructions by counterparty and amount.',
                        trailing: TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.postTradeSettlementQueue),
                          child: const Text('Full queue'),
                        ),
                        child: queue.isEmpty
                            ? const Center(
                                child: StatusBadge(
                                    label: 'No live instructions',
                                    tone: AppTone.neutral))
                            : Column(
                                children: queue
                                    .take(4)
                                    .map(
                                      (instruction) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: AppSpacing.sm),
                                        child: _SettlementPreviewTile(
                                            instruction: instruction),
                                      ),
                                    )
                                    .toList(),
                              ),
                      );

                      final workflowPanel = SectionCard(
                        title: 'Operational workspaces',
                        subtitle:
                            'Move directly into the areas that require operational intervention.',
                        child: Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: [
                            _DeskTile(
                              title: 'Reconciliation',
                              icon: Icons.compare_arrows_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.postTradeReconciliation),
                            ),
                            _DeskTile(
                              title: 'Exceptions',
                              icon: Icons.warning_amber_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.postTradeExceptions),
                            ),
                            _DeskTile(
                              title: 'Treasury',
                              icon: Icons.account_balance_wallet_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.postTradeTreasury),
                            ),
                            _DeskTile(
                              title: 'Finality tracker',
                              icon: Icons.timeline_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.postTradeFinalityTracker),
                            ),
                            _DeskTile(
                              title: 'Audit trail',
                              icon: Icons.rule_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.postTradeReportingAudit),
                            ),
                            _DeskTile(
                              title: 'Exposure',
                              icon: Icons.bar_chart_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.postTradeExposure),
                            ),
                          ],
                        ),
                      );

                      if (stacked) {
                        return Column(
                          children: [
                            queuePanel,
                            const SectionSpacing(height: AppSpacing.md),
                            workflowPanel,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: queuePanel),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: workflowPanel),
                        ],
                      );
                    },
                  ),
                  const SectionSpacing(),
                  SectionCard(
                    title: 'Service levels',
                    subtitle:
                        'Current operating performance against defined operational targets.',
                    child: Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: slaMetrics
                          .map(
                            (metric) => SizedBox(
                              width: 240,
                              child: AppCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StatusBadge(
                                      label: metric.met
                                          ? 'On target'
                                          : 'Watchlist',
                                      tone: metric.met
                                          ? AppTone.success
                                          : AppTone.warning,
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    Text(metric.name, style: AppTypography.h5),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      '${metric.value.toStringAsFixed(1)}${metric.unit}',
                                      style: AppTypography.h3,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Target ${metric.target.toStringAsFixed(1)}${metric.unit}',
                                      style: AppTypography.caption,
                                    ),
                                  ],
                                ),
                              ),
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

class _SettlementPreviewTile extends StatelessWidget {
  final SettlementInstruction instruction;

  const _SettlementPreviewTile({Key? key, required this.instruction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.of(context).pushNamed(
        Routes.postTradeSettlementDetail,
        arguments: instruction.id,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(instruction.reference, style: AppTypography.h5),
                const SizedBox(height: AppSpacing.xxs),
                Text(instruction.counterparty, style: AppTypography.body2),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(
                label: _statusLabel(instruction.status),
                tone: _statusTone(instruction.status),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppFormatters.currency(
                  instruction.amount,
                  symbol: instruction.currency,
                  decimals: 0,
                ),
                style: AppTypography.subtitle2
                    .copyWith(color: AppColorsDS.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _statusLabel(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.queued:
        return 'Queued';
      case SettlementStatus.processing:
        return 'Processing';
      case SettlementStatus.settled:
        return 'Settled';
      case SettlementStatus.failed:
        return 'Failed';
    }
  }

  static AppTone _statusTone(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.queued:
        return AppTone.warning;
      case SettlementStatus.processing:
        return AppTone.info;
      case SettlementStatus.settled:
        return AppTone.success;
      case SettlementStatus.failed:
        return AppTone.danger;
    }
  }
}

class _DeskTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DeskTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColorsDS.accentBlueSoft,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Icon(icon, color: AppColorsDS.primary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title,
                style: AppTypography.subtitle2
                    .copyWith(color: AppColorsDS.textPrimary)),
          ],
        ),
      ),
    );
  }
}
