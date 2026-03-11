import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/issuance_metric.dart';
import '../cubit/issuance_analytics_cubit.dart';
import '../cubit/issuance_analytics_state.dart';

class IssuanceAnalyticsPage extends StatelessWidget {
  const IssuanceAnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final programId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider<IssuanceAnalyticsCubit>(
      create: (_) =>
          getIt<IssuanceAnalyticsCubit>()..loadAnalytics(programId ?? ''),
      child: BlocBuilder<IssuanceAnalyticsCubit, IssuanceAnalyticsState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading issuance analytics'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context
                    .read<IssuanceAnalyticsCubit>()
                    .loadAnalytics(programId ?? ''),
              ),
            );
          }

          final metrics = state.data ?? <IssuanceMetric>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Issuance analytics',
                      title: 'Program performance indicators',
                      subtitle:
                          'Review placement progress, investor participation, pricing context, and issuance KPI movement for the selected program.',
                    ),
                    const SectionSpacing(),
                    if (metrics.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No analytics available',
                              tone: AppTone.neutral))
                    else
                      AdaptiveGrid(
                        itemCount: metrics.length,
                        minCellWidth: 220,
                        itemBuilder: (_, index) {
                          final metric = metrics[index];
                          return MetricCard(
                            title: metric.name,
                            value: metric.value,
                            footer:
                                '${metric.change >= 0 ? '+' : ''}${metric.change.toStringAsFixed(1)} pts',
                            icon: Icons.insights_outlined,
                            iconColor: metric.change >= 0
                                ? AppColorsDS.success
                                : AppColorsDS.danger,
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
