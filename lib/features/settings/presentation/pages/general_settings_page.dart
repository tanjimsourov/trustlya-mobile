import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/general_settings.dart';
import '../../presentation/cubit/settings_cubit.dart';
import '../../presentation/cubit/settings_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays general application settings.
class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => getIt<SettingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('General Settings')),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final settings = state.data as GeneralSettings;
                return Column(
                  children: [
                    SwitchListTile(
                      value: settings.notificationsEnabled,
                      onChanged: (_) {},
                      title: const Text('Enable Notifications'),
                    ),
                    SwitchListTile(
                      value: settings.analyticsEnabled,
                      onChanged: (_) {},
                      title: const Text('Share Analytics'),
                    ),
                  ],
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<SettingsCubit>().loadGeneralSettings(),
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
