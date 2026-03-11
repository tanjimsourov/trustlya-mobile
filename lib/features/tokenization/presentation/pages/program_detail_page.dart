import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
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
import '../../domain/entities/tokenized_asset_program.dart';
import '../cubit/program_detail_cubit.dart';
import '../cubit/program_detail_state.dart';

class ProgramDetailPage extends StatelessWidget {
  const ProgramDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final programId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider<ProgramDetailCubit>(
      create: (_) => getIt<ProgramDetailCubit>()..loadProgram(programId ?? ''),
      child: BlocBuilder<ProgramDetailCubit, ProgramDetailState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading program detail'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context
                    .read<ProgramDetailCubit>()
                    .loadProgram(programId ?? ''),
              ),
            );
          }

          final program = state.data;
          if (program == null) {
            return const AppScaffold(
              body: Center(
                child: StatusBadge(
                    label: 'Program not found', tone: AppTone.warning),
              ),
            );
          }

          final progress = program.totalTokens == 0
              ? 0.0
              : program.allocatedTokens / program.totalTokens;
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Program detail',
                      title: program.name,
                      subtitle: program.description,
                      metadata: [
                        StatusBadge(
                            label: _statusLabel(program.status),
                            tone: _statusTone(program.status)),
                        StatusBadge(
                          label:
                              'Issued ${AppFormatters.dateShort(program.issuanceDate)}',
                          tone: AppTone.neutral,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    AdaptiveGrid(
                      itemCount: 3,
                      minCellWidth: 240,
                      itemBuilder: (_, index) {
                        switch (index) {
                          case 0:
                            return MetricCard(
                              title: 'Total supply',
                              value: AppFormatters.compactNumber(
                                  program.totalTokens),
                              icon: Icons.stacked_bar_chart_outlined,
                            );
                          case 1:
                            return MetricCard(
                              title: 'Allocated',
                              value: AppFormatters.compactNumber(
                                  program.allocatedTokens),
                              icon: Icons.pie_chart_outline,
                            );
                          default:
                            return MetricCard(
                              title: 'Placement',
                              value: '${(progress * 100).toStringAsFixed(0)}%',
                              icon: Icons.insights_outlined,
                            );
                        }
                      },
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Program controls',
                      subtitle:
                          'Navigate directly into the core lifecycle workspaces for this mandate.',
                      child: Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: [
                          _NavTile(
                            label: 'Issuance workflow',
                            icon: Icons.timeline_outlined,
                            onTap: () => Navigator.of(context).pushNamed(
                              Routes.tokenizationIssuanceWorkflow,
                              arguments: program.id,
                            ),
                          ),
                          _NavTile(
                            label: 'Cap table',
                            icon: Icons.pie_chart_outline,
                            onTap: () => Navigator.of(context).pushNamed(
                              Routes.tokenizationCapTable,
                              arguments: program.id,
                            ),
                          ),
                          _NavTile(
                            label: 'Lifecycle events',
                            icon: Icons.event_outlined,
                            onTap: () => Navigator.of(context).pushNamed(
                              Routes.tokenizationLifecycleEvents,
                              arguments: program.id,
                            ),
                          ),
                          _NavTile(
                            label: 'Compliance',
                            icon: Icons.rule_folder_outlined,
                            onTap: () => Navigator.of(context).pushNamed(
                              Routes.tokenizationCompliance,
                              arguments: program.id,
                            ),
                          ),
                          _NavTile(
                            label: 'Analytics',
                            icon: Icons.insights_outlined,
                            onTap: () => Navigator.of(context).pushNamed(
                              Routes.tokenizationAnalytics,
                              arguments: program.id,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Placement summary',
                      subtitle:
                          'Current distribution status for the active issuance mandate.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: AppColorsDS.surfaceMuted,
                            color: AppColorsDS.primary,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: InfoPair(
                                  label: 'Allocated tokens',
                                  value: AppFormatters.compactNumber(
                                      program.allocatedTokens),
                                ),
                              ),
                              Expanded(
                                child: InfoPair(
                                  label: 'Unallocated tokens',
                                  value: AppFormatters.compactNumber(
                                      program.totalTokens -
                                          program.allocatedTokens),
                                ),
                              ),
                              Expanded(
                                child: InfoPair(
                                  label: 'Placement ratio',
                                  value:
                                      '${(progress * 100).toStringAsFixed(0)}%',
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
          );
        },
      ),
    );
  }

  static String _statusLabel(ProgramStatus status) {
    switch (status) {
      case ProgramStatus.active:
        return 'Active';
      case ProgramStatus.planning:
        return 'Planning';
      case ProgramStatus.completed:
        return 'Completed';
      case ProgramStatus.paused:
        return 'Paused';
    }
  }

  static AppTone _statusTone(ProgramStatus status) {
    switch (status) {
      case ProgramStatus.active:
        return AppTone.success;
      case ProgramStatus.planning:
        return AppTone.warning;
      case ProgramStatus.completed:
        return AppTone.primary;
      case ProgramStatus.paused:
        return AppTone.danger;
    }
  }
}

class _NavTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _NavTile({
    Key? key,
    required this.label,
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
            Text(label,
                style: AppTypography.subtitle2
                    .copyWith(color: AppColorsDS.textPrimary)),
          ],
        ),
      ),
    );
  }
}
