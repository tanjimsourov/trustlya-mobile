import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/language_option.dart';
import '../../presentation/cubit/settings_cubit.dart';
import '../../presentation/cubit/settings_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Page to select application language.
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => getIt<SettingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Language Settings')),
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
                final languages = state.data as List<LanguageOption>;
                return ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final option = languages[index];
                    return ListTile(
                      title: Text(option.name),
                      subtitle: Text(option.code),
                    );
                  },
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<SettingsCubit>().loadLanguageOptions(),
                    child: const Text('Load Languages'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
