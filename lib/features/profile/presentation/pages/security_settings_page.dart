import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/security_settings.dart';
import '../../presentation/cubit/profile_cubit.dart';
import '../../presentation/cubit/profile_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays user's security settings.
class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Security Settings')),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final settings = state.data as SecuritySettings;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        value: settings.twoFactorEnabled,
                        onChanged: (_) {},
                        title: const Text('Two Factor Authentication'),
                      ),
                      SwitchListTile(
                        value: settings.biometricEnabled,
                        onChanged: (_) {},
                        title: const Text('Biometric Unlock'),
                      ),
                    ],
                  ),
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<ProfileCubit>().loadSecuritySettings(),
                    child: const Text('Load Security Settings'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
