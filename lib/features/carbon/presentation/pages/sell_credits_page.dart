import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/carbon_transaction.dart';
import '../../presentation/cubit/carbon_cubit.dart';
import '../../presentation/cubit/carbon_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Page for selling carbon credits.
class SellCreditsPage extends StatelessWidget {
  const SellCreditsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CarbonCubit>(
      create: (_) => getIt<CarbonCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sell Credits')),
        body: BlocBuilder<CarbonCubit, CarbonState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final tx = state.data as CarbonTransaction;
                return Center(
                  child:
                      Text('Sold ${tx.quantity} credits of ${tx.creditName}'),
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<CarbonCubit>().sellCredits('1', 5),
                    child: const Text('Sell 5 Credits'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
