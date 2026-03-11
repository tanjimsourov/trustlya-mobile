import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/vip_info.dart';
import '../../presentation/cubit/vip_cubit.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// VIP & loyalty page displaying the user’s tier ladder and progress.
class VipLoyaltyPage extends StatelessWidget {
  const VipLoyaltyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VipCubit, VipState>(
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
                title: const Text('VIP & Loyalty'),
                backgroundColor: AppColorsDS.surface,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCurrentTierCard(info),
                      const SectionSpacing(),
                      Text(
                        'Tier Ladder',
                        style: AppTypography.subtitle1
                            .copyWith(color: AppColorsDS.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildTierLadder(info),
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

  Widget _buildCurrentTierCard(VipInfo info) {
    final currentTier =
        info.tiers.firstWhere((t) => t.name == info.currentTier);
    final nextIndex = info.tiers.indexOf(currentTier) + 1;
    final nextTier =
        nextIndex < info.tiers.length ? info.tiers[nextIndex] : null;
    final pointsNeeded =
        nextTier != null ? nextTier.requiredPoints - info.currentPoints : 0;
    final progress = nextTier != null
        ? (info.currentPoints - currentTier.requiredPoints) /
            (nextTier.requiredPoints - currentTier.requiredPoints)
        : 1.0;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColorsDS.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Tier: ${info.currentTier}',
            style: AppTypography.subtitle1
                .copyWith(color: AppColorsDS.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            currentTier.description,
            style: AppTypography.caption
                .copyWith(color: AppColorsDS.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColorsDS.card,
            color: AppColorsDS.primary,
            minHeight: 6,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            nextTier != null
                ? '${info.currentPoints} / ${nextTier.requiredPoints} points (need $pointsNeeded more)'
                : '${info.currentPoints} points',
            style: AppTypography.caption
                .copyWith(color: AppColorsDS.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTierLadder(VipInfo info) {
    return Column(
      children: info.tiers.map((tier) {
        final isCurrent = tier.name == info.currentTier;
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isCurrent
                ? AppColorsDS.primary.withOpacity(0.1)
                : AppColorsDS.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCurrent ? AppColorsDS.primary : AppColorsDS.card,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                // Use card surface for the non‑active tier background. surface2 is not defined in AppColorsDS.
                backgroundColor:
                    isCurrent ? AppColorsDS.primary : AppColorsDS.card,
                child: Text(
                  tier.name.substring(0, 1),
                  style: AppTypography.subtitle2.copyWith(
                    color: isCurrent ? Colors.white : AppColorsDS.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier.name,
                      style: AppTypography.subtitle1
                          .copyWith(color: AppColorsDS.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tier.description,
                      style: AppTypography.caption
                          .copyWith(color: AppColorsDS.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '${tier.requiredPoints} pts',
                style: AppTypography.caption
                    .copyWith(color: AppColorsDS.textSecondary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
