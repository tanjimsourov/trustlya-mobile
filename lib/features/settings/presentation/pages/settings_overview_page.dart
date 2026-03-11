import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

/// A high level overview of user settings. Presents a list of common
/// configuration categories and a logout action. Each tile navigates
/// to its respective detailed settings page when tapped.
class SettingsOverviewPage extends StatelessWidget {
  const SettingsOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // When the auth state returns to initial and there is no user,
          // the logout has completed. Redirect back to the login screen.
          if (state.status == Status.initial && state.data == null) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.login, (route) => false);
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          return AppScaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: ListView(
              children: [
                AppListTile(
                  leading: const Icon(Icons.person),
                  title: 'Account',
                  subtitle: 'Profile and personal info',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.profileView);
                  },
                ),
                AppListTile(
                  leading: const Icon(Icons.lock),
                  title: 'Security',
                  subtitle: 'Password and security settings',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.securitySettings);
                  },
                ),
                AppListTile(
                  leading: const Icon(Icons.credit_card),
                  title: 'Payment Methods',
                  subtitle: 'Manage cards and bank accounts',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.paymentMethods);
                  },
                ),
                AppListTile(
                  leading: const Icon(Icons.settings),
                  title: 'Preferences',
                  subtitle: 'Language, theme and notifications',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.preferences);
                  },
                ),
                AppListTile(
                  leading: const Icon(Icons.verified_user),
                  title: 'KYC & Compliance',
                  subtitle: 'Verify your identity',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to the KYC status page which guides the user
                    Navigator.of(context).pushNamed(Routes.kycStatus);
                  },
                ),
                AppListTile(
                  leading: const Icon(Icons.help_outline),
                  title: 'Support',
                  subtitle: 'Get help and contact us',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.helpSupport);
                  },
                ),
                const Divider(),
                AppListTile(
                  leading: const Icon(Icons.logout, color: AppColorsDS.danger),
                  title: 'Logout',
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColorsDS.danger),
                  onTap: () {
                    context.read<AuthCubit>().logout();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
