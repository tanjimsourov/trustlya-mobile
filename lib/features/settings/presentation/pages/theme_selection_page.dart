import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/theme_option.dart';
import '../../presentation/cubit/settings_cubit.dart';
import '../../presentation/cubit/settings_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Page to select app theme.
class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => getIt<SettingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Theme Selection')),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.empty:
                return const EmptyWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final themes = state.data as List<ThemeOption>;
                return ListView.builder(
                  itemCount: themes.length,
                  itemBuilder: (context, index) {
                    final option = themes[index];
                    return ListTile(
                      title: Text(option.name),
                    );
                  },
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<SettingsCubit>().loadThemeOptions(),
                    child: const Text('Load Themes'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
