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
import '../../domain/entities/tokenized_asset_program.dart';
import '../cubit/asset_programs_cubit.dart';
import '../cubit/asset_programs_state.dart';
import '../cubit/tokenization_activity_cubit.dart';
import '../cubit/tokenization_activity_state.dart';
import '../cubit/tokenization_overview_cubit.dart';
import '../cubit/tokenization_overview_state.dart';

class TokenizationOverviewPage extends StatelessWidget {
  final bool embedded;

  const TokenizationOverviewPage({Key? key, this.embedded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = MultiBlocProvider(
      providers: [
        BlocProvider<TokenizationOverviewCubit>(
          create: (_) => getIt<TokenizationOverviewCubit>()..loadOverview(),
        ),
        BlocProvider<AssetProgramsCubit>(
          create: (_) => getIt<AssetProgramsCubit>()..loadPrograms(),
        ),
        BlocProvider<TokenizationActivityCubit>(
          create: (_) => getIt<TokenizationActivityCubit>()..loadActivity(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final overviewState =
              context.watch<TokenizationOverviewCubit>().state;
          final programsState = context.watch<AssetProgramsCubit>().state;
          final activityState =
              context.watch<TokenizationActivityCubit>().state;

          final loading = [
            overviewState.status,
            programsState.status,
            activityState.status,
          ].contains(Status.loading);

          final error = overviewState.message ??
              programsState.message ??
              activityState.message;

          final hasError = [
            overviewState.status,
            programsState.status,
            activityState.status,
          ].contains(Status.error);

          if (loading) {
            return const LoadingWidget(label: 'Loading tokenization workspace');
          }

          if (hasError) {
            return shared.ErrorWidgetView(
              message: error,
              onRetry: () {
                context.read<TokenizationOverviewCubit>().loadOverview();
                context.read<AssetProgramsCubit>().loadPrograms();
                context.read<TokenizationActivityCubit>().loadActivity();
              },
            );
          }

          final overview = overviewState.data!;
          final programs = programsState.data ?? <TokenizedAssetProgram>[];
          final activity = activityState.data ?? [];

          final body = SingleChildScrollView(
            child: ResponsivePageWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    eyebrow: 'Tokenization infrastructure',
                    title: 'Issuer console and program governance',
                    subtitle:
                        'Structure asset programs, manage onboarding queues, monitor lifecycle readiness, and keep transfer controls visible to operations teams.',
                    metadata: const [
                      StatusBadge(
                          label: 'Issuer workspace', tone: AppTone.primary),
                      StatusBadge(
                          label: 'Transfer controls', tone: AppTone.success),
                      StatusBadge(
                          label: 'Lifecycle monitoring', tone: AppTone.info),
                    ],
                    actions: [
                      SizedBox(
                        width: 150,
                        child: GhostButton(
                          label: 'Activity feed',
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.tokenizationActivity),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: PrimaryButton(
                          label: 'View programs',
                          icon: Icons.arrow_forward,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.tokenizationPrograms),
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
                            title: 'Total programs',
                            value: '${overview.totalPrograms}',
                            icon: Icons.account_tree_outlined,
                          );
                        case 1:
                          return MetricCard(
                            title: 'Active programs',
                            value: '${overview.activePrograms}',
                            footer:
                                '${overview.totalPrograms - overview.activePrograms} in structuring',
                            icon: Icons.play_circle_outline,
                            iconColor: AppColorsDS.success,
                          );
                        case 2:
                          return MetricCard(
                            title: 'Investor records',
                            value:
                                AppFormatters.compactNumber(overview.investors),
                            icon: Icons.groups_outlined,
                          );
                        default:
                          return MetricCard(
                            title: 'Pending onboarding',
                            value: '${overview.pendingOnboardings}',
                            icon: Icons.fact_check_outlined,
                            iconColor: AppColorsDS.warning,
                          );
                      }
                    },
                  ),
                  const SectionSpacing(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 980;
                      final programPanel = SectionCard(
                        title: 'Program roster',
                        subtitle:
                            'Current issuance mandates and allocation posture.',
                        trailing: TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.tokenizationPrograms),
                          child: const Text('All programs'),
                        ),
                        child: Column(
                          children: programs
                              .take(3)
                              .map(
                                (program) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm),
                                  child: _ProgramSummaryTile(program: program),
                                ),
                              )
                              .toList(),
                        ),
                      );

                      final actionPanel = SectionCard(
                        title: 'Core workflows',
                        subtitle:
                            'Move between onboarding, compliance, analytics, and lifecycle events.',
                        child: Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: [
                            _WorkflowShortcut(
                              title: 'Investor queue',
                              icon: Icons.groups_2_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.tokenizationInvestorQueue),
                            ),
                            _WorkflowShortcut(
                              title: 'Compliance',
                              icon: Icons.rule_folder_outlined,
                              onTap: () => Navigator.of(context).pushNamed(
                                  Routes.tokenizationCompliance,
                                  arguments: programs.isEmpty
                                      ? ''
                                      : programs.first.id),
                            ),
                            _WorkflowShortcut(
                              title: 'Lifecycle events',
                              icon: Icons.timeline_outlined,
                              onTap: () => Navigator.of(context).pushNamed(
                                  Routes.tokenizationLifecycleEvents,
                                  arguments: programs.isEmpty
                                      ? ''
                                      : programs.first.id),
                            ),
                            _WorkflowShortcut(
                              title: 'Issuance analytics',
                              icon: Icons.insights_outlined,
                              onTap: () => Navigator.of(context).pushNamed(
                                  Routes.tokenizationAnalytics,
                                  arguments: programs.isEmpty
                                      ? ''
                                      : programs.first.id),
                            ),
                          ],
                        ),
                      );

