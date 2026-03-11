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
import '../../domain/entities/treasury_position.dart';
import '../cubit/treasury_position_cubit.dart';
import '../cubit/treasury_position_state.dart';

class TreasuryPositionPage extends StatelessWidget {
  const TreasuryPositionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TreasuryPositionCubit>(
      create: (_) => getIt<TreasuryPositionCubit>()..loadPositions(),
      child: BlocBuilder<TreasuryPositionCubit, TreasuryPositionState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading treasury positions'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<TreasuryPositionCubit>().loadPositions(),
              ),
            );
          }

          final positions = state.data ?? <TreasuryPosition>[];
          final totalBalance =
              positions.fold<double>(0, (sum, item) => sum + item.balance);
          final totalAvailable =
              positions.fold<double>(0, (sum, item) => sum + item.available);

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Treasury workspace',
                      title: 'Liquidity positions',
                      subtitle:
                          'Monitor available balances, pending movements, and cash coverage across treasury accounts.',
                    ),
                    const SectionSpacing(),
                    AdaptiveGrid(
                      itemCount: 2,
                      minCellWidth: 260,
                      itemBuilder: (_, index) {
                        if (index == 0) {
                          return MetricCard(
                            title: 'Total balance',
                            value: AppFormatters.currency(totalBalance,
                                symbol: '€', decimals: 0, symbolFirst: true),
                            icon: Icons.account_balance_outlined,
                          );
                        }
                        return MetricCard(
                          title: 'Available liquidity',
                          value: AppFormatters.currency(totalAvailable,
                              symbol: '€', decimals: 0, symbolFirst: true),
                          icon: Icons.payments_outlined,
                        );
                      },
                    ),
                    const SectionSpacing(),
                    if (positions.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No treasury positions',
                              tone: AppTone.neutral))
                    else
                      Column(
                        children: positions
                            .map(
                              (position) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: AppCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(position.accountName,
                                          style: AppTypography.h5),
                                      const SizedBox(height: AppSpacing.md),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InfoPair(
                                              label: 'Balance',
                                              value: AppFormatters.currency(
                                                  position.balance,
                                                  symbol: position.currency,
                                                  decimals: 0),
                                            ),
                                          ),
                                          Expanded(
                                            child: InfoPair(
                                              label: 'Available',
                                              value: AppFormatters.currency(
                                                  position.available,
                                                  symbol: position.currency,
                                                  decimals: 0),
                                            ),
                                          ),
                                          Expanded(
                                            child: InfoPair(
                                              label: 'Pending',
                                              value: AppFormatters.currency(
                                                  position.pending,
                                                  symbol: position.currency,
                                                  decimals: 0),
                                            ),
                                          ),
                                        ],
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
