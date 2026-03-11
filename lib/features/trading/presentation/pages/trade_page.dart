import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/order.dart';
import '../../presentation/cubit/trading_cubit.dart';
import '../../presentation/cubit/trading_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Allows users to place buy or sell orders. This page simulates a single
/// order placement for demonstration purposes.
class TradePage extends StatelessWidget {
  const TradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradingCubit>(
      create: (_) => getIt<TradingCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Place Order')),
        body: BlocBuilder<TradingCubit, TradingState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                return const Center(child: Text('Order placed successfully!'));
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final order = Order(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        assetSymbol: 'BTC',
                        amount: 0.1,
                        price: 45000,
                        type: 'buy',
                        date: DateTime.now(),
                      );
                      context.read<TradingCubit>().placeOrder(order);
                    },
                    child: const Text('Place Buy Order'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
