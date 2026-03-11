import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/referral_entry.dart';
import '../cubit/referral_cubit.dart';
import '../cubit/referral_state.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Referral & invite screen. Displays the user’s referral code,
/// accumulated rewards and list of referred users. Allows inviting
/// new users via an input field.
class ReferralPage extends StatefulWidget {
  const ReferralPage({Key? key}) : super(key: key);

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReferralCubit>(
      create: (_) => ReferralCubit(getIt()),
      child: BlocConsumer<ReferralCubit, ReferralState>(
        listener: (context, state) {
          if (state.status == Status.error) {
            showAppSnackBar(context, message: state.message ?? 'Error');
          }
        },
        builder: (context, state) {
          Widget body;
          switch (state.status) {
            case Status.loading:
              body = const LoadingWidget();
              break;
            case Status.error:
              body = shared.ErrorWidgetView(message: state.message);
              break;
            case Status.success:
              final data = state.data!;
              body = SingleChildScrollView(
                child: ResponsivePageWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Refer & Earn',
                          style: AppTypography.h3
                              .copyWith(color: AppColorsDS.textPrimary)),
                      const SizedBox(height: AppSpacing.md),
                      Text('Your referral code',
                          style: AppTypography.subtitle1
                              .copyWith(color: AppColorsDS.textSecondary)),
                      const SizedBox(height: AppSpacing.xs),
                      GestureDetector(
                        onTap: () {
                          // Copy code to clipboard (omitted for brevity)
                          showAppSnackBar(context,
                              message: 'Copied to clipboard');
                        },
                        child: AppCard(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(data.code,
                                    style: AppTypography.h4
                                        .copyWith(color: AppColorsDS.primary)),
                              ),
                              const Icon(Icons.copy,
                                  color: AppColorsDS.textSecondary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Invite Friends',
                          style: AppTypography.subtitle1
                              .copyWith(color: AppColorsDS.textSecondary)),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _nameController,
                              hintText: 'Enter name',
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          PrimaryButton(
                            label: 'Invite',
                            onPressed: () {
                              final name = _nameController.text.trim();
                              if (name.isEmpty) {
                                showAppSnackBar(context,
                                    message: 'Enter a name');
                                return;
                              }
                              context.read<ReferralCubit>().invite(name);
                              _nameController.clear();
                              showSuccessDialog(context,
                                  title: 'Invite Sent',
                                  message: 'Invitation sent to $name');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Referred Users',
                          style: AppTypography.subtitle1
                              .copyWith(color: AppColorsDS.textPrimary)),
                      const SizedBox(height: AppSpacing.sm),
                      ...data.referrals
                          .map((r) => _buildReferralRow(r))
                          .toList(),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Total Rewards',
                          style: AppTypography.subtitle1
                              .copyWith(color: AppColorsDS.textPrimary)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(data.rewardStats,
                          style: AppTypography.body2
                              .copyWith(color: AppColorsDS.primary)),
                    ],
                  ),
                ),
              );
              break;
            case Status.empty:
              body = const EmptyWidget();
              break;
            default:
              body = const LoadingWidget();
          }
          return AppScaffold(
            appBar: AppBar(title: const Text('Referral & Invite')),
            body: body,
          );
        },
      ),
    );
  }

  Widget _buildReferralRow(ReferralEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColorsDS.surface,
              child:
                  Text(entry.name.substring(0, 1), style: AppTypography.body1),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name,
                      style: AppTypography.subtitle2
                          .copyWith(color: AppColorsDS.textPrimary)),
                  const SizedBox(height: 2),
                  Text('Joined ${entry.joinedDate}',
                      style: AppTypography.caption
                          .copyWith(color: AppColorsDS.textSecondary)),
                ],
              ),
            ),
            Text(entry.rewardEarned,
                style: AppTypography.subtitle2
                    .copyWith(color: AppColorsDS.success)),
          ],
        ),
      ),
    );
  }
}
