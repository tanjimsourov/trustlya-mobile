import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/sla_metric.dart';
import '../cubit/operations_sla_cubit.dart';
import '../cubit/operations_sla_state.dart';

class OperationsSlaPage extends StatelessWidget {
  const OperationsSlaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OperationsSlaCubit>(
      create: (_) => getIt<OperationsSlaCubit>()..loadSla(),
      child: BlocBuilder<OperationsSlaCubit, OperationsSlaState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading SLA metrics'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context.read<OperationsSlaCubit>().loadSla(),
              ),
            );
          }

          final metrics = state.data ?? <SlaMetric>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Operations SLA',
                      title: 'Service-level monitoring',
                      subtitle:
                          'Compare actual operating performance against defined service-level commitments across settlement operations.',
                    ),
                    const SectionSpacing(),
                    if (metrics.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No SLA metrics', tone: AppTone.neutral))
                    else
                      AdaptiveGrid(
                        itemCount: metrics.length,
                        minCellWidth: 240,
                        itemBuilder: (_, index) {
                          final metric = metrics[index];
                          return MetricCard(
                            title: metric.name,
                            value:
                                '${metric.value.toStringAsFixed(1)}${metric.unit}',
                            footer:
                                'Target ${metric.target.toStringAsFixed(1)}${metric.unit}',
                            icon: Icons.speed_outlined,
                            iconColor: metric.met
                                ? AppColorsDS.success
                                : AppColorsDS.warning,
                          );
                        },
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
