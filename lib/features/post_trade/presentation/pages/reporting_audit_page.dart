import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/audit_record.dart';
import '../cubit/reporting_audit_cubit.dart';
import '../cubit/reporting_audit_state.dart';

class ReportingAuditPage extends StatelessWidget {
  const ReportingAuditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReportingAuditCubit>(
      create: (_) => getIt<ReportingAuditCubit>()..loadAudit(),
      child: BlocBuilder<ReportingAuditCubit, ReportingAuditState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading audit records'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context.read<ReportingAuditCubit>().loadAudit(),
              ),
            );
          }

          final records = state.data ?? <AuditRecord>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Reporting and audit',
                      title: 'Operational audit trail',
                      subtitle:
                          'Review user and system actions captured for controls, reporting, and operational oversight.',
                    ),
                    const SectionSpacing(),
                    if (records.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No audit records', tone: AppTone.neutral))
                    else
                      Column(
                        children: records
                            .map(
                              (record) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: AppCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                '${record.entity} • ${record.action}',
                                                style: AppTypography.h5),
                                          ),
                                          StatusBadge(
                                              label: record.user,
                                              tone: AppTone.neutral),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(record.description,
                                          style: AppTypography.body2),
                                      const SizedBox(height: AppSpacing.md),
                                      Text(
                                        AppFormatters.dateTimeShort(
                                            record.timestamp),
                                        style: AppTypography.caption,
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
}
