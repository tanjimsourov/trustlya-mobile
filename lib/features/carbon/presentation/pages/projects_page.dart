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
import '../../../../shared/widgets/filter_row.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/carbon_project.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/projects_state.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = const [
    'All',
    'Reforestation',
    'Renewable Energy',
    'Blue Carbon'
  ];

  int _selectedCategoryIndex = 0;
  bool _gridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectsCubit>(
      create: (_) => getIt<ProjectsCubit>()..load(),
      child: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          final projects = state.data ?? const <CarbonProject>[];
          final query = _searchController.text.trim().toLowerCase();
          final visibleProjects = projects.where((project) {
            if (query.isEmpty) {
              return true;
            }
            return project.name.toLowerCase().contains(query) ||
                project.location.toLowerCase().contains(query) ||
                project.category.toLowerCase().contains(query) ||
                project.badges
                    .any((badge) => badge.toLowerCase().contains(query));
          }).toList();

          final averagePrice = visibleProjects.isEmpty
              ? 0.0
              : visibleProjects.fold<double>(
                      0, (sum, project) => sum + project.pricePerCredit) /
                  visibleProjects.length;
          final uniqueStandards = visibleProjects
              .expand((project) => project.badges)
              .toSet()
              .length;

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Project marketplace',
                      title: 'Verified carbon project discovery',
                      subtitle:
                          'Search the project catalogue, compare registry-backed supply, and move from sourcing into purchase and retirement workflows with operational context.',
                      metadata: const [
                        StatusBadge(
                            label: 'Registry screened', tone: AppTone.success),
                        StatusBadge(
                            label: 'Marketplace ready', tone: AppTone.primary),
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
                            label: 'Carbon dashboard',
                            icon: Icons.arrow_forward,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonDashboard),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Visible projects',
                          value: '${visibleProjects.length}',
                          icon: Icons.eco_outlined,
                        ),
                        MetricCard(
                          title: 'Categories',
                          value:
                              '${visibleProjects.map((project) => project.category).toSet().length}',
                          icon: Icons.category_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Average price',
                          value: AppFormatters.currency(
                            averagePrice,
                            symbol: '\$',
                            decimals: 2,
                            symbolFirst: true,
                          ),
                          icon: Icons.sell_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                        MetricCard(
                          title: 'Standards',
                          value: '$uniqueStandards',
                          icon: Icons.verified_outlined,
                          iconColor: AppColorsDS.success,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    FilterToolbar(
                      leading: SearchField(
                        controller: _searchController,
                        hintText: 'Search project, location, or registry',
                        onChanged: (_) => setState(() {}),
                      ),
                      center: FilterRow(
                        options: _categories,
                        selectedIndex: _selectedCategoryIndex,
                        onSelected: (index) {
                          setState(() => _selectedCategoryIndex = index);
                          context.read<ProjectsCubit>().load(
                                category:
                                    index == 0 ? null : _categories[index],
                              );
                        },
                      ),
                      trailing: Wrap(
                        spacing: AppSpacing.sm,
                        children: [
                          IconButton(
                            tooltip:
                                _gridView ? 'Show list view' : 'Show grid view',
                            onPressed: () =>
                                setState(() => _gridView = !_gridView),
                            icon: Icon(
                              _gridView
                                  ? Icons.view_list_outlined
                                  : Icons.grid_view_outlined,
                              color: AppColorsDS.primary,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Refresh projects',
                            onPressed: () => context.read<ProjectsCubit>().load(
                                  category: _selectedCategoryIndex == 0
                                      ? null
                                      : _categories[_selectedCategoryIndex],
                                ),
                            icon: const Icon(Icons.refresh,
                                color: AppColorsDS.primary),
                          ),
                        ],
                      ),
                    ),
                    const SectionSpacing(),
                    if (state.status == Status.loading && projects.isEmpty)
                      const LoadingWidget(label: 'Loading carbon projects')
                    else if (state.status == Status.error)
                      shared.ErrorWidgetView(
                        message: state.message,
                        onRetry: () => context.read<ProjectsCubit>().load(
                              category: _selectedCategoryIndex == 0
                                  ? null
                                  : _categories[_selectedCategoryIndex],
                            ),
                      )
                    else if (projects.isEmpty)
                      EmptyWidget(
                        title: 'No projects available',
                        message:
                            'Verified carbon projects will appear here once marketplace inventory has been published.',
                        actionLabel: 'Return to dashboard',
                        onAction: () => Navigator.of(context)
                            .pushNamed(Routes.carbonDashboard),
                      )
                    else if (visibleProjects.isEmpty)
                      const EmptyWidget(
                        title: 'No projects match the current view',
                        message:
                            'Adjust the search phrase or category filter to find a different project set.',
                        icon: Icons.search_off,
                      )
                    else
                      SectionCard(
                        title: 'Project catalogue',
                        subtitle:
                            'Verified inventory available for sourcing, holding, and retirement workflows.',
                        child: _gridView
                            ? AdaptiveGrid(
                                itemCount: visibleProjects.length,
                                minCellWidth: 270,
                                childAspectRatio: 0.98,
                                itemBuilder: (context, index) {
                                  return _ProjectSummaryCard(
                                      project: visibleProjects[index]);
                                },
                              )
                            : Column(
                                children: visibleProjects
                                    .map(
                                      (project) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: AppSpacing.md),
                                        child: _ProjectSummaryCard(
                                          project: project,
                                          horizontal: true,
                                        ),
                                      ),
                                    )
                                    .toList(),
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
}

class _ProjectSummaryCard extends StatelessWidget {
  final CarbonProject project;
  final bool horizontal;

  const _ProjectSummaryCard({
    required this.project,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return AppCard(
        onTap: () => Navigator.of(context)
            .pushNamed(Routes.carbonProjectDetail, arguments: project.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProjectIcon(project: project),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _ProjectCardContent(project: project)),
          ],
        ),
      );
    }

    return AppCard(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.carbonProjectDetail, arguments: project.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProjectIcon(project: project),
          const SizedBox(height: AppSpacing.md),
          _ProjectCardContent(project: project),
        ],
      ),
    );
  }
}

class _ProjectIcon extends StatelessWidget {
  final CarbonProject project;

  const _ProjectIcon({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColorsDS.accentGreenSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child:
          const Icon(Icons.eco_outlined, color: AppColorsDS.success, size: 30),
    );
  }
}

class _ProjectCardContent extends StatelessWidget {
  final CarbonProject project;

  const _ProjectCardContent({required this.project});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(project.name, style: AppTypography.h5),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${project.category} | ${project.location}',
          style: AppTypography.body2,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: project.badges
              .take(3)
              .map((badge) => StatusBadge(label: badge, tone: AppTone.info))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppFormatters.currency(project.pricePerCredit,
              symbol: '\$', decimals: 2, symbolFirst: true),
          style:
              AppTypography.subtitle2.copyWith(color: AppColorsDS.textPrimary),
        ),
      ],
    );
  }
}
