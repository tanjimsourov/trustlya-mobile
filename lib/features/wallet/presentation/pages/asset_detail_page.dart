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
import '../../domain/entities/asset_detail.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../cubit/asset_detail_cubit.dart';
import '../cubit/asset_detail_state.dart';

class AssetDetailPage extends StatelessWidget {
  final String symbol;

  const AssetDetailPage({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssetDetailCubit>(
      create: (_) => getIt<AssetDetailCubit>()..load(symbol),
      child: BlocBuilder<AssetDetailCubit, AssetDetailState>(
        builder: (context, state) {
          if (state.status == Status.loading && state.data == null) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading asset details'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context.read<AssetDetailCubit>().load(symbol),
              ),
            );
          }

          final asset = state.data;
          if (asset == null) {
            return const AppScaffold(
              body: EmptyWidget(
                title: 'Asset not available',
                message:
                    'The requested asset line could not be loaded in the wallet workspace.',
                icon: Icons.account_balance_wallet_outlined,
              ),
            );
          }

          final exposureValue = asset.amount * asset.price;
          final changePositive = asset.change24h >= 0;

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Asset detail',
                      title: '${asset.name} operational balance',
                      subtitle:
                          'Review wallet exposure, recent movement, and action controls for a single asset line before routing deposits, withdrawals, or conversions.',
                      metadata: [
                        StatusBadge(label: asset.symbol, tone: AppTone.primary),
                        StatusBadge(
                          label: changePositive
                              ? '${AppFormatters.percent(asset.change24h, signed: true)} 24h'
                              : '${AppFormatters.percent(asset.change24h)} 24h',
                          tone:
                              changePositive ? AppTone.success : AppTone.danger,
                        ),
                        StatusBadge(
                          label:
                              '${state.recentTransactions.length} recent events',
                          tone: AppTone.info,
                        ),
                      ],
                      actions: [
                        SizedBox(
                          width: 150,
                          child: GhostButton(
                            label: 'History',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.transactionHistory),
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: PrimaryButton(
                            label: 'Withdraw',
                            icon: Icons.north_east,
                            onPressed: () => Navigator.of(context).pushNamed(
                              Routes.withdraw,
                              arguments: asset.symbol,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Balance',
                          value:
                              '${asset.amount.toStringAsFixed(4)} ${asset.symbol}',
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                        MetricCard(
                          title: 'Exposure',
                          value: AppFormatters.currency(
                            exposureValue,
                            symbol: 'EUR ',
                            decimals: 0,
                            symbolFirst: true,
                          ),
                          icon: Icons.euro_outlined,
                        ),
                        MetricCard(
                          title: 'Mark price',
                          value: AppFormatters.currency(
                            asset.price,
                            symbol: 'EUR ',
                            decimals: 0,
                            symbolFirst: true,
                          ),
                          icon: Icons.show_chart_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Recent activity',
                          value: '${state.recentTransactions.length}',
                          icon: Icons.history_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stacked = constraints.maxWidth < 980;

                        final performancePanel = SectionCard(
                          title: 'Performance and exposure',
                          subtitle:
                              'Seven-day reference movement for this wallet asset line.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 180,
                                child: _AssetSparkline(asset: asset),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Wrap(
                                spacing: AppSpacing.xl,
                                runSpacing: AppSpacing.md,
                                children: [
                                  InfoPair(
                                      label: 'Low point',
                                      value: asset.history
                                          .reduce(_min)
                                          .toStringAsFixed(2)),
                                  InfoPair(
                                      label: 'High point',
                                      value: asset.history
                                          .reduce(_max)
                                          .toStringAsFixed(2)),
                                  InfoPair(
                                    label: 'Current move',
                                    value: AppFormatters.percent(
                                        asset.change24h,
                                        signed: true),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );

                        final controlsPanel = SectionCard(
                          title: 'Available actions',
                          subtitle:
                              'Operational controls supported for this asset line.',
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: PrimaryButton(
                                      label: 'Deposit',
                                      icon: Icons.south_west,
                                      onPressed: () =>
                                          Navigator.of(context).pushNamed(
                                        Routes.deposit,
                                        arguments: asset.symbol,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: GhostButton(
                                      label: 'Withdraw',
                                      icon: Icons.north_east,
                                      onPressed: () =>
                                          Navigator.of(context).pushNamed(
                                        Routes.withdraw,
                                        arguments: asset.symbol,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Expanded(
                                    child: GhostButton(
                                      label: 'Receive',
                                      icon: Icons.qr_code_2_outlined,
                                      onPressed: () =>
                                          Navigator.of(context).pushNamed(
                                        Routes.walletReceive,
                                        arguments: asset.symbol,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: GhostButton(
                                      label: 'Swap',
                                      icon: Icons.sync_alt,
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed(Routes.swapAssets),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              InsightBanner(
                                title: 'Custody note',
                                description:
                                    '${asset.symbol} movements should be initiated through controlled transfer routes with network and fee review before submission.',
                                icon: Icons.shield_outlined,
                                tone: AppTone.info,
                              ),
                            ],
                          ),
                        );

                        if (stacked) {
                          return Column(
                            children: [
                              performancePanel,
                              const SectionSpacing(height: AppSpacing.md),
                              controlsPanel,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: performancePanel),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(flex: 5, child: controlsPanel),
                          ],
                        );
                      },
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Recent asset activity',
                      subtitle:
                          'Latest transactions associated with this balance line.',
                      child: state.recentTransactions.isEmpty
                          ? const EmptyWidget(
                              title: 'No recent asset activity',
                              message:
                                  'Deposits, withdrawals, and swaps involving this asset line will appear here.',
                              icon: Icons.history_toggle_off,
                            )
                          : Column(
                              children: state.recentTransactions
                                  .map(
                                    (tx) => Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSpacing.sm),
                                      child: _AssetTransactionTile(
                                          transaction: tx),
                                    ),
                                  )
                                  .toList(),
                            ),
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

  double _min(double a, double b) => a < b ? a : b;

  double _max(double a, double b) => a > b ? a : b;
}

class _AssetTransactionTile extends StatelessWidget {
  final WalletTransaction transaction;

  const _AssetTransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final negative = transaction.type == 'withdraw';
    return TransactionRow(
      icon: transaction.type == 'deposit'
          ? Icons.south_west
          : transaction.type == 'swap'
              ? Icons.sync_alt
              : Icons.north_east,
      title: AppFormatters.titleCase(transaction.type),
      subtitle: transaction.destination ?? transaction.network,
      amount:
          '${negative ? '-' : '+'}${transaction.amount.toStringAsFixed(4)} ${transaction.symbol}',
      negative: negative,
      onTap: () => Navigator.of(context).pushNamed(Routes.transactionHistory),
    );
  }
}

class _AssetSparkline extends StatelessWidget {
  final AssetDetail asset;

  const _AssetSparkline({required this.asset});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: CustomPaint(
        painter: _SparklinePainter(
          points: asset.history,
          strokeColor:
              asset.change24h >= 0 ? AppColorsDS.success : AppColorsDS.danger,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color strokeColor;

  _SparklinePainter({
    required this.points,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) {
      return;
    }

    final minPoint = points.reduce((a, b) => a < b ? a : b);
    final maxPoint = points.reduce((a, b) => a > b ? a : b);
    final span =
        (maxPoint - minPoint).abs() < 0.0001 ? 1.0 : maxPoint - minPoint;

    final fillPath = Path();
    final linePath = Path();
    for (var i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = size.height - ((points[i] - minPoint) / span) * size.height;
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath
      ..lineTo(size.width, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          strokeColor.withOpacity(0.20),
          strokeColor.withOpacity(0.02),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);

    final strokePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final guidePaint = Paint()
      ..color = AppColorsDS.divider
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      guidePaint,
    );
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.strokeColor != strokeColor;
  }
}
