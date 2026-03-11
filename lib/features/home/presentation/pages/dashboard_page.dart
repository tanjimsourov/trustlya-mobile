import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/config/app_backend.dart';
import '../../../../core/config/backend_registry.dart';
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
import '../../../carbon/presentation/cubit/marketplace_dashboard_cubit.dart';
import '../../../carbon/presentation/cubit/marketplace_dashboard_state.dart';
import '../../../post_trade/presentation/cubit/post_trade_dashboard_cubit.dart';
import '../../../post_trade/presentation/cubit/post_trade_dashboard_state.dart';
import '../../../tokenization/presentation/cubit/tokenization_overview_cubit.dart';
import '../../../tokenization/presentation/cubit/tokenization_overview_state.dart';
import '../../../wallet/presentation/cubit/wallet_overview_cubit.dart';
import '../../../wallet/presentation/cubit/wallet_overview_state.dart';

class DashboardPage extends StatelessWidget {
  final bool embedded;

  const DashboardPage({Key? key, this.embedded = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = MultiBlocProvider(
      providers: [
        BlocProvider<TokenizationOverviewCubit>(
          create: (_) => getIt<TokenizationOverviewCubit>()..loadOverview(),
        ),
        BlocProvider<PostTradeDashboardCubit>(
          create: (_) => getIt<PostTradeDashboardCubit>()..loadDashboard(),
        ),
        BlocProvider<WalletOverviewCubit>(
          create: (_) => getIt<WalletOverviewCubit>()..loadOverview(),
        ),
        BlocProvider<MarketplaceDashboardCubit>(
          create: (_) => getIt<MarketplaceDashboardCubit>()..load(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final backendConfig = getIt<AppBackendConfig>();
          final backendRegistry = getIt<BackendRegistry>();
          final tokenState = context.watch<TokenizationOverviewCubit>().state;
          final postState = context.watch<PostTradeDashboardCubit>().state;
          final walletState = context.watch<WalletOverviewCubit>().state;
          final carbonState = context.watch<MarketplaceDashboardCubit>().state;

          final loading = [
            tokenState.status,
            postState.status,
            walletState.status,
            carbonState.status,
          ].contains(Status.loading);

          final errorMessage = tokenState.message ??
              postState.message ??
              walletState.message ??
              carbonState.message;

          final hasError = [
            tokenState.status,
            postState.status,
            walletState.status,
            carbonState.status,
          ].contains(Status.error);

          if (loading) {
            return const LoadingWidget(label: 'Loading platform overview');
          }

          if (hasError) {
            return shared.ErrorWidgetView(
              message: errorMessage,
              onRetry: () {
                context.read<TokenizationOverviewCubit>().loadOverview();
                context.read<PostTradeDashboardCubit>().loadDashboard();
                context.read<WalletOverviewCubit>().loadOverview();
                context.read<MarketplaceDashboardCubit>().load();
              },
            );
          }

          final tokenData = tokenState.data!;
          final postData = postState.data!;
          final walletData = walletState.data!;
          final carbonData = carbonState.data!;
          final metadata = [
            const StatusBadge(
              label: 'MiCA-ready posture',
              tone: AppTone.primary,
            ),
            const StatusBadge(
              label: 'Operational monitoring',
              tone: AppTone.success,
            ),
            StatusBadge(
              label: backendConfig.statusLabel,
              tone: backendConfig.usesApi ? AppTone.info : AppTone.neutral,
            ),
            StatusBadge(
              label: backendRegistry.summaryLabel,
              tone: backendRegistry.hasFallbacks
                  ? AppTone.warning
                  : AppTone.success,
            ),
          ];

          final body = SingleChildScrollView(
            child: ResponsivePageWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    eyebrow: 'Platform overview',
                    title: 'Institutional digital asset operations',
                    subtitle:
                        'Monitor issuance programs, settlement throughput, operational wallet balances, and carbon inventory from a single infrastructure workspace.',
                    metadata: metadata,
                    actions: [
                      SizedBox(
                        width: 150,
                        child: GhostButton(
                          label: 'Activity',
                          icon: Icons.notifications_none_outlined,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.activityCenter),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: PrimaryButton(
                          label: 'Open Post-Trade',
                          icon: Icons.arrow_forward,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.postTradeDashboard),
                        ),
                      ),
                    ],
                  ),
                  const SectionSpacing(),
                  AdaptiveGrid(
                    itemCount: 4,
                    minCellWidth: 250,
                    childAspectRatio: 1.45,
                    itemBuilder: (_, index) {
                      switch (index) {
                        case 0:
                          return MetricCard(
                            title: 'Tokenization programs',
                            value: '${tokenData.totalPrograms}',
                            footer:
                                '${tokenData.activePrograms} active mandates',
                            icon: Icons.account_tree_outlined,
                          );
                        case 1:
                          return MetricCard(
                            title: 'Settlement queue',
                            value: '${postData.pendingInstructions}',
                            footer:
                                '${postData.openExceptions} live exceptions',
                            icon: Icons.fact_check_outlined,
                            iconColor: AppColorsDS.warning,
                          );
                        case 2:
                          return MetricCard(
                            title: 'Wallet balances',
                            value: AppFormatters.currency(
                              walletData.balance.totalBalance,
                              symbol: '€',
                              decimals: 0,
                              symbolFirst: true,
                            ),
                            footer:
                                '${walletData.balance.tokens.length} operational assets',
                            icon: Icons.account_balance_wallet_outlined,
                            iconColor: AppColorsDS.secondary,
                          );
                        default:
                          return MetricCard(
                            title: 'Carbon impact',
                            value:
                                '${carbonData.totalImpact.toStringAsFixed(1)} tCO2e',
                            footer:
                                '${carbonData.totalCreditsHeld.toStringAsFixed(0)} credits on hand',
                            icon: Icons.eco_outlined,
                            iconColor: AppColorsDS.success,
                          );
                      }
                    },
                  ),
                  const SectionSpacing(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 980;
                      final platformPanel = SectionCard(
                        title: 'Platform posture',
                        subtitle:
                            'Key operational indicators across the four product pillars.',
                        child: Column(
                          children: [
                            _SummaryRow(
                              label: 'Pending investor onboardings',
                              value: '${tokenData.pendingOnboardings}',
                            ),
                            _SummaryRow(
                              label: 'Unresolved reconciliation breaks',
                              value: '${postData.unresolvedBreaks}',
                            ),
                            _SummaryRow(
                              label: 'Counterparty exposures',
                              value: '${postData.exposures}',
                            ),
                            _SummaryRow(
                              label: 'Treasury balance',
                              value: AppFormatters.currency(
                                postData.treasuryBalance,
                                symbol: '€',
                                decimals: 0,
                                symbolFirst: true,
                              ),
                            ),
                            _SummaryRow(
                              label: 'Backend mode',
                              value: backendConfig.statusLabel,
                            ),
                            _SummaryRow(
                              label: 'Integration coverage',
                              value: backendRegistry.summaryLabel,
                            ),
                          ],
                        ),
                      );

                      final actionPanel = SectionCard(
                        title: 'Primary workflows',
                        subtitle:
                            'Jump directly into the live operational modules.',
                        child: Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: [
                            _WorkflowTile(
                              title: 'Issuer console',
                              description:
                                  'Programs, onboarding, compliance, lifecycle events.',
                              icon: Icons.account_tree_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.tokenizationOverview),
                            ),
                            _WorkflowTile(
                              title: 'Settlement desk',
                              description:
                                  'Queues, breaks, finality, treasury, reporting.',
                              icon: Icons.fact_check_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.postTradeDashboard),
                            ),
                            _WorkflowTile(
                              title: 'Operational wallet',
                              description:
                                  'Balances, transfers, custody rails, linked methods.',
                              icon: Icons.account_balance_wallet_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.walletOverview),
                            ),
                            _WorkflowTile(
                              title: 'Carbon marketplace',
                              description:
                                  'Project sourcing, holdings, retirements, analytics.',
                              icon: Icons.eco_outlined,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.carbonDashboard),
                            ),
                          ],
                        ),
                      );

                      if (stacked) {
                        return Column(
                          children: [
                            platformPanel,
                            const SectionSpacing(height: AppSpacing.md),
                            actionPanel,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: platformPanel),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: actionPanel),
                        ],
                      );
                    },
                  ),
                  const SectionSpacing(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 980;

                      final walletActivity = SectionCard(
                        title: 'Recent wallet activity',
                        subtitle:
                            'Operational account movements and last-mile actions.',
                        child: walletData.recentTransactions.isEmpty
                            ? const SizedBox(
                                height: 160,
                                child: Center(
                                  child: StatusBadge(
                                    label: 'No recent wallet activity',
                                    tone: AppTone.neutral,
                                  ),
                                ),
                              )
                            : Column(
                                children: walletData.recentTransactions
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
                                          title:
                                              AppFormatters.titleCase(tx.type),
                                          subtitle:
                                              tx.destination ?? tx.network,
                                          amount:
                                              '${tx.type == 'withdraw' ? '-' : '+'}${tx.amount.toStringAsFixed(4)} ${tx.symbol}',
                                          negative: tx.type == 'withdraw',
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(
                                                  Routes.transactionHistory),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                      );

                      final marketSignals = SectionCard(
                        title: 'Institutional watchlist',
                        subtitle:
                            'Reference asset pricing used for treasury and valuation context.',
                        child: Column(
                          children: walletData.balance.tokens
                              .take(4)
                              .map(
                                (token) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm),
                                  child: AssetRow(
                                    symbol: token.symbol,
                                    name: token.symbol,
                                    price: AppFormatters.currency(
                                      token.value,
                                      symbol: '€',
                                      decimals: 0,
                                      symbolFirst: true,
                                    ),
                                    change: AppFormatters.percent(0),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );

                      if (stacked) {
                        return Column(
                          children: [
                            walletActivity,
                            const SectionSpacing(height: AppSpacing.md),
                            marketSignals,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: walletActivity),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: marketSignals),
                        ],
                      );
                    },
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

    if (embedded) {
      return content;
    }

    return content;
  }
}

class _WorkflowTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _WorkflowTile({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColorsDS.accentBlueSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColorsDS.primary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: AppTypography.h5),
            const SizedBox(height: AppSpacing.xs),
            Text(description, style: AppTypography.body2),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.mdSm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.body2)),
          const SizedBox(width: AppSpacing.md),
          Text(value,
              style: AppTypography.subtitle2
                  .copyWith(color: AppColorsDS.textPrimary)),
        ],
      ),
    );
  }
}
