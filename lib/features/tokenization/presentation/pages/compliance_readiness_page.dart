import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/compliance_checkpoint.dart';
import '../cubit/compliance_readiness_cubit.dart';
import '../cubit/compliance_readiness_state.dart';

class ComplianceReadinessPage extends StatelessWidget {
  const ComplianceReadinessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final programId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider<ComplianceReadinessCubit>(
      create: (_) =>
          getIt<ComplianceReadinessCubit>()..loadCheckpoints(programId ?? ''),
      child: BlocBuilder<ComplianceReadinessCubit, ComplianceReadinessState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading compliance readiness'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context
                    .read<ComplianceReadinessCubit>()
                    .loadCheckpoints(programId ?? ''),
              ),
            );
          }

          final checkpoints = state.data ?? <ComplianceCheckpoint>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Compliance readiness',
                      title: 'Transfer controls and regulatory checks',
                      subtitle:
                          'Monitor the set of approvals, filings, and internal governance checkpoints required before distribution or servicing actions.',
                    ),
                    const SectionSpacing(),
                    if (checkpoints.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No checkpoints defined',
                              tone: AppTone.neutral))
                    else
                      Column(
                        children: checkpoints
                            .map(
                              (checkpoint) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: AppCard(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: _tone(checkpoint.status) ==
                                                  AppTone.success
                                              ? AppColorsDS.accentGreenSoft
                                              : _tone(checkpoint.status) ==
                                                      AppTone.warning
                                                  ? AppColorsDS.accentAmberSoft
                                                  : AppColorsDS.accentRedSoft,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: Icon(
                                          Icons.verified_user_outlined,
                                          color: _iconColor(checkpoint.status),
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
                                                    child: Text(checkpoint.name,
                                                        style:
                                                            AppTypography.h5)),
                                                StatusBadge(
                                                  label: _statusLabel(
                                                      checkpoint.status),
                                                  tone:
                                                      _tone(checkpoint.status),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: AppSpacing.xs),
                                            Text(checkpoint.description,
                                                style: AppTypography.body2),
                                          ],
                                        ),
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

  static String _statusLabel(ComplianceStatus status) {
    switch (status) {
      case ComplianceStatus.pending:
        return 'Pending';
      case ComplianceStatus.passed:
        return 'Passed';
      case ComplianceStatus.failed:
        return 'Failed';
    }
  }

  static AppTone _tone(ComplianceStatus status) {
    switch (status) {
      case ComplianceStatus.pending:
        return AppTone.warning;
      case ComplianceStatus.passed:
        return AppTone.success;
      case ComplianceStatus.failed:
        return AppTone.danger;
    }
  }

  static Color _iconColor(ComplianceStatus status) {
    switch (status) {
      case ComplianceStatus.pending:
        return AppColorsDS.warning;
      case ComplianceStatus.passed:
        return AppColorsDS.success;
      case ComplianceStatus.failed:
        return AppColorsDS.danger;
    }
  }
}
