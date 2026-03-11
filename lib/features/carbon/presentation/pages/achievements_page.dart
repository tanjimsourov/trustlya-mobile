import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../presentation/cubit/achievements_cubit.dart';
import '../../presentation/cubit/achievements_state.dart';
import '../../domain/entities/achievement.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/cards.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Displays the user’s eco achievements and progress towards future
/// milestones. Each achievement shows its title, description, progress
/// bar and an indicator when completed. Uses [AchievementsCubit] to
/// fetch the data.
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AchievementsCubit>(
      create: (_) => getIt<AchievementsCubit>()..load(),
      child: BlocBuilder<AchievementsCubit, AchievementsState>(
        builder: (context, state) {
          Widget body;
          switch (state.status) {
            case Status.loading:
              body = const LoadingWidget();
              break;
            case Status.error:
              body = shared.ErrorWidgetView(message: state.message);
              break;
            case Status.empty:
              body = const EmptyWidget();
              break;
            case Status.success:
              final achievements = state.data ?? [];
              body = SingleChildScrollView(
                child: ResponsivePageWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Achievements',
                          style: AppTypography.h3
                              .copyWith(color: AppColorsDS.textPrimary)),
                      const SizedBox(height: AppSpacing.lg),
                      Column(
                        children: achievements
                            .map((a) => _AchievementCard(achievement: a))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
              break;
            default:
              body = const LoadingWidget();
          }
          return AppScaffold(
            appBar: AppBar(title: const Text('Achievements')),
            body: body,
          );
        },
      ),
    );
  }
}

/// Internal widget for displaying a single achievement with progress bar.
class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  const _AchievementCard({Key? key, required this.achievement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color =
        achievement.achieved ? AppColorsDS.success : AppColorsDS.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  achievement.achieved
                      ? Icons.emoji_events
                      : Icons.lock_outline,
                  color: color,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  achievement.title,
                  style: AppTypography.subtitle1
                      .copyWith(color: AppColorsDS.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              achievement.description,
              style: AppTypography.body2
                  .copyWith(color: AppColorsDS.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Progress bar
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColorsDS.surface,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: achievement.progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${(achievement.progress * 100).toStringAsFixed(0)}% complete',
              style: AppTypography.caption
                  .copyWith(color: AppColorsDS.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
