import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/bonus.dart';
import '../../presentation/cubit/bonus_cubit.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/buttons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Displays available bonuses and rewards. Users can claim bonuses when
/// eligible. Each bonus shows progress towards claiming and a CTA.
class BonusRewardsPage extends StatelessWidget {
  const BonusRewardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BonusCubit, BonusState>(
      builder: (context, state) {
        switch (state.status) {
          case Status.loading:
            return const LoadingWidget();
          case Status.error:
            return shared.ErrorWidgetView(message: state.message);
          case Status.empty:
            return const EmptyWidget();
          case Status.success:
            final bonuses = state.data!;
            return AppScaffold(
              appBar: AppBar(
                title: const Text('Bonuses & Rewards'),
                backgroundColor: AppColorsDS.surface,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: bonuses
                        .map((bonus) => _buildBonusCard(context, bonus))
                        .toList(),
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

  Widget _buildBonusCard(BuildContext context, Bonus bonus) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
            bonus.title,
            style: AppTypography.subtitle1
                .copyWith(color: AppColorsDS.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            bonus.description,
            style: AppTypography.caption
                .copyWith(color: AppColorsDS.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Progress bar
          LinearProgressIndicator(
            value: bonus.progress,
            backgroundColor: AppColorsDS.card,
            color: bonus.claimable ? AppColorsDS.success : AppColorsDS.primary,
            minHeight: 6,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bonus.claimable
                    ? 'Ready to claim'
                    : '${(bonus.progress * 100).toStringAsFixed(0)}% complete',
                style: AppTypography.caption
                    .copyWith(color: AppColorsDS.textSecondary),
              ),
              PrimaryButton(
                label: bonus.claimable ? 'Claim' : 'View',
                onPressed: () {
                  if (bonus.claimable) {
                    context.read<BonusCubit>().claim(bonus.id);
                  }
                },
                enabled: bonus.claimable,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
