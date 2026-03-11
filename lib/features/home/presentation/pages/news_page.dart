import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../presentation/cubit/home_cubit.dart';
import '../../presentation/cubit/home_state.dart';
import '../../domain/entities/news_item.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays news articles relevant to the user.
class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('News')),
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
                final news = state.data as List<NewsItem>;
                return ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    final item = news[index];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.summary),
                    );
                  },
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().loadNews(),
                    child: const Text('Load News'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
