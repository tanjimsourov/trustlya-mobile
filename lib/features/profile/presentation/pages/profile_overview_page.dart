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
import '../../domain/entities/user_profile.dart';
import '../../presentation/cubit/profile_cubit.dart';
import '../../presentation/cubit/profile_state.dart';

/// Displays the user's profile overview. Shows avatar, name, tier,
/// verification status, join date, profile completion and linked
/// accounts. Provides an action to edit the profile.
class ProfileOverviewPage extends StatelessWidget {
  const ProfileOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>()..loadProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          if (state.status == Status.success) {
            final profile = state.data as UserProfile;
            return AppScaffold(
              appBar: AppBar(title: const Text('Profile')),
              body: SingleChildScrollView(
                child: ResponsivePageWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profile.avatarUrl),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        profile.name,
                        style: AppTypography.h2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        profile.email,
                        style: AppTypography.body2
                            .copyWith(color: AppColorsDS.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Tier and verification
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppChip(label: profile.tier, selected: true),
                          const SizedBox(width: AppSpacing.sm),
                          if (profile.verified)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: AppColorsDS.success,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified,
                                      size: 16, color: AppColorsDS.textPrimary),
                                  const SizedBox(width: 4),
                                  Text('Verified',
                                      style: AppTypography.subtitle2),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Join date and progress
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Joined',
                                style: AppTypography.subtitle2.copyWith(
                                    color: AppColorsDS.textSecondary)),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(profile.joinedDate),
                              style: AppTypography.subtitle1,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text('Profile completion',
                                style: AppTypography.subtitle2.copyWith(
                                    color: AppColorsDS.textSecondary)),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: profile.completion,
                              backgroundColor: AppColorsDS.surface,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColorsDS.primary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(profile.completion * 100).round()}% complete',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      const SectionSpacing(),
                      // Linked accounts
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Linked Accounts', style: AppTypography.h3),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (profile.linkedAccounts.isEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('No linked accounts',
                              style: AppTypography.body2
                                  .copyWith(color: AppColorsDS.textSecondary)),
                        )
                      else
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            for (final account in profile.linkedAccounts)
                              AppChip(label: account.provider, selected: false),
                          ],
                        ),
                      const SectionSpacing(),
                      PrimaryButton(
                        label: 'Edit Profile',
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.editProfile);
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
