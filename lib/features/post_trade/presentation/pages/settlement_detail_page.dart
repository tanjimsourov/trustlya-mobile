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
import '../../domain/entities/settlement_leg.dart';
import '../cubit/settlement_detail_cubit.dart';
import '../cubit/settlement_detail_state.dart';

class SettlementDetailPage extends StatelessWidget {
  const SettlementDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instructionId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider<SettlementDetailCubit>(
      create: (_) =>
          getIt<SettlementDetailCubit>()..loadDetail(instructionId ?? ''),
      child: BlocBuilder<SettlementDetailCubit, SettlementDetailState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
              body: LoadingWidget(label: 'Loading settlement detail'),
            );
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context
                    .read<SettlementDetailCubit>()
                    .loadDetail(instructionId ?? ''),
              ),
            );
          }

          final instruction = state.data;
          if (instruction == null) {
            return const AppScaffold(
              body: Center(
                child: StatusBadge(
                  label: 'Instruction not found',
                  tone: AppTone.warning,
                ),
              ),
            );
          }

          final matchedLegs = instruction.legs
              .where((leg) =>
                  leg.status == LegStatus.matched ||
                  leg.status == LegStatus.settled)
              .length;
          final unmatchedLegs = instruction.legs
              .where((leg) => leg.status == LegStatus.unmatched)
              .length;

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Settlement detail',
                      title: instruction.reference,
                      subtitle:
                          'Detailed operational context for the selected settlement instruction, including counterparty posture, leg movement, and processing readiness.',
                      metadata: [
                        StatusBadge(
                          label: _statusLabel(instruction.status),
                          tone: _statusTone(instruction.status),
                        ),
                        StatusBadge(
                          label: AppFormatters.dateShort(instruction.date),
                          tone: AppTone.neutral,
                        ),
                        StatusBadge(
                          label: '${instruction.legs.length} legs tracked',
                          tone: AppTone.info,
                        ),
                      ],
                      actions: [
                        GhostButton(
                          label: 'Queue',
                          icon: Icons.view_list_outlined,
                          fullWidth: false,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.postTradeSettlementQueue),
                        ),
                        PrimaryButton(
                          label: 'Refresh',
                          icon: Icons.refresh,
                          fullWidth: false,
                          onPressed: () => context
                              .read<SettlementDetailCubit>()
                              .loadDetail(instructionId ?? ''),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Gross notional',
                          value:
                              '${AppFormatters.compactNumber(instruction.amount)} ${instruction.currency}',
                          icon: Icons.payments_outlined,
                          footer: AppFormatters.currency(
                            instruction.amount,
                            symbol: instruction.currency,
                            decimals: 0,
                          ),
                        ),
                        MetricCard(
                          title: 'Leg coverage',
                          value: '${instruction.legs.length}',
                          icon: Icons.alt_route_outlined,
                          footer: 'Settlement movement paths',
                        ),
                        MetricCard(
                          title: 'Matched legs',
                          value: '$matchedLegs/${instruction.legs.length}',
                          icon: Icons.rule_outlined,
                          iconColor: unmatchedLegs == 0
                              ? AppColorsDS.success
                              : AppColorsDS.warning,
                          footer: unmatchedLegs == 0
                              ? 'All legs aligned'
                              : '$unmatchedLegs unresolved',
                        ),
                        MetricCard(
                          title: 'Processing state',
                          value: _statusLabel(instruction.status),
                          icon: Icons.radar_outlined,
                          iconColor: _statusColor(instruction.status),
                          footer: instruction.counterparty,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    InsightBanner(
                      title: _operationalInsightTitle(instruction),
                      description: _operationalInsightDescription(
                        instruction,
                        unmatchedLegs: unmatchedLegs,
                      ),
                      icon: unmatchedLegs > 0
                          ? Icons.warning_amber_outlined
                          : Icons.verified_outlined,
                      tone: unmatchedLegs > 0
                          ? AppTone.warning
                          : _statusTone(instruction.status),
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Instruction summary',
                      subtitle:
                          'Core identifiers and control attributes used by operations and reconciliation teams.',
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = constraints.maxWidth >= 980
                              ? 4
                              : constraints.maxWidth >= 620
                                  ? 2
                                  : 1;
                          final tileWidth = (constraints.maxWidth -
                                  (AppSpacing.md * (columns - 1))) /
                              columns;

                          return Wrap(
                            spacing: AppSpacing.md,
                            runSpacing: AppSpacing.md,
                            children: [
                              SizedBox(
                                width: tileWidth,
                                child: _SummaryTile(
                                  label: 'Instruction ID',
                                  value: instruction.id,
                                  icon: Icons.tag_outlined,
                                ),
                              ),
                              SizedBox(
                                width: tileWidth,
                                child: _SummaryTile(
                                  label: 'Counterparty',
                                  value: instruction.counterparty,
                                  icon: Icons.apartment_outlined,
                                ),
                              ),
                              SizedBox(
                                width: tileWidth,
                                child: _SummaryTile(
                                  label: 'Settlement date',
                                  value:
                                      AppFormatters.dateShort(instruction.date),
                                  icon: Icons.event_outlined,
                                ),
                              ),
                              SizedBox(
                                width: tileWidth,
                                child: _SummaryTile(
                                  label: 'Settlement status',
                                  value: _statusLabel(instruction.status),
                                  icon: Icons.verified_user_outlined,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Settlement legs',
                      subtitle:
                          'Leg-level movement detail, amount coverage, and matching posture for downstream review.',
                      trailing: StatusBadge(
                        label: unmatchedLegs == 0
                            ? 'All legs aligned'
                            : '$unmatchedLegs require review',
                        tone: unmatchedLegs == 0
                            ? AppTone.success
                            : AppTone.warning,
                      ),
                      child: instruction.legs.isEmpty
                          ? const Center(
                              child: StatusBadge(
                                label: 'No legs available',
                                tone: AppTone.neutral,
                              ),
                            )
                          : Column(
                              children: instruction.legs
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => Padding(
                                      padding: EdgeInsets.only(
                                        bottom: entry.key ==
                                                instruction.legs.length - 1
                                            ? 0
                                            : AppSpacing.md,
                                      ),
                                      child: _LegTile(leg: entry.value),
                                    ),
                                  )
                                  .toList(),
                            ),
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

  static Color _statusColor(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.queued:
        return AppColorsDS.warning;
      case SettlementStatus.processing:
        return AppColorsDS.secondary;
      case SettlementStatus.settled:
        return AppColorsDS.success;
      case SettlementStatus.failed:
        return AppColorsDS.danger;
    }
  }

  static String _operationalInsightTitle(SettlementInstruction instruction) {
    switch (instruction.status) {
      case SettlementStatus.queued:
        return 'Instruction is queued for processing';
      case SettlementStatus.processing:
        return 'Instruction is moving through processing';
      case SettlementStatus.settled:
        return 'Instruction has reached settlement finality';
      case SettlementStatus.failed:
        return 'Instruction requires exception handling';
    }
  }

  static String _operationalInsightDescription(
    SettlementInstruction instruction, {
    required int unmatchedLegs,
  }) {
    if (instruction.status == SettlementStatus.failed) {
      return 'Processing has failed for this instruction. Review leg status, counterparty details, and escalation routing before retrying settlement.';
    }
    if (unmatchedLegs > 0) {
      final noun = unmatchedLegs == 1 ? 'leg is' : 'legs are';
      return '$unmatchedLegs $noun still unmatched. Reconciliation review should resolve the break before treasury teams mark the instruction ready.';
    }
    if (instruction.status == SettlementStatus.settled) {
      return 'All tracked legs are aligned and final settlement has been recorded for this instruction.';
    }
    if (instruction.status == SettlementStatus.processing) {
      return 'All currently tracked legs are aligned while the instruction continues through operational processing steps.';
    }
    return 'The instruction is queued with all required context captured and is awaiting the next settlement processing window.';
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: AppColorsDS.border,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColorsDS.accentBlueSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: AppColorsDS.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.caption),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value,
                  style: AppTypography.subtitle2.copyWith(
                    color: AppColorsDS.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegTile extends StatelessWidget {
  final SettlementLeg leg;

  const _LegTile({Key? key, required this.leg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accent = _legAccentColor(leg.status);
    final tone = _legStatusTone(leg.status);

    return AppCard(
      borderColor: accent.withOpacity(0.18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 620;
          final routeSummary = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${leg.fromAccount} -> ${leg.toAccount}',
                style: AppTypography.h5,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppFormatters.currency(
                  leg.amount,
                  symbol: leg.currency,
                  decimals: 0,
                ),
                style: AppTypography.subtitle1.copyWith(
                  color: AppColorsDS.textPrimary,
                ),
              ),
            ],
          );

          final meta = Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.md,
            children: [
              InfoPair(label: 'Leg ID', value: leg.id),
              InfoPair(label: 'From', value: leg.fromAccount),
              InfoPair(label: 'To', value: leg.toAccount),
              InfoPair(
                label: 'Match state',
                value: _legStatusLabel(leg.status),
              ),
            ],
          );

          final header = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  leg.status == LegStatus.settled
                      ? Icons.task_alt_outlined
                      : Icons.swap_horiz_outlined,
                  color: accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: routeSummary),
              const SizedBox(width: AppSpacing.md),
              StatusBadge(
                label: _legStatusLabel(leg.status),
                tone: tone,
              ),
            ],
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1, color: AppColorsDS.divider),
                const SizedBox(height: AppSpacing.md),
                meta,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColorsDS.divider),
              const SizedBox(height: AppSpacing.md),
              meta,
            ],
          );
        },
      ),
    );
  }

  static String _legStatusLabel(LegStatus status) {
    switch (status) {
      case LegStatus.matched:
        return 'Matched';
      case LegStatus.unmatched:
        return 'Unmatched';
      case LegStatus.settled:
        return 'Settled';
    }
  }

  static AppTone _legStatusTone(LegStatus status) {
    switch (status) {
      case LegStatus.matched:
        return AppTone.info;
      case LegStatus.unmatched:
        return AppTone.warning;
      case LegStatus.settled:
        return AppTone.success;
    }
  }

  static Color _legAccentColor(LegStatus status) {
    switch (status) {
      case LegStatus.matched:
        return AppColorsDS.secondary;
      case LegStatus.unmatched:
        return AppColorsDS.warning;
      case LegStatus.settled:
        return AppColorsDS.success;
    }
  }
}
