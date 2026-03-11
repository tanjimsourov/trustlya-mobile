import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../domain/entities/trader_profile.dart';
import '../../domain/entities/item.dart';
import '../cubit/trader_profile_cubit.dart';
import '../cubit/trader_profile_state.dart';
import '../widgets/item_card.dart';

/// Displays a public profile for a trader. Shows avatar, name, trust score,
/// completed trades, badges and an inventory preview. Uses
/// [TraderProfileCubit] to load the profile data from the repository.
class TraderProfilePage extends StatefulWidget {
  final String traderId;
  const TraderProfilePage({Key? key, required this.traderId}) : super(key: key);

  @override
  State<TraderProfilePage> createState() => _TraderProfilePageState();
}

class _TraderProfilePageState extends State<TraderProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TraderProfileCubit>().loadProfile(widget.traderId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TraderProfileCubit>(
      create: (_) => getIt<TraderProfileCubit>(),
      child: BlocBuilder<TraderProfileCubit, TraderProfileState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          if (state.status == Status.success && state.data != null) {
            final TraderProfile profile = state.data!;
            return AppScaffold(
              appBar: AppBar(title: Text(profile.name)),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(profile.avatarUrl),
                            backgroundColor: AppColorsDS.surface,
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.name, style: AppTypography.h3),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: AppColorsDS.warning, size: 20),
                                    const SizedBox(width: 4),
                                    Text(profile.trustScore.toStringAsFixed(1),
                                        style: AppTypography.body1),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                    '${profile.completedTrades} trades completed',
                                    style: AppTypography.body2.copyWith(
                                        color: AppColorsDS.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Badges
                      if (profile.badges.isNotEmpty) ...[
                        Text('Badges', style: AppTypography.subtitle1),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          children: profile.badges
                              .map((badge) => Chip(
                                    label: Text(badge),
                                    backgroundColor:
                                        AppColorsDS.primary.withOpacity(0.2),
                                    labelStyle: AppTypography.caption
                                        .copyWith(color: AppColorsDS.primary),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      // Inventory preview
                      Text('Inventory Preview', style: AppTypography.subtitle1),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 240,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: profile.inventoryPreview.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: AppSpacing.md),
                          itemBuilder: (_, index) {
                            final Item item = profile.inventoryPreview[index];
                            return SizedBox(
                              width: 180,
                              child: ItemCard(
                                item: item,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      Routes.itemDetail,
                                      arguments: item.id);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Actions (placeholder)
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              label: 'Trade',
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.tradeBuilder);
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: SecondaryButton(
                              label: 'Message',
                              onPressed: () {
                                showAppSnackBar(context,
                                    message: 'Messaging not implemented');
                              },
                            ),
                          ),
                        ],
                      ),
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
}
