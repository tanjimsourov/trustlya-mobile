import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/carbon_credit.dart';
import '../../presentation/cubit/carbon_cubit.dart';
import '../../presentation/cubit/carbon_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays carbon credit marketplace listing.
class MarketplacePage extends StatelessWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CarbonCubit>(
      create: (_) => getIt<CarbonCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Carbon Marketplace')),
        body: BlocBuilder<CarbonCubit, CarbonState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.empty:
                return const EmptyWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final credits = state.data as List<CarbonCredit>;
                return ListView.builder(
                  itemCount: credits.length,
                  itemBuilder: (context, index) {
                    final credit = credits[index];
                    return ListTile(
                      title: Text(credit.name),
                      subtitle:
                          Text('Price: \$${credit.price.toStringAsFixed(2)}'),
                      trailing: Text('Avail: ${credit.availableQuantity}'),
                    );
                  },
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<CarbonCubit>().loadMarketplace(),
                    child: const Text('Load Marketplace'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
