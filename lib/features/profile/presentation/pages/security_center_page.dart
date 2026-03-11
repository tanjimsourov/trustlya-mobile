import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/chips.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../domain/entities/security_settings.dart';
import '../../presentation/cubit/profile_cubit.dart';
import '../../presentation/cubit/profile_state.dart';

/// Displays a comprehensive security centre for the user. It surfaces
/// password status, two factor authentication, biometric settings,
/// trusted devices, login alerts, auto logout duration and backup
/// methods. Users can navigate to change their password or set up
/// two factor authentication from here. Toggle switches trigger
/// updates via the profile cubit.
class SecurityCenterPage extends StatelessWidget {
  const SecurityCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>()..loadSecuritySettings(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == Status.error && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          if (state.status == Status.success) {
            final settings = state.data as SecuritySettings;
            return AppScaffold(
              appBar: AppBar(title: const Text('Security Centre')),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Password section
                      Text('Password', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      AppCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last changed',
                                  style: AppTypography.subtitle2.copyWith(
                                      color: AppColorsDS.textSecondary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(settings.passwordLastChanged),
                                  style: AppTypography.subtitle1,
                                ),
                              ],
                            ),
                            PrimaryButton(
                              label: 'Change',
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.changePassword);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SectionSpacing(),

                      // Two factor authentication
                      Text('Two Factor Authentication',
                          style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SwitchListTile.adaptive(
                              value: settings.twoFactorEnabled,
                              onChanged: (val) {
                                context
                                    .read<ProfileCubit>()
                                    .toggleTwoFactor(val);
                              },
                              activeColor: AppColorsDS.primary,
                              title: const Text('Enable 2FA'),
                              subtitle: Text(
                                settings.twoFactorEnabled
                                    ? 'Two factor is enabled'
                                    : 'Two factor is disabled',
                                style: AppTypography.body2
                                    .copyWith(color: AppColorsDS.textSecondary),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(Routes.twoFactorSetup);
                                },
                                child: const Text('Setup 2FA'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SectionSpacing(),

                      // Biometric unlock
                      Text('Biometric Unlock', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      AppCard(
                        child: SwitchListTile.adaptive(
                          value: settings.biometricEnabled,
                          onChanged: (_) {
                            // For mock we just toggle and update state
                            final updated = settings.copyWith(
                                biometricEnabled: !settings.biometricEnabled);
                            context
                                .read<ProfileCubit>()
                                .updateSecuritySettings(updated);
                          },
                          activeColor: AppColorsDS.primary,
                          title: const Text('Enable biometric unlock'),
                          subtitle: Text(
                            settings.biometricEnabled
                                ? 'Use fingerprint or FaceID to unlock'
                                : 'Biometric unlock disabled',
                            style: AppTypography.body2
                                .copyWith(color: AppColorsDS.textSecondary),
                          ),
                        ),
                      ),
                      const SectionSpacing(),

                      // Trusted devices
                      Text('Trusted Devices', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      if (settings.trustedDevices.isEmpty)
                        Text(
                          'No trusted devices',
                          style: AppTypography.body2
                              .copyWith(color: AppColorsDS.textSecondary),
                        )
                      else
                        Column(
                          children: [
                            for (final device in settings.trustedDevices)
                              AppListTile(
                                leading: const Icon(Icons.devices_other),
                                title: device.name,
                                subtitle:
                                    'Last active: ${_formatRelative(device.lastActive)}',
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  // Could open device details or remove
                                },
                              ),
                          ],
                        ),
                      const SectionSpacing(),

                      // Login alerts
                      Text('Login Alerts', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      AppCard(
                        child: SwitchListTile.adaptive(
                          value: settings.loginAlertsEnabled,
                          onChanged: (val) {
                            final updated =
                                settings.copyWith(loginAlertsEnabled: val);
                            context
                                .read<ProfileCubit>()
                                .updateSecuritySettings(updated);
                          },
                          activeColor: AppColorsDS.primary,
                          title: const Text('Enable login alerts'),
                          subtitle: Text(
                            settings.loginAlertsEnabled
                                ? 'Receive notifications on new logins'
                                : 'Login alerts disabled',
                            style: AppTypography.body2
                                .copyWith(color: AppColorsDS.textSecondary),
                          ),
                        ),
                      ),
                      const SectionSpacing(),

                      // Auto logout
                      Text('Auto Logout', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      AppCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Automatically log out after',
                                style: AppTypography.subtitle1),
                            DropdownButton<Duration>(
                              value: settings.autoLogoutDuration,
                              dropdownColor: AppColorsDS.surface,
                              onChanged: (val) {
                                if (val != null) {
                                  final updated = settings.copyWith(
                                      autoLogoutDuration: val);
                                  context
                                      .read<ProfileCubit>()
                                      .updateSecuritySettings(updated);
                                }
                              },
                              items: const [
                                Duration(minutes: 5),
                                Duration(minutes: 10),
                                Duration(minutes: 30),
                                Duration(hours: 1),
                              ]
                                  .map((d) => DropdownMenuItem(
                                        value: d,
                                        child: Text(_durationLabel(d)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SectionSpacing(),

                      // Backup methods
                      Text('Backup Methods', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        children: [
                          for (final method in settings.backupMethods)
                            AppChip(label: method, selected: false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          // Fallback for unexpected state
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Formats a [DateTime] into a human readable date string.
  static String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays >= 1) {
      return '${date.day}/${date.month}/${date.year}';
    }
    if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    }
    if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    }
    return 'Just now';
  }

  /// Returns a friendly label for a [Duration].
  static String _durationLabel(Duration duration) {
    if (duration.inHours >= 1) {
      return '${duration.inHours}h';
    }
    return '${duration.inMinutes}m';
  }

  /// Formats a [DateTime] difference relative to now for trusted devices.
  static String _formatRelative(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    }
    if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    }
    if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    }
    return 'Just now';
  }
}
