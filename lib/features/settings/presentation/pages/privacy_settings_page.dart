import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/privacy_settings.dart';
import '../../presentation/cubit/settings_cubit.dart';
import '../../presentation/cubit/settings_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays privacy settings.
class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => getIt<SettingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Privacy Settings')),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final settings = state.data as PrivacySettings;
                return Column(
                  children: [
                    SwitchListTile(
                      value: settings.shareUsageData,
                      onChanged: (_) {},
                      title: const Text('Share Usage Data'),
                    ),
                    SwitchListTile(
                      value: settings.personalizedAds,
                      onChanged: (_) {},
                      title: const Text('Personalized Ads'),
                    ),
                  ],
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<SettingsCubit>().loadPrivacySettings(),
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
