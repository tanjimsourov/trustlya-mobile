import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/notification_item.dart';
import '../../presentation/cubit/notifications_cubit.dart';
import '../../presentation/cubit/notifications_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays detailed information about a single notification.
class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (_) => getIt<NotificationsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notification Detail')),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final item = state.data as NotificationItem;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(item.body),
                      const SizedBox(height: 8),
                      Text('Date: ${item.date.toLocal()}'),
                    ],
                  ),
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<NotificationsCubit>()
                        .loadNotificationDetail('1'),
                    child: const Text('Load Notification Detail'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
