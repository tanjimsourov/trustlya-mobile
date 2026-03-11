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
import '../../domain/entities/ownership_holder.dart';
import '../cubit/cap_table_cubit.dart';
import '../cubit/cap_table_state.dart';

class CapTablePage extends StatelessWidget {
  const CapTablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final programId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider<CapTableCubit>(
      create: (_) => getIt<CapTableCubit>()..loadCapTable(programId ?? ''),
      child: BlocBuilder<CapTableCubit, CapTableState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading cap table'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<CapTableCubit>().loadCapTable(programId ?? ''),
              ),
            );
          }

          final holders = state.data ?? <OwnershipHolder>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Cap table',
                      title: 'Holder distribution',
                      subtitle:
                          'Review holder concentration, token ownership, and placement structure for the selected issuance program.',
                    ),
                    const SectionSpacing(),
                    if (holders.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No holder records',
                              tone: AppTone.neutral))
                    else
                      Column(
                        children: holders
                            .map(
                              (holder) => Padding(
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
                                              child: Text(holder.investorName,
                                                  style: AppTypography.h5)),
                                          Text(
                                            '${holder.percentage.toStringAsFixed(1)}%',
                                            style: AppTypography.subtitle2
                                                .copyWith(
                                                    color: AppColorsDS
                                                        .textPrimary),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        '${AppFormatters.compactNumber(holder.tokens)} tokens',
                                        style: AppTypography.body2,
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      LinearProgressIndicator(
                                        value: holder.percentage / 100,
                                        minHeight: 8,
                                        backgroundColor:
                                            AppColorsDS.surfaceMuted,
                                        color: AppColorsDS.primary,
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
