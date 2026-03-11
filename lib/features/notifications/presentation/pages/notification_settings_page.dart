import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/notification_settings.dart';
import '../../presentation/cubit/notifications_cubit.dart';
import '../../presentation/cubit/notifications_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays notification settings.
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (_) => getIt<NotificationsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notification Settings')),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final settings = state.data as NotificationSettings;
                return Column(
                  children: [
                    SwitchListTile(
                      value: settings.pushEnabled,
                      onChanged: (_) {},
                      title: const Text('Push Notifications'),
                    ),
                    SwitchListTile(
                      value: settings.emailEnabled,
                      onChanged: (_) {},
                      title: const Text('Email Notifications'),
                    ),
                  ],
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<NotificationsCubit>()
                        .loadNotificationSettings(),
                    child: const Text('Load Settings'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
