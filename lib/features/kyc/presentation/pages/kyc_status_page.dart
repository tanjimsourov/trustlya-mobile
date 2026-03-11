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
import '../../domain/entities/kyc_status.dart';
import '../../presentation/cubit/kyc_cubit.dart';
import '../../presentation/cubit/kyc_state.dart';

/// Displays the status of the user's KYC verification with a timeline
/// representation. Provides actions to start or continue the
/// verification process. Uses the [KycCubit] to fetch the current
/// status and trigger uploads.
class KycStatusPage extends StatelessWidget {
  const KycStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KycCubit>(
      create: (_) => getIt<KycCubit>()..getStatus(),
      child: BlocBuilder<KycCubit, KycState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          if (state.status == Status.success) {
            final status = state.data as KycStatus;
            final stepInfo = _statusToStep(status.status);
            return AppScaffold(
              appBar: AppBar(title: const Text('Verification Status')),
              body: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your verification progress', style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.md),
                    // Timeline representation
                    Column(
                      children: [
                        for (var i = 0; i < _steps.length; i++)
                          _TimelineStep(
                            title: _steps[i],
                            state: i < stepInfo.currentStep
                                ? _StepState.completed
                                : i == stepInfo.currentStep
                                    ? _StepState.current
                                    : _StepState.pending,
                            isLast: i == _steps.length - 1,
                          ),
                      ],
                    ),
                    const SectionSpacing(),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status', style: AppTypography.subtitle1),
                          const SizedBox(height: 4),
                          Text(
                            status.status.replaceAll('_', ' ').toUpperCase(),
                            style: AppTypography.h3,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(status.message,
                              style: AppTypography.body2
                                  .copyWith(color: AppColorsDS.textSecondary)),
                        ],
                      ),
                    ),
                    const SectionSpacing(),
                    if (status.status == 'not_started')
                      PrimaryButton(
                        label: 'Start Verification',
                        onPressed: () {
                          context.read<KycCubit>().start();
                          // After starting, refresh status
                          Future.delayed(const Duration(milliseconds: 600), () {
                            context.read<KycCubit>().getStatus();
                          });
                        },
                      )
                    else if (status.status == 'pending')
                      PrimaryButton(
                        label: 'Continue Upload',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(Routes.documentUpload);
                        },
                      )
                    else if (status.status == 'under_review')
                      SecondaryButton(
                        label: 'Under Review',
                        onPressed: null,
                      )
                    else if (status.status == 'approved')
                      SecondaryButton(
                        label: 'Verified',
                        onPressed: null,
                      )
                    else if (status.status == 'rejected')
                      DestructiveButton(
                        label: 'Resubmit',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(Routes.documentUpload);
                        },
                      ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Maps a status string to the current step index and an optional
  /// description. Steps are 0-based.
  _StepInfo _statusToStep(String status) {
    switch (status) {
      case 'not_started':
        return const _StepInfo(currentStep: 0);
      case 'pending':
        return const _StepInfo(currentStep: 1);
      case 'under_review':
        return const _StepInfo(currentStep: 3);
      case 'approved':
        return const _StepInfo(currentStep: 4);
      case 'rejected':
        return const _StepInfo(currentStep: 4);
      default:
        return const _StepInfo(currentStep: 0);
    }
  }

  static const List<String> _steps = [
    'Start',
    'Upload Identity',
    'Upload Documents',
    'Review',
    'Complete',
  ];
}

/// Information about the current step in the timeline.
class _StepInfo {
  final int currentStep;
  const _StepInfo({required this.currentStep});
}

/// Represents the state of a single step in the timeline.
enum _StepState { completed, current, pending }

/// A widget that displays a single step in the KYC timeline with an icon
/// and label, styled according to its [_StepState].
class _TimelineStep extends StatelessWidget {
  final String title;
  final _StepState state;
  final bool isLast;
  const _TimelineStep(
      {Key? key, required this.title, required this.state, this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (state) {
      case _StepState.completed:
        color = AppColorsDS.success;
        icon = Icons.check_circle;
        break;
      case _StepState.current:
        color = AppColorsDS.primary;
        icon = Icons.radio_button_checked;
        break;
      case _StepState.pending:
        color = AppColorsDS.textSecondary;
        icon = Icons.radio_button_unchecked;
        break;
    }
    return Row(
      children: [
        Column(
          children: [
            Icon(icon, color: color),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: color,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Text(title, style: AppTypography.subtitle1.copyWith(color: color)),
      ],
    );
  }
}
