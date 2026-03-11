import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/finality_event.dart';
import '../cubit/finality_tracker_cubit.dart';
import '../cubit/finality_tracker_state.dart';

class FinalityTrackerPage extends StatelessWidget {
  const FinalityTrackerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FinalityTrackerCubit>(
      create: (_) => getIt<FinalityTrackerCubit>()..loadEvents(),
      child: BlocBuilder<FinalityTrackerCubit, FinalityTrackerState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading finality tracker'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<FinalityTrackerCubit>().loadEvents(),
              ),
            );
          }

          final events = (state.data ?? <FinalityEvent>[])
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Finality tracker',
                      title: 'Settlement lifecycle events',
                      subtitle:
                          'Review instruction-level event flow from initiation to final settlement or failure.',
                    ),
                    const SectionSpacing(),
                    if (events.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No finality events',
                              tone: AppTone.neutral))
                    else
                      SectionCard(
                        title: 'Event timeline',
                        subtitle:
                            'Events are ordered by most recent processing timestamp.',
                        child: Column(
                          children: events
                              .map(
                                (event) => TimelineTile(
                                  title:
                                      '${event.instructionId} • ${_eventLabel(event.event)}',
                                  subtitle:
                                      'Lifecycle event received for settlement monitoring.',
                                  trailing: AppFormatters.dateTimeShort(
                                      event.timestamp),
                                  accent: _eventColor(event.event),
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

  static String _eventLabel(FinalityEventType type) {
    switch (type) {
      case FinalityEventType.initiated:
        return 'Initiated';
      case FinalityEventType.matched:
        return 'Matched';
      case FinalityEventType.settled:
        return 'Settled';
      case FinalityEventType.failed:
        return 'Failed';
    }
  }

  static Color _eventColor(FinalityEventType type) {
    switch (type) {
      case FinalityEventType.initiated:
        return AppColorsDS.info;
      case FinalityEventType.matched:
        return AppColorsDS.primary;
      case FinalityEventType.settled:
        return AppColorsDS.success;
      case FinalityEventType.failed:
        return AppColorsDS.danger;
    }
  }
}
