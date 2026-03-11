import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
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
import '../../domain/entities/settlement_instruction.dart';
import '../cubit/settlement_queue_cubit.dart';
import '../cubit/settlement_queue_state.dart';

class SettlementQueuePage extends StatefulWidget {
  const SettlementQueuePage({Key? key}) : super(key: key);

  @override
  State<SettlementQueuePage> createState() => _SettlementQueuePageState();
}

class _SettlementQueuePageState extends State<SettlementQueuePage> {
  final List<String> _filters = const [
    'All',
    'Queued',
    'Processing',
    'Settled',
    'Failed'
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettlementQueueCubit>(
      create: (_) => getIt<SettlementQueueCubit>()..loadQueue(),
      child: BlocBuilder<SettlementQueueCubit, SettlementQueueState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading settlement queue'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context.read<SettlementQueueCubit>().loadQueue(),
              ),
            );
          }

          final instructions = state.data ?? <SettlementInstruction>[];
          final filtered = instructions.where((instruction) {
            if (_selectedIndex == 0) {
              return true;
            }
            return _statusLabel(instruction.status).toLowerCase() ==
                _filters[_selectedIndex].toLowerCase();
          }).toList();

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Settlement queue',
                      title: 'Operational settlement backlog',
                      subtitle:
                          'Review queued, processing, and completed instructions with clear status, counterparty, and notional visibility.',
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
                              label: 'No instructions in this filter',
                              tone: AppTone.neutral))
                    else
                      Column(
                        children: filtered
                            .map(
                              (instruction) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: AppCard(
                                  onTap: () => Navigator.of(context).pushNamed(
                                    Routes.postTradeSettlementDetail,
                                    arguments: instruction.id,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(instruction.reference,
                                                    style: AppTypography.h5),
                                                const SizedBox(
                                                    height: AppSpacing.xs),
                                                Text(instruction.counterparty,
                                                    style: AppTypography.body2),
                                              ],
                                            ),
                                          ),
                                          StatusBadge(
                                            label: _statusLabel(
                                                instruction.status),
                                            tone:
                                                _statusTone(instruction.status),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InfoPair(
                                              label: 'Instruction ID',
                                              value: instruction.id,
                                            ),
                                          ),
                                          Expanded(
                                            child: InfoPair(
                                              label: 'Settlement date',
                                              value: AppFormatters.dateShort(
                                                  instruction.date),
                                            ),
                                          ),
                                          Expanded(
                                            child: InfoPair(
                                              label: 'Notional',
                                              value: AppFormatters.currency(
                                                instruction.amount,
                                                symbol: instruction.currency,
                                                decimals: 0,
                                              ),
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

  static String _statusLabel(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.queued:
        return 'Queued';
      case SettlementStatus.processing:
        return 'Processing';
      case SettlementStatus.settled:
        return 'Settled';
      case SettlementStatus.failed:
        return 'Failed';
    }
  }

  static AppTone _statusTone(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.queued:
        return AppTone.warning;
      case SettlementStatus.processing:
        return AppTone.info;
      case SettlementStatus.settled:
        return AppTone.success;
      case SettlementStatus.failed:
        return AppTone.danger;
    }
  }
}
