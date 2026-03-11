import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/preferences.dart';
import '../../presentation/cubit/profile_cubit.dart';
import '../../presentation/cubit/profile_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays and allows modification of user preferences.
class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Preferences')),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final prefs = state.data as Preferences;
                return Column(
                  children: [
                    ListTile(
                      title: const Text('Language'),
                      subtitle: Text(prefs.language),
                    ),
                    ListTile(
                      title: const Text('Theme'),
                      subtitle: Text(prefs.theme),
                    ),
                  ],
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<ProfileCubit>().loadPreferences(),
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
