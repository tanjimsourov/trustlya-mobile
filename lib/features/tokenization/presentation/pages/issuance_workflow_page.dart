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
import '../../domain/entities/issuance_stage.dart';
import '../cubit/issuance_workflow_cubit.dart';
import '../cubit/issuance_workflow_state.dart';

class IssuanceWorkflowPage extends StatelessWidget {
  const IssuanceWorkflowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final programId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider<IssuanceWorkflowCubit>(
      create: (_) =>
          getIt<IssuanceWorkflowCubit>()..loadWorkflow(programId ?? ''),
      child: BlocBuilder<IssuanceWorkflowCubit, IssuanceWorkflowState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading issuance workflow'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context
                    .read<IssuanceWorkflowCubit>()
                    .loadWorkflow(programId ?? ''),
              ),
            );
          }

          final stages = state.data ?? <IssuanceStage>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Issuance workflow',
                      title: 'Program delivery stages',
                      subtitle:
                          'Track structuring, regulatory, minting, and distribution stages with due dates and blockers clearly visible.',
                    ),
                    const SectionSpacing(),
                    if (stages.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No stages configured',
                              tone: AppTone.neutral))
                    else
                      Column(
                        children: List.generate(stages.length, (index) {
                          final stage = stages[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.md),
                            child: AppCard(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: _statusColor(stage.status)
                                          .withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text('${index + 1}'),
                                    ),
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
                                                child: Text(stage.name,
                                                    style: AppTypography.h5)),
                                            StatusBadge(
                                              label: _statusLabel(stage.status),
                                              tone: _statusTone(stage.status),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(stage.description,
                                            style: AppTypography.body2),
                                        const SizedBox(height: AppSpacing.md),
                                        Text(
                                          'Due ${AppFormatters.dateShort(stage.dueDate)}',
                                          style: AppTypography.caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
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

  static String _statusLabel(StageStatus status) {
    switch (status) {
      case StageStatus.pending:
        return 'Pending';
      case StageStatus.inProgress:
        return 'In progress';
      case StageStatus.completed:
        return 'Completed';
      case StageStatus.blocked:
        return 'Blocked';
    }
  }

  static AppTone _statusTone(StageStatus status) {
    switch (status) {
      case StageStatus.pending:
        return AppTone.warning;
      case StageStatus.inProgress:
        return AppTone.info;
      case StageStatus.completed:
        return AppTone.success;
      case StageStatus.blocked:
        return AppTone.danger;
    }
  }

  static Color _statusColor(StageStatus status) {
    switch (status) {
      case StageStatus.pending:
        return AppColorsDS.warning;
      case StageStatus.inProgress:
        return AppColorsDS.info;
      case StageStatus.completed:
        return AppColorsDS.success;
      case StageStatus.blocked:
        return AppColorsDS.danger;
    }
  }
}
