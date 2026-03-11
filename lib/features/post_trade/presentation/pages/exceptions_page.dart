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
import '../../../../shared/widgets/filter_row.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/settlement_exception.dart';
import '../cubit/exceptions_cubit.dart';
import '../cubit/exceptions_state.dart';

class ExceptionsPage extends StatefulWidget {
  const ExceptionsPage({Key? key}) : super(key: key);

  @override
  State<ExceptionsPage> createState() => _ExceptionsPageState();
}

class _ExceptionsPageState extends State<ExceptionsPage> {
  final List<String> _filters = const ['All', 'Low', 'Medium', 'High'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExceptionsCubit>(
      create: (_) => getIt<ExceptionsCubit>()..loadExceptions(),
      child: BlocBuilder<ExceptionsCubit, ExceptionsState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading settlement exceptions'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context.read<ExceptionsCubit>().loadExceptions(),
              ),
            );
          }

          final exceptions = state.data ?? <SettlementException>[];
          final filtered = exceptions.where((item) {
            if (_selectedIndex == 0) {
              return true;
            }
            return _severityLabel(item.severity).toLowerCase() ==
                _filters[_selectedIndex].toLowerCase();
          }).toList();

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Exceptions',
                      title: 'Operational exception queue',
                      subtitle:
                          'Prioritize unresolved settlement issues by severity, impacted instruction, and current remediation status.',
                    ),
                    const SectionSpacing(),
                    FilterToolbar(
                      leading: FilterRow(
                        options: _filters,
                        selectedIndex: _selectedIndex,
                        onSelected: (index) =>
                            setState(() => _selectedIndex = index),
                      ),
                    ),
                    const SectionSpacing(),
                    if (filtered.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No exceptions in this filter',
                              tone: AppTone.neutral))
                    else
                      Column(
                        children: filtered
                            .map(
                              (item) => Padding(
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
                                              'Instruction ${item.instructionId}',
                                              style: AppTypography.h5,
                                            ),
                                          ),
                                          StatusBadge(
                                            label:
                                                _severityLabel(item.severity),
                                            tone: _severityTone(item.severity),
                                          ),
                                          const SizedBox(width: AppSpacing.sm),
                                          StatusBadge(
                                            label: item.resolved
                                                ? 'Resolved'
                                                : 'Open',
                                            tone: item.resolved
                                                ? AppTone.success
                                                : AppTone.warning,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(item.description,
                                          style: AppTypography.body2),
                                      const SizedBox(height: AppSpacing.md),
                                      Text(
                                        AppFormatters.dateShort(item.date),
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

  static String _severityLabel(ExceptionSeverity severity) {
    switch (severity) {
      case ExceptionSeverity.low:
        return 'Low';
      case ExceptionSeverity.medium:
        return 'Medium';
      case ExceptionSeverity.high:
        return 'High';
    }
  }

  static AppTone _severityTone(ExceptionSeverity severity) {
    switch (severity) {
      case ExceptionSeverity.low:
        return AppTone.info;
      case ExceptionSeverity.medium:
        return AppTone.warning;
      case ExceptionSeverity.high:
        return AppTone.danger;
    }
  }
}
