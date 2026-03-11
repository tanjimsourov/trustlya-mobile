import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../cubit/rewards_cubit.dart';
import '../cubit/rewards_state.dart';
import '../../domain/entities/mission.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Rewards and missions screen. Displays a list of missions across
/// modules with progress bars and claim buttons. Uses [RewardsCubit]
/// for state management.
class RewardsPage extends StatelessWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RewardsCubit>(
      create: (_) => RewardsCubit(getIt()),
      child: BlocBuilder<RewardsCubit, RewardsState>(
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
              final missions = state.data ?? [];
              body = ListView.builder(
                itemCount: missions.length,
                itemBuilder: (context, index) {
                  final mission = missions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  mission.title,
                                  style: AppTypography.subtitle1
                                      .copyWith(color: AppColorsDS.textPrimary),
                                ),
                              ),
                              Chip(
                                label: Text(mission.module),
                                backgroundColor: AppColorsDS.surface,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mission.description,
                            style: AppTypography.caption
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
                              widthFactor: mission.progress.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: mission.progress >= 1.0
                                      ? AppColorsDS.success
                                      : AppColorsDS.primary,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(mission.progress * 100).toStringAsFixed(0)}% complete • Reward: ${mission.reward}',
                            style: AppTypography.overline
                                .copyWith(color: AppColorsDS.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Align(
                            alignment: Alignment.centerRight,
                            child: PrimaryButton(
                              label: mission.claimed
                                  ? 'Claimed'
                                  : (mission.progress >= 1.0
                                      ? 'Claim Reward'
                                      : 'In Progress'),
                              onPressed:
                                  mission.progress >= 1.0 && !mission.claimed
                                      ? () => context
                                          .read<RewardsCubit>()
                                          .claim(mission.id)
                                      : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              break;
            default:
              body = const LoadingWidget();
          }
          return AppScaffold(
            appBar: AppBar(title: const Text('Rewards & Missions')),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: body,
            ),
          );
        },
      ),
    );
  }
}
