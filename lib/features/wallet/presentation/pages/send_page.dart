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
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/token_balance.dart';
import '../cubit/wallet_overview_cubit.dart';
import '../cubit/wallet_overview_state.dart';

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  String? _selectedSymbol;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletOverviewCubit>(
      create: (_) => getIt<WalletOverviewCubit>()..loadOverview(),
      child: BlocBuilder<WalletOverviewCubit, WalletOverviewState>(
        builder: (context, state) {
          if (state.status == Status.loading && state.data == null) {
            return const AppScaffold(
              body: LoadingWidget(label: 'Loading outbound transfer routing'),
            );
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<WalletOverviewCubit>().loadOverview(),
              ),
            );
          }

          final data = state.data;
          final tokens = data?.balance.tokens ?? const <TokenBalance>[];
          if (tokens.isEmpty) {
            return AppScaffold(
              body: EmptyWidget(
                title: 'No transferable balances',
                message:
                    'Asset lines will appear here once balances are funded and ready for outbound operations.',
                actionLabel: 'Open wallet overview',
                onAction: () =>
                    Navigator.of(context).pushNamed(Routes.walletOverview),
              ),
            );
          }

          final selectedSymbol =
              tokens.any((token) => token.symbol == _selectedSymbol)
                  ? _selectedSymbol!
                  : tokens.first.symbol;
          final selectedToken =
              tokens.firstWhere((token) => token.symbol == selectedSymbol);
          final recentOutbound = data!.recentTransactions
              .where((tx) => tx.type == 'withdraw')
              .toList();

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Outbound transfers',
                      title: 'Controlled asset transfer launcher',
                      subtitle:
                          'Use the send route as an operations entry point into the governed withdrawal workflow, with asset selection, balance context, and recent outbound visibility.',
                      metadata: const [
                        StatusBadge(
                            label: 'Route controlled', tone: AppTone.primary),
                        StatusBadge(
                            label: 'Balance backed', tone: AppTone.success),
                        StatusBadge(label: 'Custody aware', tone: AppTone.info),
                      ],
                      actions: [
                        SizedBox(
                          width: 170,
                          child: GhostButton(
                            label: 'Activity log',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.transactionHistory),
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: PrimaryButton(
                            label: 'Continue',
                            icon: Icons.arrow_forward,
                            onPressed: () => Navigator.of(context).pushNamed(
                              Routes.withdraw,
                              arguments: selectedToken.symbol,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Selected asset',
                          value: selectedToken.symbol,
                          icon: Icons.account_balance_wallet_outlined,
                          footer:
                              '${selectedToken.amount.toStringAsFixed(4)} units available',
                        ),
                        MetricCard(
                          title: 'Fiat equivalent',
                          value: AppFormatters.currency(
                            selectedToken.value,
                            symbol: 'EUR ',
                            decimals: 0,
                            symbolFirst: true,
                          ),
                          icon: Icons.euro_outlined,
                        ),
                        MetricCard(
                          title: 'Transferable lines',
                          value: '${tokens.length}',
                          icon: Icons.stacked_bar_chart_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Recent outbound events',
                          value: '${recentOutbound.length}',
                          icon: Icons.north_east_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Select asset line',
                      subtitle:
                          'Choose the balance line to route into the outbound transfer form.',
                      child: Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: tokens.map((token) {
                          final selected = token.symbol == selectedToken.symbol;
                          return SizedBox(
                            width: 220,
                            child: AppCard(
                              borderColor:
                                  selected ? AppColorsDS.primary : null,
                              onTap: () => setState(
                                  () => _selectedSymbol = token.symbol),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: AppColorsDS.accentBlueSoft,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            token.symbol.substring(0, 1),
                                            style: AppTypography.subtitle2
                                                .copyWith(
                                              color: AppColorsDS.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (selected)
                                        const StatusBadge(
                                          label: 'Selected',
                                          tone: AppTone.primary,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(token.symbol, style: AppTypography.h5),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    '${token.amount.toStringAsFixed(4)} units',
                                    style: AppTypography.body2,
                                  ),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    AppFormatters.currency(
                                      token.value,
                                      symbol: 'EUR ',
                                      decimals: 0,
                                      symbolFirst: true,
                                    ),
                                    style: AppTypography.subtitle2.copyWith(
                                      color: AppColorsDS.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SectionSpacing(),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stacked = constraints.maxWidth < 980;

                        final readinessPanel = SectionCard(
                          title: 'Transfer readiness',
                          subtitle:
                              'Confirm the selected asset line before continuing into the governed withdrawal form.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: AppSpacing.xl,
                                runSpacing: AppSpacing.md,
                                children: [
                                  InfoPair(
                                      label: 'Asset line',
                                      value: selectedToken.symbol),
                                  InfoPair(
                                    label: 'Available balance',
                                    value:
                                        selectedToken.amount.toStringAsFixed(4),
                                  ),
                                  InfoPair(
                                    label: 'Estimated value',
                                    value: AppFormatters.currency(
                                      selectedToken.value,
                                      symbol: 'EUR ',
                                      decimals: 0,
                                      symbolFirst: true,
                                    ),
                                  ),
                                  const InfoPair(
                                    label: 'Route type',
                                    value: 'Controlled withdrawal',
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const InsightBanner(
                                title: 'Legacy route handling',
                                description:
                                    'The send entry now routes into the institutional withdrawal workflow to avoid bypassing transfer controls, fee estimation, and destination validation.',
                                icon: Icons.security_outlined,
                                tone: AppTone.info,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Row(
                                children: [
                                  Expanded(
                                    child: PrimaryButton(
                                      label: 'Continue to withdrawal',
                                      icon: Icons.north_east,
                                      onPressed: () =>
                                          Navigator.of(context).pushNamed(
                                        Routes.withdraw,
                                        arguments: selectedToken.symbol,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: GhostButton(
                                      label: 'Deposit instructions',
                                      icon: Icons.south_west,
                                      onPressed: () =>
                                          Navigator.of(context).pushNamed(
                                        Routes.deposit,
                                        arguments: selectedToken.symbol,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );

                        final activityPanel = SectionCard(
                          title: 'Recent outbound activity',
                          subtitle:
                              'Most recent completed outbound transfers from the wallet workspace.',
                          child: recentOutbound.isEmpty
                              ? const EmptyWidget(
                                  title: 'No outbound transfers yet',
                                  message:
                                      'Submitted withdrawals will appear here once the transfer queue starts moving.',
                                  icon: Icons.history_toggle_off,
                                )
                              : Column(
                                  children: recentOutbound
                                      .map(
                                        (tx) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: AppSpacing.sm),
                                          child: TransactionRow(
                                            icon: Icons.north_east,
                                            title: tx.symbol,
                                            subtitle:
                                                tx.destination ?? tx.network,
                                            amount:
                                                '-${tx.amount.toStringAsFixed(4)} ${tx.symbol}',
                                            negative: true,
                                            onTap: () =>
                                                Navigator.of(context).pushNamed(
                                              Routes.transactionHistory,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                        );

                        if (stacked) {
                          return Column(
                            children: [
                              readinessPanel,
                              const SectionSpacing(height: AppSpacing.md),
                              activityPanel,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: readinessPanel),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(flex: 4, child: activityPanel),
                          ],
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
