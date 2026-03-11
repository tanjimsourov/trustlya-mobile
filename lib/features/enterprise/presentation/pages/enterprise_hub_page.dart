import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../tokenization/presentation/cubit/tokenization_overview_cubit.dart';
import '../../../tokenization/presentation/cubit/tokenization_overview_state.dart';
import '../../../post_trade/presentation/cubit/post_trade_dashboard_cubit.dart';
import '../../../post_trade/presentation/cubit/post_trade_dashboard_state.dart';

/// Enterprise hub page that aggregates key insights from the tokenisation
/// and post‑trade modules. It surfaces high level metrics and quick
/// navigation cards to the underlying enterprise workflows. This page is
/// intended to provide institutional users a single entry point into
/// Trustlya's B2B capabilities.
class EnterpriseHubPage extends StatelessWidget {
  const EnterpriseHubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TokenizationOverviewCubit>(
          create: (_) => getIt<TokenizationOverviewCubit>()..loadOverview(),
        ),
        BlocProvider<PostTradeDashboardCubit>(
          create: (_) => getIt<PostTradeDashboardCubit>()..loadDashboard(),
        ),
      ],
      child: BlocBuilder<TokenizationOverviewCubit, TokenizationOverviewState>(
        builder: (context, tokenState) {
          return BlocBuilder<PostTradeDashboardCubit, PostTradeDashboardState>(
            builder: (context, postState) {
              // Determine combined loading/error states
              if (tokenState.status == Status.loading ||
                  postState.status == Status.loading) {
                return const LoadingWidget();
              }
              if (tokenState.status == Status.error) {
                return shared.ErrorWidgetView(message: tokenState.message);
              }
              if (postState.status == Status.error) {
                return shared.ErrorWidgetView(message: postState.message);
              }
              // Successful loading of both modules
              final tokenData = tokenState.data!;
              final postData = postState.data!;
              return AppScaffold(
                appBar: AppBar(title: const Text('Enterprise Solutions')),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Enterprise Insights', style: AppTypography.h4),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: [
                            MetricCard(
                              title: 'Asset Programs',
                              value: '${tokenData.totalPrograms}',
                              icon: Icons.layers,
                            ),
                            MetricCard(
                              title: 'Active Programs',
                              value: '${tokenData.activePrograms}',
                              icon: Icons.play_circle_filled,
                            ),
                            MetricCard(
                              title: 'Investors',
                              value: '${tokenData.investors}',
                              icon: Icons.group,
                            ),
                            MetricCard(
                              title: 'Pending Onboardings',
                              value: '${tokenData.pendingOnboardings}',
                              icon: Icons.pending_actions,
                            ),
                            MetricCard(
                              title: 'Settlement Queue',
                              value: '${postData.pendingInstructions}',
                              icon: Icons.list_alt,
                            ),
                            MetricCard(
                              title: 'Exceptions',
                              value: '${postData.openExceptions}',
                              icon: Icons.error_outline,
                            ),
                            MetricCard(
                              title: 'Exposures',
                              value: '${postData.exposures}',
                              icon: Icons.assessment,
                            ),
                            MetricCard(
                              title: 'Treasury Balance',
                              value:
                                  '\$${postData.treasuryBalance.toStringAsFixed(2)}',
                              icon: Icons.account_balance,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text('Modules', style: AppTypography.h4),
                        const SizedBox(height: AppSpacing.md),
                        _moduleCard(
                          context,
                          title: 'Tokenisation Hub',
                          description:
                              'Manage asset tokenisation programmes, investor onboarding, lifecycle events and analytics.',
                          icon: Icons.layers,
                          route: Routes.tokenizationOverview,
                        ),
                        _moduleCard(
                          context,
                          title: 'Post‑Trade Operations',
                          description:
                              'Monitor settlement queues, reconciliation, exceptions, treasury positioning and audit trails.',
                          icon: Icons.swap_vert,
                          route: Routes.postTradeDashboard,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Builds a navigational card linking to a module within the enterprise hub.
  Widget _moduleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String route,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: () => Navigator.pushNamed(context, route),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColorsDS.surface.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColorsDS.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.subtitle1
                          .copyWith(color: AppColorsDS.textPrimary)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.caption
                        .copyWith(color: AppColorsDS.textSecondary),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColorsDS.textSecondary),
          ],
        ),
      ),
    );
  }
}
