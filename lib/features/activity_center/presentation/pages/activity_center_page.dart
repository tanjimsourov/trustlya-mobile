import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/segmented_control.dart';
import '../../domain/entities/activity_item.dart';
import '../cubit/activity_cubit.dart';
import '../cubit/activity_state.dart';

class ActivityCenterPage extends StatefulWidget {
  const ActivityCenterPage({Key? key}) : super(key: key);

  @override
  State<ActivityCenterPage> createState() => _ActivityCenterPageState();
}

class _ActivityCenterPageState extends State<ActivityCenterPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final List<String> _filters = const [
    'All',
    'Tokenization',
    'Settlement',
    'Wallet',
    'Carbon'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivityCubit>(
      create: (_) => getIt<ActivityCubit>(),
      child: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, state) {
          final events = state.data ?? const <ActivityItem>[];
          final query = _searchController.text.trim().toLowerCase();
          final filtered = events.where((event) {
            final typeMatch =
                _selectedFilter == 'All' || event.type == _selectedFilter;
            final queryMatch = query.isEmpty ||
                event.title.toLowerCase().contains(query) ||
                event.description.toLowerCase().contains(query) ||
                event.type.toLowerCase().contains(query);
            return typeMatch && queryMatch;
          }).toList();

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Activity center',
                      title: 'Cross-module operational timeline',
                      subtitle:
                          'Track recent activity across tokenization, settlement, wallet, and carbon workflows from a single event log.',
                      metadata: [
                        StatusBadge(
                            label: _selectedFilter, tone: AppTone.primary),
                        StatusBadge(
                            label: '${filtered.length} visible',
                            tone: AppTone.info),
                      ],
                    ),
                    const SectionSpacing(),
                    FilterToolbar(
                      leading: SearchField(
                        controller: _searchController,
                        hintText: 'Search title or description',
                        onChanged: (_) => setState(() {}),
                      ),
                      center: SegmentedControl<String>(
                        values: _filters,
                        selected: _selectedFilter,
                        labels: _filters.map((filter) => Text(filter)).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedFilter = value),
                      ),
                      trailing: StatusBadge(
                        label: state.status == Status.loading
                            ? 'Refreshing'
                            : 'Event stream',
                        tone: state.status == Status.loading
                            ? AppTone.warning
                            : AppTone.success,
                      ),
                    ),
                    const SectionSpacing(),
                    if (state.status == Status.loading && events.isEmpty)
                      const LoadingWidget(label: 'Loading activity feed')
                    else if (state.status == Status.error)
                      shared.ErrorWidgetView(
                        message: state.message,
                        onRetry: () => context.read<ActivityCubit>().load(),
                      )
                    else if (events.isEmpty)
                      const EmptyWidget(
                        title: 'No activity available',
                        message:
                            'Recent operational events will appear here when the platform is in use.',
                        icon: Icons.timeline_outlined,
                      )
                    else if (filtered.isEmpty)
                      const EmptyWidget(
                        title: 'No events match the current view',
                        message:
                            'Adjust the filter or search phrase to find a different event set.',
                        icon: Icons.search_off,
                      )
                    else
                      Column(
                        children: filtered
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: AppCard(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: item.color.withOpacity(0.14),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child:
                                            Icon(item.icon, color: item.color),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(item.title,
                                                      style: AppTypography.h5),
                                                ),
                                                StatusBadge(
                                                    label: item.type,
                                                    tone: _toneForType(
                                                        item.type)),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: AppSpacing.xs),
                                            Text(item.description,
                                                style: AppTypography.body2),
                                            const SizedBox(
                                                height: AppSpacing.md),
                                            Text(
                                              AppFormatters.dateTimeShort(
                                                  item.date),
                                              style: AppTypography.caption
                                                  .copyWith(
                                                color:
                                                    AppColorsDS.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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

  AppTone _toneForType(String type) {
    switch (type) {
      case 'Tokenization':
        return AppTone.primary;
      case 'Settlement':
        return AppTone.warning;
      case 'Wallet':
        return AppTone.info;
      case 'Carbon':
        return AppTone.success;
      default:
        return AppTone.neutral;
    }
  }
}
