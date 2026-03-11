import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../presentation/cubit/home_cubit.dart';
import '../../presentation/cubit/home_state.dart';
import '../../domain/entities/home_item.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays a list of trending assets.
class TrendingAssetsPage extends StatelessWidget {
  const TrendingAssetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Trending Assets')),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.empty:
                return const EmptyWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final assets = state.data as List<HomeItem>;
                return ListView.builder(
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final item = assets[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle:
                          Text('Price: \$${item.price.toStringAsFixed(2)}'),
                      trailing: Text('${item.change24h.toStringAsFixed(2)}%'),
                    );
                  },
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<HomeCubit>().loadTrendingAssets(),
                    child: const Text('Load Trending Assets'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
