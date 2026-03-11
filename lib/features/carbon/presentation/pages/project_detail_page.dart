import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/carbon_project_detail.dart';
import '../cubit/project_detail_cubit.dart';
import '../cubit/project_detail_state.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailPage({Key? key, required this.projectId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectDetailCubit>(
      create: (_) => getIt<ProjectDetailCubit>()..load(projectId),
      child: BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
        builder: (context, state) {
          if (state.status == Status.loading && state.data == null) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading project detail'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<ProjectDetailCubit>().load(projectId),
              ),
            );
          }

          final project = state.data;
          if (project == null) {
            return const AppScaffold(
              body: EmptyWidget(
                title: 'Project unavailable',
                message: 'The requested carbon project could not be loaded.',
                icon: Icons.eco_outlined,
              ),
            );
          }

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Project detail',
                      title: project.name,
                      subtitle:
                          'Review project narrative, verification context, pricing movement, and available inventory before initiating a purchase or retirement workflow.',
                      metadata: [
                        StatusBadge(
                            label: project.category, tone: AppTone.primary),
                        StatusBadge(
                          label:
                              '${AppFormatters.compactNumber(project.availableCredits)} credits available',
                          tone: AppTone.success,
                        ),
                        ...project.badges.take(2).map(
                              (badge) =>
                                  StatusBadge(label: badge, tone: AppTone.info),
                            ),
                      ],
                      actions: [
                        SizedBox(
                          width: 150,
                          child: GhostButton(
                            label: 'Holdings',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonHoldings),
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: PrimaryButton(
                            label: 'Buy credits',
                            icon: Icons.shopping_cart_outlined,
                            onPressed: () => Navigator.of(context).pushNamed(
                              Routes.carbonBuy,
                              arguments: project.id,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Unit price',
                          value: AppFormatters.currency(
                            project.pricePerCredit,
                            symbol: '\$',
                            decimals: 2,
                            symbolFirst: true,
                          ),
                          icon: Icons.sell_outlined,
                        ),
                        MetricCard(
                          title: 'Available inventory',
                          value: AppFormatters.compactNumber(
                              project.availableCredits),
                          icon: Icons.inventory_2_outlined,
                          iconColor: AppColorsDS.success,
                        ),
                        MetricCard(
                          title: 'Registry standards',
                          value: '${project.badges.length}',
                          icon: Icons.verified_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Location',
                          value: project.location.split(',').first,
                          icon: Icons.location_on_outlined,
                          iconColor: AppColorsDS.warning,
                          footer: project.location,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stacked = constraints.maxWidth < 980;

                        final overviewPanel = SectionCard(
                          title: 'Narrative and verification',
                          subtitle:
                              'Business context for the project and registry-backed validation status.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(project.story, style: AppTypography.body1),
                              const SizedBox(height: AppSpacing.lg),
                              Text('Verification controls',
                                  style: AppTypography.h5),
                              const SizedBox(height: AppSpacing.xs),
                              Text(project.verificationInfo,
                                  style: AppTypography.body2),
                              const SizedBox(height: AppSpacing.lg),
                              Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                children: project.badges
                                    .map((badge) => StatusBadge(
                                        label: badge, tone: AppTone.info))
                                    .toList(),
                              ),
                            ],
                          ),
                        );

                        final pricingPanel = SectionCard(
                          title: 'Pricing and sourcing',
                          subtitle:
                              'Reference pricing movement and inventory posture for this project.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 120,
                                child: _ProjectPriceBars(project: project),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Wrap(
                                spacing: AppSpacing.xl,
                                runSpacing: AppSpacing.md,
                                children: [
                                  InfoPair(
                                      label: 'Low',
                                      value: _currency(
                                          project.priceHistory.reduce(_min))),
                                  InfoPair(
                                      label: 'High',
                                      value: _currency(
                                          project.priceHistory.reduce(_max))),
                                  InfoPair(
                                      label: 'Current',
                                      value: _currency(project.pricePerCredit)),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const InsightBanner(
                                title: 'Marketplace note',
                                description:
                                    'Carbon project inventory is shown as operational supply for acquisition and retirement, with registry evidence and price context designed for procurement review.',
                                icon: Icons.shield_outlined,
                                tone: AppTone.primary,
                              ),
                            ],
                          ),
                        );

                        if (stacked) {
                          return Column(
                            children: [
                              overviewPanel,
                              const SectionSpacing(height: AppSpacing.md),
                              pricingPanel,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: overviewPanel),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(flex: 5, child: pricingPanel),
                          ],
                        );
                      },
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Next actions',
                      subtitle:
                          'Move from review to execution from the same project workspace.',
                      child: Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: [
                          SizedBox(
                            width: 180,
                            child: PrimaryButton(
                              label: 'Purchase credits',
                              icon: Icons.shopping_cart_outlined,
                              onPressed: () => Navigator.of(context).pushNamed(
                                Routes.carbonBuy,
                                arguments: project.id,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: GhostButton(
                              label: 'View holdings',
                              icon: Icons.inventory_2_outlined,
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(Routes.carbonHoldings),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: GhostButton(
                              label: 'Retire credits',
                              icon: Icons.verified_outlined,
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(Routes.carbonRetire),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _min(double a, double b) => a < b ? a : b;

  double _max(double a, double b) => a > b ? a : b;

  String _currency(double value) {
    return AppFormatters.currency(value,
        symbol: '\$', decimals: 2, symbolFirst: true);
  }
}

class _ProjectPriceBars extends StatelessWidget {
  final CarbonProjectDetail project;

  const _ProjectPriceBars({required this.project});

  @override
  Widget build(BuildContext context) {
    final maxValue = project.priceHistory.reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: project.priceHistory.map((value) {
        final ratio = maxValue == 0 ? 0.0 : value / maxValue;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              height: 20 + (ratio * 100),
              decoration: BoxDecoration(
                color: AppColorsDS.success.withOpacity(0.7),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
