import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../presentation/cubit/responsible_gaming_cubit.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/responsible_gaming_info.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Page outlining responsible gaming options and information. Shows
/// deposit limits, session reminders and educational guidance. All
/// settings are currently read-only with mock data.
class ResponsibleGamingPage extends StatelessWidget {
  const ResponsibleGamingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResponsibleGamingCubit, ResponsibleGamingState>(
      builder: (context, state) {
        switch (state.status) {
          case Status.loading:
            return const LoadingWidget();
          case Status.error:
            return shared.ErrorWidgetView(message: state.message);
          case Status.success:
            final info = state.data!;
            return AppScaffold(
              appBar: AppBar(
                title: const Text('Responsible Gaming'),
                backgroundColor: AppColorsDS.surface,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Deposit Limit',
                        style: AppTypography.subtitle1
                            .copyWith(color: AppColorsDS.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      LinearProgressIndicator(
                        value: (info.usedDeposit / info.dailyDepositLimit)
                            .clamp(0.0, 1.0),
                        backgroundColor: AppColorsDS.card,
                        color: AppColorsDS.primary,
                        minHeight: 8,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '\$${info.usedDeposit.toStringAsFixed(2)} used of \$${info.dailyDepositLimit.toStringAsFixed(2)}',
                        style: AppTypography.caption
                            .copyWith(color: AppColorsDS.textSecondary),
                      ),
                      const SectionSpacing(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Session Reminders',
                            style: AppTypography.subtitle1
                                .copyWith(color: AppColorsDS.textPrimary),
                          ),
                          Switch(
                            value: info.sessionReminderEnabled,
                            onChanged: (_) {
                              // In a real app this would toggle the setting.
                            },
                          ),
                        ],
                      ),
                      const SectionSpacing(),
                      Text(
                        'Self‑Exclusion',
                        style: AppTypography.subtitle1
                            .copyWith(color: AppColorsDS.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Temporarily block yourself from playing by activating self‑exclusion. (Placeholder)',
                        style: AppTypography.caption
                            .copyWith(color: AppColorsDS.textSecondary),
                      ),
                      const SectionSpacing(),
                      Text(
                        'Education & Tips',
                        style: AppTypography.subtitle1
                            .copyWith(color: AppColorsDS.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        info.info,
                        style: AppTypography.body2
                            .copyWith(color: AppColorsDS.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColorsDS.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Safe Play',
                              style: AppTypography.subtitle1
                                  .copyWith(color: AppColorsDS.textPrimary),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Gambling should be fun and entertaining. Set limits, take breaks and never chase losses.',
                              style: AppTypography.caption
                                  .copyWith(color: AppColorsDS.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          default:
            return const LoadingWidget();
        }
      },
    );
  }
}
