import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/push_preferences.dart';
import '../../presentation/cubit/notifications_cubit.dart';
import '../../presentation/cubit/notifications_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays user push notification preferences.
class PushPreferencesPage extends StatelessWidget {
  const PushPreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (_) => getIt<NotificationsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Push Preferences')),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final prefs = state.data as PushPreferences;
                return Column(
                  children: [
                    SwitchListTile(
                      value: prefs.marketing,
                      onChanged: (_) {},
                      title: const Text('Marketing'),
                    ),
                    SwitchListTile(
                      value: prefs.productUpdates,
                      onChanged: (_) {},
                      title: const Text('Product Updates'),
                    ),
                    SwitchListTile(
                      value: prefs.securityAlerts,
                      onChanged: (_) {},
                      title: const Text('Security Alerts'),
                    ),
                  ],
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<NotificationsCubit>()
                        .loadPushPreferences(),
                    child: const Text('Load Preferences'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
