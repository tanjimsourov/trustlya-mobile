import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/segmented_control.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../cubit/transaction_history_cubit.dart';
import '../cubit/transaction_history_state.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  String? _filter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionHistoryCubit>(
      create: (_) => getIt<TransactionHistoryCubit>()..load(filter: _filter),
      child: BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
        builder: (context, state) {
          final transactions = state.data ?? const <WalletTransaction>[];
          final query = _searchController.text.trim().toLowerCase();
          final filteredTransactions = transactions.where((tx) {
            if (query.isEmpty) {
              return true;
            }
            return tx.symbol.toLowerCase().contains(query) ||
                tx.network.toLowerCase().contains(query) ||
                (tx.destination?.toLowerCase().contains(query) ?? false) ||
                tx.type.toLowerCase().contains(query) ||
                tx.status.toLowerCase().contains(query);
          }).toList();

          final completed =
              transactions.where((tx) => tx.status == 'completed').length;
          final internal =
              transactions.where((tx) => tx.network == 'internal').length;
          final uniqueNetworks =
              transactions.map((tx) => tx.network).toSet().length;

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Wallet history',
                      title: 'Operational transaction log',
                      subtitle:
                          'Review deposits, withdrawals, and internal conversions with route context, destination details, and execution status.',
                      metadata: [
                        StatusBadge(
                          label: _filter == null
                              ? 'All events'
                              : AppFormatters.titleCase(_filter!),
                          tone: AppTone.primary,
                        ),
                        StatusBadge(
                          label: '${filteredTransactions.length} visible',
                          tone: AppTone.info,
                        ),
                      ],
                      actions: [
                        SizedBox(
                          width: 170,
                          child: GhostButton(
                            label: 'Wallet overview',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.walletOverview),
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: PrimaryButton(
                            label: 'Refresh log',
                            icon: Icons.refresh,
                            onPressed: () => context
                                .read<TransactionHistoryCubit>()
                                .load(filter: _filter),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Entries',
                          value: '${transactions.length}',
                          icon: Icons.receipt_long_outlined,
                        ),
                        MetricCard(
                          title: 'Completed',
                          value: '$completed',
                          icon: Icons.check_circle_outline,
                          iconColor: AppColorsDS.success,
                        ),
                        MetricCard(
                          title: 'Internal conversions',
                          value: '$internal',
                          icon: Icons.sync_alt_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Networks',
                          value: '$uniqueNetworks',
                          icon: Icons.hub_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    FilterToolbar(
                      leading: SearchField(
                        controller: _searchController,
                        hintText: 'Search symbol, network, or destination',
                        onChanged: (_) => setState(() {}),
                      ),
                      center: SegmentedControl<String>(
                        values: const ['all', 'deposit', 'withdraw', 'swap'],
                        selected: _filter ?? 'all',
                        onChanged: (value) {
                          final nextFilter = value == 'all' ? null : value;
                          setState(() => _filter = nextFilter);
                          context
                              .read<TransactionHistoryCubit>()
                              .load(filter: nextFilter);
                        },
                        labels: const [
                          Text('All'),
                          Text('Deposits'),
                          Text('Withdrawals'),
                          Text('Swaps'),
                        ],
                      ),
                      trailing: StatusBadge(
                        label: state.status == Status.loading
                            ? 'Refreshing'
                            : 'Latest state',
                        tone: state.status == Status.loading
                            ? AppTone.warning
                            : AppTone.success,
                      ),
                    ),
                    const SectionSpacing(),
                    if (state.status == Status.loading && state.data == null)
                      const LoadingWidget(label: 'Loading wallet activity')
                    else if (state.status == Status.error)
                      shared.ErrorWidgetView(
                        message: state.message,
                        onRetry: () => context
                            .read<TransactionHistoryCubit>()
                            .load(filter: _filter),
                      )
                    else if (transactions.isEmpty)
                      EmptyWidget(
                        title: 'No wallet activity yet',
                        message:
                            'Deposits, withdrawals, and swaps will appear here once the operational wallet starts moving.',
                        actionLabel: 'Open wallet overview',
                        onAction: () => Navigator.of(context)
                            .pushNamed(Routes.walletOverview),
                      )
                    else if (filteredTransactions.isEmpty)
                      const EmptyWidget(
                        title: 'No matches for this view',
                        message:
                            'Try a different filter or search phrase to find the required wallet event.',
                        icon: Icons.search_off,
                      )
                    else
                      Column(
                        children: filteredTransactions
                            .map(
                              (tx) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: _TransactionHistoryCard(transaction: tx),
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

class _TransactionHistoryCard extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionHistoryCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final negative = transaction.type == 'withdraw';
    final tone = _toneForStatus(transaction.status);
    final accent = _accentColor(transaction.type);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_iconForType(transaction.type), color: accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppFormatters.titleCase(transaction.type)} ${transaction.symbol}',
                      style: AppTypography.h5,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      transaction.destination ?? transaction.network,
                      style: AppTypography.body2,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge(
                    label: AppFormatters.titleCase(transaction.status),
                    tone: tone,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${negative ? '-' : '+'}${transaction.amount.toStringAsFixed(4)} ${transaction.symbol}',
                    style: AppTypography.subtitle2.copyWith(
                      color:
                          negative ? AppColorsDS.danger : AppColorsDS.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.md,
            children: [
              InfoPair(label: 'Network', value: transaction.network),
              InfoPair(label: 'Fee', value: transaction.fee.toStringAsFixed(6)),
              InfoPair(
                  label: 'Date',
                  value: AppFormatters.dateTimeShort(transaction.date)),
              InfoPair(label: 'Reference', value: transaction.id),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'deposit':
        return Icons.south_west;
      case 'withdraw':
        return Icons.north_east;
      case 'swap':
        return Icons.sync_alt;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  Color _accentColor(String type) {
    switch (type) {
      case 'deposit':
        return AppColorsDS.success;
      case 'withdraw':
        return AppColorsDS.danger;
      case 'swap':
        return AppColorsDS.secondary;
      default:
        return AppColorsDS.primary;
    }
  }

  AppTone _toneForStatus(String status) {
    switch (status) {
      case 'completed':
        return AppTone.success;
      case 'pending':
        return AppTone.warning;
      case 'failed':
        return AppTone.danger;
      default:
        return AppTone.neutral;
    }
  }
}
