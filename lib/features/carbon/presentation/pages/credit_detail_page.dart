import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/carbon_credit.dart';
import '../../presentation/cubit/carbon_cubit.dart';
import '../../presentation/cubit/carbon_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays details for a carbon credit.
class CreditDetailPage extends StatelessWidget {
  const CreditDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CarbonCubit>(
      create: (_) => getIt<CarbonCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Credit Detail')),
        body: BlocBuilder<CarbonCubit, CarbonState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final credit = state.data as CarbonCredit;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(credit.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Price: \$${credit.price.toStringAsFixed(2)}'),
                      Text('Available Quantity: ${credit.availableQuantity}'),
                    ],
                  ),
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<CarbonCubit>().loadCreditDetail('1'),
                    child: const Text('Load Credit Detail'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