                      if (stacked) {
                        return Column(
                          children: [
                            programPanel,
                            const SectionSpacing(height: AppSpacing.md),
                            actionPanel,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: programPanel),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: actionPanel),
                        ],
                      );
                    },
                  ),
                  const SectionSpacing(),
                  SectionCard(
                    title: 'Recent activity',
                    subtitle:
                        'Operational events across onboarding, distributions, and program servicing.',
                    child: activity.isEmpty
                        ? const Center(
                            child: StatusBadge(
                                label: 'No recent activity',
                                tone: AppTone.neutral))
                        : Column(
                            children: activity
                                .take(4)
                                .map(
                                  (item) => TimelineTile(
                                    title: item.title,
                                    subtitle: item.description,
                                    trailing:
                                        AppFormatters.dateShort(item.date),
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

class _ProgramSummaryTile extends StatelessWidget {
  final TokenizedAssetProgram program;

  const _ProgramSummaryTile({Key? key, required this.program})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = program.totalTokens == 0
        ? 0.0
        : program.allocatedTokens / program.totalTokens;
    return AppCard(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.tokenizationProgramDetail, arguments: program.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(program.name, style: AppTypography.h5)),
              StatusBadge(
                label: _statusLabel(program.status),
                tone: _statusTone(program.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(program.description,
              style: AppTypography.body2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColorsDS.surfaceMuted,
            color: AppColorsDS.primary,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                '${AppFormatters.compactNumber(program.allocatedTokens)} allocated',
                style: AppTypography.caption,
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toStringAsFixed(0)}% placed',
                style: AppTypography.caption
                    .copyWith(color: AppColorsDS.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _statusLabel(ProgramStatus status) {
    switch (status) {
      case ProgramStatus.planning:
        return 'Planning';
      case ProgramStatus.active:
        return 'Active';
      case ProgramStatus.completed:
        return 'Completed';
      case ProgramStatus.paused:
        return 'Paused';
    }
  }

  static AppTone _statusTone(ProgramStatus status) {
    switch (status) {
      case ProgramStatus.planning:
        return AppTone.warning;
      case ProgramStatus.active:
        return AppTone.success;
      case ProgramStatus.completed:
        return AppTone.primary;
      case ProgramStatus.paused:
        return AppTone.danger;
    }
  }
}

class _WorkflowShortcut extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _WorkflowShortcut({
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
