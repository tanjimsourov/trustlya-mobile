import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/order.dart';
import '../../presentation/cubit/trading_cubit.dart';
import '../../presentation/cubit/trading_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays the user's past orders.
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradingCubit>(
      create: (_) => getIt<TradingCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Order History')),
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
                final orders = state.data as List<Order>;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      title: Text(
                          '${order.type.toUpperCase()} ${order.assetSymbol}'),
                      subtitle: Text('${order.amount} at \$${order.price}'),
                      trailing: Text('${order.date.toLocal()}'),
                    );
                  },
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<TradingCubit>().loadOrderHistory(),
                    child: const Text('Load Order History'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
