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
import '../../domain/entities/carbon_transaction.dart';
import '../cubit/carbon_history_cubit.dart';
import '../cubit/carbon_history_state.dart';

class CarbonHistoryPage extends StatefulWidget {
  const CarbonHistoryPage({Key? key}) : super(key: key);

  @override
  State<CarbonHistoryPage> createState() => _CarbonHistoryPageState();
}

class _CarbonHistoryPageState extends State<CarbonHistoryPage> {
  String _selected = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CarbonHistoryCubit>(
      create: (_) => getIt<CarbonHistoryCubit>()..load(),
      child: BlocBuilder<CarbonHistoryCubit, CarbonHistoryState>(
        builder: (context, state) {
          final transactions = state.data ?? const <CarbonTransaction>[];
          final query = _searchController.text.trim().toLowerCase();
          final visibleTransactions = transactions.where((transaction) {
            final filterMatches =
                _selected == 'all' || transaction.type == _selected;
            final queryMatches = query.isEmpty ||
                transaction.projectName.toLowerCase().contains(query) ||
                transaction.status.toLowerCase().contains(query) ||
                transaction.id.toLowerCase().contains(query);
            return filterMatches && queryMatches;
          }).toList();

          final totalValue =
              transactions.fold<double>(0, (sum, item) => sum + item.total);
          final buyCount =
              transactions.where((item) => item.type == 'buy').length;
          final retireCount =
              transactions.where((item) => item.type == 'retire').length;

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Carbon history',
                      title: 'Marketplace and retirement event log',
                      subtitle:
                          'Review purchased and retired carbon positions with pricing, quantity, and timestamp context for reporting and audit review.',
                      metadata: [
                        StatusBadge(
                          label: _selected == 'all'
                              ? 'All events'
                              : AppFormatters.titleCase(_selected),
                          tone: AppTone.primary,
                        ),
                        StatusBadge(
                            label: '${visibleTransactions.length} visible',
                            tone: AppTone.info),
                      ],
                      actions: [
                        SizedBox(
                          width: 150,
                          child: GhostButton(
                            label: 'Analytics',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonImpact),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: PrimaryButton(
                            label: 'Retire credits',
                            icon: Icons.verified_outlined,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonRetire),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Transactions',
                          value: '${transactions.length}',
                          icon: Icons.receipt_long_outlined,
                        ),
                        MetricCard(
                          title: 'Purchases',
                          value: '$buyCount',
                          icon: Icons.shopping_cart_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Retirements',
                          value: '$retireCount',
                          icon: Icons.assignment_turned_in_outlined,
                          iconColor: AppColorsDS.success,
                        ),
                        MetricCard(
                          title: 'Gross value',
                          value: AppFormatters.currency(
                            totalValue,
                            symbol: '\$',
                            decimals: 0,
                            symbolFirst: true,
                          ),
                          icon: Icons.payments_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    FilterToolbar(
                      leading: SearchField(
                        controller: _searchController,
                        hintText: 'Search project, reference, or status',
                        onChanged: (_) => setState(() {}),
                      ),
                      center: SegmentedControl<String>(
                        values: const ['all', 'buy', 'retire'],
                        selected: _selected,
                        onChanged: (value) => setState(() => _selected = value),
                        labels: const [
                          Text('All'),
                          Text('Buy'),
                          Text('Retire'),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 150,
                        child: GhostButton(
                          label: 'Refresh',
                          icon: Icons.refresh,
                          onPressed: () =>
                              context.read<CarbonHistoryCubit>().load(),
                        ),
                      ),
                    ),
                    const SectionSpacing(),
                    if (state.status == Status.loading && transactions.isEmpty)
                      const LoadingWidget(label: 'Loading carbon history')
                    else if (state.status == Status.error)
                      shared.ErrorWidgetView(
                        message: state.message,
                        onRetry: () =>
                            context.read<CarbonHistoryCubit>().load(),
                      )
                    else if (transactions.isEmpty)
                      EmptyWidget(
                        title: 'No carbon events recorded',
                        message:
                            'Purchases and retirements will appear here once the carbon workspace is in use.',
                        actionLabel: 'Browse projects',
                        onAction: () => Navigator.of(context)
                            .pushNamed(Routes.carbonProjects),
                      )
                    else if (visibleTransactions.isEmpty)
                      const EmptyWidget(
                        title: 'No transactions match the current view',
                        message:
                            'Try a different filter or search term to locate a carbon event.',
                        icon: Icons.search_off,
                      )
                    else
                      Column(
                        children: visibleTransactions
                            .map(
                              (transaction) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: _CarbonHistoryCard(
                                    transaction: transaction),
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

class _CarbonHistoryCard extends StatelessWidget {
  final CarbonTransaction transaction;

  const _CarbonHistoryCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final buy = transaction.type == 'buy';
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
                  color: (buy
                      ? AppColorsDS.accentBlueSoft
                      : AppColorsDS.accentGreenSoft),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  buy
                      ? Icons.shopping_cart_outlined
                      : Icons.assignment_turned_in_outlined,
                  color: buy ? AppColorsDS.primary : AppColorsDS.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.projectName, style: AppTypography.h5),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${AppFormatters.titleCase(transaction.type)} | ${AppFormatters.dateTimeShort(transaction.date)}',
                      style: AppTypography.body2,
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: AppFormatters.titleCase(transaction.status),
                tone: transaction.status == 'completed'
                    ? AppTone.success
                    : AppTone.warning,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.md,
            children: [
              InfoPair(
                  label: 'Quantity',
                  value: transaction.quantity.toStringAsFixed(2)),
              InfoPair(
                label: 'Unit price',
                value: AppFormatters.currency(
                  transaction.pricePerCredit,
                  symbol: '\$',
                  decimals: 2,
                  symbolFirst: true,
                ),
              ),
              InfoPair(
                label: 'Total value',
                value: AppFormatters.currency(
                  transaction.total,
                  symbol: '\$',
                  decimals: 2,
                  symbolFirst: true,
                ),
              ),
              InfoPair(label: 'Reference', value: transaction.id),
            ],
          ),
        ],
      ),
    );
  }
}
