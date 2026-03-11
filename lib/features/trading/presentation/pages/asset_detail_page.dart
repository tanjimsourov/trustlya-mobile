import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/asset_detail.dart';
import '../../presentation/cubit/trading_cubit.dart';
import '../../presentation/cubit/trading_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays detailed information about a particular asset. For demonstration
/// purposes, this page loads the first asset in the market list.
class AssetDetailPage extends StatelessWidget {
  const AssetDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradingCubit>(
      create: (_) => getIt<TradingCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Asset Detail')),
        body: BlocBuilder<TradingCubit, TradingState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final detail = state.data as AssetDetail;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(detail.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Symbol: ${detail.symbol}'),
                      Text('Price: \$${detail.price.toStringAsFixed(2)}'),
                      Text(
                          '24h Change: ${detail.change24h.toStringAsFixed(2)}%'),
                      Text(
                          'Market Cap: \$${detail.marketCap.toStringAsFixed(2)}'),
                      Text('Supply: ${detail.supply.toStringAsFixed(2)}'),
                    ],
                  ),
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<TradingCubit>().loadAssetDetail('btc'),
                    child: const Text('Load Asset Detail'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
