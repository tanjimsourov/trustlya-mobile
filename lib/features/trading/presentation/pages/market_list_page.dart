import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/market_asset.dart';
import '../../presentation/cubit/trading_cubit.dart';
import '../../presentation/cubit/trading_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays a list of market assets for trading.
class MarketListPage extends StatelessWidget {
  const MarketListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradingCubit>(
      create: (_) => getIt<TradingCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Market')),
        body: BlocBuilder<TradingCubit, TradingState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.empty:
                return const EmptyWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final assets = state.data as List<MarketAsset>;
                return ListView.builder(
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final item = assets[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.symbol),
                      trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                    );
                  },
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<TradingCubit>().loadMarketAssets(),
                    child: const Text('Load Market Assets'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
