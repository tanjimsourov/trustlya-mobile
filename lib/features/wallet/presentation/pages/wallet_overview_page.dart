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
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/payment_brand_badge.dart';
import '../../domain/entities/token_balance.dart';
import '../cubit/fiat_ramp_cubit.dart';
import '../cubit/fiat_ramp_state.dart';
import '../cubit/linked_methods_cubit.dart';
import '../cubit/linked_methods_state.dart';
import '../cubit/wallet_overview_cubit.dart';
import '../cubit/wallet_overview_state.dart';

class WalletOverviewPage extends StatelessWidget {
  final bool embedded;

  const WalletOverviewPage({Key? key, this.embedded = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = MultiBlocProvider(
      providers: [
        BlocProvider<WalletOverviewCubit>(
          create: (_) => getIt<WalletOverviewCubit>()..loadOverview(),
        ),
        BlocProvider<FiatRampCubit>(
          create: (_) => getIt<FiatRampCubit>()..load(),
        ),
        BlocProvider<LinkedMethodsCubit>(
          create: (_) => getIt<LinkedMethodsCubit>()..load(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final overviewState = context.watch<WalletOverviewCubit>().state;
          final railsState = context.watch<FiatRampCubit>().state;
          final methodsState = context.watch<LinkedMethodsCubit>().state;

          final loading = [
            overviewState.status,
            railsState.status,
            methodsState.status,
          ].contains(Status.loading);

          final error = overviewState.message ??
              railsState.message ??
              methodsState.message;
          final hasError = [
            overviewState.status,
            railsState.status,
            methodsState.status,
          ].contains(Status.error);

          if (loading) {
            return const LoadingWidget(label: 'Loading wallet operations');
          }

          if (hasError) {
            return shared.ErrorWidgetView(
              message: error,
              onRetry: () {
                context.read<WalletOverviewCubit>().loadOverview();
                context.read<FiatRampCubit>().load();
                context.read<LinkedMethodsCubit>().load();
              },
            );
          }

          final data = overviewState.data!;
          final rails = railsState.data ?? [];
          final methods = methodsState.data ?? [];

          final body = SingleChildScrollView(
            child: ResponsivePageWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    eyebrow: 'Wallet and asset management',
                    title: 'Operational wallet balances and rails',
                    subtitle:
                        'Control account balances, transfer rails, liquidity movements, and custody hygiene from a wallet workspace designed for operations teams instead of retail trading.',
                    metadata: const [
                      StatusBadge(
                          label: 'Custody messaging', tone: AppTone.primary),
                      StatusBadge(
                          label: 'Fiat rails connected', tone: AppTone.success),
                      StatusBadge(
                          label: 'Transfer controls', tone: AppTone.info),
                    ],
                    actions: [
                      SizedBox(
                        width: 140,
                        child: GhostButton(
                          label: 'Methods',
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.linkedMethods),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: PrimaryButton(
                          label: 'Transaction log',
                          icon: Icons.arrow_forward,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.transactionHistory),
                        ),
                      ),
                    ],
                  ),
                  const SectionSpacing(),
                  AdaptiveGrid(
                    itemCount: 4,
                    minCellWidth: 240,
                    itemBuilder: (_, index) {
                      switch (index) {
                        case 0:
                          return MetricCard(
                            title: 'Total balance',
                            value: AppFormatters.currency(
                              data.balance.totalBalance,
                              symbol: '€',
                              decimals: 0,
                              symbolFirst: true,
                            ),
                            icon: Icons.account_balance_wallet_outlined,
                          );
                        case 1:
                          return MetricCard(
                            title: 'Asset lines',
                            value: '${data.balance.tokens.length}',
                            icon: Icons.stacked_line_chart_outlined,
                          );
                        case 2:
                          return MetricCard(
                            title: 'Linked methods',
                            value: '${methods.length}',
                            icon: Icons.link_outlined,
                            iconColor: AppColorsDS.secondary,
                          );
                        default:
                          return MetricCard(
                            title: 'Fiat rails',
                            value: '${rails.length}',
                            icon: Icons.account_balance_outlined,
                            iconColor: AppColorsDS.success,
                          );
                      }
                    },
                  ),
                  const SectionSpacing(),
                  SectionCard(
                    title: 'Primary actions',
                    subtitle:
                        'Core account operations available to treasury and operations users.',
                    child: Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: [
                        SizedBox(
                          width: 180,
                          child: PrimaryButton(
                            label: 'Deposit',
                            icon: Icons.south_west,
                            onPressed: () => Navigator.of(context).pushNamed(
                              Routes.deposit,
                              arguments: data.balance.tokens.isEmpty
                                  ? 'BTC'
                                  : data.balance.tokens.first.symbol,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: GhostButton(
                            label: 'Withdraw',
                            icon: Icons.north_east,
                            onPressed: () => Navigator.of(context).pushNamed(
                              Routes.withdraw,
                              arguments: data.balance.tokens.isEmpty
                                  ? 'BTC'
                                  : data.balance.tokens.first.symbol,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: GhostButton(
                            label: 'Swap',
                            icon: Icons.sync_alt,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.swapAssets),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: GhostButton(
                            label: 'Fiat rails',
                            icon: Icons.account_balance,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.fiatRamp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SectionSpacing(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 980;

                      final balancesPanel = SectionCard(
                        title: 'Asset balances',
                        subtitle: 'Operational balances by asset line.',
                        child: Column(
                          children: data.balance.tokens
                              .map(
                                (token) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm),
                                  child: _AssetBalanceTile(token: token),
                                ),
                              )
                              .toList(),
                        ),
                      );

                      final railsPanel = SectionCard(
                        title: 'Custody and rail coverage',
                        subtitle:
                            'Linked payout methods and available fiat connectivity.',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const InsightBanner(
                              title: 'Operational custody posture',
                              description:
                                  'Transfer initiation remains separated from consumer trading surfaces and supported by linked payout controls.',
                              icon: Icons.shield_outlined,
                              tone: AppTone.primary,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ...methods.take(2).map(
                                  (method) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: AppSpacing.sm),
                                    child: AppCard(
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final stacked =
                                              constraints.maxWidth < 460;
                                          final details = Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(method.provider,
                                                  style: AppTypography.h5),
                                              Text(method.maskedNumber,
                                                  style: AppTypography.body2),
                                            ],
                                          );
                                          final status = StatusBadge(
                                            label: method.verified
                                                ? 'Verified'
                                                : 'Pending',
                                            tone: method.verified
                                                ? AppTone.success
                                                : AppTone.warning,
                                          );

                                          if (stacked) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                PaymentBrandBadge(
                                                  provider: method.provider,
                                                  type: method.type,
                                                ),
                                                const SizedBox(
                                                    height: AppSpacing.md),
                                                details,
                                                const SizedBox(
                                                    height: AppSpacing.sm),
                                                status,
                                              ],
                                            );
                                          }

                                          return Row(
                                            children: [
                                              PaymentBrandBadge(
                                                provider: method.provider,
                                                type: method.type,
                                              ),
                                              const SizedBox(
                                                  width: AppSpacing.md),
                                              Expanded(child: details),
                                              status,
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                            ...rails.take(2).map(
                                  (rail) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: AppSpacing.sm),
                                    child: AppCard(
                                      child: Row(
                                        children: [
                                          PaymentBrandBadge(
                                            provider: rail.provider,
                                            type: rail.type,
                                          ),
                                          const SizedBox(width: AppSpacing.md),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(rail.provider,
                                                    style: AppTypography.h5),
                                                Text(
                                                  '${AppFormatters.titleCase(rail.type)} • ${rail.processingTime}',
                                                  style: AppTypography.body2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            AppFormatters.percent(
                                                rail.fee * 100,
                                                decimals: 1),
                                            style: AppTypography.subtitle2
                                                .copyWith(
                                                    color: AppColorsDS
                                                        .textPrimary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      );

                      if (stacked) {
                        return Column(
                          children: [
                            balancesPanel,
                            const SectionSpacing(height: AppSpacing.md),
                            railsPanel,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: balancesPanel),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: railsPanel),
                        ],
                      );
                    },
                  ),
                  const SectionSpacing(),
                  SectionCard(
                    title: 'Recent account activity',
                    subtitle:
                        'Latest wallet events requiring operational visibility.',
                    child: data.recentTransactions.isEmpty
                        ? const Center(
                            child: StatusBadge(
                                label: 'No recent activity',
                                tone: AppTone.neutral))
                        : Column(
                            children: data.recentTransactions
                                .map(
                                  (tx) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: AppSpacing.sm),
                                    child: TransactionRow(
                                      icon: tx.type == 'withdraw'
                                          ? Icons.north_east
                                          : tx.type == 'deposit'
                                              ? Icons.south_west
                                              : Icons.sync_alt,
                                      title: AppFormatters.titleCase(tx.type),
                                      subtitle: tx.destination ?? tx.network,
                                      amount:
                                          '${tx.type == 'withdraw' ? '-' : '+'}${tx.amount.toStringAsFixed(4)} ${tx.symbol}',
                                      negative: tx.type == 'withdraw',
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(Routes.transactionHistory),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          );

          if (embedded) {
            return body;
          }

          return AppScaffold(body: body);
        },
      ),
    );

    return content;
  }
}

class _AssetBalanceTile extends StatelessWidget {
  final TokenBalance token;

  const _AssetBalanceTile({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.walletAssetDetail, arguments: token.symbol),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColorsDS.accentBlueSoft,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                token.symbol.substring(0, 1),
                style: AppTypography.subtitle2
                    .copyWith(color: AppColorsDS.primary),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(token.symbol, style: AppTypography.h5),
                Text('${token.amount.toStringAsFixed(4)} units',
                    style: AppTypography.body2),
              ],
            ),
          ),
          Text(
            AppFormatters.currency(token.value,
                symbol: '€', decimals: 0, symbolFirst: true),
            style: AppTypography.subtitle2
                .copyWith(color: AppColorsDS.textPrimary),
          ),
        ],
      ),
    );
  }
}
